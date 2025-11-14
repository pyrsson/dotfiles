Name = "newsession"
NamePretty = "New Niri Workspace"
Icon = "view-grid"
Cache = false
Action = "%VALUE%"
HideFromProviderlist = false
Description = "Niri Workspaces"
SearchName = true
History = false

function GetEntries()
	local entries = {}
	local handle = io.popen("fd --search-path $HOME/projects --exact-depth 2 --type d --format '{//}'")

	if handle then
		for p in handle:lines() do
			if p ~= nil then
				table.insert(entries, {
					Text = p,
					Value = "niri msg action create-workspace " .. tostring(p),
				})
			end
		end
	end

	return entries
end
