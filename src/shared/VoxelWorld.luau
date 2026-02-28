--!strict

local VoxelGenerator = require(script.Parent.VoxelGenerator)

local VoxelChunk = require(game:GetService("ReplicatedStorage").Shared.VoxelChunk)
type VoxelChunk = typeof(VoxelChunk)

local VoxelWorld = {}
VoxelWorld.__index = VoxelWorld


export type VoxelWorldData = {
    _chunks : {[string]: VoxelChunk.VoxelChunk?},
    _updEvent : BindableEvent,

    WorldGen : VoxelGenerator.VoxelGenerator,
    OnUpdated : RBXScriptSignal
}
export type VoxelWorld = typeof(setmetatable({} :: VoxelWorldData, VoxelWorld))

-- equivalent to 1 meter in studs
VoxelWorld.BLOCK_SCALE = 3.5714285714


function VoxelWorld.new() : VoxelWorld
    local self = {}
    self._chunks = {}

    self._updEvent = Instance.new("BindableEvent")
    self.OnUpdated = self._updEvent.Event
    self.WorldGen = VoxelGenerator.new()

    return setmetatable(self, VoxelWorld)
end


local function _vector2ToHash(vector : Vector2int16) : string
    -- this is horrible but i have more important stuff to do rather than trying to create a good int hash that is based on vector2 with no collisions
    return tostring(vector)
end


function VoxelWorld.GetChunk(self : VoxelWorld, pos : Vector2int16) : VoxelChunk.VoxelChunk?
    local chunk = self._chunks[_vector2ToHash(pos)]
    return chunk
end

function VoxelWorld.SetChunk(self : VoxelWorld, pos : Vector2int16, chunk : VoxelChunk.VoxelChunk)
    self._chunks[_vector2ToHash(pos)] = chunk
    self._updEvent:Fire(pos)
end

function VoxelWorld.IsChunkLoaded(self : VoxelWorld, pos : Vector2int16) : boolean
    return self:GetChunk(pos) ~= nil
end


function VoxelWorld.GenerateChunk(self : VoxelWorld, pos : Vector2int16)
    if self:IsChunkLoaded(pos) then
        return
    end

    local chunk = VoxelChunk.new(pos)
    self.WorldGen:Generate(chunk)

    self._chunks[_vector2ToHash(pos)] = chunk
    self._updEvent:Fire(pos)
end

function VoxelWorld.GenerateChunks(self : VoxelWorld, center : Vector2int16, size : Vector2int16)
    size /= 2

    for x = -size.X + 1, size.X - 1, 1 do
        for y = -size.Y + 1, size.Y - 1, 1 do

            local chunkPos = Vector2int16.new(x, y) + center
            self:GenerateChunk(chunkPos)

        end
    end

end


function VoxelWorld.GetChunks(self : VoxelWorld, center : Vector2int16, size : Vector2int16) : {[Vector2int16]: VoxelChunk.VoxelChunk?}
    size /= 2

    local chunks : {[Vector2int16]: VoxelChunk.VoxelChunk?} = {}

    for x = -size.X + 1, size.X - 1, 1 do
        for y = -size.Y + 1, size.Y - 1, 1 do

            local chunkPos = Vector2int16.new(x, y) + center

            if self:IsChunkLoaded(chunkPos) then
                chunks[chunkPos] = self:GetChunk(chunkPos)
            end

        end 
    end

    return chunks
end


function VoxelWorld.GetChunkFromWorldPosition(self : VoxelWorld, pos : Vector3) : Vector2int16
    local chunkSize = VoxelChunk.CHUNK_SIZE

    local vector2Pos = Vector2.new(pos.X, pos.Z)
    vector2Pos /= self.BLOCK_SCALE
    vector2Pos /= Vector2.new(chunkSize.X, chunkSize.Z)

    return Vector2int16.new(math.floor(vector2Pos.X), math.floor(vector2Pos.Y))
end


function VoxelWorld.GetBlock(self : VoxelWorld, pos : Vector2int16)
    --TODO: implement
end


function VoxelWorld.SetBlock(self : VoxelWorld, Pos :Vector2int16, block : number)
    --TODO:implement
end


return VoxelWorld