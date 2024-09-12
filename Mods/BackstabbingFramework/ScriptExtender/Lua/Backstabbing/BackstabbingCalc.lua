function Lu_BsF_AngleMinMax(angle,modifier)
    if Lu_BsF_DebugState then
        _P("In AngleMinMax : ")
        _P("Angle is : " .. angle,"Modifier is : " .. modifier)
    end
    local angle = angle + modifier
    local anglemin = (math.pi-(angle/2)*math.pi/180)
    local anglemax = (math.pi+(angle/2)*math.pi/180)
    return anglemin,anglemax
end 

function Lu_BsF_CharSteeringVec(target)
    if Lu_BsF_DebugState then
        _P("In CharSteeringVec : ",target)
    end
    local targetzsteering = math.cos(Ext.Entity.Get(target).Steering.TargetRotation)
    local targetxsteering = math.sin(Ext.Entity.Get(target).Steering.TargetRotation)
    local orient = {targetxsteering,0,targetzsteering}
    return orient
end 

function Lu_BsF_BackstabbingCheck(backstabber,target,distance,anglemin,anglemax)
    if Lu_BsF_DebugState then
        _P("In BackstabbingCheck : ",backstabber,target,anglemin,anglemax)
    end
    local normalized = Ext.Math.Normalize(distance)
    local DP = Ext.Math.Dot(Lu_BsF_CharSteeringVec(target),normalized)
    local currentangle = Ext.Math.Acos(DP)
    if (anglemin<=currentangle and currentangle<=anglemax) then
        return true
    else
        return false
    end
end

function Lu_BsF_StatusApplier(backstabber,target,distance,spell)
    if Lu_BsF_DebugState then
        _P("In StatusApplier : ",backstabber,target,spell)
    end
    Osi.RemoveStatus(target,"BACKSTABBING_FRAMEWORK_MAIN_STATUS_200001")
    local anglemin,anglemax = Lu_BsF_AngleMinMax(Lu_BsF_CheckInAngleMatrix(backstabber,spell),Lu_BsF_CheckModifiers(backstabber,spell))
    if (Lu_BsF_BackstabbingCheck(backstabber,target,distance,anglemin,anglemax)) then
        Osi.ApplyStatus(target,"BACKSTABBING_FRAMEWORK_MAIN_STATUS_200001",5.0,1)
        if Lu_BsF_DebugState then
            _P("Status Successfully applied to ",target)
        end
    end
end

function Lu_BsF_BackstabbingInit(backstabber, spell)
    for _,character in ipairs(Ext.Entity.GetAllEntitiesWithComponent("IsCharacter")) do
        local selfx = Ext.Entity.Get(backstabber).Transform.Transform.Translate[1]
        local selfz = Ext.Entity.Get(backstabber).Transform.Transform.Translate[3]
        local targetx = character.Transform.Transform.Translate[1]
        local targetz = character.Transform.Transform.Translate[3]
        local distance = {targetx-selfx,0,targetz-selfz}
        if (Ext.Math.Length(distance) <= 30 and character.Uuid.EntityUuid ~= Ext.Entity.Get(backstabber).Uuid.EntityUuid and character.Steering.TargetRotation ~= nil and IsDead(character.Uuid.EntityUuid) == 0) then
            Lu_BsF_StatusApplier(backstabber,character.Uuid.EntityUuid,distance,spell)
        end
    end
end
