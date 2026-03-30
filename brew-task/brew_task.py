#!/usr/bin/env python3
"""
brew-task — Lightweight popup task manager
Application ID: com.brewtask.Popup
Window title / WM class: brew-task
"""

import gi
gi.require_version("Gtk", "3.0")
from gi.repository import Gtk, Gdk, GLib, Gio
import json
import os
import sys
import socket
import threading
import subprocess
import signal
from pathlib import Path

# Configuration
APP_ID       = "com.brewtask.Popup"
WIN_TITLE    = "brew-task"
POPUP_WIDTH  = 480
POPUP_HEIGHT = 560
ANCHOR       = "top-right"
BAR_HEIGHT   = 30
POPUP_GAP    = 8
EDGE_MARGIN  = 12

DATA_DIR     = Path.home() / ".local" / "share" / "brew-task"
TASKS_FILE   = DATA_DIR / "tasks.json"
IPC_SOCKET   = Path("/tmp") / f"brew-task-{os.getenv('USER', 'user')}.sock"

STYLE_FILE   = Path.home() / ".config" / "brew-task" / "style.css"
if not STYLE_FILE.exists():
    STYLE_FILE = Path(__file__).parent / "style.css"

# Storage
def load_tasks() -> dict:
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    if TASKS_FILE.exists():
        try:
            with open(TASKS_FILE) as f:
                data = json.load(f)
                data.setdefault("active", [])
                data.setdefault("finished", [])
                return data
        except Exception:
            pass
    return {"active": [], "finished": []}

def save_tasks(data: dict) -> None:
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    with open(TASKS_FILE, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

# Monitor Geometry for Placement
def get_monitor_geometry() -> dict:
    try:
        result = subprocess.run(
            ["hyprctl", "monitors", "-j"],
            capture_output=True, text=True, timeout=2
        )
        monitors = json.loads(result.stdout)
        for m in monitors:
            if m.get("focused"): return m
        if monitors: return monitors[0]
    except Exception:
        pass
    return {"x": 0, "y": 0, "width": 1920, "height": 1080, "scale": 1.0}

def calculate_popup_position(monitor: dict) -> tuple[int, int]:
    scale  = monitor.get("scale", 1.0) or 1.0
    mon_x  = monitor.get("x", 0)
    mon_y  = monitor.get("y", 0)
    mon_w  = int(monitor.get("width", 1920) / scale)
    popup_y = mon_y + BAR_HEIGHT + POPUP_GAP
    if ANCHOR == "top-right":
        popup_x = mon_x + mon_w - POPUP_WIDTH - EDGE_MARGIN
    else:
        popup_x = mon_x + EDGE_MARGIN
    return popup_x, popup_y

# IPC Server
class IPCServer:
    def __init__(self, app: "BrewTaskApp"):
        self.app = app
        self._thread = None
        self._sock = None
        self._running = False

    def start(self):
        if IPC_SOCKET.exists():
            try: IPC_SOCKET.unlink()
            except Exception: pass
        self._sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        self._sock.bind(str(IPC_SOCKET))
        self._sock.listen(5)
        self._sock.settimeout(1.0)
        self._running = True
        self._thread = threading.Thread(target=self._serve)
        self._thread.daemon = True
        self._thread.start()

    def stop(self):
        self._running = False
        if self._sock:
            try: self._sock.close()
            except Exception: pass
        if IPC_SOCKET.exists():
            try: IPC_SOCKET.unlink()
            except Exception: pass

    def _serve(self):
        while self._running:
            try:
                conn, _ = self._sock.accept()
            except socket.timeout:
                continue
            except OSError:
                break
            try:
                data = conn.recv(64).decode().strip()
                if data == "ping":
                    conn.sendall(b"pong\n")
                elif data in ("toggle", "show", "hide"):
                    GLib.idle_add(self._dispatch, data)
                conn.close()
            except Exception:
                pass

    def _dispatch(self, cmd: str):
        win = self.app.window
        if win is None: return GLib.SOURCE_REMOVE
        if cmd == "toggle":
            if win.get_property("visible"): win.hide()
            else: win.present()
        elif cmd == "show": win.present()
        elif cmd == "hide": win.hide()
        return GLib.SOURCE_REMOVE

# UI Widgets
class ActiveTaskRow(Gtk.Box):
    def __init__(self, text: str, on_complete, on_delete):
        super().__init__(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        self.get_style_context().add_class("task-row")
        self.get_style_context().add_class("task-row-active")

        label = Gtk.Label(label=text)
        label.set_hexpand(True)
        label.set_xalign(0)
        label.set_line_wrap(True)
        label.set_max_width_chars(40)
        label.get_style_context().add_class("task-label")

        complete_btn = Gtk.Button()
        complete_btn.get_style_context().add_class("flat")
        complete_btn.get_style_context().add_class("task-btn")
        complete_btn.set_tooltip_text("Mark done")
        complete_btn.set_image(Gtk.Image.new_from_icon_name("emblem-ok-symbolic", Gtk.IconSize.BUTTON))
        complete_btn.connect("clicked", lambda _: on_complete(text))

        delete_btn = Gtk.Button()
        delete_btn.get_style_context().add_class("flat")
        delete_btn.get_style_context().add_class("task-btn")
        delete_btn.set_tooltip_text("Delete")
        delete_btn.set_image(Gtk.Image.new_from_icon_name("edit-delete-symbolic", Gtk.IconSize.BUTTON))
        delete_btn.connect("clicked", lambda _: on_delete(text))

        self.pack_start(label, True, True, 0)
        self.pack_start(complete_btn, False, False, 0)
        self.pack_start(delete_btn, False, False, 0)

class FinishedTaskRow(Gtk.Box):
    def __init__(self, text: str, on_restore, on_delete):
        super().__init__(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        self.get_style_context().add_class("task-row")
        self.get_style_context().add_class("task-row-finished")

        label = Gtk.Label()
        label.set_markup(f"<s>{GLib.markup_escape_text(text)}</s>")
        label.set_hexpand(True)
        label.set_xalign(0)
        label.set_line_wrap(True)
        label.set_max_width_chars(40)
        label.get_style_context().add_class("task-label")

        restore_btn = Gtk.Button()
        restore_btn.get_style_context().add_class("flat")
        restore_btn.get_style_context().add_class("task-btn")
        restore_btn.set_tooltip_text("Restore")
        restore_btn.set_image(Gtk.Image.new_from_icon_name("edit-undo-symbolic", Gtk.IconSize.BUTTON))
        restore_btn.connect("clicked", lambda _: on_restore(text))

        delete_btn = Gtk.Button()
        delete_btn.get_style_context().add_class("flat")
        delete_btn.get_style_context().add_class("task-btn")
        delete_btn.set_tooltip_text("Delete")
        delete_btn.set_image(Gtk.Image.new_from_icon_name("edit-delete-symbolic", Gtk.IconSize.BUTTON))
        delete_btn.connect("clicked", lambda _: on_delete(text))

        self.pack_start(label, True, True, 0)
        self.pack_start(restore_btn, False, False, 0)
        self.pack_start(delete_btn, False, False, 0)

# Window
class BrewTaskWindow(Gtk.ApplicationWindow):
    _FOCUS_GRACE_MS = 600

    def __init__(self, app: "BrewTaskApp"):
        super().__init__(application=app)
        self.set_title(WIN_TITLE)
        self.set_default_size(POPUP_WIDTH, POPUP_HEIGHT)
        self.set_resizable(False)
        self.set_decorated(False)
        self.set_keep_above(True)

        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual and self.get_screen().is_composited():
            self.set_visual(visual)
        self.set_app_paintable(True)

        self._data = load_tasks()
        self._focus_grace = False
        self._build_ui()

        self.connect("key-press-event", self._on_key_pressed)
        self.connect("focus-out-event", self._on_focus_leave)

    def present(self):
        self._start_grace()
        super().present()

    def _start_grace(self):
        self._focus_grace = True
        GLib.timeout_add(self._FOCUS_GRACE_MS, self._end_grace)

    def _end_grace(self):
        self._focus_grace = False
        return GLib.SOURCE_REMOVE

    def _build_ui(self):
        outer = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        outer.get_style_context().add_class("brew-task-root")
        outer.pack_start(self._build_header(), False, False, 0)

        self._stack = Gtk.Stack()
        self._stack.set_vexpand(True)
        self._stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT)
        self._stack.set_transition_duration(150)

        self._active_list_box = None
        self._finished_list_box = None

        self._stack.add_titled(self._build_active_page(), "active", "Active")
        self._stack.add_titled(self._build_finished_page(), "finished", "Finished")

        switcher = Gtk.StackSwitcher(stack=self._stack)
        switcher.set_halign(Gtk.Align.CENTER)
        
        switcher_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        switcher_box.get_style_context().add_class("switcher-bar")
        switcher_box.pack_start(switcher, True, True, 6)

        outer.pack_start(switcher_box, False, False, 0)
        outer.pack_start(self._stack, True, True, 0)
        outer.pack_start(self._build_input_area(), False, False, 0)

        self.add(outer)
        self.show_all()
        self._update_tab_labels()

    def _build_header(self) -> Gtk.Box:
        box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        box.get_style_context().add_class("header-bar")

        icon = Gtk.Label(label="󰄳 ")
        icon.get_style_context().add_class("header-icon")
        title = Gtk.Label(label="brew-task")
        title.set_hexpand(True)
        title.set_xalign(0)
        title.get_style_context().add_class("header-title")

        close_btn = Gtk.Button()
        close_btn.get_style_context().add_class("flat")
        close_btn.set_image(Gtk.Image.new_from_icon_name("window-close-symbolic", Gtk.IconSize.BUTTON))
        close_btn.connect("clicked", lambda _: self.hide())

        box.pack_start(icon, False, False, 0)
        box.pack_start(title, True, True, 0)
        box.pack_start(close_btn, False, False, 0)
        return box

    def _build_active_page(self) -> Gtk.Widget:
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        box.get_style_context().add_class("tab-page")

        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scroll.set_vexpand(True)

        self._active_list_box = Gtk.ListBox()
        self._active_list_box.set_selection_mode(Gtk.SelectionMode.NONE)
        self._active_list_box.get_style_context().add_class("task-list")
        self._active_list_box.set_placeholder(self._make_empty_label("No active tasks.\nAdd one below ↓"))

        self._populate_active()
        scroll.add(self._active_list_box)
        box.pack_start(scroll, True, True, 0)
        return box

    def _build_finished_page(self) -> Gtk.Widget:
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        box.get_style_context().add_class("tab-page")

        top_bar = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        top_bar.get_style_context().add_class("finished-top-bar")
        spacer = Gtk.Label()
        spacer.set_hexpand(True)
        clear_btn = Gtk.Button(label="Clear all")
        clear_btn.get_style_context().add_class("flat")
        clear_btn.connect("clicked", self._on_clear_finished)
        top_bar.pack_start(spacer, True, True, 0)
        top_bar.pack_start(clear_btn, False, False, 0)
        box.pack_start(top_bar, False, False, 4)

        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        scroll.set_vexpand(True)

        self._finished_list_box = Gtk.ListBox()
        self._finished_list_box.set_selection_mode(Gtk.SelectionMode.NONE)
        self._finished_list_box.get_style_context().add_class("task-list")
        self._finished_list_box.set_placeholder(self._make_empty_label("No finished tasks yet."))

        self._populate_finished()
        scroll.add(self._finished_list_box)
        box.pack_start(scroll, True, True, 0)
        return box

    def _build_input_area(self) -> Gtk.Box:
        box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=8)
        box.get_style_context().add_class("input-area")

        self._entry = Gtk.Entry()
        self._entry.set_placeholder_text("New task…")
        self._entry.set_hexpand(True)
        self._entry.set_max_length(200)
        self._entry.connect("activate", self._on_add_task)

        add_btn = Gtk.Button(label="Add")
        add_btn.get_style_context().add_class("suggested-action")
        add_btn.connect("clicked", self._on_add_task)

        box.pack_start(self._entry, True, True, 0)
        box.pack_start(add_btn, False, False, 0)
        return box

    @staticmethod
    def _make_empty_label(text: str) -> Gtk.Label:
        lbl = Gtk.Label(label=text)
        lbl.get_style_context().add_class("dim-label")
        lbl.set_justify(Gtk.Justification.CENTER)
        lbl.set_margin_top(24)
        lbl.set_margin_bottom(24)
        lbl.show()
        return lbl

    def _populate_active(self):
        if not self._active_list_box: return
        for child in self._active_list_box.get_children():
            self._active_list_box.remove(child)
        for text in self._data["active"]:
            row = Gtk.ListBoxRow()
            row.add(ActiveTaskRow(text, self._on_complete_task, self._on_delete_active))
            self._active_list_box.add(row)
        self._active_list_box.show_all()
        self._update_tab_labels()

    def _populate_finished(self):
        if not self._finished_list_box: return
        for child in self._finished_list_box.get_children():
            self._finished_list_box.remove(child)
        for text in self._data["finished"]:
            row = Gtk.ListBoxRow()
            row.add(FinishedTaskRow(text, self._on_restore_task, self._on_delete_finished))
            self._finished_list_box.add(row)
        self._finished_list_box.show_all()
        self._update_tab_labels()

    def _update_tab_labels(self):
        na = len(self._data["active"])
        nf = len(self._data["finished"])

        active_child = self._stack.get_child_by_name("active")
        finished_child = self._stack.get_child_by_name("finished")

        if active_child:
            self._stack.child_set_property(active_child, "title", f"Active ({na})" if na else "Active")
        if finished_child:
            self._stack.child_set_property(finished_child, "title", f"Finished ({nf})" if nf else "Finished")

    def _on_add_task(self, *_):
        text = self._entry.get_text().strip()
        if not text: return
        self._data["active"].append(text)
        save_tasks(self._data)
        self._populate_active()
        self._entry.set_text("")
        self._entry.grab_focus()

    def _on_complete_task(self, text: str):
        if text in self._data["active"]: self._data["active"].remove(text)
        self._data["finished"].append(text)
        save_tasks(self._data)
        self._populate_active()
        self._populate_finished()

    def _on_delete_active(self, text: str):
        if text in self._data["active"]: self._data["active"].remove(text)
        save_tasks(self._data)
        self._populate_active()

    def _on_restore_task(self, text: str):
        if text in self._data["finished"]: self._data["finished"].remove(text)
        self._data["active"].append(text)
        save_tasks(self._data)
        self._populate_active()
        self._populate_finished()

    def _on_delete_finished(self, text: str):
        if text in self._data["finished"]: self._data["finished"].remove(text)
        save_tasks(self._data)
        self._populate_finished()

    def _on_clear_finished(self, *_):
        self._data["finished"].clear()
        save_tasks(self._data)
        self._populate_finished()

    def _on_key_pressed(self, widget, event):
        if event.keyval == Gdk.KEY_Escape:
            self.hide()
            return True
        if event.keyval == Gdk.KEY_n and (event.state & Gdk.ModifierType.CONTROL_MASK):
            self._entry.grab_focus()
            return True
        return False

    def _on_focus_leave(self, widget, event):
        if self._focus_grace: return False
        self.hide()
        return False

    def do_realize(self):
        Gtk.ApplicationWindow.do_realize(self)
        self._apply_position()

    def _apply_position(self):
        monitor = get_monitor_geometry()
        x, y = calculate_popup_position(monitor)
        try:
            surface = self.get_window()
            if hasattr(surface, "move"):
                surface.move(x, y)
        except Exception:
            pass

# Application
class BrewTaskApp(Gtk.Application):
    def __init__(self):
        super().__init__(
            application_id=APP_ID,
            flags=Gio.ApplicationFlags.NON_UNIQUE
        )
        self.window = None
        self._ipc = IPCServer(self)

        GLib.unix_signal_add(GLib.PRIORITY_DEFAULT, signal.SIGINT, self._quit)
        GLib.unix_signal_add(GLib.PRIORITY_DEFAULT, signal.SIGTERM, self._quit)

    def do_activate(self):
        if self.window is None:
            _load_css()
            self.window = BrewTaskWindow(self)
            self.add_window(self.window)
            self.window.present()
            self._ipc.start()

    def _quit(self):
        self._ipc.stop()
        self.quit()
        return GLib.SOURCE_REMOVE

# CSS Loader
def _load_css():
    provider = Gtk.CssProvider()
    if STYLE_FILE.exists():
        provider.load_from_path(str(STYLE_FILE))
    else:
        css = b"""
        .brew-task-root { border-radius: 12px; padding: 0; }
        .header-bar { padding: 8px 12px; border-bottom: 1px solid alpha(@theme_fg_color, 0.1); }
        .switcher-bar { padding: 8px; border-bottom: 1px solid alpha(@theme_fg_color, 0.1); }
        .tab-page { padding: 2px 0; }
        .input-area { padding: 8px 12px; border-top: 1px solid alpha(@theme_fg_color, 0.1); }
        .task-list { padding: 6px; }
        .task-row { padding: 4px; border-radius: 6px; }
        .task-row:hover { background-color: alpha(@theme_fg_color, 0.05); }
        .finished-top-bar { padding: 0 10px; }
        """
        provider.load_from_data(css)
    
    Gtk.StyleContext.add_provider_for_screen(
        Gdk.Screen.get_default(),
        provider,
        Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
    )

# IPC Client Hook
def send_ipc(cmd: str) -> bool:
    try:
        sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
        sock.settimeout(1.0)
        sock.connect(str(IPC_SOCKET))
        sock.sendall((cmd + "\n").encode())
        resp = sock.recv(64).decode().strip()
        sock.close()
        return resp == "pong" if cmd == "ping" else True
    except Exception:
        return False

if __name__ == "__main__":
    if len(sys.argv) > 1:
        cmd = sys.argv[1].lower()
        if cmd in ("toggle", "show", "hide", "ping"):
            ok = send_ipc(cmd)
            sys.exit(0 if ok else 1)

    if send_ipc("ping"):
        send_ipc("toggle")
        sys.exit(0)

    app = BrewTaskApp()
    sys.exit(app.run(sys.argv[:1]))
