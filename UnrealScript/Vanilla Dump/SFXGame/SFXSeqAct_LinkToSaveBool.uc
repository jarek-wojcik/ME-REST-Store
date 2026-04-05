Class SFXSeqAct_LinkToSaveBool extends SequenceAction;

var Actor oActor;
var SeqVar_Bool oTargetBool;
var SeqVar_Bool oCombatTargetBool;

public function Activated()
{
    local SFXSelectionModule SelModule;
    
    if (oActor == None)
    {
        return;
    }
    SelModule = oActor.GetModule(Class'SFXSelectionModule');
    if (VariableLinks.Length >= 2 && SeqVar_Bool(VariableLinks[1].LinkedVariables[0]) != None)
    {
        oTargetBool = SeqVar_Bool(VariableLinks[1].LinkedVariables[0]);
        SelModule.TargetSaveBool = oTargetBool;
        SelModule.SetTargetable(oTargetBool.bValue > 0);
    }
    if (VariableLinks.Length >= 3 && VariableLinks[2].LinkedVariables[0] != None)
    {
        oCombatTargetBool = SeqVar_Bool(VariableLinks[2].LinkedVariables[0]);
        SelModule.CombatTargetSaveBool = oCombatTargetBool;
        SelModule.SetCombatTargetable(oCombatTargetBool.bValue > 0);
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
                      LinkDesc = "Actor", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'oActor', 
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
                      PropertyName = 'oTargetBool', 
                      MinVars = 1, 
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
                      PropertyName = 'oCombatTargetBool', 
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