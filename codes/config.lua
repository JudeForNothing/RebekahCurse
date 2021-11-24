


if ModConfigMenu then
	ModConfigMenu.SetCategoryInfo("Cursed and Brokenhearted","Cursed and Brokenhearted Settings")
	ModConfigMenu.AddBooleanSetting(
		"Cursed and Brokenhearted",
		"Rebekah Dash Alternative Key Enable",
		false,
		"Rebekah Dash Alternative Key Enable",
		{[true]="On",[false]="Off"},
		"Enable Rebekah Dash Key Alternative?")

	ModConfigMenu.AddKeyboardSetting(
		"Cursed and Brokenhearted",
		"Rebekah Dash",
		Keyboard.KEY_C,
		"Rebekah Dash",
		true,
		"Rebekah Dash")
	ModConfigMenu.AddControllerSetting(
		"Cursed and Brokenhearted",
		"Rebekah Dash (Controller)",
		0,
		"Rebekah Dash",
		true,
		"Rebekah Dash (Controller)")
end