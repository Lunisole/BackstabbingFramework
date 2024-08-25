function Lu_BsF_CheckInAngleMatrix(backstabber,spell)
  for index,value in ipairs(Lu_BsF_AngleMatrix) do
    for _,value in ipairs(Lu_BsF_AngleMatrix[index][2]) do
      if (spell == value) then
        return Lu_BsF_AngleMatrix[index][1]
      end
    end
    for _,value in ipairs(Lu_BsF_AngleMatrix[index][3]) do
      if (HasPassive(backstabber,value) == 1) then
        return Lu_BsF_AngleMatrix[index][1]
      end
    end
  end
end

local function Lu_BsF_SpellInList(spell,list)
    for _,spellcheck in pairs(list) do
      if (spell == spellcheck) then
        --print('Spell is Valid')
        return true
      end
    end
    --print('Spell is Invalid')
    return false
end

local function Lu_BsF_PassiveInList(entity,list)
    for _,passivecheck in pairs(list) do
      if (HasPassive(entity,passivecheck) == 1) then
        --print('Entity Has Valid Passive')
        return true
      end
    end
    --print('Entity has no Valid Passive')
  return false
end


Ext.Osiris.RegisterListener("StartedPreviewingSpell", 4, "before", function (backstabber,spell,_,_,_)
    if (Lu_BsF_SpellInList(spell,Lu_BsF_EnablingSpells) or Lu_BsF_PassiveInList(backstabber,Lu_BsF_EnablingPassives)) then
        Lu_BsF_BackstabbingInit(backstabber,spell)
    end
end)
