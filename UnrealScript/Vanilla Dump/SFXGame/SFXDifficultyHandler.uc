Class SFXDifficultyHandler within SFXGRI
    native
    config(Difficulty);

struct native DifficultySettings 
{
    var array<AbilityDifficultyData> CategoryData;
    var Name Category;
};
struct native AbilityDifficultyData 
{
    var Name StatName;
    var Vector2D StatRange;
    var bool bStatActive;
    
    structdefaultproperties
    {
        bStatActive = TRUE
    }
};

var config array<DifficultySettings> Level1DifficultyData;
var config array<DifficultySettings> Level2DifficultyData;
var config array<DifficultySettings> Level3DifficultyData;
var config array<DifficultySettings> Level4DifficultyData;
var config array<DifficultySettings> Level5DifficultyData;
var int CurrentLevel;
var config int MaxPlayerLevel;
var float DifficultyScore;
var float StoppingPowerScalar;
var transient float OutHenchDamageScale;
var transient float OutAIDamageScale;
var float AmmoPct;
var int GrenadesPerDrop;
var float DownedDistanceRange;
var float ShieldRegenPct;
var float ShieldRegenDelay;
var float PartialShieldRegenDelay;
var float CoverDamageReduction;
var float NoCoverDamageBonus;
var float ReviveDamageReductionLength;
var float ReviveDamageReductionAmount;
var float MaxSwarmers;
var float PlayerPartyHealthGateDuration;
var float PlayerPartyShieldGateDuration;
var bool bNeedsUpdate;
var EDifficultyOptions CurrentDifficulty;
var config EDifficultyOptions NormalizedDifficulty;

public function bool GetBool(Name PropertyName, Name DifficultyCategory)
{
    local int Index;
    local int PropertyIndex;
    
    if (bNeedsUpdate)
    {
        Update();
    }
    switch (CurrentDifficulty)
    {
        case EDifficultyOptions.DO_Level1:
            Index = Level1DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level1DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level1DifficultyData[Index].CategoryData[PropertyIndex].bStatActive;
                }
            }
            break;
        case EDifficultyOptions.DO_Level2:
            Index = Level2DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level2DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level2DifficultyData[Index].CategoryData[PropertyIndex].bStatActive;
                }
            }
            break;
        case EDifficultyOptions.DO_Level3:
            Index = Level3DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level3DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level3DifficultyData[Index].CategoryData[PropertyIndex].bStatActive;
                }
            }
            break;
        case EDifficultyOptions.DO_Level4:
            Index = Level4DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level4DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level4DifficultyData[Index].CategoryData[PropertyIndex].bStatActive;
                }
            }
            break;
        case EDifficultyOptions.DO_Level5:
            Index = Level5DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level5DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level5DifficultyData[Index].CategoryData[PropertyIndex].bStatActive;
                }
            }
            break;
        default:
            break;
    }
    return FALSE;
}
public function float GetFloat(Name PropertyName, Name DifficultyCategory)
{
    if (bNeedsUpdate)
    {
        Update();
    }
    return GetFloatAtDifficulty(PropertyName, DifficultyCategory, CurrentDifficulty, DifficultyScore);
}
public function Update()
{
    bNeedsUpdate = FALSE;
    SFXGRI(Outer.WorldInfo.GRI).GetPlayerLevel(0, CurrentLevel);
    UpdateDifficultyScore();
    OutAIDamageScale = GetFloat('OutAIDamageScale', 'Global');
    OutHenchDamageScale = GetFloat('OutHenchDamageScale', 'Global');
    AmmoPct = GetFloat('AmmoPct', 'Global');
    GrenadesPerDrop = int(GetFloat('GrenadesPerDrop', 'Global'));
    ShieldRegenPct = GetFloat('PlayerShieldRegenPct', 'Global');
    ShieldRegenDelay = GetFloat('PlayerShieldRegenDelayFromDestroyed', 'Global');
    PartialShieldRegenDelay = GetFloat('PlayerShieldRegenDelayFromPartial', 'Global');
    CoverDamageReduction = GetFloat('CoverDamageReduction', 'Global');
    NoCoverDamageBonus = GetFloat('NoCoverDamageBonus', 'Global');
    ReviveDamageReductionLength = GetFloat('ReviveDamageReductionLength', 'Global');
    ReviveDamageReductionAmount = GetFloat('ReviveDamageReductionAmount', 'Global');
    StoppingPowerScalar = GetFloat('StoppingPowerScalar', 'Global');
    MaxSwarmers = GetFloat('MaxSwarmers', 'Ravager');
    PlayerPartyHealthGateDuration = GetFloat('PlayerHealthGateDuration', 'Global');
    PlayerPartyShieldGateDuration = GetFloat('PlayerShieldGateDuration', 'Global');
    if (Outer.WorldInfo.Game != None)
    {
        Outer.WorldInfo.Game.AddMutator("SFXGame.SFXMutator_DifficultySpeed", FALSE);
        Outer.WorldInfo.Game.SetGameSpeed(1.0);
    }
}
public static final function SFXDifficultyHandler GetDifficultyHandler()
{
    local BioWorldInfo WI;
    local SFXGame Game;
    local SFXGRI GRI;
    
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (WI == None)
    {
        return None;
    }
    Game = SFXGame(WI.Game);
    if (Game == None)
    {
        return None;
    }
    GRI = SFXGRI(Game.GameReplicationInfo);
    if (GRI == None)
    {
        return None;
    }
    return GRI.DifficultyHandler;
}
private final function float GetFloatAtDifficulty(Name PropertyName, Name DifficultyCategory, EDifficultyOptions Difficulty, float Score)
{
    local int Index;
    local int PropertyIndex;
    
    switch (Difficulty)
    {
        case EDifficultyOptions.DO_Level1:
            Index = Level1DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level1DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return GetRangeValueByPct(Level1DifficultyData[Index].CategoryData[PropertyIndex].StatRange, Score);
                }
            }
            break;
        case EDifficultyOptions.DO_Level2:
            Index = Level2DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level2DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return GetRangeValueByPct(Level2DifficultyData[Index].CategoryData[PropertyIndex].StatRange, Score);
                }
            }
            break;
        case EDifficultyOptions.DO_Level3:
            Index = Level3DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level3DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return GetRangeValueByPct(Level3DifficultyData[Index].CategoryData[PropertyIndex].StatRange, Score);
                }
            }
            break;
        case EDifficultyOptions.DO_Level4:
            Index = Level4DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level4DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return GetRangeValueByPct(Level4DifficultyData[Index].CategoryData[PropertyIndex].StatRange, Score);
                }
            }
            break;
        case EDifficultyOptions.DO_Level5:
            Index = Level5DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level5DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return GetRangeValueByPct(Level5DifficultyData[Index].CategoryData[PropertyIndex].StatRange, Score);
                }
            }
            break;
        default:
            break;
    }
    return -1.0;
}
public function float GetFloatNormalized(Name PropertyName, Name DifficultyCategory)
{
    return GetFloatAtDifficulty(PropertyName, DifficultyCategory, NormalizedDifficulty, 0.0);
}
public function float GetMaxFloat(Name PropertyName, Name DifficultyCategory)
{
    local int Index;
    local int PropertyIndex;
    
    switch (CurrentDifficulty)
    {
        case EDifficultyOptions.DO_Level1:
            Index = Level1DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level1DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level1DifficultyData[Index].CategoryData[PropertyIndex].StatRange.Y;
                }
            }
            break;
        case EDifficultyOptions.DO_Level2:
            Index = Level2DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level2DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level2DifficultyData[Index].CategoryData[PropertyIndex].StatRange.Y;
                }
            }
            break;
        case EDifficultyOptions.DO_Level3:
            Index = Level3DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level3DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level3DifficultyData[Index].CategoryData[PropertyIndex].StatRange.Y;
                }
            }
            break;
        case EDifficultyOptions.DO_Level4:
            Index = Level4DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level4DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level4DifficultyData[Index].CategoryData[PropertyIndex].StatRange.Y;
                }
            }
            break;
        case EDifficultyOptions.DO_Level5:
            Index = Level5DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level5DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level5DifficultyData[Index].CategoryData[PropertyIndex].StatRange.Y;
                }
            }
            break;
        default:
            break;
    }
    return -1.0;
}
public function float GetMinFloat(Name PropertyName, Name DifficultyCategory)
{
    local int Index;
    local int PropertyIndex;
    
    switch (CurrentDifficulty)
    {
        case EDifficultyOptions.DO_Level1:
            Index = Level1DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level1DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level1DifficultyData[Index].CategoryData[PropertyIndex].StatRange.X;
                }
            }
            break;
        case EDifficultyOptions.DO_Level2:
            Index = Level2DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level2DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level2DifficultyData[Index].CategoryData[PropertyIndex].StatRange.X;
                }
            }
            break;
        case EDifficultyOptions.DO_Level3:
            Index = Level3DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level3DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level3DifficultyData[Index].CategoryData[PropertyIndex].StatRange.X;
                }
            }
            break;
        case EDifficultyOptions.DO_Level4:
            Index = Level4DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level4DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level4DifficultyData[Index].CategoryData[PropertyIndex].StatRange.X;
                }
            }
            break;
        case EDifficultyOptions.DO_Level5:
            Index = Level5DifficultyData.Find('Category', DifficultyCategory);
            if (Index != -1)
            {
                PropertyIndex = Level5DifficultyData[Index].CategoryData.Find('StatName', PropertyName);
                if (PropertyIndex != -1)
                {
                    return Level5DifficultyData[Index].CategoryData[PropertyIndex].StatRange.X;
                }
            }
            break;
        default:
            break;
    }
    return -1.0;
}
public function UpdateDifficultyScore()
{
    DifficultyScore = float(CurrentLevel) / float(MaxPlayerLevel);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Level1DifficultyData = ({
                             CategoryData = ({
                                              StatName = 'OutAIDamageScale', 
                                              StatRange = {X = -0.899999976, Y = -0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'OutHenchDamageScale', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HenchDamageTaken', 
                                              StatRange = {X = -0.5, Y = -0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AmmoDropPct', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AmmoPct', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadesPerDrop', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIEnergyShieldGatePct', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIArmorDamageReduction', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenPct', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenDelayFromDestroyed', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenDelayFromPartial', 
                                              StatRange = {X = 1.5, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveHealthReturn', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'StoppingPowerScalar', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CoverDamageReduction', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GlobalEnemyGrenadeCooldown', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NoCoverDamageBonus', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveDamageReductionLength', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveDamageReductionAmount', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldGateDuration', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerHealthGateDuration', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Global'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MedigelHealAmount', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'XPForExcessMedigel', 
                                              StatRange = {X = 25.0, Y = 25.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_ShieldStrength', 
                                              StatRange = {X = 50.0, Y = 50.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_RegenStrength', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_PlaceableRegenStrength', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_KineticBarrier_Health', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Generator_BlastDamage', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_RachniiEgg_RottenBlastDamage', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_IndoctrinationDevice_ShieldStrength', 
                                              StatRange = {X = 50.0, Y = 50.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_IndoctrinationDevice_BeamCooldown', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_GethTripMine_ZapDamage', 
                                              StatRange = {X = 50.0, Y = 50.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'SPGlobal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 3.0, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.800000012, Y = 0.699999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 1.0, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 15.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.100000001, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.100000001, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 1.20000005, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 125.0, Y = 175.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 40.0, Y = 40.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 120.0, Y = 120.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'AssaultTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 4.0, Y = 4.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.400000006, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.449999988, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.100000001, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.100000001, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CoverMoveSmokeChance', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankedSmokeChance', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SmokeFrequency', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 120.0, Y = 120.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 150.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 160.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Centurion'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.600000024, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.800000012, Y = 0.699999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.899999976, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.100000001, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.100000001, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 1.20000005, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RepairPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DeployBreachThreshold', 
                                              StatRange = {X = 170.0, Y = 220.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 150.0, Y = 225.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 275.0, Y = 325.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Gunner'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 200.0, Y = 300.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 175.0, Y = 275.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 30.0, Y = 30.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GunnerTurret'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 15.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 3.0, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.800000012, Y = 0.699999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 1.0, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 15.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.100000001, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.100000001, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 1.20000005, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachFrequency', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldResetDuration', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDamageBreachThreshold', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldBashInterval', 
                                              StatRange = {X = 15.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 300.0, Y = 450.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Guardian'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 5.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.600000024, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.699999988, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.300000012, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.100000001, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.800000012, Y = 0.699999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NemesisAimDelay', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AimTrackingDuration', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 150.0, Y = 225.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 275.0, Y = 325.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 40.0, Y = 40.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Nemesis'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SmokeInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RocketInterval', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BlockInterval', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CockpitDamageResetDuration', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CockpitBlockThreshold', 
                                              StatRange = {X = 444.0, Y = 666.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ArmourPieceHealth', 
                                              StatRange = {X = 185.0, Y = 277.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GlassCockpitHealth', 
                                              StatRange = {X = 925.0, Y = 1387.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 3700.0, Y = 5550.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1100.0, Y = 1650.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 30.0, Y = 30.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.0250000004, Y = 0.0250000004}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 90.0, Y = 90.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 140.0, Y = 140.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Atlas'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 5.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.0599999987, Y = 0.0399999991}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.0700000003, Y = 0.0599999987}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 10.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamageScalePct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDamageScalePct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.5, Y = 0.699999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CloakHealthPct', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'VortexDamageWindow', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'VortexFrequency', 
                                              StatRange = {X = 30.0, Y = 30.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldFrequency', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AggressiveFrequency', 
                                              StatRange = {X = 30.0, Y = 30.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 4.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 250.0, Y = 300.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBarriers', 
                                              StatRange = {X = 275.0, Y = 425.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 90.0, Y = 90.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 140.0, Y = 140.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Phantom'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 3.0, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 1.20000005, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.100000001, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelConsumeHealthPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ConsumeHealPct', 
                                              StatRange = {X = 0.0500000007, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PoweredHealPct', 
                                              StatRange = {X = 0.00999999978, Y = 0.00999999978}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 200.0, Y = 275.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 120.0, Y = 120.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Cannibal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 275.0, Y = 275.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'TutorialCannibal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 4.0, Y = 4.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.400000006, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.449999988, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.100000001, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.100000001, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BuffInterval', 
                                              StatRange = {X = 25.0, Y = 25.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreakBuffDamageThreshold', 
                                              StatRange = {X = 80.0, Y = 115.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 250.0, Y = 350.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 150.0, Y = 225.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Marauder'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardDuration', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardSpeedMod', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RoarChance', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AngryDuration', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AngrySpeedMod', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardDamageResetDuration', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardHealthPctThreshold', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 2100.0, Y = 3150.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 90.0, Y = 90.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 380.0, Y = 380.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Brute'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 4500.0, Y = 6750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 490.0, Y = 490.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 590.0, Y = 590.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'HARVESTER'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 6.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 40.0, Y = 30.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 150.0, Y = 225.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Husk'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 70.0, Y = 70.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'TutorialHusk'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'SackDamageHealthPct', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackBurstDamage', 
                                              StatRange = {X = 10.0, Y = 50.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackBurstRadius', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackHealth', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AimDelay', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeLow', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeHigh', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NumSwarmersToSpawn', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NumSwarmersInSack', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxSwarmers', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SwarmerSpawnIntervalRangeLow', 
                                              StatRange = {X = 60.0, Y = 30.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SwarmerSpawnIntervalRangeHigh', 
                                              StatRange = {X = 120.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1300.0, Y = 1950.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 90.0, Y = 90.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 380.0, Y = 380.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Swarmer_MaxHealth', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Ravager'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 4.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldFrequency', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDuration', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'LongRangeBlastInterval', 
                                              StatRange = {X = 10.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BlastInterval', 
                                              StatRange = {X = 5.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AggressiveDuration', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AOEBlastInterval', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TeleportInterval', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxTeleports', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageThreshold', 
                                              StatRange = {X = 750.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBreachDamageThreshold', 
                                              StatRange = {X = 1000.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageResetDuration', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ChargedIntervalLow', 
                                              StatRange = {X = 45.0, Y = 45.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ChargedIntervalHigh', 
                                              StatRange = {X = 120.0, Y = 120.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxChargedBanshees', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 2000.0, Y = 3000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBarriers', 
                                              StatRange = {X = 500.0, Y = 800.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 30.0, Y = 30.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.0250000004, Y = 0.0250000004}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 90.0, Y = 90.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 380.0, Y = 380.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Banshee'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 4.0, Y = 4.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.400000006, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.449999988, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.100000001, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.100000001, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 250.0, Y = 300.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 5.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.600000024, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.699999988, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.300000012, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.800000012, Y = 0.699999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.100000001, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 150.0, Y = 225.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 275.0, Y = 325.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethRocketTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CloakSpeedMod', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HunterAimDelay', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HunterRecloakDelay', 
                                              StatRange = {X = 1.5, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.100000001, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 300.0, Y = 450.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 250.0, Y = 300.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethHunter'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.100000001, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TankHealth', 
                                              StatRange = {X = 150.0, Y = 225.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 300.0, Y = 450.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 250.0, Y = 375.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethPyro'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TurretSpawnInterval', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DroneSpawnInterval', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeLow', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeHigh', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MoveFireDelayTimeLow', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MoveFireDelayTimeHigh', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1000.0, Y = 1250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1000.0, Y = 1500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 30.0, Y = 30.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.0250000004, Y = 0.0250000004}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 90.0, Y = 90.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 140.0, Y = 140.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDrone_MaxHealth', 
                                              StatRange = {X = 200.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Turret_MaxHealth', 
                                              StatRange = {X = 150.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethPrime'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'AggressiveFrequency', 
                                              StatRange = {X = 25.0, Y = 25.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 800.0, Y = 1600.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1100.0, Y = 1650.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'KnockbackFrequency', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RollFrequency', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DamageThreshold', 
                                              StatRange = {X = 150.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerSlashInterval', 
                                              StatRange = {X = 40.0, Y = 40.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachFrequency', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageResetDuration', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageThreshold', 
                                              StatRange = {X = 750.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'KaiLeng'
                            }
                           )
    Level2DifficultyData = ({
                             CategoryData = ({
                                              StatName = 'OutAIDamageScale', 
                                              StatRange = {X = -0.75, Y = -0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'OutHenchDamageScale', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HenchDamageTaken', 
                                              StatRange = {X = -0.5, Y = -0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AmmoDropPct', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AmmoPct', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadesPerDrop', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIEnergyShieldGatePct', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIArmorDamageReduction', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenPct', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenDelayFromDestroyed', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenDelayFromPartial', 
                                              StatRange = {X = 1.5, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveHealthReturn', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'StoppingPowerScalar', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CoverDamageReduction', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GlobalEnemyGrenadeCooldown', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NoCoverDamageBonus', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveDamageReductionLength', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveDamageReductionAmount', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldGateDuration', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerHealthGateDuration', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Global'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MedigelHealAmount', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'XPForExcessMedigel', 
                                              StatRange = {X = 25.0, Y = 25.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_ShieldStrength', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_RegenStrength', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_PlaceableRegenStrength', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_KineticBarrier_Health', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Generator_BlastDamage', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_RachniiEgg_RottenBlastDamage', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_IndoctrinationDevice_ShieldStrength', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_IndoctrinationDevice_BeamCooldown', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_GethTripMine_ZapDamage', 
                                              StatRange = {X = 50.0, Y = 50.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'SPGlobal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.400000006, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 4.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.5, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.699999988, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 10.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.699999988, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 250.0, Y = 300.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 40.0, Y = 40.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 125.0, Y = 125.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'AssaultTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.300000012, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 5.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.200000003, Y = 0.174999997}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.349999994, Y = 0.275000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 10.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.5, Y = 0.449999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CoverMoveSmokeChance', 
                                              StatRange = {X = 0.200000003, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankedSmokeChance', 
                                              StatRange = {X = 0.200000003, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SmokeFrequency', 
                                              StatRange = {X = 10.0, Y = 9.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 120.0, Y = 120.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 250.0, Y = 375.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 250.0, Y = 375.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Centurion'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.400000006, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 4.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.449999988, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.699999988, Y = 0.550000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 8.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.699999988, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RepairPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DeployBreachThreshold', 
                                              StatRange = {X = 230.0, Y = 320.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 250.0, Y = 375.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 325.0, Y = 425.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Gunner'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 350.0, Y = 450.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 300.0, Y = 400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 18.0, Y = 18.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GunnerTurret'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 12.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.400000006, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 4.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.5, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.699999988, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 10.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.699999988, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachFrequency', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldResetDuration', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDamageBreachThreshold', 
                                              StatRange = {X = 300.0, Y = 400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldBashInterval', 
                                              StatRange = {X = 12.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 400.0, Y = 575.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Guardian'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.349999994, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 7.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.5, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.649999976, Y = 0.550000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 10.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.5, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.300000012, Y = 0.449999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.449999988, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NemesisAimDelay', 
                                              StatRange = {X = 1.5, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AimTrackingDuration', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 250.0, Y = 375.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 325.0, Y = 425.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 40.0, Y = 40.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Nemesis'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 45.0, Y = 45.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SmokeInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RocketInterval', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BlockInterval', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CockpitDamageResetDuration', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CockpitBlockThreshold', 
                                              StatRange = {X = 672.0, Y = 1008.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ArmourPieceHealth', 
                                              StatRange = {X = 280.0, Y = 420.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GlassCockpitHealth', 
                                              StatRange = {X = 1400.0, Y = 2100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 5600.0, Y = 8400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1650.0, Y = 2475.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 18.0, Y = 18.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.0250000004, Y = 0.0250000004}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 140.0, Y = 140.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 390.0, Y = 390.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Atlas'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.349999994, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 7.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.0500000007, Y = 0.0299999993}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.0649999976, Y = 0.0549999997}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 7.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamageScalePct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDamageScalePct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.600000024, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CloakHealthPct', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'VortexDamageWindow', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'VortexFrequency', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldFrequency', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AggressiveFrequency', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 300.0, Y = 375.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBarriers', 
                                              StatRange = {X = 400.0, Y = 525.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 90.0, Y = 90.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 140.0, Y = 140.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.649999976, Y = 0.649999976}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Phantom'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.400000006, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 4.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.699999988, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelConsumeHealthPct', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ConsumeHealPct', 
                                              StatRange = {X = 0.0700000003, Y = 0.0700000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PoweredHealPct', 
                                              StatRange = {X = 0.0199999996, Y = 0.0199999996}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 300.0, Y = 425.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 120.0, Y = 120.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Cannibal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 400.0, Y = 400.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'TutorialCannibal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.300000012, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 5.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.200000003, Y = 0.174999997}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.349999994, Y = 0.275000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 10.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.5, Y = 0.449999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BuffInterval', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreakBuffDamageThreshold', 
                                              StatRange = {X = 130.0, Y = 170.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 400.0, Y = 500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 250.0, Y = 350.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Marauder'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardDuration', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardSpeedMod', 
                                              StatRange = {X = 0.375, Y = 0.375}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RoarChance', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AngryDuration', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AngrySpeedMod', 
                                              StatRange = {X = 1.14999998, Y = 1.14999998}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardDamageResetDuration', 
                                              StatRange = {X = 1.75, Y = 1.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardHealthPctThreshold', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 3200.0, Y = 4800.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 380.0, Y = 380.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 590.0, Y = 590.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Brute'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 6700.0, Y = 10050.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 490.0, Y = 490.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 590.0, Y = 590.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 800.0, Y = 800.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'HARVESTER'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 4.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 20.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 230.0, Y = 345.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 40.0, Y = 40.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Husk'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 70.0, Y = 70.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'TutorialHusk'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'SackDamageHealthPct', 
                                              StatRange = {X = 0.224999994, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackBurstDamage', 
                                              StatRange = {X = 100.0, Y = 150.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackBurstRadius', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackHealth', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AimDelay', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeLow', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeHigh', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NumSwarmersToSpawn', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NumSwarmersInSack', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxSwarmers', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SwarmerSpawnIntervalRangeLow', 
                                              StatRange = {X = 30.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SwarmerSpawnIntervalRangeHigh', 
                                              StatRange = {X = 60.0, Y = 30.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 2000.0, Y = 3000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 380.0, Y = 380.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 590.0, Y = 590.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Swarmer_MaxHealth', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Ravager'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 6.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldFrequency', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDuration', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'LongRangeBlastInterval', 
                                              StatRange = {X = 10.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BlastInterval', 
                                              StatRange = {X = 5.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AggressiveDuration', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AOEBlastInterval', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TeleportInterval', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxTeleports', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageThreshold', 
                                              StatRange = {X = 750.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBreachDamageThreshold', 
                                              StatRange = {X = 2000.0, Y = 2000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageResetDuration', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ChargedIntervalLow', 
                                              StatRange = {X = 45.0, Y = 45.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ChargedIntervalHigh', 
                                              StatRange = {X = 90.0, Y = 90.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxChargedBanshees', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 2800.0, Y = 3800.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBarriers', 
                                              StatRange = {X = 800.0, Y = 1100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 18.0, Y = 18.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.0250000004, Y = 0.0250000004}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 380.0, Y = 380.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 590.0, Y = 590.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Banshee'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.300000012, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 5.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.200000003, Y = 0.174999997}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.349999994, Y = 0.275000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 10.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.5, Y = 0.449999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 350.0, Y = 525.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.349999994, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 7.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.5, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.649999976, Y = 0.550000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 10.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.5, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.449999988, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 250.0, Y = 375.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 325.0, Y = 425.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethRocketTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CloakSpeedMod', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HunterAimDelay', 
                                              StatRange = {X = 2.0999999, Y = 2.0999999}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HunterRecloakDelay', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.349999994, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 10.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.400000006, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 400.0, Y = 575.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 375.0, Y = 450.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethHunter'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.349999994, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 10.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.200000003, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TankHealth', 
                                              StatRange = {X = 200.0, Y = 287.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 400.0, Y = 575.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 350.0, Y = 500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethPyro'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TurretSpawnInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DroneSpawnInterval', 
                                              StatRange = {X = 16.0, Y = 16.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeLow', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeHigh', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MoveFireDelayTimeLow', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MoveFireDelayTimeHigh', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 3000.0, Y = 5000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1500.0, Y = 2500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 18.0, Y = 18.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.0250000004, Y = 0.0250000004}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 140.0, Y = 140.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 390.0, Y = 390.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDrone_MaxHealth', 
                                              StatRange = {X = 250.0, Y = 325.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Turret_MaxHealth', 
                                              StatRange = {X = 200.0, Y = 275.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethPrime'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'AggressiveFrequency', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 800.0, Y = 1600.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1650.0, Y = 2475.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'KnockbackFrequency', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RollFrequency', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DamageThreshold', 
                                              StatRange = {X = 150.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerSlashInterval', 
                                              StatRange = {X = 40.0, Y = 40.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachFrequency', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageResetDuration', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageThreshold', 
                                              StatRange = {X = 750.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.649999976, Y = 0.649999976}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'KaiLeng'
                            }
                           )
    Level3DifficultyData = ({
                             CategoryData = ({
                                              StatName = 'OutAIDamageScale', 
                                              StatRange = {X = -0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'OutHenchDamageScale', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HenchDamageTaken', 
                                              StatRange = {X = -0.25, Y = -0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AmmoDropPct', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AmmoPct', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadesPerDrop', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIEnergyShieldGatePct', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIArmorDamageReduction', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenPct', 
                                              StatRange = {X = 0.330000013, Y = 0.330000013}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenDelayFromDestroyed', 
                                              StatRange = {X = 3.5, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenDelayFromPartial', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveHealthReturn', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'StoppingPowerScalar', 
                                              StatRange = {X = 1.5, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CoverDamageReduction', 
                                              StatRange = {X = 0.899999976, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GlobalEnemyGrenadeCooldown', 
                                              StatRange = {X = 25.0, Y = 25.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NoCoverDamageBonus', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveDamageReductionLength', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveDamageReductionAmount', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldGateDuration', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerHealthGateDuration', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Global'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MedigelHealAmount', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'XPForExcessMedigel', 
                                              StatRange = {X = 50.0, Y = 50.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_ShieldStrength', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_RegenStrength', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_PlaceableRegenStrength', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_KineticBarrier_Health', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Generator_BlastDamage', 
                                              StatRange = {X = 300.0, Y = 300.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_RachniiEgg_RottenBlastDamage', 
                                              StatRange = {X = 300.0, Y = 300.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_IndoctrinationDevice_ShieldStrength', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_IndoctrinationDevice_BeamCooldown', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_GethTripMine_ZapDamage', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'SPGlobal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.300000012, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 6.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.449999988, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.600000024, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 9.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.300000012, Y = 0.449999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.300000012, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.5, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 500.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 75.0, Y = 75.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 25.0, Y = 25.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'AssaultTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.200000003, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 7.0, Y = 9.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.174999997, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.275000006, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 9.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.400000006, Y = 0.550000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.699999988, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.400000006, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CoverMoveSmokeChance', 
                                              StatRange = {X = 0.699999988, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankedSmokeChance', 
                                              StatRange = {X = 0.699999988, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SmokeFrequency', 
                                              StatRange = {X = 8.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 500.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 500.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 8.5, Y = 8.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.850000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Centurion'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.200000003, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 6.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.349999994, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.449999988, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 7.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.400000006, Y = 0.550000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.699999988, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.5, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RepairPct', 
                                              StatRange = {X = 0.600000024, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DeployBreachThreshold', 
                                              StatRange = {X = 400.0, Y = 600.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 500.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 500.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 8.5, Y = 8.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.850000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Gunner'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 600.0, Y = 900.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 600.0, Y = 900.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 240.0, Y = 240.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GunnerTurret'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.300000012, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 6.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.449999988, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.600000024, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 9.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.300000012, Y = 0.449999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.300000012, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.5, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachFrequency', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldResetDuration', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDamageBreachThreshold', 
                                              StatRange = {X = 500.0, Y = 600.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldBashInterval', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 500.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.850000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Guardian'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.150000006, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 8.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.449999988, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.600000024, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 9.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.550000012, Y = 0.699999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.699999988, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.349999994, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NemesisAimDelay', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AimTrackingDuration', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 300.0, Y = 450.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 500.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 8.5, Y = 8.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 75.0, Y = 75.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.850000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Nemesis'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SmokeInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RocketInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BlockInterval', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CockpitDamageResetDuration', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CockpitBlockThreshold', 
                                              StatRange = {X = 600.0, Y = 900.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ArmourPieceHealth', 
                                              StatRange = {X = 250.0, Y = 375.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GlassCockpitHealth', 
                                              StatRange = {X = 2000.0, Y = 3000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 5000.0, Y = 7500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 5000.0, Y = 7500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.0625, Y = 0.0625}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 390.0, Y = 390.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 700.0, Y = 700.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Atlas'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.150000006, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 8.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.0450000018, Y = 0.0250000004}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.0599999987, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 4.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamageScalePct', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDamageScalePct', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.800000012, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CloakHealthPct', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'VortexDamageWindow', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'VortexFrequency', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldFrequency', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AggressiveFrequency', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 1.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 500.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBarriers', 
                                              StatRange = {X = 700.0, Y = 1050.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 8.5, Y = 8.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.150000006, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 140.0, Y = 140.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 440.0, Y = 440.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Phantom'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.300000012, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 6.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.5, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.300000012, Y = 0.449999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelConsumeHealthPct', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ConsumeHealPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PoweredHealPct', 
                                              StatRange = {X = 0.0399999991, Y = 0.0399999991}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 600.0, Y = 900.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 25.0, Y = 25.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Cannibal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 480.0, Y = 720.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'TutorialCannibal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.200000003, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 7.0, Y = 9.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.174999997, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.275000006, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 9.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.5, Y = 0.649999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.400000006, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.699999988, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BuffInterval', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreakBuffDamageThreshold', 
                                              StatRange = {X = 315.0, Y = 472.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 600.0, Y = 900.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 450.0, Y = 675.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 8.5, Y = 8.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.850000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Marauder'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardDuration', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardSpeedMod', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RoarChance', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AngryDuration', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AngrySpeedMod', 
                                              StatRange = {X = 1.25, Y = 1.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardDamageResetDuration', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardHealthPctThreshold', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 4000.0, Y = 6000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 380.0, Y = 380.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 590.0, Y = 590.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1000.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.800000012, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Brute'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 8000.0, Y = 12000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 590.0, Y = 590.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 800.0, Y = 800.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1100.0, Y = 1100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'HARVESTER'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 18.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 275.0, Y = 412.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 40.0, Y = 40.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Husk'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'TutorialHusk'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'SackDamageHealthPct', 
                                              StatRange = {X = 0.100000001, Y = 0.075000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackBurstDamage', 
                                              StatRange = {X = 200.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackBurstRadius', 
                                              StatRange = {X = 250.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackHealth', 
                                              StatRange = {X = 0.25, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AimDelay', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 7.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeLow', 
                                              StatRange = {X = 1.5, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeHigh', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NumSwarmersToSpawn', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NumSwarmersInSack', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxSwarmers', 
                                              StatRange = {X = 9.0, Y = 9.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SwarmerSpawnIntervalRangeLow', 
                                              StatRange = {X = 15.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SwarmerSpawnIntervalRangeHigh', 
                                              StatRange = {X = 30.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 2400.0, Y = 3600.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 380.0, Y = 380.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 590.0, Y = 590.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1000.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Swarmer_MaxHealth', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.850000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Ravager'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 5.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldFrequency', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDuration', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'LongRangeBlastInterval', 
                                              StatRange = {X = 6.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BlastInterval', 
                                              StatRange = {X = 2.0, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AggressiveDuration', 
                                              StatRange = {X = 17.0, Y = 21.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AOEBlastInterval', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TeleportInterval', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxTeleports', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageThreshold', 
                                              StatRange = {X = 1500.0, Y = 2000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBreachDamageThreshold', 
                                              StatRange = {X = 4000.0, Y = 4000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageResetDuration', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ChargedIntervalLow', 
                                              StatRange = {X = 25.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ChargedIntervalHigh', 
                                              StatRange = {X = 30.0, Y = 25.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxChargedBanshees', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 5000.0, Y = 7500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBarriers', 
                                              StatRange = {X = 3000.0, Y = 4500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.0625, Y = 0.0625}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 380.0, Y = 380.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 590.0, Y = 590.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1000.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Banshee'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.200000003, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 7.0, Y = 9.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.174999997, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.275000006, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 9.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.400000006, Y = 0.550000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.300000012, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.400000006, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 500.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.150000006, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 8.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.449999988, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.600000024, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 9.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.550000012, Y = 0.699999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.349999994, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.699999988, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 400.0, Y = 600.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 400.0, Y = 600.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 8.5, Y = 8.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.850000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethRocketTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CloakSpeedMod', 
                                              StatRange = {X = 0.699999988, Y = 0.699999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HunterAimDelay', 
                                              StatRange = {X = 1.25, Y = 1.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HunterRecloakDelay', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 9.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.699999988, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 500.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 450.0, Y = 675.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 8.5, Y = 8.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.800000012, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethHunter'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 9.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.300000012, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TankHealth', 
                                              StatRange = {X = 350.0, Y = 525.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 700.0, Y = 1050.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 500.0, Y = 750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 8.5, Y = 8.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.800000012, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethPyro'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TurretSpawnInterval', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DroneSpawnInterval', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeLow', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeHigh', 
                                              StatRange = {X = 3.5, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MoveFireDelayTimeLow', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MoveFireDelayTimeHigh', 
                                              StatRange = {X = 3.5, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 5000.0, Y = 7500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 3500.0, Y = 5250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.0625, Y = 0.0625}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 390.0, Y = 390.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 700.0, Y = 700.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDrone_MaxHealth', 
                                              StatRange = {X = 300.0, Y = 375.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Turret_MaxHealth', 
                                              StatRange = {X = 250.0, Y = 325.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethPrime'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'AggressiveFrequency', 
                                              StatRange = {X = 15.5, Y = 15.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1600.0, Y = 2400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 5000.0, Y = 7500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'KnockbackFrequency', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RollFrequency', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DamageThreshold', 
                                              StatRange = {X = 250.0, Y = 350.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerSlashInterval', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachFrequency', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageResetDuration', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageThreshold', 
                                              StatRange = {X = 1250.0, Y = 1500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'KaiLeng'
                            }
                           )
    Level4DifficultyData = ({
                             CategoryData = ({
                                              StatName = 'OutAIDamageScale', 
                                              StatRange = {X = 0.600000024, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'OutHenchDamageScale', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HenchDamageTaken', 
                                              StatRange = {X = -0.5, Y = -0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AmmoDropPct', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AmmoPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadesPerDrop', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIEnergyShieldGatePct', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIArmorDamageReduction', 
                                              StatRange = {X = 30.0, Y = 30.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenPct', 
                                              StatRange = {X = 0.286000013, Y = 0.286000013}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenDelayFromDestroyed', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenDelayFromPartial', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveHealthReturn', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'StoppingPowerScalar', 
                                              StatRange = {X = 6.5, Y = 6.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CoverDamageReduction', 
                                              StatRange = {X = 0.899999976, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GlobalEnemyGrenadeCooldown', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NoCoverDamageBonus', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveDamageReductionLength', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveDamageReductionAmount', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldGateDuration', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerHealthGateDuration', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Global'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MedigelHealAmount', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'XPForExcessMedigel', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_ShieldStrength', 
                                              StatRange = {X = 300.0, Y = 300.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_RegenStrength', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_PlaceableRegenStrength', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_KineticBarrier_Health', 
                                              StatRange = {X = 500.0, Y = 500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Generator_BlastDamage', 
                                              StatRange = {X = 400.0, Y = 400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_RachniiEgg_RottenBlastDamage', 
                                              StatRange = {X = 400.0, Y = 400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_IndoctrinationDevice_ShieldStrength', 
                                              StatRange = {X = 300.0, Y = 300.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_IndoctrinationDevice_BeamCooldown', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_GethTripMine_ZapDamage', 
                                              StatRange = {X = 150.0, Y = 150.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'SPGlobal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.25, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 8.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.400000006, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.449999988, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 8.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.600000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.400000006, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.300000012, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 750.0, Y = 1125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 75.0, Y = 75.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.850000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'AssaultTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.150000006, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 9.0, Y = 11.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.150000006, Y = 0.119999997}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.200000003, Y = 0.174999997}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 8.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.5, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.699999988, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.800000012, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.25, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CoverMoveSmokeChance', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankedSmokeChance', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SmokeFrequency', 
                                              StatRange = {X = 7.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 750.0, Y = 1125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 750.0, Y = 1125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 7.5, Y = 7.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Centurion'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.150000006, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 8.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.300000012, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.400000006, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 5.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.5, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.699999988, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.800000012, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.300000012, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RepairPct', 
                                              StatRange = {X = 0.800000012, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DeployBreachThreshold', 
                                              StatRange = {X = 675.0, Y = 1012.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 750.0, Y = 1125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 750.0, Y = 1125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 7.5, Y = 7.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 110.0, Y = 110.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Gunner'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 900.0, Y = 1350.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 900.0, Y = 1350.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.286000013, Y = 0.286000013}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 240.0, Y = 240.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GunnerTurret'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.25, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 8.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.400000006, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.449999988, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 8.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.5, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.600000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.400000006, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.300000012, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachFrequency', 
                                              StatRange = {X = 7.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldResetDuration', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDamageBreachThreshold', 
                                              StatRange = {X = 800.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldBashInterval', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 750.0, Y = 1125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Guardian'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 10.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.400000006, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.550000012, Y = 0.449999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 8.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.5, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.800000012, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.800000012, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.200000003, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NemesisAimDelay', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AimTrackingDuration', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 450.0, Y = 675.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 750.0, Y = 1125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 7.5, Y = 7.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 75.0, Y = 75.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Nemesis'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 1.5, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SmokeInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RocketInterval', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BlockInterval', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CockpitDamageResetDuration', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CockpitBlockThreshold', 
                                              StatRange = {X = 900.0, Y = 1350.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ArmourPieceHealth', 
                                              StatRange = {X = 375.0, Y = 562.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GlassCockpitHealth', 
                                              StatRange = {X = 3000.0, Y = 4500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 7500.0, Y = 11250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 7500.0, Y = 11250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.0850000009, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 390.0, Y = 390.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 700.0, Y = 700.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1200.0, Y = 1200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.349999994, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Atlas'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 10.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.0399999991, Y = 0.0199999996}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.0549999997, Y = 0.0450000018}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 3.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamageScalePct', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDamageScalePct', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.899999976, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.200000003, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CloakHealthPct', 
                                              StatRange = {X = 0.800000012, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'VortexDamageWindow', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'VortexFrequency', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldFrequency', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AggressiveFrequency', 
                                              StatRange = {X = 7.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 750.0, Y = 1125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBarriers', 
                                              StatRange = {X = 1050.0, Y = 1575.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 7.5, Y = 7.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 440.0, Y = 440.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 700.0, Y = 700.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Phantom'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.25, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 8.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.300000012, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.600000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelConsumeHealthPct', 
                                              StatRange = {X = 0.349999994, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ConsumeHealPct', 
                                              StatRange = {X = 0.150000006, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PoweredHealPct', 
                                              StatRange = {X = 0.0500000007, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 900.0, Y = 1350.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.850000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Cannibal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 720.0, Y = 1080.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'TutorialCannibal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.150000006, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 9.0, Y = 11.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.150000006, Y = 0.119999997}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.200000003, Y = 0.174999997}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 8.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.5, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.800000012, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.25, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.800000012, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BuffInterval', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreakBuffDamageThreshold', 
                                              StatRange = {X = 472.5, Y = 708.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 900.0, Y = 1350.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 675.0, Y = 1012.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 7.5, Y = 7.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.286000013, Y = 0.286000013}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Marauder'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardDuration', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardSpeedMod', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RoarChance', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AngryDuration', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AngrySpeedMod', 
                                              StatRange = {X = 1.29999995, Y = 1.29999995}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardDamageResetDuration', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardHealthPctThreshold', 
                                              StatRange = {X = 0.0500000007, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 5000.0, Y = 7500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 590.0, Y = 590.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 1000.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1200.0, Y = 1200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.649999976, Y = 0.649999976}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Brute'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 9600.0, Y = 14400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 800.0, Y = 800.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 1100.0, Y = 1100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1400.0, Y = 1400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'HARVESTER'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 10.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 412.5, Y = 618.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 60.0, Y = 60.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 75.0, Y = 75.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.850000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Husk'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'TutorialHusk'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'SackDamageHealthPct', 
                                              StatRange = {X = 0.0900000036, Y = 0.0599999987}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackBurstDamage', 
                                              StatRange = {X = 400.0, Y = 500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackBurstRadius', 
                                              StatRange = {X = 275.0, Y = 275.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackHealth', 
                                              StatRange = {X = 0.300000012, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AimDelay', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeLow', 
                                              StatRange = {X = 1.25, Y = 1.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeHigh', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NumSwarmersToSpawn', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NumSwarmersInSack', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxSwarmers', 
                                              StatRange = {X = 9.0, Y = 9.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SwarmerSpawnIntervalRangeLow', 
                                              StatRange = {X = 10.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SwarmerSpawnIntervalRangeHigh', 
                                              StatRange = {X = 20.0, Y = 16.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 3600.0, Y = 5400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 590.0, Y = 590.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 1000.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1200.0, Y = 1200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Swarmer_MaxHealth', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Ravager'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 4.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldFrequency', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDuration', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'LongRangeBlastInterval', 
                                              StatRange = {X = 6.0, Y = 4.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BlastInterval', 
                                              StatRange = {X = 2.0, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AggressiveDuration', 
                                              StatRange = {X = 24.0, Y = 28.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AOEBlastInterval', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TeleportInterval', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxTeleports', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageThreshold', 
                                              StatRange = {X = 2500.0, Y = 3000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBreachDamageThreshold', 
                                              StatRange = {X = 6000.0, Y = 6000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageResetDuration', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ChargedIntervalLow', 
                                              StatRange = {X = 20.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ChargedIntervalHigh', 
                                              StatRange = {X = 25.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxChargedBanshees', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 7500.0, Y = 11250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBarriers', 
                                              StatRange = {X = 4500.0, Y = 6750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.0850000009, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 590.0, Y = 590.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 1000.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1200.0, Y = 1200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.349999994, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Banshee'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.150000006, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 9.0, Y = 11.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.150000006, Y = 0.119999997}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.200000003, Y = 0.174999997}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 8.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.5, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.699999988, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.400000006, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.25, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 750.0, Y = 1125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.850000024, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 10.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.400000006, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.550000012, Y = 0.449999988}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 8.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.5, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.800000012, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.200000003, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.800000012, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 600.0, Y = 900.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 600.0, Y = 900.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 7.5, Y = 7.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.286000013, Y = 0.286000013}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethRocketTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 4.5, Y = 4.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CloakSpeedMod', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HunterAimDelay', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HunterRecloakDelay', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.0500000007, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.150000006, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 8.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.5, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.800000012, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 750.0, Y = 1125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 675.0, Y = 1012.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 7.5, Y = 7.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.286000013, Y = 0.286000013}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.649999976, Y = 0.649999976}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethHunter'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.0500000007, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.150000006, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 8.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.400000006, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TankHealth', 
                                              StatRange = {X = 525.0, Y = 787.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1050.0, Y = 1575.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 750.0, Y = 1125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 7.5, Y = 7.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.286000013, Y = 0.286000013}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.649999976, Y = 0.649999976}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethPyro'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 1.5, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TurretSpawnInterval', 
                                              StatRange = {X = 7.5, Y = 7.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DroneSpawnInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeLow', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeHigh', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MoveFireDelayTimeLow', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MoveFireDelayTimeHigh', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 7500.0, Y = 11250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 5250.0, Y = 7875.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.0850000009, Y = 0.850000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 390.0, Y = 390.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 700.0, Y = 700.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1200.0, Y = 1200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.349999994, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDrone_MaxHealth', 
                                              StatRange = {X = 350.0, Y = 450.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Turret_MaxHealth', 
                                              StatRange = {X = 325.0, Y = 400.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethPrime'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'AggressiveFrequency', 
                                              StatRange = {X = 15.5, Y = 15.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1600.0, Y = 2400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 7500.0, Y = 11250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'KnockbackFrequency', 
                                              StatRange = {X = 7.19999981, Y = 7.19999981}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RollFrequency', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DamageThreshold', 
                                              StatRange = {X = 350.0, Y = 450.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerSlashInterval', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachFrequency', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageResetDuration', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageThreshold', 
                                              StatRange = {X = 1750.0, Y = 2000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'KaiLeng'
                            }
                           )
    Level5DifficultyData = ({
                             CategoryData = ({
                                              StatName = 'OutAIDamageScale', 
                                              StatRange = {X = 1.25, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'OutHenchDamageScale', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HenchDamageTaken', 
                                              StatRange = {X = -0.75, Y = -0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AmmoDropPct', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AmmoPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadesPerDrop', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIEnergyShieldGatePct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIArmorDamageReduction', 
                                              StatRange = {X = 50.0, Y = 50.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenDelayFromDestroyed', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldRegenDelayFromPartial', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveHealthReturn', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'StoppingPowerScalar', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CoverDamageReduction', 
                                              StatRange = {X = 0.899999976, Y = 0.899999976}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GlobalEnemyGrenadeCooldown', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NoCoverDamageBonus', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveDamageReductionLength', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ReviveDamageReductionAmount', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerShieldGateDuration', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PlayerHealthGateDuration', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Global'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MedigelHealAmount', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'XPForExcessMedigel', 
                                              StatRange = {X = 150.0, Y = 150.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_ShieldStrength', 
                                              StatRange = {X = 400.0, Y = 400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_RegenStrength', 
                                              StatRange = {X = 25.0, Y = 25.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Pylon_PlaceableRegenStrength', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_KineticBarrier_Health', 
                                              StatRange = {X = 1000.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Cerberus_Generator_BlastDamage', 
                                              StatRange = {X = 500.0, Y = 500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_RachniiEgg_RottenBlastDamage', 
                                              StatRange = {X = 500.0, Y = 500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_IndoctrinationDevice_ShieldStrength', 
                                              StatRange = {X = 400.0, Y = 400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_IndoctrinationDevice_BeamCooldown', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Reaper_GethTripMine_ZapDamage', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'SPGlobal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.150000006, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 11.0, Y = 13.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.200000003, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.300000012, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.800000012, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.5, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.150000006, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1125.0, Y = 1687.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 125.0, Y = 125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 7.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'AssaultTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.100000001, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 11.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.0700000003, Y = 0.0299999993}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.119999997, Y = 0.0700000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 6.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 3.0, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.899999976, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.100000001, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CoverMoveSmokeChance', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankedSmokeChance', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SmokeFrequency', 
                                              StatRange = {X = 5.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1125.0, Y = 1687.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1125.0, Y = 1687.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 6.5, Y = 6.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.349999994, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 250.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Centurion'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.0500000007, Y = 0.0250000004}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 12.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.150000006, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.25, Y = 0.150000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 4.0, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 3.0, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.899999976, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.150000006, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RepairPct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DeployBreachThreshold', 
                                              StatRange = {X = 1012.5, Y = 1518.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1125.0, Y = 1687.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1125.0, Y = 1687.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 6.5, Y = 6.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.349999994, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 160.0, Y = 160.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 250.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Gunner'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1350.0, Y = 2025.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1350.0, Y = 2025.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.330000013, Y = 0.330000013}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 240.0, Y = 240.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 500.0, Y = 500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GunnerTurret'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.150000006, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 11.0, Y = 13.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.200000003, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.300000012, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 6.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 3.0, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.800000012, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.5, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.150000006, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachFrequency', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldResetDuration', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDamageBreachThreshold', 
                                              StatRange = {X = 1200.0, Y = 1500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldBashInterval', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1125.0, Y = 1687.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 250.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Guardian'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.0500000007, Y = 0.00999999978}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.200000003, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.300000012, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 5.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 3.0, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.899999976, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NemesisAimDelay', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AimTrackingDuration', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 675.0, Y = 1012.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1125.0, Y = 1687.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 6.5, Y = 6.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.349999994, Y = 0.349999994}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 125.0, Y = 125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Nemesis'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 1.5, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SmokeInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RocketInterval', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BlockInterval', 
                                              StatRange = {X = 12.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CockpitDamageResetDuration', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CockpitBlockThreshold', 
                                              StatRange = {X = 1350.0, Y = 2025.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ArmourPieceHealth', 
                                              StatRange = {X = 562.5, Y = 843.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GlassCockpitHealth', 
                                              StatRange = {X = 4500.0, Y = 6750.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 11250.0, Y = 16875.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 11250.0, Y = 16875.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 700.0, Y = 700.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 1200.0, Y = 1200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1500.0, Y = 1500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Atlas'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.0500000007, Y = 0.00999999978}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.0199999996, Y = 0.00999999978}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.0299999993, Y = 0.0199999996}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 2.0, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamageScalePct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDamageScalePct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CloakHealthPct', 
                                              StatRange = {X = 0.800000012, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'VortexDamageWindow', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'VortexFrequency', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldFrequency', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AggressiveFrequency', 
                                              StatRange = {X = 5.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1125.0, Y = 1687.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBarriers', 
                                              StatRange = {X = 1575.0, Y = 2362.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 6.5, Y = 6.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.25, Y = 0.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 440.0, Y = 440.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 700.0, Y = 700.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1000.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Phantom'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.150000006, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 11.0, Y = 13.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.150000006, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 0.800000012, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelConsumeHealthPct', 
                                              StatRange = {X = 0.400000006, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ConsumeHealPct', 
                                              StatRange = {X = 0.200000003, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PoweredHealPct', 
                                              StatRange = {X = 0.0700000003, Y = 0.0700000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1350.0, Y = 2025.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 250.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GrenadeInterval', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Cannibal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1080.0, Y = 1200.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'TutorialCannibal'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.100000001, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 11.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.0700000003, Y = 0.0299999993}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.119999997, Y = 0.0700000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 6.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 3.0, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.100000001, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.899999976, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BuffInterval', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreakBuffDamageThreshold', 
                                              StatRange = {X = 708.75, Y = 1063.125}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1350.0, Y = 2025.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1012.5, Y = 1518.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 6.5, Y = 6.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.330000013, Y = 0.330000013}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 390.0, Y = 390.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Marauder'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardDuration', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardSpeedMod', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RoarChance', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AngryDuration', 
                                              StatRange = {X = 7.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AngrySpeedMod', 
                                              StatRange = {X = 1.39999998, Y = 1.39999998}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardDamageResetDuration', 
                                              StatRange = {X = 3.5, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'GuardHealthPctThreshold', 
                                              StatRange = {X = 0.0250000004, Y = 0.0250000004}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 6000.0, Y = 9000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 1000.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 1200.0, Y = 1200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1500.0, Y = 1500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Brute'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 12000.0, Y = 18000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 1100.0, Y = 1100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 1400.0, Y = 1400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1900.0, Y = 1900.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'HARVESTER'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 3.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 618.75, Y = 928.125}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 75.0, Y = 75.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 90.0, Y = 90.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Husk'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 100.0, Y = 100.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'TutorialHusk'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'SackDamageHealthPct', 
                                              StatRange = {X = 0.075000003, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackBurstDamage', 
                                              StatRange = {X = 750.0, Y = 900.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackBurstRadius', 
                                              StatRange = {X = 300.0, Y = 300.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SackHealth', 
                                              StatRange = {X = 0.349999994, Y = 0.400000006}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AimDelay', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeLow', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeHigh', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NumSwarmersToSpawn', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'NumSwarmersInSack', 
                                              StatRange = {X = 3.0, Y = 3.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxSwarmers', 
                                              StatRange = {X = 9.0, Y = 9.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SwarmerSpawnIntervalRangeLow', 
                                              StatRange = {X = 8.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SwarmerSpawnIntervalRangeHigh', 
                                              StatRange = {X = 16.0, Y = 12.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 5400.0, Y = 8100.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 1000.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 1200.0, Y = 1200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1500.0, Y = 1500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Swarmer_MaxHealth', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Ravager'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldFrequency', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDuration', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'LongRangeBlastInterval', 
                                              StatRange = {X = 6.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BlastInterval', 
                                              StatRange = {X = 2.0, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AggressiveDuration', 
                                              StatRange = {X = 32.0, Y = 36.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AOEBlastInterval', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TeleportInterval', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxTeleports', 
                                              StatRange = {X = 6.0, Y = 6.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncKillChance', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageThreshold', 
                                              StatRange = {X = 3000.0, Y = 3500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBreachDamageThreshold', 
                                              StatRange = {X = 7000.0, Y = 7000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageResetDuration', 
                                              StatRange = {X = 3.5, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ChargedIntervalLow', 
                                              StatRange = {X = 15.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ChargedIntervalHigh', 
                                              StatRange = {X = 20.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxChargedBanshees', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 11250.0, Y = 16875.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxBarriers', 
                                              StatRange = {X = 6750.0, Y = 10125.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 1000.0, Y = 1000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 1200.0, Y = 1200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1500.0, Y = 1500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'Banshee'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.100000001, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 11.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.0700000003, Y = 0.0299999993}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.119999997, Y = 0.0700000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 6.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 3.0, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.5, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.100000001, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1125.0, Y = 1687.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 250.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.75, Y = 0.75}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 2.0, Y = 2.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CancelFirePct', 
                                              StatRange = {X = 0.0500000007, Y = 0.00999999978}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxFireWaitTime', 
                                              StatRange = {X = 20.0, Y = 20.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.200000003, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.300000012, Y = 0.200000003}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 5.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 3.0, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PartialLeanPct', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FlankReactionTime', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.899999976, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 900.0, Y = 1350.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 900.0, Y = 1350.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 6.5, Y = 6.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.330000013, Y = 0.330000013}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 200.0, Y = 200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 250.0, Y = 250.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethRocketTrooper'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 4.0, Y = 4.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'CloakSpeedMod', 
                                              StatRange = {X = 0.800000012, Y = 0.800000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HunterAimDelay', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HunterRecloakDelay', 
                                              StatRange = {X = 0.0, Y = 0.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.0250000004, Y = 0.0250000004}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.0500000007, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 6.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 3.0, Y = 3.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.899999976, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1125.0, Y = 1687.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1012.5, Y = 1518.75}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 6.5, Y = 6.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.330000013, Y = 0.330000013}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 390.0, Y = 390.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethHunter'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'EvadeDamagePctLow', 
                                              StatRange = {X = 0.0250000004, Y = 0.0250000004}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeDamagePctHigh', 
                                              StatRange = {X = 0.0500000007, Y = 0.0500000007}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeFrequency', 
                                              StatRange = {X = 6.0, Y = 5.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'EvadeResetDuration', 
                                              StatRange = {X = 2.0, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerEvadeChance', 
                                              StatRange = {X = 0.5, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TankHealth', 
                                              StatRange = {X = 787.5, Y = 1181.25}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1575.0, Y = 2362.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 1125.0, Y = 1687.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.600000024, Y = 0.600000024}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 6.5, Y = 6.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.330000013, Y = 0.330000013}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 290.0, Y = 290.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 390.0, Y = 390.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethPyro'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 1.5, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'TurretSpawnInterval', 
                                              StatRange = {X = 7.0, Y = 7.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DroneSpawnInterval', 
                                              StatRange = {X = 9.0, Y = 9.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeLow', 
                                              StatRange = {X = 1.5, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'FireDelayTimeHigh', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MoveFireDelayTimeLow', 
                                              StatRange = {X = 1.5, Y = 1.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MoveFireDelayTimeHigh', 
                                              StatRange = {X = 2.5, Y = 2.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 11250.0, Y = 16875.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 7875.0, Y = 11812.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxEnemyShieldRecharge', 
                                              StatRange = {X = 0.5, Y = 0.5}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenDelay', 
                                              StatRange = {X = 8.0, Y = 8.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'AIShieldRegenPct', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Standard', 
                                              StatRange = {X = 700.0, Y = 700.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Stagger', 
                                              StatRange = {X = 1200.0, Y = 1200.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerThreshold_Knockback', 
                                              StatRange = {X = 1500.0, Y = 1500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'ShieldDrone_MaxHealth', 
                                              StatRange = {X = 400.0, Y = 500.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'Turret_MaxHealth', 
                                              StatRange = {X = 350.0, Y = 450.0}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'GethPrime'
                            }, 
                            {
                             CategoryData = ({
                                              StatName = 'AggressiveFrequency', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxHealth', 
                                              StatRange = {X = 1600.0, Y = 2400.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MaxShields', 
                                              StatRange = {X = 11250.0, Y = 16875.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'MeleeAttackInterval', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'SyncMeleeAttackInterval', 
                                              StatRange = {X = 0.100000001, Y = 0.100000001}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'KnockbackFrequency', 
                                              StatRange = {X = 7.19999981, Y = 7.19999981}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'RollFrequency', 
                                              StatRange = {X = 1.0, Y = 1.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'DamageThreshold', 
                                              StatRange = {X = 350.0, Y = 450.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'PowerSlashInterval', 
                                              StatRange = {X = 15.0, Y = 15.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachFrequency', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageResetDuration', 
                                              StatRange = {X = 10.0, Y = 10.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'BreachDamageThreshold', 
                                              StatRange = {X = 1750.0, Y = 2000.0}, 
                                              bStatActive = TRUE
                                             }, 
                                             {
                                              StatName = 'HitReactionChanceMultiplier', 
                                              StatRange = {X = 0.300000012, Y = 0.300000012}, 
                                              bStatActive = TRUE
                                             }
                                            ), 
                             Category = 'KaiLeng'
                            }
                           )
    MaxPlayerLevel = 60
    bNeedsUpdate = TRUE
    NormalizedDifficulty = EDifficultyOptions.DO_Level3
}