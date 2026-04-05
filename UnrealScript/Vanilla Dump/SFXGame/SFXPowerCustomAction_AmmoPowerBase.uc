Class SFXPowerCustomAction_AmmoPowerBase extends SFXPowerCustomAction
    abstract
    config(Game);

public static final function SFXPowerCustomAction_AmmoPowerBase GetSourceAmmoPower(Name AmmoPowerName, Name AmmoPowerSourceTag)
{
    local WorldInfo World;
    local PlayerController pController;
    local SFXPawn Pawn;
    local SFXPawn SquadMember;
    local int idx;
    
    World = Class'Engine'.static.GetCurrentWorldInfo();
    pController = World.GetALocalPlayerController();
    if (pController != None)
    {
        Pawn = SFXPawn(pController.Pawn);
        if (Pawn != None && Pawn.Squad != None)
        {
            for (idx = 0; idx < Pawn.Squad.Members.Length; idx++)
            {
                SquadMember = SFXPawn(Pawn.Squad.Members[idx]);
                if (SquadMember != None && SquadMember.Tag == AmmoPowerSourceTag)
                {
                    if (SquadMember.PowerManager != None)
                    {
                        return SFXPowerCustomAction_AmmoPowerBase(SquadMember.PowerManager.GetPower(AmmoPowerName));
                    }
                }
            }
        }
    }
    return None;
}
public function bool SetWeaponPower(BioPawn oPawn, SFXWeapon oWeapon, bool bOverrideCurrentPower)
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}