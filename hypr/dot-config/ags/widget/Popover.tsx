import { opened, setOpened } from "./quicksettings/Submenu";
import { Requests } from "../app";
import { Gtk } from "ags/gtk4";
import GObject from "gi://GObject?version=2.0";
import { Accessor } from "ags";
import Adw from "gi://Adw?version=1";

export type PopProps = {
  name?: string;
  icon?: Accessor<string> | Gtk.Image.ConstructorProps["iconName"];
  label?: Accessor<string> | Gtk.Label.ConstructorProps["label"];
  children: JSX.Element;
  halign?: Gtk.Align;
  valign?: Gtk.Align;
  maxSize?: number;
};

export const Row = ({
  toggles,
  menus,
}: {
  toggles: JSX.Element[];
  menus: JSX.Element[];
}) => (
  <box orientation={Gtk.Orientation.VERTICAL}>
    <box class="row horizontal" children={toggles} />
    {menus}
  </box>
);

export const Homogeneous = (toggles: GObject.Object[]) => (
  <box homogeneous={true} children={toggles} />
);

export default function Popover({
  name,
  icon,
  label,
  children,
  maxSize,
  ...props
}: PopProps) {
  return (
    <menubutton>
      {icon && <image iconName={icon} />}
      {label && <label label={label} />}
      <popover
        $={(self) => {
          if (name) {
            Requests.get().set(name, (res) => {
              if (self.visible) {
                self.popdown();
                res("closed " + name);
              } else {
                self.popup();
                res("opened " + name);
              }
            });
          }
          self.connect("closed", () => {
            setOpened("");
          });
          // self.set_offset(0, 0);
        }}
        hasArrow={false}
        {...props}
      >
        <Adw.Clamp maximumSize={maxSize}>{children}</Adw.Clamp>
      </popover>
    </menubutton>
  );
}
