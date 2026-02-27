--!strict

local VoxelMesh = {}
VoxelMesh.__index = VoxelMesh


function VoxelMesh.BuildVoxel() : EditableMesh
end


function VoxelMesh.BuildChunk() : EditableMesh
end


return VoxelMesh