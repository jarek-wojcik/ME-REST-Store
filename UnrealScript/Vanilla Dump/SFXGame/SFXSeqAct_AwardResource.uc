Class SFXSeqAct_AwardResource extends SequenceAction
    native;

var int ResourcePercent;
var bool bAbsoluteAmount;
var(SFXSeqAct_AwardResource) bool bIsSalvage;
var(SFXSeqAct_AwardResource) ETreasureType TreasureType;

public function Activated()
{
    local BioWorldInfo oWorldInfo;
    local BioPlayerController PC;
    local SFXPawn_Player pPawn;
    local SFXInventoryManager InvManager;
    
    oWorldInfo = BioWorldInfo(GetWorldInfo());
    if (oWorldInfo == None)
    {
        return;
    }
    PC = BioPlayerController(oWorldInfo.GetALocalPlayerController());
    if (PC == None)
    {
        return;
    }
    pPawn = SFXPawn_Player(PC.Pawn);
    if (pPawn == None)
    {
        return;
    }
    InvManager = SFXInventoryManager(pPawn.InvManager);
    InvManager.AwardResource(TreasureType, ResourcePercent, bAbsoluteAmount, bIsSalvage);
    OutputLinks[0].bHasImpulse = TRUE;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 3;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Amount", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'ResourcePercent', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Absolute Amount", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bAbsoluteAmount', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Salvage", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bIsSalvage', 
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