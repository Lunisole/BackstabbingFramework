function Lu_BsF_FlankingCheck(distance,allydistance)
    if Lu_BsF_DebugState then
        _P("In FlankingCheck : ")
    end
    local normalizeddist = Ext.Math.Normalize(distance)
    local normalizedally = Ext.Math.Normalize(allydistance)
    local DP = Ext.Math.Dot(normalizeddist,normalizedally)
    local currentangle = Ext.Math.Acos(DP)
    if (currentangle <= math.pi/4) then
        return true
    else
        return false
    end
end

function Lu_BsF_FlankStatusApplier(target,distance,allydistance)
    if Lu_BsF_DebugState then
        _P("In FlankStatusApplier : ",target,distance,allydistance)
    end
    Osi.RemoveStatus(target,"FLANKING_FRAMEWORK_MAIN_STATUS_200002")
    if (Lu_BsF_FlankingCheck(distance,allydistance)) then
        Osi.ApplyStatus(target,"FLANKING_FRAMEWORK_MAIN_STATUS_200002",5.0,1)
        if Lu_BsF_DebugState then
            _P("Flanked Status Successfully applied to ",target)
        end
    end
end

function Lu_BsF_FlankingWeaponRange(ally)
    local MHWeap = Osi.GetEquippedItem(ally.Uuid.EntityUuid,"Melee Main Weapon")
    local OHWeap = Osi.GetEquippedItem(ally.Uuid.EntityUuid,"Melee Offhand Weapon")
    local MHRange = MHWeap ~= nil and Ext.Entity.Get(MHWeap).Weapon.WeaponRange or 1.5
    local OHRange = OHWeap ~= nil and Osi.GetEquippedShield(ally.Uuid.EntityUuid) == nil and Ext.Entity.Get(OHWeap).Weapon.WeaponRange or 1.5
    if (ally.Unsheath.State == "Melee" or ally.Unsheath.State == "Sheathed") then
        if (OHRange <= MHRange) then
            return MHRange
        else
            return OHRange
        end
    else
        return 0
    end
end

function Lu_BsF_BuildCharacterList(flanker,flankerx,flankerz)
    local Lu_BsF_CharacterList = {}
    for _,target in ipairs(Ext.Entity.GetAllEntitiesWithComponent("IsCharacter")) do
        if (IsDead(target.Uuid.EntityUuid) == 0 and target.Steering.TargetRotation ~= nil and target.Uuid.EntityUuid ~= Ext.Entity.Get(flanker).Uuid.EntityUuid) then
            local targetx = target.Transform.Transform.Translate[1]
            local targetz = target.Transform.Transform.Translate[3]
            local distance = {targetx-flankerx,0,targetz-flankerz}
            if (Ext.Math.Length(distance) <= 7) then
                table.insert(Lu_BsF_CharacterList,target)
            end
        end
    end
    return Lu_BsF_CharacterList
end

function Lu_BsF_FlankingInit(flanker)
    local selfx = Ext.Entity.Get(flanker).Transform.Transform.Translate[1]
    local selfz = Ext.Entity.Get(flanker).Transform.Transform.Translate[3]
    local Lu_BsF_CharacterList = Lu_BsF_BuildCharacterList(flanker,selfx,selfz)
    for _,target in ipairs(Lu_BsF_CharacterList) do
        local targetx = target.Transform.Transform.Translate[1]
        local targetz = target.Transform.Transform.Translate[3]
        local distance = {targetx-selfx,0,targetz-selfz}
        if (Ext.Math.Length(distance) <= 5) then
            for _,ally in ipairs(Lu_BsF_CharacterList) do
                if (Osi.IsAlly(flanker, ally.Uuid.EntityUuid) == 1 and ally.Uuid.EntityUuid ~= Ext.Entity.Get(flanker).Uuid.EntityUuid and ally ~= target) then
                    local allyx = ally.Transform.Transform.Translate[1]
                    local allyz = ally.Transform.Transform.Translate[3]
                    local allydistance = {allyx-targetx,0,allyz-targetz}
                    if (Ext.Math.Length(allydistance) <= Lu_BsF_FlankingWeaponRange(ally)) then
                        Lu_BsF_FlankStatusApplier(target.Uuid.EntityUuid,distance,allydistance)
                    end
                end
            end
        end
    end
end