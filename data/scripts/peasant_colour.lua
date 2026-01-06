dofile_once( "data/scripts/lib/utilities.lua" )

colours = {

"_red",

}

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), x + y + entity_id )

local random_index = Random(1, #colours)
local colour = colours[random_index]
local sprite_path = "data/enemies_gfx/peasant" .. colour .. ".xml"

local sprite_component = EntityGetFirstComponent(entity_id, "SpriteComponent")

ComponentSetValue2(sprite_component, "image_file", sprite_path )

local damage_component = EntityGetFirstComponent(entity_id, "DamageModelComponent")

if colour == "red" then
	colour = ""
end
if colour == "_red" then
	colour = "_red2"
end
ComponentSetValue2(damage_component, "ragdoll_filenames_file", "data/ragdolls/peasant" .. colour .. "/filenames.txt" )