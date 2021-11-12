yandereWaifu.Minimenu = {}

function yandereWaifu.Minimenu:New(backdrop, position)
	o = o or {};
	
	o.menuHud = Sprite();
	o.menuHud:Load("gfx/ui/ui_minimenu.anm2", true);
	
	o.callbacks = {}
	o.backdrop = backdrop
	o.menuHud:ReplaceSpritesheet(0, backdrop)
	o.options = {
		[0] = nil,
		[1] = nil,
		[2] = nil,
		[3] = nil
	}
	o.lastVector = Vector.Zero
	o.onRelease = false
	o.rawRelease = false
	o.lastFrameRelease = 0 --marks what frame you released
	o.open = false
	
	o.leniency = 5
	
	o.menuAnchor = position --sets where the table will be rendered
	
	setmetatable(o,self);
	self.__index = self;
	return o 
end

function yandereWaifu.Minimenu:AttachCallback( func )
	table.insert(self.callbacks, func);
	--print(#self.callbacks)
end

function yandereWaifu.Minimenu:ToggleMenu(forceboolean)
	if forceboolean then --if forceboolean
		self.open = forceboolean 
	else --else it acts like a switch
		if self.open then
			self.open = false
		else
			self.open = true
		end
	end
end

function yandereWaifu.Minimenu:UpdateOptions(table)
	o.options = table
end

function yandereWaifu.Minimenu:Reset()
	self.lastVector = Vector.Zero
	self.open = false;
	self.onRelease = false;
	self.rawRelease = false
end

RebekahMinimenu = {
	RIGHT = 0,
	DOWN = 1,
	LEFT = 2,
	UP = 3
}

function yandereWaifu.Minimenu:Update( vector , position )
	self.menuAnchor = position or self.menuAnchor 
	local menuAnchor = self.menuAnchor
	if self.open then --if menu is open
		local dir = -1
		if vector.X ~= 0 or vector.Y ~= 0 then
			self.onRelease = false
			self.rawRelease = false
			if (vector.X == 1 and vector.Y == 0 ) or (vector.X == 0 and vector.Y == 1) or (vector.X == -1 and vector.Y == 0) or (vector.X == 0 and vector.Y == -1) then
				self.lastVector = vector
			end
			self.lastFrameRelease = Game():GetFrameCount()
		else
			
			print(self.lastFrameRelease + self.leniency)
			print(Game():GetFrameCount())

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

		if self.options then --display options
			self.menuHud:ReplaceSpritesheet(5, "gfx/ui/none.png")
			self.menuHud:ReplaceSpritesheet(6, "gfx/ui/none.png")
			self.menuHud:ReplaceSpritesheet(7, "gfx/ui/none.png")
			self.menuHud:ReplaceSpritesheet(8, "gfx/ui/none.png")
			for i, v in pairs (self.options) do
				if i == 1 then
					self.menuHud:ReplaceSpritesheet(1, v or "gfx/ui/minimenu_icon_default.png");
					if self.lastVector.X == 1 and self.lastVector.Y == 0  then --right
						self.menuHud:ReplaceSpritesheet(5, "gfx/ui/minimenu_select.png")
					end
				elseif i == 2 then
					self.menuHud:ReplaceSpritesheet(2, v or "gfx/ui/minimenu_icon_default.png");
					if self.lastVector.X == 0 and self.lastVector.Y == 1 then --down
						self.menuHud:ReplaceSpritesheet(6, "gfx/ui/minimenu_select.png")
					end
				elseif i == 3 then
					self.menuHud:ReplaceSpritesheet(3, v or "gfx/ui/minimenu_icon_default.png");
					if self.lastVector.X == -1 and self.lastVector.Y == 0 then --left
						self.menuHud:ReplaceSpritesheet(7, "gfx/ui/minimenu_select.png")
					end
				elseif i == 4 then
					self.menuHud:ReplaceSpritesheet(4, v or "gfx/ui/minimenu_icon_default.png");
					if self.lastVector.X == 0 and self.lastVector.Y == -1 then --up
						self.menuHud:ReplaceSpritesheet(8, "gfx/ui/minimenu_select.png")
					end
				end
			end
			self.menuHud:LoadGraphics();
		end
		
		for j=1,#self.callbacks,1 do
			self.callbacks[j](dir);
		end 
		
		--glowing code
		if not self.menuHud:IsPlaying("Menu") then self.menuHud:Play("Menu", true) end
		self.menuHud:Render(self.menuAnchor, Vector(0,0), Vector(0,0));
		--print(self.menuHud)
		--print(self.menuHud:IsPlaying("Menu"))
	end
	--reset onRelease function
	if self.lastFrameRelease + self.leniency >= Game():GetFrameCount() then
		self.onRelease = false
	end
end

function yandereWaifu.Minimenu:Remove()
	self = nil
end
--[[
InutilLib.DoubleTap = {};
	function InutilLib.DoubleTap:New(o)
		o = o or {};
		o.callbacks = {};
		o.lastVector = Vector( 0, 0 );
		o.lastFrame = 0;
		o.lastActivationFrame = 0;
		o.active = false;
		o.angleThreshold = 15;
		o.inputFrameThreshold = 6;
		o.minimumVectorLength = 0.05;
		o.onRelease = false;
		o.cooldown = 15;
		-- if the double tap was activated this many frames or less before the cooldown was over, queue one up with a timer
		o.leniency = 3;
		
		--local playerInfo = o
		
		setmetatable(o,self);
		self.__index = self;
		return o;
	end

	function InutilLib.DoubleTap:AttachCallback( func )
		table.insert(self.callbacks, func);
		--print(#self.callbacks)
	end

	function InutilLib.DoubleTap:Reset()
		self.lastFrame = 0;
		self.lastActivationFrame = 0;
		self.lastVector = Vector(0,0);
		self.active = false;
		self.cooldown = 15;
	end

	function InutilLib.DoubleTap:Update( vector , player )
		if DOUBLE_TAP_ANGLE_ROUNDING >= 1 then
			local currentAngle = vector:GetAngleDegrees();
			local targetAngle = InutilLib.RoundToNearestMultiple( currentAngle, DOUBLE_TAP_ANGLE_ROUNDING );
			vector = vector:Rotated( targetAngle - currentAngle );
		end
		local vectorAngleDegrees = vector:GetAngleDegrees();
		local vectorLength = vector:Length();
		-- Used for timing differences
		local gameFrame = Game():GetFrameCount();

		-- If the movement Vector is smaller than the minimum required length consider the player not moving
		if vectorLength < self.minimumVectorLength then
			-- If we were moving last frame and double tap on release is true then store the current frame as the last frame of movement
			if self.active == true and self.onRelease == true then
				self.lastFrame = gameFrame;
			end
			self.active = false;
		-- If the movement vector is greater than or equal to the minimum required length consider the player moving
		elseif vectorLength >= self.minimumVectorLength then
			-- If the player wasn't moving before and the input frame threshold hasn't been exceeded
			if self.active == false and gameFrame - (self.lastFrame or 0) <= self.inputFrameThreshold then
				local DEG_TO_RAD = InutilLib.DEG_TO_RAD
				local angleDifference = InutilLib.AngleDifference( self.lastVector:GetAngleDegrees()*DEG_TO_RAD, vectorAngleDegrees*DEG_TO_RAD);
				-- If the difference between the last movement angle and the attempted dash direction is within the acceptable threshold
				if math.abs(angleDifference) <= self.angleThreshold * DEG_TO_RAD then
					-- If the cooldown is not active
					if gameFrame - (self.lastActivationFrame or 0) > self.cooldown then
						-- Dash
						for j=1,#self.callbacks,1 do
							self.callbacks[j](vector, player); --NOTE TO FUTURE KAKAO, YOU COULD PUT player BOTH IN THIS PARAM AND THE BEGINNING OF THIS METHOD IF YOU WANT TO TAKE AND GIVE THE PROPER PLAYER. NO NEED TO THANK ME LOL, GET YOUR CONTROLLER ALREADY.
						end --RESPONSE TO KAKAO, THIS IS JUDE NOW BUT THANKS, THIS BECAME SO HANDY MAN, THX
						self.lastActivationFrame = gameFrame;
					-- If the cooldown was active but within leniency
					elseif gameFrame - (self.lastActivationFrame or 0) > self.cooldown - self.leniency then
						local framesUntilCooled = math.abs(gameFrame - (self.lastActivationFrame or 0) - self.cooldown);
						InutilLib.SetTimer( framesUntilCooled, function()
							for j=1,#self.callbacks,1 do
								self.callbacks[j](vector, player);
							end
						end);
						self.lastActivationFrame = gameFrame + framesUntilCooled;
					end
				end
			end
			-- If the player is moving and double table on release is false and the player wasn't moving last frame
			if self.onRelease == false and self.active == false then
				-- The last movement frame we want is the one where the player first starts to move
				self.lastFrame = gameFrame;
			end
			self.active = true;
			-- Store the movement vector
			self.lastVector = vector;
		end
	end]]