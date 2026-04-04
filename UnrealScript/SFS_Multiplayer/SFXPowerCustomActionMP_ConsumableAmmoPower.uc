Class SFXPowerCustomActionMP_ConsumableAmmoPower extends SFXPowerCustomAction
    config(Game);

public function ClientDoCustomActionImpact(Actor oActor, int ImpactCount, optional bool bFirstTarget, optional Vector HitLocation, optional Vector HitNormal, optional int CustomActionReactionType)
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect_MatchConsumable_AmmoPower_Cryo oEffectCryo;
    local SFXGameEffect_MatchConsumable_AmmoPower_Disruptor oEffectDisruptor;
    local float fDelay;
    local EPowerResistance Resistance;
    
    if (oActor == None)
    {
        return;
    }
    Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    oEffectCryo = SFXGameEffect_MatchConsumable_AmmoPower_Cryo(Manager.GetFirstEffectOfType(Class'SFXGameEffect_MatchConsumable_AmmoPower_Cryo'));
    if (oEffectCryo != None)
    {
        ReplicationDecodeDelayAndResistance(ImpactCount, fDelay, Resistance);
        oEffectCryo.DoFreezeEffect(BioPawn(oActor), fDelay, HitLocation, HitNormal, TRUE, Resistance);
    }
    oEffectDisruptor = SFXGameEffect_MatchConsumable_AmmoPower_Disruptor(Manager.GetFirstEffectOfType(Class'SFXGameEffect_MatchConsumable_AmmoPower_Disruptor'));
    if (oEffectDisruptor != None)
    {
        oEffectDisruptor.StunEnemy(BioPawn(oActor));
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RankCosts = ()
    PowerName = 'ConsumableAmmoPower'
    PowerCustomActionID = 70
    Rank = 1.0
    UsesSharedCooldown = FALSE
    DisplayInHUD = FALSE
    DisplayInCharacterRecord = FALSE
}