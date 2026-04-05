Class BioSeqAct_SetLookAtTarget extends SequenceAction;

var array<Actor> Actors;
var Actor LookAtTarget;

public function Activated()
{
    local Actor pActor;
    local SFXModule_LookAt pLookAtMod;
    
    if (Actors.Length == 0)
    {
        return;
    }
    foreach Actors(pActor, )
    {
        if (Controller(pActor) != None)
        {
            pActor = Controller(pActor).Pawn;
        }
        if (pActor != None)
        {
            pLookAtMod = pActor.GetModule(Class'SFXModule_LookAt');
            if (pLookAtMod != None)
            {
                pLookAtMod.ChangeTarget(LookAtTarget);
            }
        }
    }
}
public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 3;
}
public event function PreVersionUpdated(int OldVersion, int NewVersion)
{
    if (VariableLinks.Length > 0 && VariableLinks[0].LinkDesc == "Pawn")
    {
        VariableLinks[0].LinkDesc = "Actor";
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Actor", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Actors', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Look At Target", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'LookAtTarget', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}