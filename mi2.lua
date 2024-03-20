--[[
Music Interface 2
For ComputerCraft
Supports Minecraft, CraftOS-PC, CCEmuX
Developed by yabastar

mi2 play example.mi2
]]

local args = {...}

print(args[1],args[2])
local errmsg = "Could not find speaker"

if periphemu then
    periphemu.create("left","speaker")
    errmsg = "periphemu could not attach speaker"
elseif ccemux then
    ccemux.attach("left","speaker")
    errmsg = "ccemux could not attach speaker"
end

local speaker = peripheral.find("speaker")

if speaker == nil then
    error(errmsg,0)
end

local drumnum = 0

local function drumcycle(num)
    for i,_ in ipairs(drums[num]) do
        local note = drums[num][i].note
        local pitch = drums[num][i].pitch or 1
        local volume = drums[num][i].volume or 1

        speaker.playNote(note,volume,pitch)
    end
end

_G.new = function(data)
    local sleepTime = data.sleepTime or 0.2
    local repeatTime = data.repeatTime or 1

    for i=1,repeatTime do
        for _,v in ipairs(data) do
            if type(v) == "table" then
                local note = v.note
                local pitch = v.pitch or 1
                local volume = v.volume or 1

                if note ~= nil then
                    if note == "drum" then
                        drumnum = drumnum + 1
                        if drumnum > #drums then
                            drumnum = 1
                        end
                        drumcycle(drumnum)
                    else
                        speaker.playNote(note,volume,pitch)
                    end
                end
            end
        end
        sleep(sleepTime)
    end
end

if args[1] == "play" then
    dofile(args[2])
end

_G.new = nil
