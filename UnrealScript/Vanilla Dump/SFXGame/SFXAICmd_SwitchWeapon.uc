Class SFXAICmd_SwitchWeapon extends SFXAICommand within SFXAI_Core;

var transient SFXWeapon NextWeapon;

public static function bool SwitchWeapon(SFXAI_Core AI, SFXWeapon oWeapon)
{
    local SFXAICmd_SwitchWeapon Cmd;
    
    if (AI != None && oWeapon != None)
    {
        Cmd = new (AI) Class'SFXAICmd_SwitchWeapon';
        if (Cmd != None)
        {
            Cmd.NextWeapon = oWeapon;
            AI.PushCommand(Cmd);
            return TRUE;
        }
    }
    return FALSE;
}
public function ChangeWeapons()
{
    local SFXInventoryManager oInventory;
    
    if (Outer.MyBP != None)
    {
        oInventory = SFXInventoryManager(Outer.MyBP.InvManager);
        if (oInventory != None)
        {
            oInventory.SetWeaponIfAvailable(NextWeapon);
        }
    }
}
public function bool IsWeaponSwitching()
{
    if (Outer.MyBP != None)
    {
        return Outer.MyBP.IsSwitchingWeapons();
    }
    return FALSE;
}
public function Popped()
{
    Outer.m_bPendingWeaponSwitch = FALSE;
    Super(GameAICommand).Popped();
}
public function Pushed()
{
    Super(GameAICommand).Pushed();
    GotoState('SwitchingWeapons', , , );
}

state SwitchingWeapons extends DebugState 
{
    
Begin:
    ChangeWeapons();
    while (IsWeaponSwitching())
    {
        Outer.Sleep(0.100000001);
    }
    Outer.PopCommand(Self);
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}