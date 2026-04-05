Class BioSeqAct_GiveMissionXP_NativeBase extends SequenceAction
    native
    abstract;

struct MissionReward 
{
    var config Name MissionName;
    var config int ObjectiveXP;
    var config int CombatXP;
};

var(BioSeqAct_GiveMissionXP_NativeBase) Name CombatToken;
var(BioSeqAct_GiveMissionXP_NativeBase) float RewardAmount;
var(BioSeqAct_GiveMissionXP_NativeBase) stringref ObjectiveStringRef;
var(BioSeqAct_GiveMissionXP_NativeBase) bool bSkipNotifications;
var(BioSeqAct_GiveMissionXP_NativeBase) bool bCombatExperience;

public function Activated()
{
    local BioWorldInfo World;
    local SFXGame Game;
    local BioPlayerController PC;
    local SFXPawn_Player Player;
    local BioGlobalVariableTable VarTable;
    local TD LevelTreasure;
    local SFXInventoryManager Inventory;
    local SFXEngine Eng;
    local string MissionName;
    
    World = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    Game = SFXGame(World.Game);
    PC = World.GetLocalPlayerController();
    Player = SFXPawn_Player(PC.Pawn);
    VarTable = World.GetGlobalVariables();
    Eng = SFXEngine(Class'Engine'.static.GetEngine());
    Inventory = SFXInventoryManager(PC.Pawn.InvManager);
    if (World == None || Game == None || PC == None || Player == None || VarTable == None || Inventory == None || Eng == None)
    {
        OutputLinks[1].bHasImpulse = TRUE;
        return;
    }
    MissionName = World.GetMapName();
    RewardAmount = FClamp(RewardAmount, 0.0, 1.0);
    foreach Game.TREASURE.LevelTreasure(LevelTreasure, )
    {
        if (Locs(LevelTreasure.Level) == Locs(MissionName))
        {
            if (Game.AwardXP(int(float(LevelTreasure.XP) * RewardAmount), LevelTreasure.Level) == TRUE)
            {
                OutputLinks[0].bHasImpulse = TRUE;
            }
            else
            {
                OutputLinks[1].bHasImpulse = TRUE;
            }
            return;
        }
    }
    OutputLinks[1].bHasImpulse = TRUE;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 5;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CombatToken = '_combat'
    bCallHandler = FALSE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Success", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Failed", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Is Combat Experience", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bCombatExperience', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Reward Amount (0 - 1)", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'RewardAmount', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}