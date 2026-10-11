Name = "hyprland"
NamePretty = "Hyprland Workspaces"
Icon = "view-grid"
Cache = false
HideFromProviderlist = false
Description = "Hyprland Workspaces"
SearchName = true
History = false
FixedOrder = true

-- Workspaces that can't be closed from the menu (see hypr/hyprland/workspaces.lua)
local protected = { web = true, chat = true, gaming = true }

local function shell_quote(s)
	return "'" .. s:gsub("'", [['\'']]) .. "'"
end

local function dispatch(lua)
	os.execute("hyprctl dispatch " .. shell_quote(lua) .. " >/dev/null")
end

local function hyprctl_json(cmd)
	local handle = io.popen("hyprctl -j " .. cmd)
	if not handle then
		return nil
	end
	local out = handle:read("*a")
	handle:close()
	return jsonDecode(out)
end

-- Selector for a workspace: numeric id for regular workspaces, name for named ones
local function selector(ws)
	if ws.id > 0 then
		return tostring(ws.id)
	end
	return "name:" .. ws.name
end

function GetEntries()
	local entries = {}

	table.insert(entries, {
		Text = "Create New Workspace",
		SubMenu = "newsession",
	})

	local data = hyprctl_json("workspaces")
	if data then
		table.sort(data, function(a, b)
			return a.id < b.id
		end)
		for _, ws in ipairs(data) do
			if ws.id > 0 or not ws.name:match("^special") then
				local entry = {
					Text = ws.name,
					Value = selector(ws),
					Actions = {
						select = "lua:SelectEntry",
					},
				}
				if not protected[ws.name] then
					entry.Actions.close = "lua:CloseWorkspace"
				end
				table.insert(entries, entry)
			end
		end
	end

	return entries
end

function SelectEntry(value, args)
	local ws = tonumber(value) or string.format("%q", value)
	dispatch("hl.dsp.focus({ workspace = " .. ws .. " })")
end

function CloseWorkspace(value, args)
	local workspaces = hyprctl_json("workspaces")
	local clients = hyprctl_json("clients")
	if not workspaces or not clients then
		return
	end

	local workspace_id = nil
	for _, ws in ipairs(workspaces) do
		if selector(ws) == value then
			workspace_id = ws.id
			break
		end
	end
	if not workspace_id then
		return
	end

	for _, client in ipairs(clients) do
		if client.workspace and client.workspace.id == workspace_id then
			dispatch('hl.dsp.window.close({ window = "address:' .. client.address .. '" })')
		end
	end
end
