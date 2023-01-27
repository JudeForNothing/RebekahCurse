yandereWaifu.TaintedSkillMenu = {}

function yandereWaifu.TaintedSkillMenu:New(position, options)
	o = o or {};
	
	--o.menuHud = Sprite();
	--o.menuHud:Load("gfx/ui/ui_TaintedSkillMenu.anm2", true);
	
    o.menuHud = {
        [0] = Sprite(),
		[1] = Sprite(),
		[2] = Sprite(),
		[3] = Sprite()
    }

    for i = 0, 3, 1 do
        o.menuHud[i]:Load("gfx/ui/ui_tainted_skill.anm2", true)
    end

	o.callbacks = {}
	--o.menuHud:ReplaceSpritesheet(0, backdrop)

    --should have {texture, price, charge, maxcharge}
	o.options = {
		[0] = { sprite = nil, price = 0, charge = 0, maxcharge = 100},
		[1] = { sprite = nil, price = 0, charge = 0, maxcharge = 100},
		[2] = { sprite = nil, price = 0, charge = 0, maxcharge = 100},
		[3] = { sprite = nil, price = 0, charge = 0, maxcharge = 100}
	}
    o.options = o.options or options

    o.chargecooldown =  {
		[0] = 0,
		[1] = 0,
		[2] = 0,
		[3] = 0
	}
	o.lastVector = Vector.Zero
	o.onRelease = false
	o.rawRelease = false
	o.lastFrameRelease = 0 --marks what frame you released
	o.open = false
	
	o.leniency = 0
	
	o.menuAnchor = position --sets where the table will be rendered
	
	--this is so scuffed, a more proper code would have options, optionsValue and this as one whole class/table

	setmetatable(o,self);
	self.__index = self;
	return o 
end

function yandereWaifu.TaintedSkillMenu:AttachCallback( func )
	table.insert(self.callbacks, func);
	--print(#self.callbacks)
end

function yandereWaifu.TaintedSkillMenu:ToggleMenu(forceboolean)
	if type(forceboolean) == "boolean" then --if forceboolean
		self.open = forceboolean 
		return
	else --else it acts like a switch
		if self.open then
			self.open = false
		else
			self.open = true
		end
	end
end

function yandereWaifu.TaintedSkillMenu:UpdateOptions(table, table2)
	o.options = table
	if table2 then
		o.optionsValue = table2
	end
end

function yandereWaifu.TaintedSkillMenu:Reset()
	self.lastVector = Vector.Zero
	self.open = false;
	self.onRelease = false;
	self.rawRelease = false
end

RebekahTaintedSkillMenu = {
	RIGHT = 0,
	DOWN = 1,
	LEFT = 2,
	UP = 3
}

function yandereWaifu.TaintedSkillMenu:ChargeSkill(value)
    self.chargecooldown[value] = self.options[value].maxcharge
end

function yandereWaifu.TaintedSkillMenu:Update( vector, position, player )
	self.menuAnchor = position or self.menuAnchor 
	local menuAnchor = self.menuAnchor
    --tick
    for i, v in pairs (self.options) do
        if not v.charge then v.charge = 0 end --incase
        --print("neld")
        local chargecooldown = (self.chargecooldown[i])
       -- print(i)
        --print(chargecooldown)
        if chargecooldown > 0 then
            self.chargecooldown[i] = self.chargecooldown[i] - 1
           -- print("pasdhs")
            --print(chargecooldown)
        end
    end

	if self.open then --if menu is open
		local dir = -1
		local value 
		if vector.X ~= 0 or vector.Y ~= 0 then
			self.onRelease = false
			self.rawRelease = false
			if (vector.X == 1 and vector.Y == 0 ) or (vector.X == 0 and vector.Y == 1) or (vector.X == -1 and vector.Y == 0) or (vector.X == 0 and vector.Y == -1) then
				self.lastVector = vector
			end
			self.lastFrameRelease = Game():GetFrameCount()
		else
			if self.lastFrameRelease + self.leniency <= Game():GetFrameCount() then
				self.onRelease = true
			end
			
			if self.lastVector.X == 1 and self.lastVector.Y == 0 then --right
				dir = 0
			elseif self.lastVector.X == 0 and self.lastVector.Y == 1 then --down
				dir = 1
			elseif self.lastVector.X == -1 and self.lastVector.Y == 0 then --left
				dir = 2
			elseif self.lastVector.X == 0 and self.lastVector.Y == -1 then --up
				dir = 3
			end
		end
		local availableDir = 0
		if self.options then --display options

            for i = 0, 3, 1 do
                self.menuHud[i]:ReplaceSpritesheet(2, "gfx/ui/none.png")
                self.menuHud[i]:Render(self.menuAnchor+Vector(20,0):Rotated(90*i), Vector(0,0), Vector(0,0));
            end

			--refresh in case
			--[[for i = 0, 3 do
				self.menuHud[i]:ReplaceSpritesheet(1, "gfx/ui/minimenu_icon_default.png");
			end]]
			for i, v in pairs (self.options) do

                local icon = v.sprite or "gfx/ui/minimenu_icon_default.png"

                self.menuHud[i]:ReplaceSpritesheet(1, icon);
				if i == 0 then
					if self.lastVector.X == 1 and self.lastVector.Y == 0  then --right
						self.menuHud[i]:ReplaceSpritesheet(2, "gfx/ui/spells/minimenu_select.png")
						if self.optionsValue and self.optionsValue[i] then value = self.optionsValue[i] end
					end
				elseif i == 1 then
					if self.lastVector.X == 0 and self.lastVector.Y == 1 then --down
						self.menuHud[i]:ReplaceSpritesheet(2, "gfx/ui/spells/minimenu_select.png")
						if self.optionsValue and self.optionsValue[i] then value = self.optionsValue[i] end
					end
				elseif i == 2 then
					if self.lastVector.X == -1 and self.lastVector.Y == 0 then --left
						self.menuHud[i]:ReplaceSpritesheet(2, "gfx/ui/spells/minimenu_select.png")
						if self.optionsValue and self.optionsValue[i] then value = self.optionsValue[i] end
					end
				elseif i == 3 then
					if self.lastVector.X == 0 and self.lastVector.Y == -1 then --up
						self.menuHud[i]:ReplaceSpritesheet(2, "gfx/ui/spells/minimenu_select.png")
						if self.optionsValue and self.optionsValue[i] then value = self.optionsValue[i] end
					end
				end
				availableDir = availableDir + 1

                self.menuHud[i]:LoadGraphics()
                local chargecooldown = (self.chargecooldown[i])
				--cant do a skill or insufficient crystals
				if yandereWaifu.GetEntityData(player).CantTaintedSkill or self.options[i].price > yandereWaifu.GetEntityData(player).RageCrystal then
					self.menuHud[i]:SetFrame("Menu", 100)
				else
					if chargecooldown <= 0 then
						self.menuHud[i]:SetFrame("Menu", 0)
					else
						local percent = (chargecooldown/v.maxcharge)*100
					-- print(chargecooldown)
					-- print(percent)
						self.menuHud[i]:SetFrame("Menu", math.ceil(percent) or 0)
					end
				end
			end
		end
		
		local isAvailable = true
		if dir > availableDir-1 then
			isAvailable = false
		end
		
		for j=1,#self.callbacks,1 do
			self.callbacks[j](dir, value, isAvailable);
		end 
		
		--glowing code
		--if not self.menuHud:IsPlaying("Menu") then self.menuHud:Play("Menu", true) end
		--self.menuHud:Render(self.menuAnchor, Vector(0,0), Vector(0,0));
		--print(self.menuHud)
		--print(self.menuHud:IsPlaying("Menu"))
	end
	--reset onRelease function
	if self.lastFrameRelease + self.leniency >= Game():GetFrameCount() then
		self.onRelease = false
	end
end

function yandereWaifu.TaintedSkillMenu:Remove()
	self = nil
end