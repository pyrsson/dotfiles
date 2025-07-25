import { createBinding, createState } from "ags";
import Network from "gi://AstalNetwork";
import { Dropdown, Menu } from "./Submenu";
import Gtk from "gi://Gtk?version=4.0";
import { SelectableItem } from "./SelectableItem";
import icons from "../../icons";
import { execAsync } from "ags/process";

const network = Network.get_default();

const [activeVpn, setActiveVpn] = createState("");

export const VpnDropdown = () => {
  return (
    <Dropdown
      label={activeVpn.as((a) => a || "VPN")}
      name={"vpn"}
      icon={icons.lock}
    />
  );
};

export const Vpn = () => {
  return (
    <Menu name={"vpn"}>
      <Gtk.ScrolledWindow
        hscrollbarPolicy={Gtk.PolicyType.NEVER}
        propagateNaturalHeight
        maxContentHeight={300}
      >
        {VpnList()}
      </Gtk.ScrolledWindow>
    </Menu>
  );
};

export const VpnList = () => {
  const client = network.get_client();
  const dev = client.get_connections();

  const vpns = dev.filter((dev) =>
    ["vpn", "pptp", "l2tp", "wireguard"].includes(dev.get_connection_type()),
  );
  return (
    <box name={"vpnlist"} orientation={Gtk.Orientation.VERTICAL}>
      {vpns.map((vpn) =>
        SelectableItem({
          name: vpn.get_id(),
          label: vpn.get_id(),
          onClicked: (self: Gtk.Widget) => {
            if (self.cssClasses.includes("Selected")) {
              execAsync(`nmcli connection down "${vpn.get_id()}"`);
            } else {
              execAsync(`nmcli connection up "${vpn.get_id()}" --ask`);
              (self.get_ancestor(Gtk.Popover.$gtype) as Gtk.Popover)?.popdown();
            }
          },
          selected: createBinding(client, "activeConnections").as((active) => {
            setActiveVpn(
              active.find((a) => a.get_id() == vpn.get_id())?.get_id() || "",
            );
            return active.findIndex((a) => a.get_id() == vpn.get_id()) != -1;
          }),
        }),
      )}
    </box>
  );
};
