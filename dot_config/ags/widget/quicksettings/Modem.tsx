import { createBinding, createState } from "ags";
import Network from "gi://AstalNetwork";
import { Dropdown, Menu } from "./Submenu";
import Gtk from "gi://Gtk?version=4.0";
import { SelectableItem } from "./SelectableItem";
import { execAsync } from "ags/process";
import { setVisibleWindow } from "../../app";
import icons from "../../icons";

const network = Network.get_default();

const [activeModem, setActiveModem] = createState("");

const client = network.get_client();
const dev = client.get_connections();

export const modems = dev.filter((dev) => dev.get_connection_type() === "gsm");

export const ModemDropdown = () => {
  return (
    <Dropdown
      label={activeModem.as((a) => a || "WWAN")}
      name={"modem"}
      icon={icons.network.wwan}
    />
  );
};

export const Modem = () => {
  return (
    <Menu name={"modem"}>
      <scrolledwindow
        hscrollbarPolicy={Gtk.PolicyType.NEVER}
        propagateNaturalHeight
        maxContentHeight={300}
        minContentHeight={40}
      >
        {ModemList()}
      </scrolledwindow>
    </Menu>
  );
};

export const ModemList = () => {
  // const client = network.get_client();
  // const dev = client.get_connections();
  //
  // const modems = dev.filter((dev) => dev.get_connection_type() === "gsm");
  return (
    <box name={"modemlist"} orientation={Gtk.Orientation.VERTICAL}>
      {modems.map((modem) =>
        SelectableItem({
          name: modem.get_id(),
          label: modem.get_id(),
          onClicked: (self: Gtk.Widget) => {
            if (self.cssClasses.includes("Selected")) {
              execAsync(`nmcli connection down "${modem.get_id()}"`);
            } else {
              execAsync(`nmcli connection up "${modem.get_id()}"`);
              setVisibleWindow("");
            }
          },
          selected: createBinding(client, "activeConnections").as((active) => {
            setActiveModem(
              active.find((a) => a.get_id() == modem.get_id())?.get_id() || "",
            );
            return active.findIndex((a) => a.get_id() == modem.get_id()) != -1;
          }),
        }),
      )}
    </box>
  );
};
