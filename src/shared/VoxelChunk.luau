--!strict

local VoxelChunk = {}
VoxelChunk.__index = VoxelChunk


type VoxelChunkData = {
    Data : buffer,
    Position : Vector2int16
}
export type VoxelChunk = typeof(setmetatable({} :: VoxelChunkData, VoxelChunk))

local BLOCK_BYTE_SIZE = 1

VoxelChunk.CHUNK_SIZE = Vector3int16.new(16, 64, 16)
VoxelChunk.CHUNK_BUFFER_LENGTH = VoxelChunk.CHUNK_SIZE.X * VoxelChunk.CHUNK_SIZE.Y * VoxelChunk.CHUNK_SIZE.Z

function VoxelChunk.new(position : Vector2int16?) : VoxelChunk
    local self = {}
    self.Data = buffer.create(VoxelChunk.CHUNK_BUFFER_LENGTH * BLOCK_BYTE_SIZE)
    self.Position = position or Vector2int16.new()

    return setmetatable(self, VoxelChunk)
end

function VoxelChunk.fromBuffer(buf : buffer, position : Vector2int16?) : VoxelChunk
    local self = setmetatable({}, VoxelChunk)
    self.Data = buf
    self.Position = position or Vector2int16.new()

    return self
end


local function _isPositionInBounds(position : Vector3int16) : boolean

    if position.X < 0 or position.Y < 0 or position.Z < 0 then
        return false
    end

    if position.X > VoxelChunk.CHUNK_SIZE.X or position.Y > VoxelChunk.CHUNK_SIZE.Y or position.Z > VoxelChunk.CHUNK_SIZE.Z then
        return false
    end

    return true
end

local function _positionTo1d(pos : Vector3int16) : number

    if not _isPositionInBounds(pos) then
        error(string.format("specified position [%*] is out of bounds in VoxelChunk", pos))
    end

    return (pos.X + VoxelChunk.CHUNK_SIZE.X * (pos.Y + VoxelChunk.CHUNK_SIZE.Y * pos.Z)) * BLOCK_BYTE_SIZE
end



function VoxelChunk.GetBlock(self : VoxelChunk, pos : Vector3int16) : number
    local index = _positionTo1d(pos)
    return buffer.readu8(self.Data, index)
end

function VoxelChunk.SetBlock(self : VoxelChunk, pos : Vector3int16, block : number)
    local index = _positionTo1d(pos)
    return buffer.writeu8(self.Data, index, block)
end

return VoxelChunk