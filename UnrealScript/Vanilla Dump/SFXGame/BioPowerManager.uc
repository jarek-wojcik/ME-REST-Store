Class BioPowerManager
    native;

struct native PowerReservation 
{
    var int nID;
    var float fTimeUntilExpiry;
};

var transient native Map_Mirror m_mapGlobalCooldowns;
var transient array<PowerReservation> m_aReservations;
var transient int m_nCurrentReservationID;

public native function bool AreActorsFriendly(Actor oFirstActor, Actor oSecondActor);

public event function bool CanImpactActor(Actor oActor)
{
    if (oActor == None)
    {
        return FALSE;
    }
    if (oActor.bWorldGeometry)
    {
        return TRUE;
    }
    if (oActor.IsA('Pawn') || oActor.IsA('BioArtPlaceable') || oActor.IsA('KActor') || oActor.IsA('StaticMeshActor') || oActor.IsA('KAsset') || oActor.IsA('InterpActor'))
    {
        if (oActor.CollisionComponent != None && oActor.CollisionType != ECollisionType.COLLIDE_NoCollision)
        {
            return TRUE;
        }
    }
    else if (oActor.IsA('SFXPointOfInterest'))
    {
        return TRUE;
    }
    return FALSE;
}
public native function bool CheckLOSToActor(Actor oSourceActor, Actor oDestinationActor, Vector vStartLocation, float fMaxRange, bool bIgnoreFriendlies, bool bIgnorePawns, out Actor oHitActor, out Vector vHitLocation, out Vector vHitNormal);

public native function bool CheckLOSToLocation(Actor oSourceActor, Vector vStartLocation, Vector vEndLocation, float fMaxRange, bool bIgnoreFriendlies, out Actor oHitActor, out Vector vHitLocation, out Vector vHitNormal, float fIgnoreCoverDistance);

public native function ChooseTargetForPlayer(SFXPower oPower, out Actor oTarget, out Vector vTargetLocation);

public native function ClearReservation(int nReservationID);

public native function float GetGlobalCooldown(Name nmPower);

public native function GetStartLocationForLOSCheck(Pawn Caster, out Vector vStartLocation);

public native function int MakeReservation(SFXPowerCustomActionBase oPower, Pawn oPawn, optional bool bForceSuccess = FALSE);

public native function SetGlobalCooldown(Name nmPower, float fCooldown);

public native function bool StartReservation(int nReservationID);

public native function Tick(float fDeltaTime);

public native function TickGlobalCooldowns(float fDeltaTime);

public native function TickReservations(float fDeltaTime);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}