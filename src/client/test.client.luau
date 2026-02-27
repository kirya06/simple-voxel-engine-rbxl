local VoxelChunk = require(game:GetService("ReplicatedStorage").Shared.VoxelChunk)

local chunk = VoxelChunk.new()

chunk:SetBlock(Vector3int16.new(1, 0, 1), 1)
chunk:SetBlock(Vector3int16.new(0, 1, 0), 2)
chunk:SetBlock(Vector3int16.new(1, 12, 1), 3)

print(chunk:GetBlock(Vector3int16.new(1, 0, 1)))
print(chunk:GetBlock(Vector3int16.new(0, 1, 0)))
print(chunk:GetBlock(Vector3int16.new(1, 12, 1)))