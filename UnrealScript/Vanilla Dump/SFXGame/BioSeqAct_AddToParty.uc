Class BioSeqAct_AddToParty extends SequenceAction;

var(BioSeqAct_AddToParty) float TeleportOffsetRear;
var(BioSeqAct_AddToParty) float TeleportOffsetSide;
var(BioSeqAct_AddToParty) bool TeleportToLeader;

public function Activated()
{
    local array<Object> aLeaderObjects;
    local array<Object> aFollowerObjects;
    local SFXPawn_Player leader;
    local BioPawn follower;
    local BioBaseSquad oSquad;
    local int i;
    local int J;
    local Vector TargetLocation;
    local Vector vCross;
    local Vector vTeleportLocation;
    local bool bIsPlayerSquad;
    local SFXPawn_Henchman Henchman;
    local SFXAI_Henchman oHenchAI;
    
    bIsPlayerSquad = FALSE;
    GetObjectVars(aLeaderObjects, "Leader");
    GetObjectVars(aFollowerObjects, "Follower");
    for (i = 0; i < aFollowerObjects.Length; ++i)
    {
        if (BioPlayerController(Pawn(aFollowerObjects[i]).Controller) != None)
        {
            OutputLinks[0].bHasImpulse = FALSE;
            OutputLinks[1].bHasImpulse = TRUE;
            return;
        }
    }
    for (i = 0; i < aLeaderObjects.Length; i++)
    {
        if (BioPlayerController(aLeaderObjects[i]) != None)
        {
            leader = SFXPawn_Player(BioPlayerController(aLeaderObjects[i]).Pawn);
            bIsPlayerSquad = TRUE;
        }
        else
        {
            leader = SFXPawn_Player(aLeaderObjects[i]);
        }
        oSquad = None;
        if (leader != None)
        {
            oSquad = leader.Squad;
        }
        if (oSquad == None)
        {
            oSquad = BioBaseSquad(aLeaderObjects[i]);
        }
        if (oSquad == None)
        {
            continue;
        }
        for (J = 0; J < aFollowerObjects.Length; J++)
        {
            follower = BioPawn(aFollowerObjects[J]);
            if (follower == None || BioAiController(follower.Controller) == None || oSquad.Members.Find(follower) != -1)
            {
                continue;
            }
            if (TeleportToLeader)
            {
                TargetLocation = leader.location - Vector(leader.Rotation) * TeleportOffsetRear;
                vCross = Vector(leader.Rotation) Cross vect(0.0, 0.0, 1.0);
                if (oSquad.Members.Length < 2)
                {
                    TargetLocation -= vCross * TeleportOffsetSide;
                }
                else
                {
                    TargetLocation += vCross * TeleportOffsetSide;
                }
                oHenchAI = SFXAI_Henchman(follower.Controller);
                if (bIsPlayerSquad && oHenchAI != None)
                {
                    if (oHenchAI.FindNearestOpenLocation(TargetLocation, vTeleportLocation, leader))
                    {
                        follower.SafeSetLocation(vTeleportLocation);
                    }
                    else
                    {
                        TargetLocation = leader.location + Vector(leader.Rotation * TeleportOffsetRear);
                        if (oHenchAI.FindNearestOpenLocation(TargetLocation, vTeleportLocation, leader))
                        {
                            follower.SafeSetLocation(vTeleportLocation);
                        }
                    }
                }
                else
                {
                    follower.SetLocation(TargetLocation, );
                }
            }
            oSquad.AddMember(follower);
            Henchman = SFXPawn_Henchman(follower);
            if (bIsPlayerSquad && Henchman != None)
            {
                Henchman.InitializeHenchman(leader.CharacterLevel);
            }
        }
        break;
    }
    OutputLinks[0].bHasImpulse = TRUE;
    OutputLinks[1].bHasImpulse = FALSE;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 3;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TeleportOffsetRear = 60.0
    TeleportOffsetSide = 60.0
    bCallHandler = FALSE
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Out", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Player Controller", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Leader", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'm_oSquadObject', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Follower", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
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