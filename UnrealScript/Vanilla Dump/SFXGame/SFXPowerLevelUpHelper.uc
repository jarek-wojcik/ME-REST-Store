Class SFXPowerLevelUpHelper;

struct SavedPawnPowerData 
{
    var array<SavedPowerData> Powers;
    var SFXPawn Pawn;
    var int TalentPoints;
};
struct SavedPowerData 
{
    var array<EEvolveChoice> EvolveChoices;
    var SFXPowerCustomActionBase Power;
    var int Rank;
};

var transient array<SFXPowerCustomActionBase> m_Powers;
var transient array<SavedPawnPowerData> m_SavedPawnPowerStates;
var transient BioWorldInfo m_WorldInfo;
var transient BioPawn m_Pawn;

public function AutoLevelUp()
{
    local int LevelUpIdx;
    local int PowerIdx;
    local int EvolveIdx;
    local SFXPawn_PlayerParty Pawn;
    local SFXPawn_Player PlayerPawn;
    local Class<Object> PawnPower;
    local Class<SFXPowerCustomActionBase> AutoLevelUpPower;
    
    Pawn = SFXPawn_PlayerParty(m_Pawn);
    if (Pawn == None)
    {
        return;
    }
    if (Pawn.AutoLevelUpInfo.Length == 0)
    {
        PlayerPawn = SFXPawn_Player(Pawn);
        if (PlayerPawn != None && PlayerPawn.PlayerClass != None)
        {
            PlayerPawn.AutoLevelUpInfo = PlayerPawn.PlayerClass.default.AutoLevelUpInfo;
        }
    }
    for (LevelUpIdx = 0; LevelUpIdx < Pawn.AutoLevelUpInfo.Length; LevelUpIdx++)
    {
        for (PowerIdx = 0; PowerIdx < m_Powers.Length; PowerIdx++)
        {
            PawnPower = m_Powers[PowerIdx].Class;
            AutoLevelUpPower = Pawn.AutoLevelUpInfo[LevelUpIdx].PowerClass;
            if (ClassIsChildOf(PawnPower, AutoLevelUpPower))
            {
                if (m_Powers[PowerIdx].Rank < Pawn.AutoLevelUpInfo[LevelUpIdx].Rank)
                {
                    if (Pawn.AutoLevelUpInfo[LevelUpIdx].Rank >= float(m_Pawn.PowerManager.EvolveRank))
                    {
                        EvolveIdx = Pawn.AutoLevelUpInfo[LevelUpIdx].EvolvedChoice;
                        if (m_Powers[PowerIdx].EvolvedRankCosts[EvolveIdx] <= GetRemainingPoints())
                        {
                            if (IncreaseRank(PowerIdx) == FALSE)
                            {
                                break;
                            }
                            EvolvePower(m_Powers[PowerIdx], EvolveIdx);
                        }
                        continue;
                    }
                    if (IncreaseRank(PowerIdx) == FALSE)
                    {
                        break;
                    }
                }
            }
        }
    }
    Class'SFXTelemetry'.static.SendName('TelemetryHook_AutoLevelUp', m_Pawn.Tag);
}
public function bool Initialize(BioWorldInfo WorldInfo)
{
    if (WorldInfo == None)
    {
        return FALSE;
    }
    m_WorldInfo = WorldInfo;
    return TRUE;
}
public function bool CanEvolvePower(int nPowerIndex)
{
    if (nPowerIndex < 0 || nPowerIndex >= m_Powers.Length)
    {
        return FALSE;
    }
    if (m_Pawn == None || m_Pawn.PowerManager == None)
    {
        return FALSE;
    }
    if (m_Powers[nPowerIndex].Rank < float(m_Pawn.PowerManager.EvolveRank))
    {
        return FALSE;
    }
    return TRUE;
}
public function bool CanIncreaseRank(int PowerIndex, out int CostToIncrease)
{
    local SFXPowerCustomActionBase Power;
    
    if (PowerIndex < 0 || PowerIndex >= m_Powers.Length)
    {
        return FALSE;
    }
    Power = m_Powers[PowerIndex];
    if (Power == None)
    {
        return FALSE;
    }
    if (IsUnlocked(PowerIndex) == FALSE)
    {
        return FALSE;
    }
    if (Power.Rank >= float(6))
    {
        return FALSE;
    }
    if (Power.Rank >= float(Power.RankCosts.Length))
    {
        return FALSE;
    }
    if (m_Pawn.TalentPoints < Power.RankCosts[int(Power.Rank)])
    {
        return FALSE;
    }
    CostToIncrease = Power.RankCosts[int(Power.Rank)];
    return TRUE;
}
public function bool CanMakePurchase()
{
    local int nIndex;
    local int nCostToIncrease;
    local bool bCanMakePurchase;
    
    bCanMakePurchase = FALSE;
    for (nIndex = 0; nIndex < m_Powers.Length; nIndex++)
    {
        bCanMakePurchase = CanIncreaseRank(nIndex, nCostToIncrease);
        if (bCanMakePurchase)
        {
            break;
        }
    }
    return bCanMakePurchase;
}
public function EvolvePower(SFXPowerCustomActionBase OriginalPower, int nEvolveIndex)
{
    if (OriginalPower == None)
    {
        return;
    }
    if (m_Pawn == None || m_Pawn.PowerManager == None)
    {
        return;
    }
    OriginalPower.EvolvePower(byte(nEvolveIndex));
    OriginalPower.OnPowerRankIncreased();
}
public function float GetCurrentRank(int nPowerIndex)
{
    if (m_Pawn == None || m_Pawn.PowerManager == None)
    {
        return -1.0;
    }
    return m_Powers[nPowerIndex].Rank;
}
public function int GetNextWheelDisplayIndex()
{
    local array<SFXPowerCustomActionBase> aWheelPowers;
    
    m_Pawn.PowerManager.GetPowerWheelPowers(aWheelPowers);
    return aWheelPowers.Length;
}
public function int GetRemainingPoints()
{
    if (m_Pawn == None)
    {
        return 0;
    }
    return m_Pawn.TalentPoints;
}
public function bool IncreaseRank(int PowerIndex)
{
    local int CostToIncrease;
    local BioPlayerController PC;
    
    if (PowerIndex < 0 || PowerIndex >= m_Powers.Length)
    {
        return FALSE;
    }
    if (CanIncreaseRank(PowerIndex, CostToIncrease) == FALSE)
    {
        return FALSE;
    }
    if (m_Powers[PowerIndex].Rank == float(0))
    {
        m_Powers[PowerIndex].WheelDisplayIndex = GetNextWheelDisplayIndex();
    }
    m_Powers[PowerIndex].Rank += 1.0;
    m_Powers[PowerIndex].OnPowerRankIncreased();
    m_Pawn.TalentPoints -= CostToIncrease;
    PC = BioPlayerController(m_Pawn.Controller);
    if (PC != None && m_Powers[PowerIndex].Rank > float(1))
    {
        PC.SetAccomplishmentProgression('POWERLEVEL', int(m_Powers[PowerIndex].Rank));
    }
    return TRUE;
}
public function bool IsUnlocked(int nPowerIndex, optional out int RequiredLevel)
{
    local SFXPowerCustomActionBase Power;
    local int nIndex;
    local SFXPawn_PlayerParty oSFXPawn;
    
    if (nPowerIndex < 0 || nPowerIndex >= m_Powers.Length)
    {
        return FALSE;
    }
    oSFXPawn = SFXPawn_PlayerParty(m_Pawn);
    if (oSFXPawn == None)
    {
        return FALSE;
    }
    Power = m_Powers[nPowerIndex];
    if (Power == None)
    {
        return FALSE;
    }
    if (m_Pawn == None || m_Pawn.PowerManager == None)
    {
        return FALSE;
    }
    if (oSFXPawn.PowerUnlockRequirements.Length == 0)
    {
        return TRUE;
    }
    for (nIndex = 0; nIndex < oSFXPawn.PowerUnlockRequirements.Length; nIndex++)
    {
        if (Power.Class != oSFXPawn.PowerUnlockRequirements[nIndex].PowerClass)
        {
            continue;
        }
        RequiredLevel = oSFXPawn.PowerUnlockRequirements[nIndex].RequiredLevel;
        if (oSFXPawn.CharacterLevel >= RequiredLevel)
        {
            return TRUE;
            continue;
        }
        return FALSE;
    }
    return TRUE;
}
public function SaveCurrentPowerStates()
{
    local SavedPawnPowerData NewPawnData;
    local SavedPowerData NewPowerData;
    local PlayerController Player_Controller;
    local SFXPawn_Player Player_Pawn;
    local BioBaseSquad Player_Squad;
    local int Index;
    local SFXPawn CurrentPawn;
    local SFXPowerManager CurrentPowerManager;
    local SFXPowerCustomActionBase CurrentPower;
    local int EvolvedChoicesIndex;
    local array<Pawn> PawnsToSave;
    
    if (m_WorldInfo == None)
    {
        return;
    }
    Player_Controller = m_WorldInfo.GetALocalPlayerController();
    if (Player_Controller == None)
    {
        return;
    }
    Player_Pawn = SFXPawn_Player(Player_Controller.Pawn);
    if (Player_Pawn == None)
    {
        return;
    }
    Player_Squad = Player_Pawn.Squad;
    if (Player_Squad == None || !Player_Squad.bIsPlayerSquad)
    {
        return;
    }
    if (SFXGRI(m_WorldInfo.GRI) != None && SFXGRI(m_WorldInfo.GRI).bIsMultiplayerCharacter)
    {
        PawnsToSave.AddItem(Player_Controller.Pawn);
    }
    else
    {
        for (Index = 0; Index < Player_Squad.Members.Length; ++Index)
        {
            PawnsToSave.AddItem(Player_Squad.Members[Index]);
        }
    }
    m_SavedPawnPowerStates.Length = 0;
    for (Index = 0; Index < PawnsToSave.Length; Index++)
    {
        NewPawnData.Pawn = None;
        NewPawnData.Powers.Length = 0;
        NewPawnData.TalentPoints = 0;
        NewPowerData.EvolveChoices.Length = 0;
        NewPowerData.Power = None;
        NewPowerData.Rank = 0;
        CurrentPawn = SFXPawn(PawnsToSave[Index]);
        if (CurrentPawn == None)
        {
            break;
        }
        CurrentPowerManager = CurrentPawn.PowerManager;
        if (CurrentPowerManager == None)
        {
            break;
        }
        NewPawnData.Pawn = CurrentPawn;
        foreach CurrentPowerManager.Powers(CurrentPower, )
        {
            NewPowerData.Power = CurrentPower;
            NewPowerData.Rank = int(CurrentPower.Rank);
            for (EvolvedChoicesIndex = 0; EvolvedChoicesIndex < 6; EvolvedChoicesIndex++)
            {
                if (CurrentPower.IsEvolvedWithChoice(byte(EvolvedChoicesIndex)) == TRUE)
                {
                    NewPowerData.EvolveChoices.AddItem(byte(EvolvedChoicesIndex));
                }
            }
            NewPawnData.Powers.AddItem(NewPowerData);
            NewPowerData.EvolveChoices.Length = 0;
            NewPowerData.Power = None;
            NewPowerData.Rank = 0;
        }
        NewPawnData.TalentPoints = CurrentPawn.TalentPoints;
        m_SavedPawnPowerStates.AddItem(NewPawnData);
    }
}
public function bool SetPawn(BioPawn Pawn)
{
    if (m_WorldInfo == None)
    {
        return FALSE;
    }
    if (Pawn == None || Pawn.PowerManager == None)
    {
        return FALSE;
    }
    m_Pawn = Pawn;
    m_Powers.Length = 0;
    m_Pawn.PowerManager.GetSquadRecordPowers(m_Powers);
    return TRUE;
}
public function UndoChanges()
{
    local SavedPawnPowerData SavedPawnIterator;
    local SFXPowerManager CurrentPowerManager;
    local SavedPowerData CurrentPowerData;
    local EEvolveChoice EvolveChoicesIterator;
    
    foreach m_SavedPawnPowerStates(SavedPawnIterator, )
    {
        if (SavedPawnIterator.Pawn == None || SavedPawnIterator.Pawn != m_Pawn)
        {
            continue;
        }
        CurrentPowerManager = SavedPawnIterator.Pawn.PowerManager;
        if (CurrentPowerManager == None)
        {
            continue;
        }
        foreach SavedPawnIterator.Powers(CurrentPowerData, )
        {
            if (CurrentPowerData.Power == None)
            {
                continue;
            }
            CurrentPowerData.Power.ResetPower();
            CurrentPowerData.Power.Rank = float(CurrentPowerData.Rank);
            foreach CurrentPowerData.EvolveChoices(EvolveChoicesIterator, )
            {
                CurrentPowerData.Power.EvolvePower(EvolveChoicesIterator);
            }
            CurrentPowerData.Power.OnPowerRankIncreased();
        }
        SavedPawnIterator.Pawn.TalentPoints = SavedPawnIterator.TalentPoints;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}