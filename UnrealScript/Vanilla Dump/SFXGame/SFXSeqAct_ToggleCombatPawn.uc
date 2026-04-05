Class SFXSeqAct_ToggleCombatPawn extends SeqAct_Latent
    native;

var transient QWord frame;
var(SFXSeqAct_ToggleCombatPawn) int ForcedCasualAppearanceID;
var transient int State;
var(SFXSeqAct_ToggleCombatPawn) bool bUseCasualAppearance;
var(SFXSeqAct_ToggleCombatPawn) bool bCreateAndShowWeapons;
var(SFXSeqAct_ToggleCombatPawn) bool bShowLoadingIcon;
var transient bool bFastSwitch;
var transient bool bNewCombatPawn;
var transient bool bInjuredPawn;

private final event function bool GatherPawnParameters()
{
    local SFXEngine Engine;
    local SFXPawn TargetPawn;
    local SFXGame GameInfo;
    local BioPlayerController PC;
    local Pawn PlayerArchetype;
    local string firstName;
    local EOriginType Origin;
    local ENotorietyType Notoriety;
    local string faceCode;
    local Guid CharacterGUID;
    local bool bFastChange;
    
    bFastChange = FALSE;
    bNewCombatPawn = FALSE;
    bInjuredPawn = FALSE;
    if (InputLinks[0].bHasImpulse)
    {
        bNewCombatPawn = TRUE;
    }
    else if (InputLinks[1].bHasImpulse)
    {
        bNewCombatPawn = FALSE;
    }
    else if (InputLinks[2].bHasImpulse)
    {
        bNewCombatPawn = TRUE;
        bInjuredPawn = TRUE;
    }
    else if (InputLinks[3].bHasImpulse)
    {
        bNewCombatPawn = !bNewCombatPawn;
    }
    TargetPawn = SFXPawn(GetPawn(Actor(Targets[0])));
    PC = BioPlayerController(GetController(Actor(Targets[0])));
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine != None && Engine.CurrentSaveGame != None)
    {
        Engine.CurrentSaveGame.SavePlayer(LocalPlayer(PC.Player).ControllerId);
        Engine.CurrentSaveGame.SaveHenchmen(LocalPlayer(PC.Player).ControllerId);
    }
    if (TargetPawn != None)
    {
        GameInfo = SFXGame(TargetPawn.WorldInfo.Game);
        if (GameInfo != None)
        {
            GameInfo.GetPlayerSpawnArchetype(bNewCombatPawn, bInjuredPawn, PlayerArchetype, firstName, Origin, Notoriety, faceCode, CharacterGUID);
            if (TargetPawn.ObjectArchetype == PlayerArchetype)
            {
                bFastChange = TRUE;
            }
        }
    }
    return bFastChange;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 2;
}
private final event function TogglePawn()
{
    local SFXEngine Engine;
    local SFXPawn OldPawn;
    local Pawn NewPawn;
    local BioPlayerController PC;
    local SFXGame GameInfo;
    
    OldPawn = SFXPawn(GetPawn(Actor(Targets[0])));
    PC = BioPlayerController(GetController(Actor(Targets[0])));
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine != None && Engine.CurrentSaveGame != None)
    {
        GameInfo = SFXGame(OldPawn.WorldInfo.Game);
        if (GameInfo != None)
        {
            Engine.bPlayerNeedsLoad = TRUE;
            BioPlayerSquad(OldPawn.Squad).SetPlayerPawn(None);
            NewPawn = GameInfo.SpawnNewPlayerPawn(bNewCombatPawn, bInjuredPawn, bUseCasualAppearance, ForcedCasualAppearanceID, bCreateAndShowWeapons, PC, OldPawn.location, OldPawn.Rotation);
            if (NewPawn != None)
            {
                OldPawn.Destroy();
            }
            PC.ConsoleCommand("ce Hench_SetupSquad_NoFade");
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ForcedCasualAppearanceID = -1
    bCreateAndShowWeapons = TRUE
    bShowLoadingIcon = TRUE
    bCallHandler = FALSE
    InputLinks = ({
                   LinkDesc = "Combat", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Exploration", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Injured", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }, 
                  {
                   LinkDesc = "Toggle", 
                   LinkAction = 'None', 
                   QueuedActivations = 0, 
                   LinkedOp = None, 
                   bHasImpulse = FALSE, 
                   bDisabled = FALSE
                  }
                 )
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Out", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
}