function OnPlayerSpawned(player)
    local x,y = EntityGetTransform(player)
    EntityLoad("mods/humans/files/enemy/miner.xml", x-50, y-50)
end