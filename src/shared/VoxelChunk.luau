--!strict

local VoxelChunk = {}
VoxelChunk.__index = VoxelChunk


type VoxelChunkData = {
    Data : buffer
}
export type VoxelChunk = typeof(setmetatable({} :: VoxelChunkData, VoxelChunk))
type Self = VoxelChunk


local CHUNK_SIZE_MAX : Vector3int16 = Vector3int16.new(16, 64, 16)
local CHUNK_BUFFER_LENGTH = CHUNK_SIZE_MAX.X * CHUNK_SIZE_MAX.Y * CHUNK_SIZE_MAX.Z
local BLOCK_BYTE_SIZE = 1


function VoxelChunk.new() : VoxelChunk
    local self = setmetatable({}, VoxelChunk)
    self.Data = buffer.create(CHUNK_BUFFER_LENGTH * BLOCK_BYTE_SIZE)
    return self
end

function VoxelChunk.fromBuffer(buf : buffer) : VoxelChunk
    local self = setmetatable({}, VoxelChunk)
    self.Data = buf
    return self
end


local function _isPositionInBounds(position : Vector3int16) : boolean

    if position.X < 0 or position.Y < 0 or position.Z < 0 then
        return false
    end

    if position.X > CHUNK_SIZE_MAX.X or position.Y > CHUNK_SIZE_MAX.Y or position.Z > CHUNK_SIZE_MAX.Z then
        return false
    end

    return true
end

local function _positionTo1d(pos : Vector3int16) : number

    if not _isPositionInBounds(pos) then
        error(string.format("specified position %* is out of bounds in VoxelChunk", pos))
    end

    return (pos.X + CHUNK_SIZE_MAX.X * (pos.Y + CHUNK_SIZE_MAX.Y * pos.Z)) * BLOCK_BYTE_SIZE
end



function VoxelChunk.GetBlock(self : Self, pos : Vector3int16) : number
    local index = _positionTo1d(pos)
    return buffer.readu8(self.Data, index)
end

function VoxelChunk.SetBlock(self : Self, pos : Vector3int16, block : number)
    local index = _positionTo1d(pos)
    return buffer.writeu8(self.Data, index, block)
end



return VoxelChunk