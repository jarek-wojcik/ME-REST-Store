Class Path_WithinDistanceEnvelope extends PathConstraint
    native;

var(Path_WithinDistanceEnvelope) Vector EnvelopeTestPoint;
var(Path_WithinDistanceEnvelope) float MaxDistance;
var(Path_WithinDistanceEnvelope) float MinDistance;
var(Path_WithinDistanceEnvelope) float SoftStartPenalty;
var(Path_WithinDistanceEnvelope) bool bSoft;
var(Path_WithinDistanceEnvelope) bool bOnlyThrowOutNodesThatLeaveEnvelope;

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
public static function bool StayWithinEnvelopeToLoc(Pawn P, Vector InEnvelopeTestPoint, float InMaxDistance, float InMinDistance, optional bool bInSoft = TRUE, optional float InSoftStartPenalty = -1.0, optional bool bOnlyTossOutSpecsThatLeave)
{
    local Path_WithinDistanceEnvelope Con;
    
    if (P != None)
    {
        Con = Path_WithinDistanceEnvelope(P.CreatePathConstraint(default.Class));
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
            P.AddPathConstraint(Con);
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
    CacheIdx = 3
}