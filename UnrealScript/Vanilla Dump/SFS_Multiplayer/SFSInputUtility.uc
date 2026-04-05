Class SFSInputUtility;

public static function AutoMapXbox(BioPlayerInput BPI, SFXPawn_PlayerMP Player)
{
    local array<Name> MappedPowers;
    local int idx;
    local SFXPowerCustomActionBase Power;
    
    if (BPI != None)
    {
        MappedPowers = Player.PlayerClass.MappedPowers;
        idx = 0;
        while (idx < MappedPowers.Length)
        {
            Power = Player.FindPower(MappedPowers[idx]);
            if (Power != None)
            {
                MappedPowers[idx] = Power.Class.Name;
                idx++;
                continue;
            }
            MappedPowers.Remove(idx, 1);
        }
        Power = Player.FindPower(BPI.m_nmMappedPower);
        if (Power != None)
        {
            BPI.m_nmMappedPower = Power.Class.Name;
        }
        else
        {
            BPI.m_nmMappedPower = 'None';
        }
        Power = Player.FindPower(BPI.m_nmMappedPower2);
        if (Power != None)
        {
            BPI.m_nmMappedPower2 = Power.Class.Name;
        }
        else
        {
            BPI.m_nmMappedPower2 = 'None';
        }
        Power = Player.FindPower(BPI.m_nmMappedPower3);
        if (Power != None)
        {
            BPI.m_nmMappedPower3 = Power.Class.Name;
        }
        else
        {
            BPI.m_nmMappedPower3 = 'None';
        }
        MappedPowers.RemoveItem(BPI.m_nmMappedPower);
        MappedPowers.RemoveItem(BPI.m_nmMappedPower2);
        MappedPowers.RemoveItem(BPI.m_nmMappedPower3);
        if (BPI.m_nmMappedPower3 == 'None' && MappedPowers.Length > 0)
        {
            BPI.m_nmMappedPower3 = MappedPowers[0];
            MappedPowers.Remove(0, 1);
        }
        if (BPI.m_nmMappedPower2 == 'None' && MappedPowers.Length > 0)
        {
            BPI.m_nmMappedPower2 = MappedPowers[0];
            MappedPowers.Remove(0, 1);
        }
        if (BPI.m_nmMappedPower == 'None' && MappedPowers.Length > 0)
        {
            BPI.m_nmMappedPower = MappedPowers[0];
            MappedPowers.Remove(0, 1);
        }
    }
    SFXPlayerControllerMP(Player.Controller).GetMPHUD().InitializeCenterPowerIcons();
}
public static function AutoMapPCSpecial(BioPlayerInput BPI, SFXPawn_PlayerMP Player)
{
    local SFXGUIInteraction oGM;
    local SFXSFHandler_PCPowerWheel oPowerWheel;
    local SFXPowerCustomActionBase oPower;
    local BioPlayerController BPC;
    local int i;
    local int J;
    local array<Name> PowerHotkeyAssignments;
    
    BPC = BioPlayerController(Player.Controller);
    oGM = Class'SFXGUIInteraction'.static.GetInstance();
    oPowerWheel = SFXSFHandler_PCPowerWheel(oGM.GetMovie(BPC, oGM.MovieTag_PowerWheel));
    if (oGM == None || oPowerWheel == None || BPC == None || Player == None)
    {
        return;
    }
    oPowerWheel.SetupPlayerPowers();
    PowerHotkeyAssignments.Length = 8;
    if (Player.PlayerClass != None)
    {
        for (i = 0; i < 4; i++)
        {
            oPower = Player.PowerManager.GetPowerByClass(Player.PlayerClass.SquadScreenPowerOrder[i]);
            if (oPower != None)
            {
                PowerHotkeyAssignments[i] = oPower.PowerName;
            }
        }
    }
    PowerHotkeyAssignments[4] = 'Consumable_Rocket';
    PowerHotkeyAssignments[5] = 'Consumable_Shield';
    PowerHotkeyAssignments[6] = 'Consumable_Revive';
    PowerHotkeyAssignments[7] = 'Consumable_Ammo';
    for (i = 0; i < oPowerWheel.m_aPowerIcons.Length; i++)
    {
        oPower = oPowerWheel.m_aPowerIcons[i].pPower;
        for (J = 0; J < PowerHotkeyAssignments.Length; J++)
        {
            if (PowerHotkeyAssignments[J] == oPower.PowerName)
            {
                oPowerWheel.NewSetQuickSlotPower(J, i, TRUE, TRUE);
                break;
            }
        }
    }
}
public static function MapXboxSpecial(BioPlayerInput BPI, SFXPawn_PlayerMP Player)
{
    SetXboxKeyBindInternal(BPI, 'XboxTypeS_RightThumbstick', "castpower 10");
}
public static final function SetPCKeyBindInternal(BioPlayerInput BPI, Name keyName, string command, bool Alt, bool Control, bool Shift)
{
    local StaticKeyBind PowerKeyBind;
    
    PowerKeyBind.command = command;
    PowerKeyBind.Name = keyName;
    PowerKeyBind.Control = Control;
    PowerKeyBind.Alt = Alt;
    PowerKeyBind.Shift = Shift;
    BPI.StaticPCBinds.AddItem(PowerKeyBind);
}
public static final function SetXboxKeyBindInternal(BioPlayerInput BPI, Name keyName, string command)
{
    local StaticKeyBind PowerKeyBind;
    
    PowerKeyBind.command = command;
    PowerKeyBind.Name = keyName;
    BPI.StaticConsoleBinds.AddItem(PowerKeyBind);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}