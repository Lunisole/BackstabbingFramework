function Lu_BsF_CheckInAngleMatrix(backstabber,spell)
  for index,value in ipairs(Lu_BsF_AngleMatrix) do
    for _,value in ipairs(Lu_BsF_AngleMatrix[index][2]) do
      if (spell == value) then
        if Lu_BsF_DebugState then
          _P("Spell Angle Found for : " .. value)
          _P("Angle is : " .. Lu_BsF_AngleMatrix[index][1])
        end
        return Lu_BsF_AngleMatrix[index][1]
      end
    end
    for _,value in ipairs(Lu_BsF_AngleMatrix[index][3]) do
      if (HasPassive(backstabber,value) == 1) then
        if Lu_BsF_DebugState then
          _P("Passive Angle Found for : " .. value)
          _P("Angle is : " .. Lu_BsF_AngleMatrix[index][1])
        end
        return Lu_BsF_AngleMatrix[index][1]
      end
    end
  end
end

function Lu_BsF_CheckModifiers(backstabber,spell)
  local anglemod = 0
  for _,value in ipairs(Lu_BsF_SpellsModifiers) do
    if (spell == value[1]) then
      anglemod = anglemod + value[2]
      if Lu_BsF_DebugState then
        _P("Spell modifier found for : " .. value[1])
      end
    end
  end
  for _,value in ipairs(Lu_BsF_PassivesModifiers) do
    if (HasPassive(backstabber,value[1]) == 1) then
      anglemod = anglemod + value[2]
      if Lu_BsF_DebugState then
        _P("Passive modifier found for : " .. value[1])
      end
    end
  end
  if Lu_BsF_DebugState then
    _P("Modifier is : " .. anglemod)
  end
  return anglemod
end

function Lu_BsF_SpellInList(spell,list)
    for _,spellcheck in pairs(list) do
      if (spell == spellcheck) then
        if Lu_BsF_DebugState then
          _P('Spell is Invalid')
        end
        return true
      end
    end
    if Lu_BsF_DebugState then
      _P('Spell is Invalid')
    end
    return false
end

function Lu_BsF_PassiveInList(entity,list)
    for _,passivecheck in pairs(list) do
      if (HasPassive(entity,passivecheck) == 1) then
        if Lu_BsF_DebugState then
          _P('Entity Has Valid Passive')
        end
        return true
      end
    end
    if Lu_BsF_DebugState then
      _P('Entity has no Valid Passive')
    end
  return false
end


Ext.Osiris.RegisterListener("StartedPreviewingSpell", 4, "before", function (backstabber,spell,_,_,_)
    if (Lu_BsF_SpellInList(spell,Lu_BsF_EnablingSpells) or Lu_BsF_PassiveInList(backstabber,Lu_BsF_EnablingPassives)) then
        Lu_BsF_BackstabbingInit(backstabber,spell)
    end
end)

