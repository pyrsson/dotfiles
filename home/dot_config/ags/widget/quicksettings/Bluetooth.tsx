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
      <scrolledwindow
        hscrollbarPolicy={Gtk.PolicyType.NEVER}
        propagateNaturalHeight
        maxContentHeight={300}
        minContentHeight={40}
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
      </scrolledwindow>
    </Menu>
  );
};
