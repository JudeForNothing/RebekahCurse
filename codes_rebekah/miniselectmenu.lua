InutilLib.DoubleTap = {};

yandereWaifu.MiniSelectMenu = {}

function yandereWaifu.MiniSelectMenu:New(o)
	o = o or {};
	o.options = {}
	o.direction = Vector.Zero
	
	setmetatable(o,self);
	self.__index = self;
	return o;
end

function yandereWaifu.MiniSelectMenu:Reset()
	self.direction = Vector
end


function yandereWaifu.MiniSelectMenu:Update( dir, player )
end

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
end