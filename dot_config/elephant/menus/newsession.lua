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
	local projects = io.popen("fd --base-directory $HOME/projects --exact-depth 2 --type d --format '{}'")
	local gh_projects = io.popen("fd --base-directory $HOME/github --exact-depth 1 --type d --format '{}'")

	if projects then
		for p in projects:lines() do
			if p ~= nil then
				table.insert(entries, {
					Text = p,
					Value = home .. "/projects/" .. p,
				})
			end
		end
		projects:close()
	end

	if gh_projects then
		for p in gh_projects:lines() do
			if p ~= nil then
				table.insert(entries, {
					Text = p,
					Value = home .. "/github/" .. p,
				})
			end
		end
		gh_projects:close()
	end

	return entries
end

function CreateWorkspace(value, args)
	local name = value:match("([^/]+)$")

	os.execute("niri msg action focus-workspace 99")
	os.execute("niri msg action move-workspace-to-index 2")
	os.execute("niri msg action move-workspace-to-index --reference chat 3")
	os.execute("niri msg action set-workspace-name " .. name)
	os.execute("uwsm app -- ghostty --working-directory=" .. value)
	os.execute("niri msg action maximize-column")
end
