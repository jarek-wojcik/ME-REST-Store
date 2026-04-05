Class SFXGameEffect_AIHacking extends SFXGameEffect;

var Guid TargetCrustGuid;
var int OriginalTeam;
var BioPawn Caster;
var SFXPawn OwnerPawn;
var SFXAI_Core OwnerAI;
var RvrClientEffectInterface CE_TargetCrust;
var clearcrosslevel SFXPowerCustomAction_AIHacking Power;
var bool bExplodeOnDeath;
var bool bExploded;

public function OnRemoved()
{
    Super.OnRemoved();
    if (OwnerPawn != None && OwnerPawn.ScoreSourceOverrideSetter == Name)
    {
        OwnerPawn.ScoreSourceOverride = None;
    }
    if (OwnerAI != None)
    {
        OwnerAI.SetTeam(OriginalTeam);
        OwnerAI.SelectTarget();
    }
    if (OwnerPawn != None)
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CE_TargetCrust, TargetCrustGuid, TRUE);
    }
}
public function OnUpdate(float DeltaSeconds)
{
    Super.OnUpdate(DeltaSeconds);
    if (bExplodeOnDeath && !bExploded && Power != None && OwnerPawn != None && OwnerPawn.IsDead())
    {
        bExploded = TRUE;
        Power.OnHackedTargetDied(OwnerPawn);
    }
}
public function OnApplied()
{
    local RvrClientEffectTarget TargetInfo;
    
    Super.OnApplied();
    OwnerPawn = SFXPawn(Owner);
    if (OwnerPawn != None)
    {
        OwnerPawn.ScoreSourceOverride = SFXPawn_Player(Caster);
        OwnerPawn.ScoreSourceOverrideSetter = Name;
        OwnerAI = SFXAI_Core(OwnerPawn.Controller);
        if (OwnerAI != None)
        {
            OriginalTeam = int(OwnerAI.GetTeamNum());
            OwnerAI.SetTeam(2);
            OwnerAI.SelectTarget();
        }
        TargetInfo.Instigator = Owner;
        TargetInfo.SpawnValue.X = Duration;
        TargetCrustGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(CE_TargetCrust, TargetInfo, Owner);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}