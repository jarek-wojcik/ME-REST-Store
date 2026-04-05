Class SFXSeqAct_SetTreasure extends SequenceAction;

var(SFXSeqAct_SetTreasure) int ResourcePercent;
var(SFXSeqAct_SetTreasure) bool bTargetable;
var(SFXSeqAct_SetTreasure) bool bOverrideResource;
var(SFXSeqAct_SetTreasure) bool bTreasureTypeOverride;
var(SFXSeqAct_SetTreasure) ETreasureType TreasureType;

public function Activated()
{
    local Object ChkObject;
    local Actor ChkActor;
    local SFXTreasureUseModule TreasureMod;
    
    foreach Targets(ChkObject, )
    {
        ChkActor = Actor(ChkObject);
        if (ChkActor != None)
        {
            TreasureMod = ChkActor.GetModule(Class'SFXTreasureUseModule');
            if (TreasureMod != None)
            {
                TreasureMod.m_bTargetable = bTargetable;
            }
            if (bOverrideResource && TreasureMod.ResourcePercent > 0)
            {
                TreasureMod.ResourcePercent = ResourcePercent;
            }
            if (bTreasureTypeOverride)
            {
                TreasureMod.TreasureType = TreasureType;
            }
        }
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 4;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bCallHandler = FALSE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Targets', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Targetable", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bTargetable', 
                      MinVars = 0, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Resource Percent", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'ResourcePercent', 
                      MinVars = 0, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Resource Percent Override", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bOverrideResource', 
                      MinVars = 0, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}