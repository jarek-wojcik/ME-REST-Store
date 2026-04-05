Class SeqEvent_Touch extends SequenceEvent
    native;

var(TouchTypes) array<Class<Actor>> ClassProximityTypes;
var(TouchTypes) array<Class<Actor>> IgnoredClassProximityTypes;
var array<Actor> TouchedList;
var(SeqEvent_Touch) bool bForceOverlapping;
var(SeqEvent_Touch) bool bUseInstigator;
var(SeqEvent_Touch) bool m_bIgnoreVehicleTransitions;
var(SeqEvent_Touch) bool bAllowDeadPawns;

public final native function bool CheckTouchActivate(Actor inOriginator, Actor inInstigator, optional bool bTest);

public final native function bool CheckUnTouchActivate(Actor inOriginator, Actor inInstigator, optional bool bTest);

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + 1;
}
public event function Toggled()
{
    local Actor TouchingActor;
    
    if (bEnabled)
    {
        if (Originator != None)
        {
            foreach Originator.TouchingActors(Class'Actor', TouchingActor, )
            {
                CheckTouchActivate(Originator, TouchingActor);
            }
        }
    }
    else
    {
        TouchedList.Length = 0;
    }
}
public function NotifyTouchingPawnDied(Pawn P)
{
    if (!bAllowDeadPawns)
    {
        CheckUnTouchActivate(Originator, P);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ClassProximityTypes = (Class'Pawn')
    bForceOverlapping = TRUE
    ReTriggerDelay = 0.100000001
    WhoTriggers = EWhoTriggers.WT_PlayerOnly
    OutputLinks = ({
                    Links = (), 
                    LinkDesc = "Touched", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "UnTouched", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }, 
                   {
                    Links = (), 
                    LinkDesc = "Empty", 
                    LinkAction = 'None', 
                    LinkedOp = None, 
                    bHasImpulse = FALSE, 
                    bDisabled = FALSE
                   }
                  )
}