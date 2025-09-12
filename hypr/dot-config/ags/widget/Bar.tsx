import Gtk from "gi://Gtk?version=4.0";
import Hyprland from "gi://AstalHyprland";
import Mpris from "gi://AstalMpris";
import Battery from "gi://AstalBattery";
import AstalTray from "gi://AstalTray";
import Dashboard, { DashboardButton } from "./dashboard/Dashboard";
import QuickSettings, {
  QuickSettingsButton,
} from "./quicksettings/QuickSettings";
import Pango from "gi://Pango";
import { PrivacyModule } from "./quicksettings/Sound";
import { createBinding, For, With } from "ags";
import app from "ags/gtk4/app";
import Astal from "gi://Astal?version=4.0";
import Adw from "gi://Adw?version=1";

function FocusedClient({ maxSize }: { maxSize: number }) {
  const hypr = Hyprland.get_default();
  const focused = createBinding(hypr, "focusedClient");

  return (
    <Adw.Clamp maximumSize={maxSize} halign={Gtk.Align.START}>
      <box
        class="FocusedClient"
        visible={focused.as(Boolean)}
        halign={Gtk.Align.START}
      >
        <With value={focused}>
          {(focused) => (
            <label
              xalign={0}
              widthRequest={maxSize}
              halign={Gtk.Align.START}
              label={createBinding(focused, "title")}
              ellipsize={Pango.EllipsizeMode.END}
            />
          )}
        </With>
      </box>
    </Adw.Clamp>
  );
}

function Workspaces() {
  const hypr = Hyprland.get_default();
  const workspaces = createBinding(hypr, "workspaces").as((wss) =>
    wss.sort((a, b) => a.id - b.id),
  );

  return (
    <box
      class="Workspaces"
      halign={Gtk.Align.START}
      widthRequest={workspaces.as((wss) => wss.length * 40)}
    >
      <For each={workspaces}>
        {(ws) => (
          <button
            class={createBinding(hypr, "focusedWorkspace").as((fw) =>
              ws === fw ? "focused" : "",
            )}
            onClicked={() => ws.focus()}
          >
            {ws.id}
          </button>
        )}
      </For>
    </box>
  );
}

function SysTray() {
  const tray = AstalTray.get_default();
  const items = createBinding(tray, "items");

  const init = (btn: Gtk.MenuButton, item: AstalTray.TrayItem) => {
    const menu = Gtk.PopoverMenu.new_from_model(item.menuModel);
    menu.set_flags(Gtk.PopoverMenuFlags.NESTED);
    menu.set_has_arrow(false);
    btn.set_popover(menu);
    btn.insert_action_group("dbusmenu", item.actionGroup);
    item.connect("notify::action-group", () => {
      btn.insert_action_group("dbusmenu", item.actionGroup);
    });
  };

  return (
    <box class="SysTray">
      <For each={items}>
        {(item) => (
          <menubutton $={(self) => init(self, item)}>
            <image gicon={createBinding(item, "gicon")} />
          </menubutton>
        )}
      </For>
    </box>
  );
}

function BatteryLevel() {
  const bat = Battery.get_default();

  return (
    <box class="Battery" visible={createBinding(bat, "isPresent")}>
      <image iconName={createBinding(bat, "batteryIconName")} />
      <label
        label={createBinding(bat, "percentage").as(
          (p) => `${Math.floor(p * 100)} %`,
        )}
      />
    </box>
  );
}

function Media() {
  const mpris = Mpris.get_default();
  const players = createBinding(mpris, "players");

  return (
    <box class="Media">
      <With value={players}>
        {(ps) =>
          ps[0] ? (
            <box>
              <box class="Cover" valign={Gtk.Align.CENTER} />
              <label
                label={createBinding(ps[0], "metadata").as(
                  () => `${ps[0].title} - ${ps[0].artist}`,
                )}
              />
            </box>
          ) : (
            <label label="Nothing Playing" />
          )
        }
      </With>
    </box>
  );
}

export default function Bar() {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;
  const monitors = createBinding(app, "monitors");

  return (
    <For each={monitors} cleanup={(win) => (win as Gtk.Window).destroy()}>
      {(monitor) => {
        const maxSize = monitor.geometry.width / 2 - 250;
        return (
          <window
            name="bar"
            class="Bar"
            gdkmonitor={monitor}
            keymode={Astal.Keymode.ON_DEMAND}
            exclusivity={Astal.Exclusivity.EXCLUSIVE}
            anchor={TOP | LEFT | RIGHT}
            $={(self) => app.add_window(self)}
            visible={true}
            application={app}
          >
            <centerbox>
              <box $type="start" halign={Gtk.Align.START} hexpand={false}>
                <Workspaces />
                <FocusedClient maxSize={maxSize} />
              </box>
              <box $type="center">
                <DashboardButton />
              </box>
              <box $type="end" hexpand halign={Gtk.Align.END}>
                <PrivacyModule />
                <SysTray />
                <BatteryLevel />
                <QuickSettingsButton />
              </box>
            </centerbox>
          </window>
        );
      }}
    </For>
  );
}
