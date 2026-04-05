Class SFXProjectile_PowerCustomAction_ConcussiveShot extends SFXProjectile_PowerCustomAction_SuperSeeking
    config(Game);

var ParticleSystem PS_NormalConcussiveShot;

public simulated function bool InitializePowerProjectile(Actor oCaster, float fTravelSpeed, float fRadius, SFXPowerCustomAction oPower)
{
    local SFXPowerCustomAction_ConcussiveShot ConcussiveShot;
    local Vector vParams;
    
    if (!bClientPredictionTarget)
    {
        ConcussiveShot = SFXPowerCustomAction_ConcussiveShot(oPower);
        if (ConcussiveShot != None && ConcussiveShot.AmmoPower != None && ConcussiveShot.AmmoPower.CE_ConcussiveShotProjectile != None)
        {
            vParams.X = oPower.VFXIntensity.CurrentValue;
            vParams.Y = fRadius;
            vParams.Z = fTravelSpeed;
            Class'RvrClientEffectManager'.static.GetClientEffectManager().Play(ConcussiveShot.AmmoPower.CE_ConcussiveShotProjectile, Self, vParams);
        }
        else
        {
            ProjEffectsHeadTemplate = PS_NormalConcussiveShot;
        }
    }
    return Super(SFXProjectile_PowerCustomAction_Seeking).InitializePowerProjectile(oCaster, fTravelSpeed, fRadius, oPower);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    PS_NormalConcussiveShot = ParticleSystem'BioVFX_C_FlashBang.Particles.FlashBang_Tracer'
    CylinderComponent = CollisionCylinder
    Components = (CollisionCylinder)
    CollisionComponent = CollisionCylinder
}