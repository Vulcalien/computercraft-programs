-- Copyright 2021 Vulcalien
-- 2021-09-15 20:20 +0200

local tArgs = { ... }
if #tArgs < 1 then
    print('Usage: rat <length>')
    return
end

local traveled = 0

function tryRefuel()
    print('Trying to refuel.')
    for i=1,16 do
        turtle.select(i)
        if turtle.refuel() then
            print('Fuel found.')
            return true
        end
    end
    return false
end

function goHome()
    print('Going home.')

    turtle.turnLeft()
    turtle.turnLeft()
    
    -- go back home
    for _=1,traveled - 1 do
        turtle.forward()
        turtle.dig()
    end
    turtle.forward()
    
    -- clear inventory
    for i=1,16 do
        turtle.select(i)
        turtle.drop()
    end
    
    turtle.turnRight()
    turtle.turnRight()
    
    traveled = 0
end

-- entry point
local maxTravel = tonumber(tArgs[1])
while traveled < maxTravel do
    -- check fuel level
    local fuel = turtle.getFuelLevel()
      -- the turtle has to go forward and then
      -- back, so fuel must be even
    fuel = fuel - fuel % 2
    if fuel <= traveled then
        if not tryRefuel() then
            print('Out of fuel.')
            goHome()
            return
        end
    end
    
    -- dig next block
    turtle.dig()
    turtle.forward()
    traveled = traveled + 1
    
    -- check inventory space
    local invFull = true
    for i=1,16 do
        if turtle.getItemCount(i)
           == 0 then
            invFull = false
            break
        end
    end
    if invFull then
        print('Inventory is full.')
        goHome()
    end
end
print('End of journey.')
goHome()
-- end of program