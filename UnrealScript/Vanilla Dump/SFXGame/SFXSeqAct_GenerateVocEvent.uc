Class SFXSeqAct_GenerateVocEvent extends SequenceAction;

var(SFXSeqAct_GenerateVocEvent) Actor oInstigator;
var(SFXSeqAct_GenerateVocEvent) BioPawn oRecipient;
var(SFXSeqAct_GenerateVocEvent) float fDelay;
var(SFXSeqAct_GenerateVocEvent) float fChanceToPlayMod;
var(SFXSeqAct_GenerateVocEvent) ESFXVocalizationEventID oEventID;

public function Activated()
{
    local BioPawn oPawnInstigator;
    local BioPawn oPawnRecipient;
    
    oPawnInstigator = GetBioPawn(oInstigator);
    if (oPawnInstigator != None)
    {
        oPawnRecipient = GetBioPawn(oRecipient);
        SFXGRI(oInstigator.WorldInfo.GRI).TriggerVocalizationEvent(oEventID, oPawnInstigator, oPawnRecipient, fDelay, fChanceToPlayMod);
    }
}
public function BioPawn GetBioPawn(Actor oTarget)
{
    if (oTarget != None)
    {
        if (BioPawn(oTarget) != None)
        {
            return BioPawn(oTarget);
        }
        else if (Controller(oTarget) != None)
        {
            return BioPawn(Controller(oTarget).Pawn);
        }
    }
    return None;
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    fChanceToPlayMod = 1.0
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Instigator", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'oInstigator', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Recipient", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'oRecipient', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Delay", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fDelay', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "ChanceToPlayMod", 
                      ExpectedType = Class'SeqVar_Float', 
                      LinkVar = 'None', 
                      PropertyName = 'fChanceToPlayMod', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}