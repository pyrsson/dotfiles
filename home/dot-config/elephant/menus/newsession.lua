Name = "newsession"
NamePretty = "New Workspace"
Icon = "view-grid"
Cache = false
Action = "lua:CreateWorkspace"
HideFromProviderlist = false
Description = "New workspace for a project"
SearchName = true
History = false

function GetEntries()
	local entries = {}
	local home = os.getenv("HOME")
	local projects = io.popen(
		"fd -E /archive/ --strip-cwd-prefix=always --base-directory $HOME/Projects --exact-depth 2 --type d --format '{}'"
	)

	if projects then
		for p in projects:lines() do
			if p ~= nil then
				table.insert(entries, {
					Text = p,
					Value = home .. "/Projects/" .. p,
				})
			end
		end
		projects:close()
	end

	return entries
end

local function niri_running()
	local ok = os.execute("niri msg version >/dev/null 2>&1")
	return ok == true or ok == 0 -- Lua 5.1 returns the exit code, 5.2+ a boolean
end

function CreateWorkspace(value, args)
	local project = value:match("([^/]+/[^/]+)$")
	local name, _ = project:gsub("[/]", "-")

	if niri_running() then
		os.execute("niri msg action focus-workspace 99")
		os.execute("niri msg action move-workspace-to-index 2")
		os.execute("niri msg action move-workspace-to-index --reference chat 3")
		os.execute("niri msg action set-workspace-name " .. name)
		os.execute("ghostty +new-window --working-directory=" .. value)
		os.execute("niri msg action maximize-column")
	else
		-- Hyprland: named workspaces are created on focus
		os.execute("hyprctl dispatch 'hl.dsp.focus({ workspace = \"name:" .. name .. "\" })' >/dev/null")
		os.execute("ghostty +new-window --working-directory=" .. value)
	end
end
