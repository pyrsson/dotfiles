import { Accessor, createBinding, For } from "ags";
import Network from "gi://AstalNetwork";
import { Dropdown, Menu } from "./Submenu";
import Gtk from "gi://Gtk?version=4.0";
import { execAsync } from "ags/process";
import { SelectableItem } from "./SelectableItem";

const network = Network.get_default();

export const WifiDropdown = () => {
  const wifi = createBinding(network, "wifi");

  return (
    <Dropdown
      label={wifi.as((wifi) => wifi.ssid || "Wifi")}
      name={"wifi"}
      icon={wifi.as((wifi) => wifi.iconName)}
      activate={() => {
        network.wifi.set_enabled(true);
        network.wifi.scan();
      }}
    />
  );
};

export const Wifi = () => {
  const aps = createBinding(network.wifi, "accessPoints").as((aps) => {
    return aps
      .filter((ap) => ap.ssid)
      .filter((ap, i, arr) => i === arr.findIndex((t) => t.ssid === ap.ssid))
      .sort((a, b) => b.strength - a.strength);
  });
  return (
    <Menu name={"wifi"}>
      <Gtk.ScrolledWindow
        hscrollbarPolicy={Gtk.PolicyType.NEVER}
        propagateNaturalHeight
        maxContentHeight={400}
        vexpand
      >
        <box orientation={Gtk.Orientation.VERTICAL} name={"wifilist"}>
          <For each={aps}>
            {(ap) =>
              SelectableItem({
                label: ap.ssid,
                icon: ap.iconName,
                onClicked: () => {
                  execAsync(`nmcli dev wifi connect ${ap.bssid} --ask`);
                },
                selected: createBinding(network.wifi, "activeAccessPoint").as(
                  (active) => active?.ssid === ap.ssid,
                ),
              })
            }
          </For>
        </box>
      </Gtk.ScrolledWindow>
    </Menu>
  );
};

// type WifiWidget = {
//   ssid: string;
//   strength: number;
//   iconName: string;
//   connected: boolean;
//   widget: Gtk.Widget;
// };

// class WifiMap extends Accessor {
//   #map: Map<string, WifiWidget> = new Map();
//   #var= createState(Gtk.Widget[]);
//
//   private notify() {
//     this.#var.set(
//       [...this.#map.values()]
//         .sort((a, b) => {
//           if (a.connected) return -1;
//           if (b.connected) return 1;
//           return b.strength - a.strength;
//         })
//         .map(({ widget }) => widget),
//     );
//   }
//
//   constructor() {
//     network.wifi.scan();
//     createBinding(network.wifi, "accessPoints").subscribe((aps) => {
//       const filtered = aps
//         .filter((ap) => ap.ssid)
//         .filter((ap, i, arr) => i === arr.findIndex((t) => t.ssid === ap.ssid));
//
//       filtered
//         .sort((a, b) => b.strength - a.strength)
//         .map((ap) => this.set(ap));
//       this.clear_stale(filtered);
//     });
//   }
//
//   private set(ap: Network.AccessPoint) {
//     const widget = this.#map.get(ap.ssid);
//     if (widget) {
//       widget.widget.unrealize();
//     }
//     this.#map.set(ap.ssid, {
//       ssid: ap.ssid,
//       strength: ap.strength,
//       iconName: ap.iconName,
//       connected: network.wifi.activeAccessPoint?.ssid === ap.ssid,
//       widget: SelectableItem({
//         name: ap.ssid,
//         label: ap.ssid,
//         onClicked: (self) => {
//           execAsync(`nmcli dev wifi connect ${ap.bssid} --ask`);
//         },
//         selected: createBinding(network.wifi, "activeAccessPoint").as((active) =>
//           active ? ap.ssid === active.ssid : false,
//         ),
//         icon: ap.iconName,
//       }),
//     });
//     this.notify();
//   }
//
//   private clear_stale(aps: Network.AccessPoint[]) {
//     for (const ap of this.#map.keys()) {
//       if (!aps.find((a) => a.ssid === ap)) {
//         const widget = this.#map.get(ap);
//         if (widget) {
//           widget.widget.unrealize();
//           this.#map.delete(ap);
//         }
//       }
//     }
//     this.notify();
//   }
//
//   get() {
//     return this.#var.get();
//   }
//
//   subscribe(callback: (list: Array<Gtk.Widget>) => void) {
//     return this.#var.subscribe(callback);
//   }
// }
