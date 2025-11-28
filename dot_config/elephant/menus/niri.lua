Name = "niri"
NamePretty = "Niri Workspaces"
Icon = "view-grid"
Cache = false
HideFromProviderlist = false
Description = "Niri Workspaces"
SearchName = true
History = false
FixedOrder = true

function GetEntries()
	local entries = {}
	local handle = io.popen("niri msg --json workspaces")

	table.insert(entries, {
		Text = "Create New Workspace",
		SubMenu = "newsession",
	})

	if handle then
		local jsonout = handle:read("*a")
		handle:close()
		local data = jsonDecode(jsonout)
		table.sort(data, function(a, b)
			return a.idx < b.idx
		end)
		for _, workspace in ipairs(data) do
			if workspace.name ~= nil then
				local entry = {
					Text = workspace.name,
					Value = workspace.name,
					Actions = {
						select = "lua:SelectEntry",
					},
				}
				if workspace.name ~= "default" and workspace.name ~= "chat" then
					entry.Actions.close = "lua:CloseWorkspace"
				end
				table.insert(entries, entry)
			end
		end
	end

	return entries
end

function SelectEntry(value, args)
	if value == "default" or value == "chat" then
		os.execute("niri msg action focus-workspace " .. value)
		return
	end
	os.execute("niri msg action move-workspace-to-index --reference " .. value .. " 2")
	os.execute("niri msg action move-workspace-to-index --reference chat 3")
	os.execute("niri msg action focus-workspace " .. value)
end

function CloseWorkspace(value, args)
	-- Get workspace id by name
	local ws_handle = io.popen("niri msg --json workspaces")
	if not ws_handle then
		return
	end
	local ws_json = ws_handle:read("*a")
	ws_handle:close()
	local workspaces = jsonDecode(ws_json)

	local workspace_id = nil
	for _, ws in ipairs(workspaces) do
		if ws.name == value then
			workspace_id = ws.id
			break
		end
	end

	if not workspace_id then
		return
	end

	-- Get all windows and close those on this workspace
	local win_handle = io.popen("niri msg --json windows")
	if win_handle then
		local win_json = win_handle:read("*a")
		win_handle:close()
		local windows = jsonDecode(win_json)

		for _, window in ipairs(windows) do
			if window.workspace_id == workspace_id then
				os.execute("niri msg action close-window --id " .. window.id)
			end
		end
	end

	-- Unset workspace name
	os.execute("niri msg action unset-workspace-name " .. value)
end
