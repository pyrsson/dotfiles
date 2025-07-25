import { createBinding, For } from "ags";
import Bluetooth from "gi://AstalBluetooth";
import { Dropdown, Menu } from "./Submenu";
import Gtk from "gi://Gtk?version=4.0";
import icons from "../../icons";
import { SelectableItem } from "./SelectableItem";

const bluetooth = Bluetooth.get_default();

export const BtDropdown = () => {
  const connected = createBinding(bluetooth, "isConnected");

  return (
    <Dropdown
      label={"Bluetooth"}
      name={"btdevices"}
      icon={connected.as((bt) =>
        bt ? icons.bluetooth.enabled : icons.bluetooth.disabled,
      )}
      activate={() => {}}
    />
  );
};

export const BtList = () => {
  const bt = createBinding(bluetooth, "devices");
  return (
    <Menu name={"btdevices"}>
      <Gtk.ScrolledWindow
        hscrollbarPolicy={Gtk.PolicyType.NEVER}
        propagateNaturalHeight
        maxContentHeight={200}
      >
        <box orientation={Gtk.Orientation.VERTICAL} name={"btlist"}>
          <For each={bt}>
            {(dev) =>
              SelectableItem({
                onClicked: () => {
                  if (dev.connected) {
                    dev.disconnect_device((_d, result) => {
                      try {
                        dev.disconnect_device_finish(result);
                      } catch (e) {
                        console.warn("Failed to disconnect", e);
                      }
                    });
                  }
                  if (dev.paired) {
                    dev.connect_device((d, result) => {
                      try {
                        dev.connect_device_finish(result);
                        console.log("Connected to", d?.name);
                      } catch (e) {
                        console.warn(e);
                      }
                    });
                  }
                  if (!dev.connected && !dev.paired) {
                    dev.pair();
                  }
                },
                selected: createBinding(dev, "connected"),
                icon: dev.icon,
                label: dev.name,
              })
            }
          </For>
        </box>
      </Gtk.ScrolledWindow>
    </Menu>
  );
};

// type BtWidget = {
//   connected: boolean;
//   paired: boolean;
//   name: string;
//   address: string;
//   widget: Gtk.Widget;
// };
//
// class BtDeviceMap implements Subscribable {
//   #map: Map<string, BtWidget> = new Map();
//   #var: Variable<Array<Gtk.Widget>> = Variable([]);
//
//   private notify() {
//     this.#var.set(
//       [...this.#map.values()]
//         .sort((a, b) => {
//           if (a.connected || a.paired) return -1;
//           if (b.connected || b.paired) return 1;
//           return b.name.localeCompare(a.name);
//         })
//         .map(({ widget }) => widget),
//     );
//   }
//
//   constructor() {
//     bluetooth.devices.map((dev) => {
//       this.set(dev);
//     });
//     bluetooth.connect("device-added", (_, dev) => {
//       dev.connect("notify::connected", () => this.set(dev));
//       dev.connect("notify::paired", () => this.set(dev));
//       this.set(dev);
//     });
//     bluetooth.connect("device-removed", (_, dev) => this.delete(dev));
//   }
//
//   private set(dev: Bluetooth.Device) {
//     const widget = this.#map.get(dev.address);
//     if (widget) {
//       widget.widget.unrealize();
//     }
//     this.#map.set(dev.address, {
//       address: dev.address,
//       name: dev.name,
//       connected: dev.connected,
//       paired: dev.paired,
//       widget: SelectableItem({
//         label: dev.name,
//         onClicked: () => {
//           if (dev.connected) {
//             dev.disconnect_device((_d, result) => {
//               try {
//                 dev.disconnect_device_finish(result);
//               } catch (e) {
//                 console.warn("Failed to disconnect", e);
//               }
//             });
//           }
//           if (dev.paired) {
//             dev.connect_device((d, result) => {
//               try {
//                 dev.connect_device_finish(result);
//                 console.log("Connected to", d?.name);
//               } catch (e) {
//                 console.warn(e);
//               }
//             });
//           }
//           if (!dev.connected && !dev.paired) {
//             dev.pair();
//           }
//         },
//         selected: createBinding(dev, "connected"),
//         icon: dev.icon,
//       }),
//     });
//     this.notify();
//   }
//
//   private delete(dev: Bluetooth.Device) {
//     const widget = this.#map.get(dev.address);
//     if (widget) {
//       widget.widget.unrealize();
//       this.#map.delete(dev.address);
//       this.notify();
//     }
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
