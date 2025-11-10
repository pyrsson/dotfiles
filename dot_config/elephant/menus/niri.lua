Name = "niri"
NamePretty = "Niri Windows"
Icon = "niri"
Cache = false
Action = "niri msg action focus-window --id %VALUE%"
HideFromProviderlist = false
Description = "Niri Windows"
SearchName = true
History = false

function GetEntries()
	local entries = {}
	local handle =
		io.popen([[niri msg --json windows | jq -r '.[] | "\(.id)\t\(.title)\t\(.app_id)\t\(.workspace_id)"']])

	if handle then
		for line in handle:lines() do
			local id, title, app_id, workspace_id = line:match("^([^\t]+)\t([^\t]*)\t([^\t]*)\t([^\t]*)$")
			if id then
				table.insert(entries, {
					Text = title ~= "" and title or "Untitled",
					Subtext = workspace_id ~= "" and workspace_id or "Unknown",
					Value = id,
					Icon = app_id ~= "" and app_id or "window",
				})
			end
		end
		handle:close()
	end

	return entries
end
