Class SFXSeqAct_SetTargetable extends SequenceAction;

var(SFXSeqAct_SetTargetable) bool bTargetable;
var(SFXSeqAct_SetTargetable) bool bCombatTargetable;

public function Activated()
{
    local int i;
    local Actor oActor;
    
    for (i = 0; i < Targets.Length; i++)
    {
        oActor = Actor(Targets[i]);
        if (oActor.GetModule(Class'SFXSelectionModule') != None)
        {
            oActor.GetModule(Class'SFXSelectionModule').SetTargetable(bTargetable, FALSE);
            oActor.GetModule(Class'SFXSelectionModule').SetCombatTargetable(bCombatTargetable, FALSE);
        }
        if (SFXNav_LadderNode(oActor) != None)
        {
            SFXNav_LadderNode(oActor).bDisabled = !bTargetable;
        }
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
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
                      LinkDesc = "Combat Targetable", 
                      ExpectedType = Class'SeqVar_Bool', 
                      LinkVar = 'None', 
                      PropertyName = 'bCombatTargetable', 
                      MinVars = 0, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}