--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local VoxelPartRenderer = require(script.Parent.VoxelPartRenderer)
local VoxelWorld = require(ReplicatedStorage.Shared.VoxelWorld)


local RENDER_DISTANCE = 12
local GENERATION_DISTANCE = 18

-- allow :BuildChunk() to be called only N times during a heartbeat update (per each player)
local CHUNK_RENDER_HEARTBEAT_LIMIT = 2


local world : VoxelWorld.VoxelWorld = VoxelWorld.new()
world.WorldGen.Seed = math.random(-2147483647, 2147483647)
local partRenderer : VoxelPartRenderer.VoxelPartRenderer = VoxelPartRenderer.new()



local function generateChunks(center : Vector2int16)
    world:GenerateChunks(center, Vector2int16.new(GENERATION_DISTANCE, GENERATION_DISTANCE))
end


local function renderChunks(center : Vector2int16) : {Vector2int16}

    local activeChunks : {Vector2int16} = {}

    local selectedChunks = world:GetChunks(center, Vector2int16.new(RENDER_DISTANCE, RENDER_DISTANCE))

    for i,chunk in pairs(selectedChunks) do
        assert(chunk ~= nil)
        table.insert(activeChunks, chunk.Position)
    end

    local chunksBuilt = 0
    for i, chunk in pairs(selectedChunks) do
        assert(chunk ~= nil)

        if chunksBuilt >= CHUNK_RENDER_HEARTBEAT_LIMIT then
            continue
        end

        if not partRenderer:IsChunkActive(chunk.Position) then
            partRenderer:BuildChunk(chunk)
            chunksBuilt += 1
         end
    end

    return activeChunks
end



world.OnManualUpdated:Connect(function(pos : Vector2int16)
    if not partRenderer:IsChunkActive(pos) then
        return
    end

    local chunk = world:GetChunk(pos)
    assert(chunk ~= nil)

    partRenderer:BuildChunk(chunk)
end)

-- rendering
RunService.Heartbeat:Connect(function()

    local players = Players:GetPlayers()

    local activeChunks : {Vector2int16} = {}

    for i, plr in pairs(players) do

        local char = plr.Character

        if not char then
            continue
        end

        local center = world:GetChunkFromWorldPosition(char.PrimaryPart.CFrame.Position)
        
        generateChunks(center)
        local playerChunks = renderChunks(center)

        for i, chunk in pairs(playerChunks) do
            table.insert(activeChunks, chunk)
        end
    end

    partRenderer:RemoveUnusedChunks(activeChunks)
end)



-- world:GenerateChunks(INITIAL_GENERATION_CENTER, INITIAL_GENERATION_SIZE)