import GLib from "gi://GLib?version=2.0";
import { createPoll } from "ags/time";
import Popover from "../Popover";
import { Gtk } from "ags/gtk4";
import AstalNotifd from "gi://AstalNotifd";
import Notification from "../notifications/Notification";
import { createState, For, onCleanup } from "ags";

export default function Dashboard() {
  const format = "%A %e %b - %H:%M";
  const time = createPoll(
    "",
    1000,
    () => GLib.DateTime.new_now_local().format(format)!,
  );

  const notifd = AstalNotifd.get_default();

  const [notifications, setNotifications] = createState(
    new Array<AstalNotifd.Notification>(),
  );
  setNotifications(notifd.get_notifications());

  const notifiedHandler = notifd.connect("notified", (_, id, replaced) => {
    const notification = notifd.get_notification(id);

    if (replaced && notifications.get().some((n) => n.id === id)) {
      setNotifications((ns) => ns.map((n) => (n.id === id ? notification : n)));
    } else {
      setNotifications((ns) => [notification, ...ns]);
    }
  });

  const resolvedHandler = notifd.connect("resolved", (_, id) => {
    setNotifications((ns) => ns.filter((n) => n.id !== id));
  });

  onCleanup(() => {
    notifd.disconnect(notifiedHandler);
    notifd.disconnect(resolvedHandler);
  });

  return (
    <Popover label={time} name="dashboard">
      <box orientation={Gtk.Orientation.VERTICAL}>
        <label label={"Dashboard"} class="Title" />
        <box orientation={Gtk.Orientation.HORIZONTAL}>
          <box halign={Gtk.Align.END} vexpand={false}>
            <Gtk.Calendar showWeekNumbers={true} />
          </box>
          <box orientation={Gtk.Orientation.VERTICAL}>
            <For each={notifications}>
              {(n) => <Notification notification={n} onHoverLost={() => {}} />}
            </For>
          </box>
        </box>
      </box>
    </Popover>
  );
}
