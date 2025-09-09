import app from "ags/gtk4/app";
import style from "./style.scss";
import GLib from "gi://GLib";
import Bar from "./widget/Bar";
import OSD from "./widget/osd/Osd";
import NotificationPopups from "./widget/notifications/NotificationPopup";
import { monitorFile } from "ags/file";
import { exec } from "ags/process";
import { createState } from "ags";
import Applauncher from "./widget/applauncher/Applauncher";
import { Gtk } from "ags/gtk4";
import Cliphist from "./widget/clipboard/Clipboard";

type RequestHandler = (res: any) => void;

export const [Requests, setRequests] = createState(
  <Map<string, RequestHandler>>new Map(),
);

app.start({
  css: style,
  requestHandler(req, res) {
    const handler = Requests.get().get(req[0]);
    if (handler) {
      handler(res);
    } else {
      res("unhandled request: " + req);
      return;
    }
  },
  main() {
    // initialize
    NotificationPopups();
    Bar();
    OSD();
    const applauncher = Applauncher() as Gtk.Window;
    app.add_window(applauncher);
    const cliphist = Cliphist() as Gtk.Window;
    app.add_window(cliphist);

    monitorFile(GLib.getenv("HOME") + "/.config/ags/style.scss", () => {
      console.log("scss reloaded");
      exec(
        `sass ${GLib.getenv("HOME")}/.config/ags/style.scss ${GLib.getenv("HOME")}/.config/ags/style.css`,
      );
      app.reset_css();
      app.apply_css(`${GLib.getenv("HOME")}/.config/ags/style.css`);
    });
  },
});
