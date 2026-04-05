Class SFXAICmd_CA_KroganCharge extends SFXAICmd_CustomAction within SFXAI_Core;

var transient float m_fCachedTurnSpeed;
var transient float m_fChargeTurnSpeed;

public event function bool NotifyBump(Actor Other, Vector HitNormal)
{
    return TRUE;
}
public event function bool NotifyHitWall(Vector HitNormal, Actor Wall)
{
    if (BreakHitObject(Wall, HitNormal) == FALSE)
    {
        Outer.MyBP.InterruptCustomAction();
    }
    return TRUE;
}
public function bool BreakHitObject(Actor Other, Vector HitNormal)
{
    local Vector HitLoc;
    local Vector HitNorm;
    local Actor HitActor;
    local Vector Momentum;
    
    if (KActor(Other) != None)
    {
        Other.TakeDamage(10000.0, Outer, Outer.Pawn.location, Vector(Outer.Pawn.Rotation), Class'SFXDamageType_Default');
        HitActor = Outer.Pawn.Trace(HitLoc, HitNorm, Outer.Pawn.location + HitNormal * -100.0, Outer.Pawn.location, TRUE, , , );
        if (SFXKActor(HitActor) != None)
        {
            Momentum = HitNormal * -500.0;
            SFXKActor(HitActor).ImpulseFragments(Outer.Pawn.location, Momentum, Outer.Pawn.GetCollisionExtent());
        }
        return TRUE;
    }
    return FALSE;
}
public function bool ExecuteCustomAction()
{
    local BioCustomAction_KroganCharge oCharge;
    
    SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(73, Outer.MyBP, BioPawn(Outer.FireTarget), , , TRUE);
    oCharge = None;
    if (oCharge != None)
    {
        oCharge.m_oChargeTarget = Outer.FireTarget;
    }
    return TRUE;
}
public event function Popped()
{
    Super.Popped();
    if (Outer.MyBP != None)
    {
        m_fCachedTurnSpeed = 0.0;
    }
}
public event function Pushed()
{
    Super.Pushed();
    SetDesiredRotationAndLocation();
    if (Outer.MyBP != None)
    {
    }
}
public function SetDesiredRotationAndLocation()
{
    local Vector vDirection;
    local Rotator DesiredRotation;
    
    if (Outer.FireTarget != None && Outer.Pawn != None)
    {
        vDirection = Outer.FireTarget.location - Outer.Pawn.location;
        DesiredRotation = Rotator(vDirection);
        DesiredRotation.Yaw = DesiredRotation.Yaw & 65535;
        DesiredRotation.Pitch = 0;
        DesiredRotation = Normalize(DesiredRotation);
        Outer.Pawn.SetDesiredRotation(DesiredRotation);
        Outer.Pawn.SetRotation(DesiredRotation);
    }
}
public function bool ShouldFinishRotation()
{
    return TRUE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fChargeTurnSpeed = 40.0
}