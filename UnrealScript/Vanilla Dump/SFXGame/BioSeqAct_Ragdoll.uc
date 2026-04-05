Class BioSeqAct_Ragdoll extends SequenceAction;

var(BioSeqAct_Ragdoll) Actor mActor;

public function Activated()
{
    local BioPawn oPawn;
    local Vector impulse;
    local Vector HitLocation;
    
    oPawn = BioPawn(mActor);
    oPawn.AddRagdollImpulse(impulse, oPawn.LastHitBy, HitLocation, TRUE, 'None');
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Pawn", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'mActor', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}