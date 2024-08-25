local configFilePathPattern = string.gsub("Mods/%s/BackstabbingBlueprint.json", "'", "\'")
Lu_BsF_EnablingSpells = {}
Lu_BsF_EnablingPassives = {}
Lu_BsF_SpellsAngle = {}
Lu_BsF_PassivesAngle = {}
Lu_BsF_AngleMatrix = {}

local function Lu_BsF_IsEntryValid(entry,place)
    if (type(entry) == "table") then
        if (type(entry[1]) == "string") then
            if (type(entry[2]) == "number") then
                if (entry[2]%1 == 0) then
                    if (type(entry[3]) == "nil") then
                        return true
                    else
                        _P("Invalid table at",place,"The table contains more than 2 values")
                        return false
                    end
                else
                    _P("Invalid table at",place,entry[2],"isn't an integer.")
                    return false
                end
            else
                _P("Invalid table at",place,entry[2],"isn't a number.")
                return false
            end
        else
            _P("Invalid table at",place,entry[1],"isn't a string")
            return false
        end
    else
        _P("Invalid value at",place,entry,"isn't a table")
        return false
    end
end

local function Lu_BsF_DoesEntryAlreadyExist(data,list)
    for _,value in ipairs(list) do
        if (data == value) then
            return false
        end
    end
    return true
end

local function Lu_BsF_DoesAngleAlreadyExist(data,matrice)
    for index,value in ipairs(matrice) do
        if (data[1] == value[1]) then
            return index
        end
    end
    return nil
end

local function Lu_BsF_AddSpellEntryToAngleMatrix(datalist)
    for index,value in ipairs(datalist) do
        local place = Lu_BsF_DoesAngleAlreadyExist(value,Lu_BsF_AngleMatrix)
        if (place) then
            if Lu_BsF_DoesEntryAlreadyExist(value[2],Lu_BsF_AngleMatrix[place][2]) then
                table.insert(Lu_BsF_AngleMatrix[place][2],value[2])
            end
        else
            table.insert(Lu_BsF_AngleMatrix,{value[1],{value[2]},{}})
        end
    end
end

local function Lu_BsF_AddPassiveEntryToAngleMatrix(datalist)
    for index,value in ipairs(datalist) do
        local place = Lu_BsF_DoesAngleAlreadyExist(value,Lu_BsF_AngleMatrix)
        if (place) then
            if Lu_BsF_DoesEntryAlreadyExist(value[2],Lu_BsF_AngleMatrix[place][3]) then
                table.insert(Lu_BsF_AngleMatrix[place][3],value[2])
            end
        else
            table.insert(Lu_BsF_AngleMatrix,{value[1],{},{value[2]}})
        end
    end
end

local function Lu_BsF_BuildAngleMatrix(ParsedFile)
    local TempSpellList = {}
    local TempPassiveList = {}
    for index,spell in ipairs(ParsedFile.EnablingSpells) do
        if (type(spell) == "string") then
            table.insert(TempSpellList,{90,spell})
            table.insert(Lu_BsF_EnablingSpells,spell)
            --D(Lu_BsF_EnablingSpells)
        else
            _P(spell,"isn't a string")
        end
    end
    for index,passive in ipairs(ParsedFile.EnablingPassives) do
        if (type(passive) == "string") then
            table.insert(TempPassiveList,{90,passive})
            table.insert(Lu_BsF_EnablingPassives,spell)
            --_D(Lu_BsF_EnablingPassives)
        else
            _P(passive,"isn't a string")
        end
    end
    for index,customspell in ipairs(ParsedFile.Custom.Spells) do
        if (Lu_BsF_IsEntryValid(customspell,index)) then
            table.insert(Lu_BsF_SpellsAngle,{customspell[2],customspell[1]})
            table.insert(Lu_BsF_EnablingSpells,customspell[1])
            --_D(Lu_BsF_SpellsAngle)
        end
    end
    for index,custompassive in ipairs(ParsedFile.Custom.Passives) do
        if (Lu_BsF_IsEntryValid(custompassive,index)) then
            table.insert(Lu_BsF_PassivesAngle,{custompassive[2],custompassive[1]})
            table.insert(Lu_BsF_EnablingPassives,custompassive[1])
            --_D(Lu_BsF_PassivesAngle)
        end
    end
    Lu_BsF_AddSpellEntryToAngleMatrix(TempSpellList)
    Lu_BsF_AddPassiveEntryToAngleMatrix(TempPassiveList)
    Lu_BsF_AddSpellEntryToAngleMatrix(Lu_BsF_SpellsAngle)
    Lu_BsF_AddPassiveEntryToAngleMatrix(Lu_BsF_PassivesAngle)
end

local function Lu_BsF_IsJsonValid(json)
    local state,data = pcall(function()
        return Ext.Json.Parse(json)    
    end)
    if (state) then
        if (data ~= nil) then
            Lu_BsF_BuildAngleMatrix(data)
        else
            _P("Backstabbing Blueprint is empty")
        end
    else
        _P("Invalid Backstabbing Blueprint",data)
    end
end

local function OnSessionLoaded()
    for _,uuid in pairs(Ext.Mod.GetLoadOrder()) do
        local modData = Ext.Mod.GetMod(uuid)
        local filePath = configFilePathPattern:format(modData.Info.Directory)
        local ConfigFile = Ext.IO.LoadFile(filePath, "data")
        _D(filePath)
        if (ConfigFile ~= nil and ConfigFile ~= "") then
            _P("Found Backstabbing Blueprint for Mod: " .. Ext.Mod.GetMod(uuid).Info.Name)
            Lu_BsF_IsJsonValid(ConfigFile)
        else
            --_P("No config file for Mod: " .. Ext.Mod.GetMod(uuid).Info.Name)
        end
    end
    --_D(Lu_BsF_AngleMatrix)
    table.sort(Lu_BsF_AngleMatrix, function(a, b) return a[1] > b[1] end)
    _D(Lu_BsF_AngleMatrix)
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)