import { createBinding, For } from "ags";
import Wp from "gi://AstalWp";
import icons from "../../icons";
import { Menu, opened, setOpened } from "./Submenu";
import { SelectableItem } from "./SelectableItem";
import Gtk from "gi://Gtk?version=4.0";
const { audio, video } = Wp.get_default()!;

export const SpeakerToggle = () => {
  const speaker = audio.defaultSpeaker!;
  const name = "audiosinks";
  let iconOpened = false;

  return (
    <box class="AudioSlider">
      <button onClicked={() => speaker.set_mute(!speaker.mute)}>
        <image iconName={createBinding(speaker, "volumeIcon")} />
      </button>
      <slider
        hexpand
        onValueChanged={({ value }) => (speaker.volume = value)}
        value={createBinding(speaker, "volume")}
        max={1.5}
      />
      <button
        name={name}
        onClicked={() => setOpened(opened.get() === name ? "" : name)}
      >
        <image
          iconName={icons.ui.arrow.right}
          halign={Gtk.Align.END}
          $={(self) =>
            opened.subscribe(() => {
              if (opened.get() === name && !iconOpened) {
                iconOpened = !iconOpened;
                self.add_css_class("opened");
              }
              if (opened.get() !== name && iconOpened) {
                iconOpened = !iconOpened;
                self.remove_css_class("opened");
              }
            })
          }
        />
      </button>
    </box>
  );
};

export const MicrophoneToggle = () => {
  const mic = audio.defaultMicrophone!;
  const name = "audiosources";
  let iconOpened = false;

  return (
    <box class="AudioSlider">
      <button onClicked={() => mic.set_mute(!mic.mute)}>
        <image iconName={createBinding(mic, "volumeIcon")} />
      </button>
      <slider
        hexpand
        onValueChanged={({ value }) => (mic.volume = value)}
        value={createBinding(mic, "volume")}
      />
      <button
        name={name}
        onClicked={() => setOpened(opened.get() === name ? "" : name)}
      >
        <image
          iconName={icons.ui.arrow.right}
          halign={Gtk.Align.END}
          $={(self) =>
            opened.subscribe(() => {
              if (opened.get() === name && !iconOpened) {
                iconOpened = !iconOpened;
                self.add_css_class("opened");
              }
              if (opened.get() !== name && iconOpened) {
                iconOpened = !iconOpened;
                self.remove_css_class("opened");
              }
            })
          }
        />
      </button>
    </box>
  );
};

export const Sinks = () => {
  const speakers = createBinding(audio, "speakers");
  return (
    <Menu name={"audiosinks"}>
      <For each={speakers}>
        {(speaker) =>
          SelectableItem({
            label: createBinding(speaker, "description"),
            icon: icons.audio.type.speaker,
            onClicked: () => {
              speaker.set_is_default(true);
            },
            selected: createBinding(speaker, "isDefault"),
          })
        }
      </For>
    </Menu>
  );
};

export const Sources = () => {
  const sources = createBinding(audio, "microphones");
  return (
    <Menu name={"audiosources"}>
      <For each={sources}>
        {(source) =>
          SelectableItem({
            label: createBinding(source, "description"),
            icon: icons.audio.mic.high,
            onClicked: () => {
              source.set_is_default(true);
            },
            selected: createBinding(source, "isDefault"),
          })
        }
      </For>
    </Menu>
  );
};

function PrivacyTooltip(eps: Wp.Endpoint[] | Wp.Stream[]) {
  return (
    <box orientation={Gtk.Orientation.VERTICAL}>
      {eps.map((ep) => {
        return (
          <box>
            <image iconName={ep.icon} />
            <label label={ep.description} />
          </box>
        );
      })}
    </box>
  );
}

function PrivacyIndicator({
  obj,
  type,
}: {
  obj: Wp.Audio | Wp.Video;
  type: "recorders" | "streams";
}) {
  return (
    <image
      visible={createBinding(obj, type).as((list) => list.length > 0)}
      class="PrivacyIndicator"
      iconName={
        type == "recorders"
          ? "audio-input-microphone-symbolic"
          : "audio-speakers-symbolic"
      }
      has_tooltip={true}
      onQueryTooltip={(self, x, y, kbtt, tooltip) => {
        tooltip.set_custom(PrivacyTooltip(obj[type]) as Gtk.Widget);
        return true;
      }}
    />
  );
}

export const PrivacyModule = () => {
  return (
    <box>
      <PrivacyIndicator obj={audio} type="recorders" />
      <PrivacyIndicator obj={video} type="recorders" />
    </box>
  );
};
