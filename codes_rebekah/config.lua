
yandereWaifu.MCM = {
	--DashKeyEnable = false--,
	--DashKeyboardBinding = ModConfigMenu.Config["Cursed Rebekah"]["Rebekah Dash Keyboard Binding"],
	--DashControllerBinding = ModConfigMenu.Config["Cursed Rebekah"]["Rebekah Dash Controller Binding"]
}

if ModConfigMenu and potatoNachos then
	ModConfigMenu.SetCategoryInfo("Cursed Rebekah", "Cursed and Brokenhearted Settings")
	
	--[[ModConfigMenu.AddSetting("Cursed Rebekah", "General",
			{
				Type = ModConfigMenu.OptionType.BOOLEAN,
				CurrentSetting = function()
					return yandereWaifu.MCM.DashKeyEnable
				end,
				Display = function()
					local onOff = "Disabled"
					if yandereWaifu.MCM.DashKeyEnable then
						onOff = "Enabled"
					end
					return "Dash with a separate key: " .. onOff
				end,
				OnChange = function(currentBool)
					yandereWaifu.MCM.DashKeyEnable = currentBool
				end
			}
		)
	
	ModConfigMenu.AddSetting("Cursed Rebekah", "General",
			{
				Type = ModConfigMenu.OptionType.KEYBIND_KEYBOARD,
				CurrentSetting = function()
					return yandereWaifu.MCM.DashKeyboardBinding
				end,
				Display = function()
					local currentValue = Keyboard.KEY_C
					if yandereWaifu.MCM.DashKeyboardBinding then
						currentValue = yandereWaifu.MCM.DashKeyboardBinding
					end
					return "Key: " .. currentValue
				end,
				OnChange = function(currentBool)
					ModConfigMenu.Config["Cursed Rebekah"]["Rebekah Dash Keyboard Binding"] = currentBool
				end
			}
		)]]
		
	--[[ModConfigMenu.AddSetting("Cursed Rebekah", "General",
			{
				Type = ModConfigMenu.OptionType.KEYBIND_KEYBOARD,
				CurrentSetting = function()
					return yandereWaifu.MCM.DashControllerBinding
				end,
				Display = function()
					local onOff = "Disabled"
					if yandereWaifu.MCM.DashControllerBinding then
						onOff = yandereWaifu.MCM.DashControllerBinding
					end
					return "Key: " .. onOff
				end,
				OnChange = function(currentBool)
					yandereWaifu.MCM.DashControllerBinding = currentBool
				end
			}
		)]]
	ModConfigMenu.AddTitle("Cursed Rebekah", nil, "Dash Settings", nil)
	ModConfigMenu.AddBooleanSetting(
		"Cursed Rebekah",
		"Rebekah Dash Alternative Key Enable",
		false,
		"Dash Key Enable",
		{[true]="On",[false]="Off"},
		"Enable Rebekah Dash Key Alternative?")

	ModConfigMenu.AddKeyboardSetting("Cursed Rebekah", "Rebekah Dash Keyboard Binding",
		Keyboard.KEY_C,
		"Keyboard Binding",
		true,
		"Rebekah Dash")
	ModConfigMenu.AddControllerSetting("Cursed Rebekah", "Rebekah Dash Controller Binding",
		0,
		"Controller Binding",
		true,
		"Rebekah Dash (Controller)")
		
	ModConfigMenu.AddSpace("Cursed Rebekah", nil)	
	ModConfigMenu.AddTitle("Cursed Rebekah", nil, "Beta Settings", nil)
	
	ModConfigMenu.AddBooleanSetting("Cursed Rebekah", "Enable beta items",
		false,
		"Enable beta items",
		{[true]="On",[false]="Off"},
		"Enable Beta Items??")
	ModConfigMenu.AddBooleanSetting("Cursed Rebekah", "Enable unlockable items",
		false,
		"Enable unlockable Rebekah items",
		{[true]="On",[false]="Off"},
		"Enable unlockable Rebekah Items normally unlocked through defeating final bosses but hasn't been set up yet???")
	--variable stuff
	--yandereWaifu.MCM = ModConfigMenu.Config["Cursed and Brokenhearted"]["Enable beta content"]
end