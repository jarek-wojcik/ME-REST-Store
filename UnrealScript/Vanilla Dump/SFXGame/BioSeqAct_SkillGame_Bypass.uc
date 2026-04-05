Class BioSeqAct_SkillGame_Bypass extends BioSeqAct_SkillGame_Base
    native;

var(BioSeqAct_SkillGame_Bypass) int m_nNumToSpawn;
var(BioSeqAct_SkillGame_Bypass) int m_nPCBurnDown;
var(BioSeqAct_SkillGame_Bypass) int m_nConsoleBurnDown;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 6;
}
public native function OnFailure();

public native function OnSuccess(int nRemainingResources);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_nNumToSpawn = 4
    m_nPCBurnDown = 1250
    m_nConsoleBurnDown = 3000
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Remaining Resources", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Percent Remaining", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Reward on Fail", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'm_bRewardOnTimeFail', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Phase1 Time", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nStartingResource', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Phase2 Time", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nPhase2Time', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Phase2 Resource", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nPhase2Resource', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Num To Activate", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nNumToSpawn', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "PC BurnDown", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nPCBurnDown', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Console BurnDown", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'm_nConsoleBurnDown', 
                      MinVars = 1, 
                      MaxVars = 1, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}