import { MicrophoneToggle, Sinks, Sources, SpeakerToggle } from "./Sound";
import { Wifi, WifiDropdown } from "./Wifi";
import { PowerProfilesMenu, PowerProfilesToggle } from "./Power";
import { Vpn, VpnDropdown } from "./Vpn";
import { Homogeneous, Row } from "../Popover";
import icons from "../../icons";
import Gtk from "gi://Gtk?version=4.0";
import { BtDropdown, BtList } from "./Bluetooth";
import { Media } from "./Media";
import Popup from "../Popup";
import { setVisibleWindow } from "../../app";
import { Astal } from "ags/gtk4";

export const QuickSettingsButton = () => (
  <button onClicked={() => setVisibleWindow("quicksettings")}>
    <image iconName={icons.ui.menu} />
  </button>
);

export default function QuickSettings() {
  return (
    <Popup
      name={"quicksettings"}
      halign={Gtk.Align.END}
      valign={Gtk.Align.START}
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.RIGHT}
      maxSize={400}
    >
      <box orientation={Gtk.Orientation.VERTICAL} widthRequest={400}>
        <label label={"Quick Settings"} />
        <Gtk.Separator orientation={Gtk.Orientation.HORIZONTAL} />

        <Row toggles={[Homogeneous([SpeakerToggle()])]} menus={[Sinks()]} />
        <Row
          toggles={[Homogeneous([MicrophoneToggle()])]}
          menus={[Sources()]}
        />
        <Row
          toggles={[Homogeneous([BtDropdown(), WifiDropdown()])]}
          menus={[BtList(), Wifi()]}
        />
        <Row
          toggles={[Homogeneous([PowerProfilesToggle(), VpnDropdown()])]}
          menus={[PowerProfilesMenu(), Vpn()]}
        />

        <Gtk.Separator orientation={Gtk.Orientation.HORIZONTAL} />
        <Media />
      </box>
    </Popup>
  );
}
