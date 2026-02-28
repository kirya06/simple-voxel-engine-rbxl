--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local VoxelChunk = require(ReplicatedStorage.Shared.VoxelChunk)
local VoxelWorld = require(ReplicatedStorage.Shared.VoxelWorld)
local ChunkUpdateRemote = ReplicatedStorage.Shared.Event.ChunkUpdate

local worldModel = Instance.new("Model")
worldModel.Name = "World"
worldModel.Parent = game:GetService("Workspace")

local world = VoxelWorld.new()

world.OnUpdated:Connect(function(pos : Vector2int16)
    local chunk = world:GetChunk(pos)
    assert(chunk ~= nil)
    
    local chunkModel = worldModel:FindFirstChild(tostring(pos))

    if chunkModel == nil then
        chunkModel = Instance.new("Folder")

        -- assert to stop LSP complaining about something that cannot happen
        assert(chunkModel ~= nil)

        chunkModel.Name = tostring(pos)
        chunkModel.Parent = worldModel
    end

    local part = Instance.new("Part")
    part.Anchored = true
    part.Size = Vector3.one * 8
    part.Parent = chunkModel
    
    local chunkSize = Vector3.new(VoxelChunk.CHUNK_SIZE.X, VoxelChunk.CHUNK_SIZE.Y, VoxelChunk.CHUNK_SIZE.Z)
    local formula = Vector3.new(chunk.Position.X, 0, chunk.Position.Y) * world.BLOCK_SCALE * chunkSize
    part.CFrame = CFrame.new(formula)

    print(chunk)
end)


ChunkUpdateRemote.OnClientEvent:Connect(function(data : {[Vector2int16] : VoxelChunk.VoxelChunk})

    for pos, chunk in pairs(data) do
        world:SetChunk(pos, chunk)
        print(pos)
    end

end)

RunService.Heartbeat:Connect(function(deltaTime)
    local char = game.Players.LocalPlayer.Character

    if char then
        print(world:GetChunkFromWorldPosition(char.PrimaryPart.CFrame.Position))
    end
end)