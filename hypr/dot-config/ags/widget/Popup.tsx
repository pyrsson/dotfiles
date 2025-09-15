import { Astal, Gtk, Gdk } from "ags/gtk4";
import Graphene from "gi://Graphene";
import { requests, setVisibleWindow, visibleWindow } from "../app";
import GObject from "gi://GObject?version=2.0";
import Adw from "gi://Adw";
import { setOpened } from "./quicksettings/Submenu";
import { Accessor } from "ags";

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
const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

export interface PopProps {
  name: string;
  children: Array<GObject.Object> | GObject.Object;
  halign?: Gtk.Align;
  valign?: Gtk.Align;
  anchor?: Astal.WindowAnchor;
  maxSize?: number;
}

export default function Popup({
  name,
  children,
  anchor = TOP,
  maxSize = 400,
  ...props
}: PopProps) {
  let contentbox: Gtk.Box;
  let win: Astal.Window;

  requests.get().set(name, (res) => {
    const win = visibleWindow.get();

    if (win === name) setVisibleWindow("");
    else setVisibleWindow(name);

    res("ok");
  });

  // close on ESC
  // handle alt + number key
  function onKey(
    _e: Gtk.EventControllerKey,
    keyval: number,
    _: number,
    _mod: number,
  ) {
    if (keyval === Gdk.KEY_Escape) {
      setVisibleWindow("");
      return;
    }

    // if (mod === Gdk.ModifierType.ALT_MASK) {
    //   for (const i of [1, 2, 3, 4, 5, 6, 7, 8, 9] as const) {
    //     if (keyval === Gdk[`KEY_${i}`]) {
    //       return launch(list.get()[i - 1]);
    //     }
    //   }
    // }
  }

  // close on clickaway
  function onClick(_e: Gtk.GestureClick, _: number, x: number, y: number) {
    const [, rect] = contentbox.compute_bounds(win);
    const position = new Graphene.Point({ x, y });

    if (!rect.contains_point(position)) {
      setVisibleWindow("");
      return true;
    }
  }

  return (
    <window
      $={(ref) => (win = ref)}
      name={name}
      class="Popup"
      namespace={"ags-popup"}
      anchor={anchor}
      visible={visibleWindow.as((win) => win === name)}
      exclusivity={Astal.Exclusivity.NORMAL}
      keymode={Astal.Keymode.EXCLUSIVE}
      onNotifyVisible={({ visible }) => {
        if (!visible) setOpened("");
      }}
      margin={8}
      layer={Astal.Layer.TOP}
    >
      <Gtk.EventControllerKey onKeyPressed={onKey} />
      <Gtk.GestureClick onPressed={onClick} />
      <box
        $={(ref) => (contentbox = ref)}
        class="popup-content"
        valign={Gtk.Align.START}
        halign={Gtk.Align.CENTER}
        orientation={Gtk.Orientation.VERTICAL}
      >
        <Adw.Clamp
          orientation={Gtk.Orientation.HORIZONTAL}
          maximumSize={maxSize}
        >
          {children}
        </Adw.Clamp>
      </box>
    </window>
  );
}
