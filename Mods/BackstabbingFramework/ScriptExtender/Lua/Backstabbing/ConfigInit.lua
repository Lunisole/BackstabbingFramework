listetest = {{45,"ABC"},{37,"TRENTESEPT"},{45,"BCA"},{180,"ARF"},{37,"pls"},{45,"test"},{360,"THREE SIXTY"}}
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
            table.insert(Lu_BsF_AngleMatrix[place][2],value[2])
        else
            table.insert(Lu_BsF_AngleMatrix,{value[1],{value[2]},{}})
        end
    end
end

local function Lu_BsF_AddPassiveEntryToAngleMatrix(datalist)
    for index,value in ipairs(datalist) do
        local place = Lu_BsF_DoesAngleAlreadyExist(value,Lu_BsF_AngleMatrix)
        if (place) then
            table.insert(Lu_BsF_AngleMatrix[place][3],value[2])
        else
            table.insert(Lu_BsF_AngleMatrix,{value[1],{},{value[2]}})
        end
    end
end

local function Lu_BsF_BuildAngleMatrix(ConfigFile)
    local ParsedFile = Ext.Json.Parse(ConfigFile)
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

local function OnSessionLoaded()
    local ConfigFile = Ext.IO.LoadFile("Mods/BackstabbingFramework/BackstabbingBlueprint-Example.json","data")
    Lu_BsF_BuildAngleMatrix(ConfigFile)
    _D(Lu_BsF_AngleMatrix)
    _D(Lu_BsF_EnablingSpells)
    _D(Lu_BsF_EnablingPassives)
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)