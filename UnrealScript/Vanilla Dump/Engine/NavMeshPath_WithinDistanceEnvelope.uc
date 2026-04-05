Class NavMeshPath_WithinDistanceEnvelope extends NavMeshPathConstraint
    native;

var(NavMeshPath_WithinDistanceEnvelope) Vector EnvelopeTestPoint;
var(NavMeshPath_WithinDistanceEnvelope) float MaxDistance;
var(NavMeshPath_WithinDistanceEnvelope) float MinDistance;
var(NavMeshPath_WithinDistanceEnvelope) float SoftStartPenalty;
var(NavMeshPath_WithinDistanceEnvelope) bool bSoft;
var(NavMeshPath_WithinDistanceEnvelope) bool bOnlyThrowOutNodesThatLeaveEnvelope;

public function Recycle()
{
    Super.Recycle();
    MaxDistance = default.MaxDistance;
    MinDistance = default.MinDistance;
    bSoft = default.bSoft;
    SoftStartPenalty = default.SoftStartPenalty;
    EnvelopeTestPoint = default.EnvelopeTestPoint;
    bOnlyThrowOutNodesThatLeaveEnvelope = default.bOnlyThrowOutNodesThatLeaveEnvelope;
}
public static function bool StayWithinEnvelopeToLoc(NavigationHandle NavHandle, Vector InEnvelopeTestPoint, float InMaxDistance, float InMinDistance, optional bool bInSoft = TRUE, optional float InSoftStartPenalty = -1.0, optional bool bOnlyTossOutSpecsThatLeave)
{
    local NavMeshPath_WithinDistanceEnvelope Con;
    
    if (NavHandle != None)
    {
        Con = NavMeshPath_WithinDistanceEnvelope(NavHandle.CreatePathConstraint(default.Class));
        if (Con != None)
        {
            Con.EnvelopeTestPoint = InEnvelopeTestPoint;
            Con.bSoft = bInSoft;
            Con.MaxDistance = InMaxDistance;
            Con.MinDistance = InMinDistance;
            Con.bOnlyThrowOutNodesThatLeaveEnvelope = bOnlyTossOutSpecsThatLeave;
            if (InSoftStartPenalty > -1.0)
            {
                Con.SoftStartPenalty = InSoftStartPenalty;
            }
            NavHandle.AddPathConstraint(Con);
            return TRUE;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SoftStartPenalty = 320.0
    bSoft = TRUE
}