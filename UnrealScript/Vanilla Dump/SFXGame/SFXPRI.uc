Class SFXPRI extends SFXPRI_NativeBase
    config(Game);

struct ScoreInfo 
{
    var float Score;
    var float Credits;
    var byte Trigger;
};
const MAX_CONSUMABLES_PER_MATCH = 4;
struct ScoreEvent 
{
    var string Text;
    var float ExpiryTime;
};

var transient array<ScoreEvent> ScoreLog;
var transient DamageCalculationAlgorithm LastWeaponDamage;
var transient DamageCalculationAlgorithm LastPowerDamage;
var repnotify ActiveMatchConsumable ActiveMatchConsumables[4];
var transient repnotify ScoreInfo ReplicatedScoreInfo;
var privatewrite int TotalPointsAtStartOfWave;
var protectedwrite float PointsEarned;
var protectedwrite float CreditsEarned;
var config float ScoreReplicationPeriod;

public simulated function PostBeginPlay()
{
    Super(PlayerReplicationInfo).PostBeginPlay();
    if (Role == ENetRole.ROLE_Authority && !bBot)
    {
        SetTimer(ScoreReplicationPeriod, TRUE, 'ReplicateScoreInfo', );
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'ReplicatedScoreInfo')
    {
        ReplicatedScoreUpdated();
    }
    else if (VarName == 'ActiveMatchConsumables')
    {
        OnCharacterChanged();
    }
    else
    {
        Super(PlayerReplicationInfo).ReplicatedEvent(VarName);
    }
}
public function Tick(float DeltaTime)
{
    local int idx;
    
    for (idx = ScoreLog.Length - 1; idx >= 0; idx--)
    {
        if (ScoreLog[idx].ExpiryTime < WorldInfo.GameTimeSeconds)
        {
            ScoreLog.Remove(idx, 1);
        }
    }
}
public simulated function AddActiveMatchConsumable(int ClassNameID, float Value)
{
    local ActiveMatchConsumable NewActiveMatchConsumable;
    local int idx;
    
    if (ClassNameID == 0)
    {
        return;
    }
    NewActiveMatchConsumable.ClassNameID = ClassNameID;
    NewActiveMatchConsumable.Value = Value;
    for (idx = 0; idx < 4; idx++)
    {
        if (ActiveMatchConsumables[idx].ClassNameID == ClassNameID && ActiveMatchConsumables[idx].Value == Value)
        {
            return;
            continue;
        }
        if (ActiveMatchConsumables[idx].ClassNameID == 0)
        {
            ActiveMatchConsumables[idx] = NewActiveMatchConsumable;
            break;
        }
    }
}
public simulated function AddCredits(float Amount)
{
    if (Amount > float(0))
    {
        if (Role == ENetRole.ROLE_Authority)
        {
            CreditsEarned += Amount;
        }
    }
}
public function AddPlayerMedal(int Medal, optional int ReplaceMedal = -1, optional bool bDisplay = TRUE);

public simulated function AddPoints(float Amount)
{
    if (Amount > float(0))
    {
        if (Role == ENetRole.ROLE_Authority)
        {
            PointsEarned += Amount;
        }
    }
}
public simulated function bool CanSetReadyInLobby()
{
    return FALSE;
}
public static final simulated function SFXPRI FindLocalPRI()
{
    local GameReplicationInfo GRI;
    local PlayerReplicationInfo PRI;
    
    GRI = Class'Engine'.static.GetCurrentWorldInfo().GRI;
    if (GRI != None)
    {
        foreach GRI.PRIArray(PRI, )
        {
            if (SFXPRI(PRI) != None && PRI.Owner != None && PlayerController(PRI.Owner) != None && LocalPlayer(PlayerController(PRI.Owner).Player) != None)
            {
                return SFXPRI(PRI);
            }
        }
    }
    return None;
}
public simulated function bool GetActiveMatchConsumable(int ConsumableIndex, out Name ConsumableClass, out int ConsumableValue)
{
    if (ConsumableIndex < 0 || ConsumableIndex >= 4)
    {
        return FALSE;
    }
    ConsumableClass = Name(Class'SFXEngine'.static.GetStrFromSFXUniqueID(ActiveMatchConsumables[ConsumableIndex].ClassNameID));
    ConsumableValue = int(ActiveMatchConsumables[ConsumableIndex].Value);
    return TRUE;
}
public simulated function GetActiveMatchConsumables(out array<ActiveMatchConsumable> OutActiveMatchConsumables)
{
    local int i;
    
    OutActiveMatchConsumables.Length = 4;
    for (i = 0; i < 4; i++)
    {
        OutActiveMatchConsumables[i] = ActiveMatchConsumables[i];
    }
}
public simulated function float GetTotalCredits()
{
    return CreditsEarned;
}
public simulated function float GetTotalPoints()
{
    return PointsEarned;
}
public simulated function int GetWeaponLevel(Name WeaponClassPath)
{
    local SFXEngine Engine;
    local int Level;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    Level = 1;
    if (Engine != None && !bBot)
    {
        Level = Engine.GetPlayerVariable(WeaponClassPath);
    }
    return Level;
}
public function bool IsMatchConsumableActive(int UniqueConsumableID, float Value)
{
    return FALSE;
}
public simulated function bool IsReadyInLobby()
{
    return FALSE;
}
public simulated function OnCharacterChanged();

public simulated function RemoveActiveMatchConsumable(int ClassNameID, float Value)
{
    local int idx;
    
    if (ClassNameID == 0)
    {
        return;
    }
    for (idx = 0; idx < 4; idx++)
    {
        if (ActiveMatchConsumables[idx].ClassNameID == ClassNameID && ActiveMatchConsumables[idx].Value == Value)
        {
            ActiveMatchConsumables[idx].ClassNameID = 0;
            ActiveMatchConsumables[idx].Value = 0.0;
            break;
        }
    }
}
public simulated function ReplicatedScoreUpdated()
{
    PointsEarned = ReplicatedScoreInfo.Score;
    CreditsEarned = ReplicatedScoreInfo.Credits;
}
public function ReplicateScoreInfo()
{
    ReplicatedScoreInfo.Score = PointsEarned;
    ReplicatedScoreInfo.Credits = CreditsEarned;
    ReplicatedScoreInfo.Trigger++;
}
public simulated function SendTelemetryForWeapons();

public reliable server function ServerAddActiveMatchConsumable(int ClassNameID, float Value)
{
    AddActiveMatchConsumable(ClassNameID, Value);
    OnCharacterChanged();
}
public reliable server function ServerRemoveActiveMatchConsumable(int ClassNameID, float Value)
{
    RemoveActiveMatchConsumable(ClassNameID, Value);
    OnCharacterChanged();
}
public simulated function SetReadyInLobby(bool NewReadyState);

public final simulated function StoreDamageCalculation(const out DamageCalculationAlgorithm DamageCalc)
{
    if (DamageCalc.Source == EDamageCalculationSource.DamageCalcWeapon)
    {
        LastWeaponDamage = DamageCalc;
    }
    else if (DamageCalc.Source == EDamageCalculationSource.DamageCalcPower)
    {
        LastPowerDamage = DamageCalc;
    }
}
public simulated function TriggerNewScoreTag(int Amount, coerce string Message);


replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        ActiveMatchConsumables, ReplicatedScoreInfo;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScoreReplicationPeriod = 2.0
}