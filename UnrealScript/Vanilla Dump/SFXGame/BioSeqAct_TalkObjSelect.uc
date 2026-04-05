Class BioSeqAct_TalkObjSelect extends SequenceAction;

const NUM_HENCH = 12;

var(BioSeqAct_TalkObjSelect) float f00_Vixen;
var(BioSeqAct_TalkObjSelect) float f01_Leading;
var(BioSeqAct_TalkObjSelect) float f02_Convict;
var(BioSeqAct_TalkObjSelect) float f03_Geth;
var(BioSeqAct_TalkObjSelect) float f04_Thief;
var(BioSeqAct_TalkObjSelect) float f05_Garrus;
var(BioSeqAct_TalkObjSelect) float f06_Assassin;
var(BioSeqAct_TalkObjSelect) float f07_Tali;
var(BioSeqAct_TalkObjSelect) float f08_Professor;
var(BioSeqAct_TalkObjSelect) float f09_Grunt;
var(BioSeqAct_TalkObjSelect) float f10_Mystic;
var(BioSeqAct_TalkObjSelect) float f11_Veteran;
var(BioSeqAct_TalkObjSelect) Actor oPlayer;
var(BioSeqAct_TalkObjSelect) int nHench1;
var(BioSeqAct_TalkObjSelect) int nHench2;

public event function Activated()
{
    local float fPriority[12];
    local int nSwap;
    local int nSquadID1;
    local int nSquadID2;
    local Pawn oPlayerPawn;
    local BioBaseSquad oSquad;
    local float fHench1Prio;
    local float fHench2Prio;
    
    fPriority[0] = f00_Vixen;
    fPriority[1] = f01_Leading;
    fPriority[2] = f02_Convict;
    fPriority[3] = f03_Geth;
    fPriority[4] = f04_Thief;
    fPriority[5] = f05_Garrus;
    fPriority[6] = f06_Assassin;
    fPriority[7] = f07_Tali;
    fPriority[8] = f08_Professor;
    fPriority[9] = f09_Grunt;
    fPriority[10] = f10_Mystic;
    fPriority[11] = f11_Veteran;
    nHench1 = -1;
    nHench2 = -1;
    OutputLinks[0].bHasImpulse = TRUE;
    if (oPlayer == None)
    {
        return;
    }
    oPlayerPawn = Pawn(oPlayer);
    if (oPlayerPawn == None)
    {
        oPlayerPawn = PlayerController(oPlayer).Pawn;
    }
    oSquad = BioPawn(oPlayerPawn).Squad;
    if (oSquad == None)
    {
        return;
    }
    if (oSquad.Members.Length != 3)
    {
    }
    nSquadID1 = GetHenchID(oSquad.Members[1].Tag);
    nSquadID2 = GetHenchID(oSquad.Members[2].Tag);
    fHench1Prio = fPriority[nSquadID1];
    fHench2Prio = fPriority[nSquadID2];
    if (fHench1Prio > 0.0)
    {
        nHench1 = nSquadID1;
    }
    if (fHench2Prio > 0.0)
    {
        nHench2 = nSquadID2;
    }
    if (fHench1Prio > fHench2Prio)
    {
        nSwap = nHench1;
        nHench1 = nHench2;
        nHench2 = nSwap;
    }
    if (nHench1 == -1)
    {
        nHench1 = nHench2;
        nHench2 = -1;
    }
}
public function int GetHenchID(Name Tag)
{
    local int Id;
    
    Id = -1;
    switch (Tag)
    {
        case 'hench_vixen':
            Id = 0;
            break;
        case 'hench_leading':
            Id = 1;
            break;
        case 'hench_convict':
            Id = 2;
            break;
        case 'hench_geth':
            Id = 3;
            break;
        case 'hench_thief':
            Id = 4;
            break;
        case 'hench_garrus':
            Id = 5;
            break;
        case 'hench_assassin':
            Id = 6;
            break;
        case 'hench_tali':
            Id = 7;
            break;
        case 'hench_professor':
            Id = 8;
            break;
        case 'hench_grunt':
            Id = 9;
            break;
        case 'hench_mystic':
            Id = 10;
            break;
        case 'hench_veteran':
            Id = 11;
            break;
        default:
    }
    return Id;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "VX", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fPriority0', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "LM", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fPriority1', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "CV", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fPriority2', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "GT", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fPriority3', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "MT", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fPriority4', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "GR", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fPriority5', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "AS", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fPriority6', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "TL", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fPriority7', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "PR", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fPriority8', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "KG", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fPriority9', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "MW", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fPriority10', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "VT", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fPriority11', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Player", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'oPlayer', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Hench1", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'nHench1', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Hench2", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'nHench2', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
    bManualHandleOutputs = TRUE
}