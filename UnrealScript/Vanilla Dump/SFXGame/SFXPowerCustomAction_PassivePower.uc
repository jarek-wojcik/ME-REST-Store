Class SFXPowerCustomAction_PassivePower extends SFXPowerCustomAction
    abstract
    config(Game);

public function ApplyGlobalBonus()
{
    local SFXModule_GameEffectManager Manager;
    
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        Manager.RemoveEffectsByCategory(Name);
    }
}
public function OnPowerRankIncreased()
{
    Super(SFXPowerCustomActionBase).OnPowerRankIncreased();
    if (Rank < float(4))
    {
        ApplyGlobalBonus();
    }
}
public function OnPowersLoaded()
{
    Super(SFXPowerCustomActionBase).OnPowersLoaded();
    ApplyGlobalBonus();
}
public function OnSquadMemberAdded(Pawn Pawn)
{
    ApplyGlobalBonus();
}
public function ResetPower()
{
    local BioPawn oSquadMember;
    local SFXModule_GameEffectManager Manager;
    local int Index;
    
    Super(SFXPowerCustomActionBase).ResetPower();
    for (Index = 0; Index < m_oPawn.Squad.Members.Length; Index++)
    {
        oSquadMember = BioPawn(m_oPawn.Squad.Members[Index]);
        if (oSquadMember != None && oSquadMember != m_oPawn)
        {
            Manager = oSquadMember.GetModule(Class'SFXModule_GameEffectManager');
            if (Manager != None && oSquadMember.PowerManager != None)
            {
                Manager.RemoveEffectsByCategory(Name);
            }
        }
    }
    ApplyGlobalBonus();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}