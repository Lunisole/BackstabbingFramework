listetest = {{45,"ABC"},{37,"TRENTESEPT"},{45,"BCA"},{183,"ARF"},{37,"pls"},{45,"test"}}
sortedlist = {}

local function DoesAngleAlreadyExist(data,matrice)
    for index,value in ipairs(matrice) do
        if (data[1] == value[1]) then
            return index, data[2]
        end
    end
    return nil, {data[1],{data[2]},{}}
end

local function BuildCheckMatrice(datalist)
    for index,value in ipairs(datalist) do
        local place,toinsert = DoesAngleAlreadyExist(value,sortedlist)
        if place then
            table.insert(sortedlist[place][2],toinsert)
        else
            table.insert(sortedlist,toinsert)
        end
    end
end

local function Lu_BsF_BuildCheckLists(ConfigFile)
    local ParsedFile = Ext.Json.Parse(ConfigFile) 
    for _,spell in ipairs(ParsedFile.EnablingSpells) do
        table.insert(Lu_BsF_EnablingSpells,spell)
        table.insert(Lu_BsF_SpellsAngle,{90,spell})
        --_D(Lu_BsF_EnablingSpells)
    end
    for _,passive in ipairs(ParsedFile.EnablingPassives) do
        table.insert(Lu_BsF_EnablingPassives,passive)
        --_D(Lu_BsF_EnablingPassives)
    end
    for _,customspell in ipairs(ParsedFile.Custom.Spells) do
        table.insert(Lu_BsF_SpellsAngle,{customspell[2],customspell[1]})
        --_D(Lu_BsF_SpellsAngle)
    end
    for _,custompassive in ipairs(ParsedFile.Custom.Passives) do
        table.insert(Lu_BsF_PassivesAngle,{custompassive[2],custompassive[1]})
        --_D(Lu_BsF_PassivesAngle)
    end
    --_D(Lu_BsF_EnablingSpells)
    --_D(Lu_BsF_EnablingPassives)
    --_D(Lu_BsF_SpellsAngle)
    --_D(Lu_BsF_PassivesAngle)
    --_D(Sorted_List)
    --_P('Angle associated with SneakAttack_Unlock is')
    --_P(Sorted_List[2])
end

local function OnSessionLoaded()
    Lu_BsF_EnablingSpells = {}
    Lu_BsF_EnablingPassives = {}
    Lu_BsF_SpellsAngle = {}
    Lu_BsF_PassivesAngle = {}
    Sorted_List = {}
    local ConfigFile = Ext.IO.LoadFile("Mods/BackstabbingFramework/BackstabbingBlueprint-Example.json","data")
    Lu_BsF_BuildCheckLists(ConfigFile)
end

Ext.Events.SessionLoaded:Subscribe(OnSessionLoaded)