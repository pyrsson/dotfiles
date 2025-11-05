import { For, createBinding, createConnection, createState } from "ags";
import { Astal, Gtk, Gdk } from "ags/gtk4";
import AstalApps from "gi://AstalApps";
import Graphene from "gi://Graphene";
import { requests, setVisibleWindow, visibleWindow } from "../../app";
import Adw from "gi://Adw";

const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;

export default function Applauncher() {
  let contentbox: Gtk.Box;
  let searchentry: Gtk.Entry;
  let win: Astal.Window;

  const apps = new AstalApps.Apps({
    entryMultiplier: 0,
    nameMultiplier: 3,
  });
  const [list, setList] = createState(new Array<AstalApps.Application>());

  requests.get().set("applauncher", (res) => {
    const win = visibleWindow.get();

    if (win === "applauncher") setVisibleWindow("");
    else setVisibleWindow("applauncher");

    res("ok");
  });

  function search(text: string) {
    if (text === "") setList([]);
    else setList(apps.fuzzy_query(text).slice(0, 8));
  }

  function launch(app?: AstalApps.Application) {
    if (app) {
      setVisibleWindow("");
      app.launch();
    }
  }

  // close on ESC
  // handle alt + number key
  function onKey(
    _e: Gtk.EventControllerKey,
    keyval: number,
    _: number,
    mod: number,
  ) {
    if (keyval === Gdk.KEY_Escape) {
      setVisibleWindow("");
      return;
    }

    if (mod === Gdk.ModifierType.ALT_MASK) {
      for (const i of [1, 2, 3, 4, 5, 6, 7, 8, 9] as const) {
        if (keyval === Gdk[`KEY_${i}`]) {
          return launch(list.get()[i - 1]);
        }
      }
    }
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
      name="applauncher"
      class="Picker"
      namespace={"ags-applauncher"}
      anchor={TOP}
      visible={visibleWindow.as((win) => win === "applauncher")}
      exclusivity={Astal.Exclusivity.NORMAL}
      keymode={Astal.Keymode.EXCLUSIVE}
      onNotifyVisible={({ visible }) => {
        if (visible) searchentry.grab_focus();
        else searchentry.set_text("");
      }}
      marginTop={8}
    >
      <Adw.Clamp maximumSize={400}>
        <Gtk.EventControllerKey onKeyPressed={onKey} />
        <Gtk.GestureClick onPressed={onClick} />
        <box
          $={(ref) => (contentbox = ref)}
          name="picker-content"
          valign={Gtk.Align.START}
          halign={Gtk.Align.CENTER}
          orientation={Gtk.Orientation.VERTICAL}
          widthRequest={400}
        >
          <entry
            $={(ref) => (searchentry = ref)}
            onNotifyText={({ text }) => search(text)}
            onActivate={() => launch(list.get()[0])}
            placeholderText="Start typing to search"
          />
          <Gtk.Separator visible={list((l) => l.length > 0)} />
          <box orientation={Gtk.Orientation.VERTICAL}>
            <For each={list}>
              {(app, index) => (
                <button onClicked={() => launch(app)}>
                  <box>
                    <image iconName={app.iconName} />
                    <label label={app.name} maxWidthChars={40} wrap />
                    <label
                      hexpand
                      halign={Gtk.Align.END}
                      label={index((i) => `alt+${i + 1}`)}
                    />
                  </box>
                </button>
              )}
            </For>
          </box>
        </box>
      </Adw.Clamp>
    </window>
  );
}
