function Lu_BsF_SpellInList(spell,list)
    for _,spellcheck in pairs(list) do
      if spell == spellcheck then
        print('Spell is Valid')
        return true
      end
    end
    print('Spell is Invalid')
    return false
end

function Lu_BsF_PassiveInList(entity,list)
    for _,passivecheck in pairs(list) do
      if (HasPassive(entity,passivecheck)) == 1 then
        print('Entity Has Valid Passive')
        return true
      end
    end
    print('Entity has no Valid Passive')
    return false
end


Ext.Osiris.RegisterListener("StartedPreviewingSpell", 4, "before", function (caster,spell,_,_,_)
    if (Lu_BsF_SpellInList(spell,Lu_BsF_EnablingSpells) or Lu_BsF_PassiveInList(caster,Lu_BsF_EnablingPassives)) then
        print('Backstab enabled')
    else
        print('Backstab disabled')
    end
end)
