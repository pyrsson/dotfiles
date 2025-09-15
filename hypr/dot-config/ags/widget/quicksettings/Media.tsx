import AstalMpris from "gi://AstalMpris";
import { createBinding, For } from "ags";
import { Gtk } from "ags/gtk4";

export function Media() {
  const mpris = AstalMpris.get_default();
  const players = createBinding(mpris, "players");

  return (
    <box class="Media">
      <For each={players}>
        {(player) => (
          <box spacing={4} widthRequest={200}>
            <box overflow={Gtk.Overflow.HIDDEN} css="border-radius: 8px;">
              <image pixelSize={64} file={createBinding(player, "coverArt")} />
            </box>
            <box
              valign={Gtk.Align.CENTER}
              orientation={Gtk.Orientation.VERTICAL}
            >
              <label xalign={0} label={createBinding(player, "title")} />
              <label xalign={0} label={createBinding(player, "artist")} />
            </box>
            <box hexpand halign={Gtk.Align.END}>
              <button
                onClicked={() => player.previous()}
                visible={createBinding(player, "canGoPrevious")}
              >
                <image iconName="media-seek-backward-symbolic" />
              </button>
              <button
                onClicked={() => player.play_pause()}
                visible={createBinding(player, "canControl")}
              >
                <box>
                  <image
                    iconName="media-playback-start-symbolic"
                    visible={createBinding(
                      player,
                      "playbackStatus",
                    )((s) => s === AstalMpris.PlaybackStatus.PLAYING)}
                  />
                  <image
                    iconName="media-playback-pause-symbolic"
                    visible={createBinding(
                      player,
                      "playbackStatus",
                    )((s) => s !== AstalMpris.PlaybackStatus.PLAYING)}
                  />
                </box>
              </button>
              <button
                onClicked={() => player.next()}
                visible={createBinding(player, "canGoNext")}
              >
                <image iconName="media-seek-forward-symbolic" />
              </button>
            </box>
          </box>
        )}
      </For>
    </box>
  );
}
