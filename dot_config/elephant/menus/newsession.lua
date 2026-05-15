Name = "newsession"
NamePretty = "New Niri Workspace"
Icon = "view-grid"
Cache = false
Action = "lua:CreateWorkspace"
HideFromProviderlist = false
Description = "Niri Workspaces"
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

function CreateWorkspace(value, args)
	-- local name = value:match("([^/]+)$")
	local name, _ = value:gsub("[/]", "-")

	os.execute("niri msg action focus-workspace 99")
	os.execute("niri msg action move-workspace-to-index 2")
	os.execute("niri msg action move-workspace-to-index --reference chat 3")
	os.execute("niri msg action set-workspace-name " .. name)
	os.execute("ghostty +new-window --working-directory=" .. value)
	os.execute("niri msg action maximize-column")
end
