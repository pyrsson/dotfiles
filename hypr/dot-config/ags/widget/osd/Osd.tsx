import Gtk from "gi://Gtk?version=4.0";
import Brightness from "./brightness";
import Wp from "gi://AstalWp";
import { createBinding, createState, For, onCleanup } from "ags";
import { timeout } from "ags/time";
import app from "ags/gtk4/app";
import Astal from "gi://Astal?version=4.0";

export default function OSD() {
  const monitors = createBinding(app, "monitors");
  const brightness = Brightness.get_default();
  const speaker = Wp.get_default()!.get_default_speaker();
  const mic = Wp.get_default()!.get_default_microphone();

  const [iconName, setIconName] = createState("");
  const [value, setValue] = createState(0);
  const [max, setMax] = createState(0);
  const [visible, setVisible] = createState(false);

  let count = 0;
  function show(v: number, m: number, icon: string) {
    setVisible(true);
    setValue(v);
    setIconName(icon);
    setMax(m);
    count++;
    timeout(2000, () => {
      count--;
      if (count === 0) {
        setVisible(false);
      }
    });
  }

  const brightnessHandler = brightness.connect("notify::screen", () =>
    show(brightness.screen, 1, "display-brightness-symbolic"),
  );

  const speakerHandler = speaker.connect("notify::volume", () => {
    speaker.connect("notify::volume", () => {
      show(speaker.volume, 1.5, speaker.volumeIcon);
    });
    speaker.connect("notify::mute", () =>
      show(speaker.volume, 1.5, speaker.volumeIcon),
    );
  });
  const micHandler = mic.connect("notify::volume", () => {
    if (mic) {
      mic.connect("notify::volume", () => show(mic.volume, 1, mic.volumeIcon));
      mic.connect("notify::mute", () => show(mic.volume, 1, mic.volumeIcon));
    }
  });

  onCleanup(() => {
    brightness.disconnect(brightnessHandler);
    speaker.disconnect(speakerHandler);
    mic.disconnect(micHandler);
  });

  return (
    <For each={monitors} cleanup={(win) => (win as Gtk.Window).destroy()}>
      {(monitor) => (
        <window
          name="osd"
          class="OSD"
          application={app}
          gdkmonitor={monitor}
          layer={Astal.Layer.OVERLAY}
          keymode={Astal.Keymode.NONE}
          exclusivity={Astal.Exclusivity.IGNORE}
          anchor={Astal.WindowAnchor.BOTTOM}
          visible={visible}
        >
          <box onMoveFocus={(self) => self.get_parent()?.set_visible(false)}>
            <box class="OSD">
              <image iconName={iconName} />
              <levelbar
                valign={Gtk.Align.CENTER}
                widthRequest={150}
                value={value}
                maxValue={max}
              />
            </box>
          </box>
        </window>
      )}
    </For>
  );
}
