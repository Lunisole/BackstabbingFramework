Lu_BsF_DebugState = false

function BsFDebug(_,wishedstate)
    if (wishedstate == nil) then
        Lu_BsF_DebugState = not Lu_BsF_DebugState
    else
        if (wishedstate == "deactivate") then
            Lu_BsF_DebugState = false
        elseif (wishedstate == "activate") then
            Lu_BsF_DebugState = true
        else
            _P(wishedstate .. " isn't a valid argument.")
        end
    end
    if (Lu_BsF_DebugState == false) then
        _P("Debugging for Backstabbing Framework is off.")
    else
        _P("Debugging for Backstabbing Framework is on.")
    end
end


Ext.RegisterConsoleCommand("BsFDebug", BsFDebug)