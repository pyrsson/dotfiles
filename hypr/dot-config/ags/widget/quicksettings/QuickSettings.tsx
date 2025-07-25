import { MicrophoneToggle, Sinks, Sources, SpeakerToggle } from "./Sound";
import { Wifi, WifiDropdown } from "./Wifi";
import { PowerProfilesMenu, PowerProfilesToggle } from "./Power";
import { Vpn, VpnDropdown } from "./Vpn";
import Popover, { Homogeneous, Row } from "../Popover";
import icons from "../../icons";
import Gtk from "gi://Gtk?version=4.0";
import { BtDropdown, BtList } from "./Bluetooth";
import { Media } from "./Media";

export default function QuickSettings() {
  return (
    <Popover
      name={"quicksettings"}
      icon={icons.ui.menu}
      halign={Gtk.Align.END}
      valign={Gtk.Align.START}
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
    </Popover>
  );
}
