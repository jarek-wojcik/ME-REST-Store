Class SFXPowerCustomAction_ParagonRenegade extends SFXPowerCustomAction_PassivePower
    abstract
    config(Game);

var config PowerData ParagonRenegadeModifier;

public function ApplyGlobalBonus()
{
    local BioGlobalVariableTable oVariables;
    
    Super.ApplyGlobalBonus();
    oVariables = BioWorldInfo(m_oPawn.WorldInfo).GetGlobalVariables();
    if (oVariables != None)
    {
        if (Rank == float(0))
        {
            oVariables.SetFloat(oVariables.ME3_Plots_Utility_Player_Info_PersuadeMultiplier, 0.0);
        }
        else
        {
            oVariables.SetFloat(oVariables.ME3_Plots_Utility_Player_Info_PersuadeMultiplier, ParagonRenegadeModifier.CurrentValue);
        }
    }
}
public function float GetNegotiationBonus()
{
    local SFXModule_GameEffectManager Manager;
    
    if (m_oPawn != None)
    {
        Manager = m_oPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            return Manager.NegotiationBonus.Value - 1.0;
        }
    }
    return 0.0;
}
public function ModifyCharmSkill(out float fCharmSkill, optional int nRankToUse = -1)
{
    local float Modifier;
    
    Modifier = 1.0 + GetNegotiationBonus();
    if (nRankToUse < 0)
    {
        nRankToUse = int(Rank);
    }
    if (nRankToUse > 0)
    {
        Modifier += GetCurrentValueAtRank(ParagonRenegadeModifier, nRankToUse);
    }
    fCharmSkill *= Modifier;
}
public function ModifyIntimidateSkill(out float fIntimidateSkill, optional int nRankToUse = -1)
{
    local float Modifier;
    
    Modifier = 1.0 + GetNegotiationBonus();
    if (nRankToUse < 0)
    {
        nRankToUse = int(Rank);
    }
    if (nRankToUse > 0)
    {
        Modifier += GetCurrentValueAtRank(ParagonRenegadeModifier, nRankToUse);
    }
    fIntimidateSkill *= Modifier;
}
public function ModifyReputationSkill(out float fRepSkill, optional int nRankToUse = -1)
{
    local float Modifier;
    
    Modifier = 1.0 + GetNegotiationBonus();
    if (nRankToUse < 0)
    {
        nRankToUse = int(Rank);
    }
    if (nRankToUse > 0)
    {
        Modifier += GetCurrentValueAtRank(ParagonRenegadeModifier, nRankToUse);
    }
    fRepSkill *= Modifier;
}
public function RecalculateAllPowerData(optional bool bReset = FALSE)
{
    Super(SFXPowerCustomActionBase).RecalculateAllPowerData(bReset);
    RecalculatePowerData(ParagonRenegadeModifier, bReset);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ParagonRenegadeModifier = {
                               DynamicBonuses = (), 
                               RankBonuses[0] = 0.0, 
                               RankBonuses[1] = 0.0399999991, 
                               RankBonuses[2] = 0.0399999991, 
                               RankBonuses[3] = 0.0, 
                               RankBonuses[4] = 0.0, 
                               RankBonuses[5] = 0.0, 
                               BaseValue = 0.0399999991, 
                               CurrentValue = 0.0, 
                               Formula = EPowerDataFormula.BonusIsHardValue
                              }
}