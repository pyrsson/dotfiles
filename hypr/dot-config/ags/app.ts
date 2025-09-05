import app from "ags/gtk4/app";
import style from "./style.scss";
import GLib from "gi://GLib?version=2.0";
import Bar from "./widget/Bar";
import OSD from "./widget/osd/Osd";
import NotificationPopups from "./widget/notifications/NotificationPopup";
import { monitorFile } from "ags/file";
import { exec } from "ags/process";
import { createState } from "ags";

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
    }
  },
  main() {
    // initialize
    NotificationPopups();
    Bar();
    OSD();

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
