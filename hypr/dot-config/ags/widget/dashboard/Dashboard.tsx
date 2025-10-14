import GLib from "gi://GLib?version=2.0";
import { createPoll } from "ags/time";
import { Gtk } from "ags/gtk4";
import AstalNotifd from "gi://AstalNotifd";
import Notification from "../notifications/Notification";
import { createState, For, onCleanup, With } from "ags";
import Popup from "../Popup";
import { setVisibleWindow } from "../../app";
import Adw from "gi://Adw";

export function DashboardButton() {
  const format = "%A %e %b - %H:%M";
  const time = createPoll(
    "",
    1000,
    () => GLib.DateTime.new_now_local().format(format)!,
  );
  return (
    <button onClicked={() => setVisibleWindow("dashboard")}>
      <label label={time} />
    </button>
  );
}

export default function Dashboard() {
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
    <Popup name="dashboard">
      <box orientation={Gtk.Orientation.VERTICAL}>
        <label label={"Dashboard"} class="Title" />
        <box orientation={Gtk.Orientation.HORIZONTAL}>
          <Adw.Clamp
            orientation={Gtk.Orientation.VERTICAL}
            maximumSize={300}
            valign={Gtk.Align.START}
          >
            <box halign={Gtk.Align.START} vexpand={false}>
              <Gtk.Calendar
                showWeekNumbers={true}
                heightRequest={300}
                widthRequest={450}
              />
            </box>
          </Adw.Clamp>
          <Gtk.Separator orientation={Gtk.Orientation.VERTICAL} />

          <Adw.Clamp
            orientation={Gtk.Orientation.VERTICAL}
            maximumSize={400}
            valign={Gtk.Align.START}
          >
            <box
              orientation={Gtk.Orientation.VERTICAL}
              valign={Gtk.Align.START}
            >
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
                hscrollbarPolicy={Gtk.PolicyType.NEVER}
                propagateNaturalHeight
              >
                <box
                  halign={Gtk.Align.CENTER}
                  orientation={Gtk.Orientation.VERTICAL}
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
          </Adw.Clamp>
        </box>
      </box>
    </Popup>
  );
}
