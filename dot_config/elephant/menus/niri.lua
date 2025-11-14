Name = "niri"
NamePretty = "Niri Workspaces"
Icon = "view-grid"
Action = "%VALUE%"
Cache = false
HideFromProviderlist = false
Description = "Niri Workspaces"
SearchName = true
History = false

function GetEntries()
	local entries = {}
	local handle = io.popen("niri msg --json workspaces")

	if handle then
		local jsonout = handle:read("*a")
		handle:close()
		local data = jsonDecode(jsonout)
		for _, workspace in ipairs(data) do
			if workspace.name ~= nil then
				table.insert(entries, {
					Text = workspace.name,
					Value = "niri msg action focus-workspace " .. workspace.name,
				})
			end
		end
	end

	table.insert(entries, {
		Text = "Create New Workspace",
		SubMenu = "newsession",
	})

	return entries
end
