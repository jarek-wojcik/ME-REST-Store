Class SFXGameEffect_TimeDilation extends SFXGameEffect;

var InterpCurveFloat SlowDown;
var float TimeRemainingBeforePause;
var float OwnerCounterScale;

public function OnRemoved()
{
    Super.OnRemoved();
    if (Owner != None)
    {
        Owner.CustomTimeDilation = 1.0;
        if (Pawn(Owner) != None)
        {
            Pawn(Owner).Controller.CustomTimeDilation = 1.0;
        }
        if (Owner.WorldInfo != None && Owner.WorldInfo.Game != None)
        {
            SFXGame(Owner.WorldInfo.Game).CancelTimeDilation(Category);
        }
    }
}
public function OnUpdate(float TimeDelta)
{
    local float WorldTimeDilation;
    
    Super.OnUpdate(TimeDelta);
    if (OwnerCounterScale > float(0))
    {
        if (Owner != None && SFXGRI(Owner.WorldInfo.GRI).bAllowTimeDilation)
        {
            WorldTimeDilation = Owner.WorldInfo.TimeDilation;
            if (WorldTimeDilation > float(0))
            {
                Owner.CustomTimeDilation = 1.0 / WorldTimeDilation * OwnerCounterScale;
                if (Pawn(Owner) != None)
                {
                    Pawn(Owner).Controller.CustomTimeDilation = 1.0 / WorldTimeDilation * OwnerCounterScale;
                }
            }
        }
    }
}
public function OnApplied()
{
    if (SFXGRI(Owner.WorldInfo.GRI).bAllowTimeDilation)
    {
        SlowDown.Points[1].OutVal = 1.0 - EffectValue;
        SlowDown.Points[2].OutVal = 1.0 - EffectValue;
        SFXGame(Owner.WorldInfo.Game).RequestTimeDilation(SlowDown, Duration, Category);
    }
}
public function OnPaused()
{
    TimeRemainingBeforePause = Duration - CurrentTime;
    if (TimeRemainingBeforePause < 0.0)
    {
        TimeRemainingBeforePause = 0.0;
    }
    OnRemoved();
}
public function OnUnpaused()
{
    Duration = TimeRemainingBeforePause;
    OnApplied();
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SlowDown = {
                Points = ({InVal = 0.0, OutVal = 1.0, ArriveTangent = 0.0, LeaveTangent = -4.0, InterpMode = EInterpCurveMode.CIM_CurveUser}, 
                          {InVal = 0.100000001, OutVal = 1.0, ArriveTangent = -4.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveUser}, 
                          {InVal = 0.800000012, OutVal = 1.0, ArriveTangent = 0.0, LeaveTangent = 4.0, InterpMode = EInterpCurveMode.CIM_CurveUser}, 
                          {InVal = 1.0, OutVal = 1.0, ArriveTangent = 4.0, LeaveTangent = 0.0, InterpMode = EInterpCurveMode.CIM_CurveUser}
                         ), 
                InterpMethod = EInterpMethodType.IMT_UseFixedTangentEvalAndNewAutoTangents
               }
    OwnerCounterScale = 1.0
}