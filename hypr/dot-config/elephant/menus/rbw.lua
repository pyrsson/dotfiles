Name = "bitwarden"
NamePretty = "Bitwarden"
Icon = "bitwarden"
Cache = false
Action = "rbw get %VALUE% -c"
HideFromProviderlist = false
Description = "Get items from Bitwarden with rbw"
SearchName = true
History = true
HistoryWhenEmpty = true

function GetEntries()
	local entries = {}
	local unlocked = os.execute("rbw unlocked")

	if unlocked == 0 then
		local list = io.popen("rbw list --fields id,name,user")
		if list then
			for line in list:lines() do
				local id, name, user = line:match("^(.-)\t(.-)\t(.-)$")
				table.insert(entries, {
					Identifier = id,
					Subtext = user,
					Text = name,
					Value = id,
					Actions = {
						copy_password = "rbw get " .. id .. " -c",
						copy_username = "rbw get " .. id .. " --field user -c",
						copy_totp = "rbw get " .. id .. " --field totp -c",
						copy_url = "rbw get " .. id .. " --field uris -c",
					},
				})
			end
			list:close()
			return entries
		end
	end

	table.insert(entries, {
		Subtext = "rbw",
		Text = "Unlock Bitwarden vault",
		Icon = "bitwarden",
		Value = "unlock",
		Actions = { unlock = "rbw unlock" },
	})
	return entries
end
