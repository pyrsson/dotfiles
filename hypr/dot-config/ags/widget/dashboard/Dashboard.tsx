import GLib from "gi://GLib?version=2.0";
import { createPoll } from "ags/time";
import Popover from "../Popover";
import { Gtk } from "ags/gtk4";
import AstalNotifd from "gi://AstalNotifd";
import Notification from "../notifications/Notification";
import { createState, For, onCleanup, With } from "ags";

export default function Dashboard() {
  const format = "%A %e %b - %H:%M";
  const time = createPoll(
    "",
    1000,
    () => GLib.DateTime.new_now_local().format(format)!,
  );

  const notifd = AstalNotifd.get_default();

  const [dnd, setDnd] = createState(
    "preferences-system-notifications-symbolic",
  );

  const dndHandler = notifd.connect("notify::dont-disturb", () => {
    setDnd(
      notifd.get_dont_disturb()
        ? "preferences-system-notifications-symbolic"
        : "notifications-disabled-symbolic",
    );
  });

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
    notifd.disconnect(dndHandler);
  });

  return (
    <Popover label={time} name="dashboard">
      <box orientation={Gtk.Orientation.VERTICAL}>
        <label label={"Dashboard"} class="Title" />
        <box orientation={Gtk.Orientation.HORIZONTAL}>
          <box halign={Gtk.Align.START} vexpand={false}>
            <Gtk.Calendar
              showWeekNumbers={true}
              heightRequest={300}
              widthRequest={450}
            />
          </box>
          <Gtk.Separator orientation={Gtk.Orientation.VERTICAL} />
          <box orientation={Gtk.Orientation.VERTICAL}>
            <centerbox
              class="NotificationHeader"
              orientation={Gtk.Orientation.HORIZONTAL}
              widthRequest={450}
            >
              <box $type="center">
                <label label={"Notifications"} class="Title" />
              </box>
              <box $type="end">
                <button
                  iconName={dnd}
                  halign={Gtk.Align.START}
                  onClicked={() =>
                    notifd.set_dont_disturb(!notifd.get_dont_disturb())
                  }
                />
                <button
                  iconName={"user-trash-symbolic"}
                  onClicked={() =>
                    notifd.get_notifications().forEach((n) => n.dismiss())
                  }
                  halign={Gtk.Align.END}
                />
              </box>
            </centerbox>
            <scrolledwindow
              vexpand={true}
              hscrollbarPolicy={Gtk.PolicyType.NEVER}
            >
              <box
                halign={Gtk.Align.CENTER}
                orientation={Gtk.Orientation.VERTICAL}
                vexpand
              >
                <With value={notifications}>
                  {(notifications) =>
                    notifications.length === 0 && (
                      <label label={"No notifications"} />
                    )
                  }
                </With>
                <For each={notifications}>
                  {(n) => <Notification notification={n} />}
                </For>
              </box>
            </scrolledwindow>
          </box>
        </box>
      </box>
    </Popover>
  );
}
