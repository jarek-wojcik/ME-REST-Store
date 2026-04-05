Class SeqAct_AIMoveToActor extends SeqAct_Latent
    native;

var(SeqAct_AIMoveToActor) array<Actor> Destination;
var(SeqAct_AIMoveToActor) float MovementSpeedModifier;
var(SeqAct_AIMoveToActor) Actor LookAt;
var transient int LastDestinationChoice;
var(SeqAct_AIMoveToActor) bool bInterruptable;
var(SeqAct_AIMoveToActor) bool bPickClosest;

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 2;
}
public function Actor PickDestination(Actor Requestor)
{
    local float Dist;
    local float bestDist;
    local Actor Dest;
    local Actor BestDest;
    
    if (bPickClosest)
    {
        foreach Destination(Dest, )
        {
            Dist = VSize(Dest.location - Requestor.location);
            if (BestDest == None || Dist < bestDist)
            {
                BestDest = Dest;
                bestDist = Dist;
            }
        }
        return BestDest;
    }
    else
    {
        if (LastDestinationChoice < 0 || LastDestinationChoice >= Destination.Length)
        {
            LastDestinationChoice = 0;
        }
        return Destination[LastDestinationChoice++];
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MovementSpeedModifier = 1.0
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Finished", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Aborted", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Out", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
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
                      LinkDesc = "Destination", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'Destination', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Look At", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'LookAt', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = FALSE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}