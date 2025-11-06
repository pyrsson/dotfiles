import { Accessor, createState } from "ags";
import Gtk from "gi://Gtk?version=4.0";
import icons from "../../icons";
import Pango from "gi://Pango?version=1.0";
import GObject from "gi://GObject?version=2.0";

export const [opened, setOpened] = createState("");

type DropdownProps = {
  name: string;
  label?: Accessor<string> | Gtk.Label.ConstructorProps["label"];
  icon?: Accessor<string> | Gtk.Image.ConstructorProps["iconName"];
  activate?(): void;
};

export const Dropdown = ({ label, icon, name, activate }: DropdownProps) => {
  return (
    <button
      onClicked={() => {
        setOpened(opened.get() === name ? "" : name);
        if (typeof activate === "function") activate();
      }}
    >
      <box heightRequest={25}>
        <image iconName={icon} halign={Gtk.Align.START} />
        {label && (
          <label
            hexpand
            xalign={0}
            label={label}
            ellipsize={Pango.EllipsizeMode.END}
          />
        )}
        <image
          iconName={icons.ui.arrow.right}
          halign={Gtk.Align.END}
          $={(self) =>
            opened.subscribe(() => {
              if (opened.get() === name) {
                self.add_css_class("opened");
              }
              if (opened.get() !== name) {
                self.remove_css_class("opened");
              }
            })
          }
        />
      </box>
    </button>
  );
};

type MenuProps = {
  name: Accessor<string> | string;
  class?: Accessor<string> | string;
  children?: Array<GObject.Object> | GObject.Object;
};

export const Menu = ({ name, children, ...props }: MenuProps) => {
  const revealChild = opened.as((opened) => opened === name);
  return (
    <revealer
      name={name}
      class="Submenu"
      revealChild={revealChild}
      transitionDuration={200}
      transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
      vexpand
    >
      <box {...props} orientation={Gtk.Orientation.VERTICAL}>
        {children}
      </box>
    </revealer>
  );
};
