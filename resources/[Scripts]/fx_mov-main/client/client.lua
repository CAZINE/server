function GetSettings()
    return Config
end
_settings = GetSettings()

function CrouchState()
    return inCrouch
end

---MARK: KEYS
RegisterKeyMapping("FX:Crouch","Agachar","keyboard","LCONTROL")
---MARK: EXPORTS
exports("CrouchState",CrouchState)