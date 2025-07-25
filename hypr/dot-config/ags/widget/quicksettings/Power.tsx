import PowerProfiles from "gi://AstalPowerProfiles";
import { Dropdown, Menu } from "./Submenu";
import { createBinding } from "ags";
import { capitalize } from "../../utils/utils";
import { SelectableItem } from "./SelectableItem";
import Gtk from "gi://Gtk?version=4.0";
import icons from "../../icons";

const getProfileIcon = (profile: string) => {
  switch (profile) {
    case "balanced":
      return icons.powerprofile.Balanced;
    case "power-saver":
      return icons.powerprofile.Powersaver;
    case "performance":
      return icons.powerprofile.Performance;
  }
};

export const PowerProfilesToggle = () => {
  const powerProfiles = PowerProfiles.get_default();
  return (
    <Dropdown
      label={createBinding(powerProfiles, "active_profile").as(
        (active) => capitalize(active) || "",
      )}
      name={"power"}
      icon={createBinding(powerProfiles, "iconName")}
    />
  );
};

export const PowerProfilesMenu = () => {
  const powerProfiles = PowerProfiles.get_default();
  const profiles = powerProfiles.get_profiles();
  return (
    <Menu name={"power"}>
      <box orientation={Gtk.Orientation.VERTICAL}>
        {profiles.map((profile) =>
          SelectableItem({
            label: capitalize(profile.profile),
            icon: getProfileIcon(profile.profile),
            onClicked: () => {
              powerProfiles.set_active_profile(profile.profile);
            },
            selected: createBinding(powerProfiles, "active_profile").as(
              (active) => active === profile.profile,
            ),
          }),
        )}
      </box>
    </Menu>
  );
};
