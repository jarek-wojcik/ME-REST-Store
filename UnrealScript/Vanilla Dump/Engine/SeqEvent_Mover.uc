Class SeqEvent_Mover extends SequenceEvent
    native;

var(SeqEvent_Mover) float StayOpenTime;

public event function RegisterEvent()
{
    local InterpActor Mover;
    
    Mover = InterpActor(Originator);
    if (Mover != None)
    {
        Mover.StayOpenTime = StayOpenTime;
    }
}
public function NotifyAttached(Actor Other)
{
    local array<int> ActivateIndices;
    
    if (Pawn(Other) != None && IsZero(Originator.Velocity))
    {
        ActivateIndices[0] = 0;
        CheckActivate(Originator, Other, FALSE, ActivateIndices);
    }
}
public function NotifyDetached(Actor Other)
{
    local Pawn P;
    local array<int> ActivateIndices;
    
    if (Originator == None)
    {
    }
    else if (Pawn(Other) != None)
    {
        foreach Originator.BasedActors(Class'Pawn', P)
        {
            return;
        }
        ActivateIndices[0] = 1;
        CheckActivate(Originator, Instigator, FALSE, ActivateIndices);
    }
}
public function NotifyEncroachingOn(Actor Hit)
{
    local SeqVar_Object ObjVar;
    local array<int> ActivateIndices;
    
    ActivateIndices[0] = 3;
    if (CheckActivate(Originator, Instigator, FALSE, ActivateIndices, TRUE))
    {
        foreach LinkedVariables(Class'SeqVar_Object', ObjVar, "Actor Hit")
        {
            ObjVar.SetObjectValue(Hit);
        }
    }
}
public function NotifyFinishedOpen()
{
    local array<int> ActivateIndices;
    
    ActivateIndices[0] = 2;
    CheckActivate(Originator, Instigator, FALSE, ActivateIndices);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StayOpenTime = 1.5
    WhoTriggers = EWhoTriggers.WT_Everyone
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Pawn Attached", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Pawn Detached", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Open Finished", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Hit Actor", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Instigator", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Actor Hit", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}