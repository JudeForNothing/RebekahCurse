
local LiminalRoomList = StageAPI.RoomsList("Basic Backrooms", {
    Name = "Basic Backrooms",
    Rooms = require('resources.luarooms.liminal.backrooms')
})

--Replace curse rooms
StageAPI.AddCallback("RebekahCurse", "PRE_STAGEAPI_NEW_ROOM_GENERATION", 0, function()
	if (ILIB.room:GetType() == RoomType.ROOM_CURSE) then
		print("weee")
		local testRoom = StageAPI.LevelRoom("Love Curse Room", LiminalRoomList, ILIB.room:GetSpawnSeed(), ILIB.room.Shape, ILIB.room.Type, nil, nil, nil, nil, nil, StageAPI.GetCurrentRoomID())
		return testRoom
	end
end)


StageAPI.AddCallback("RebekahCurse", "POST_ROOM_INIT", 0, function(newRoom)
    if newRoom.LayoutName == "Love Curse Room" then --(newRoom:GetType() == "Love Room") 
		print("boom")
        --if newRoom.Layout.Name and string.sub(string.lower(newRoom.Layout.Name), 1, 4) == "trap" then
        newRoom:SetTypeOverride("Love Room")
       -- end
    end
end)