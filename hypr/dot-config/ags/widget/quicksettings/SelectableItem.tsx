import { Accessor } from "ags";
import Gtk from "gi://Gtk?version=4.0";
import Pango from "gi://Pango?version=1.0";
import icons from "../../icons";

type SelectableItemProps = {
  label: Accessor<string> | string;
  icon?: Accessor<string> | string;
  onClicked: (self: Gtk.Widget) => void;
  onDestroy?(): void;
  selected: Accessor<boolean>;
  name?: string;
};

export const SelectableItem = ({
  name,
  label,
  icon,
  onClicked,
  selected,
  onDestroy,
}: SelectableItemProps) => {
  return (
    <button
      name={name}
      cssClasses={selected.as((selected) => (selected ? ["Selected"] : [""]))}
      visible
      onClicked={onClicked}
      onDestroy={onDestroy}
      tooltipText={label}
    >
      <box>
        {icon && <image iconName={icon} hexpand={false} />}
        <label
          label={label}
          ellipsize={Pango.EllipsizeMode.MIDDLE}
          hexpand
          xalign={0}
        />
        <image
          halign={Gtk.Align.END}
          iconName={icons.ui.tick}
          visible={selected}
        />
      </box>
    </button>
  );
};
