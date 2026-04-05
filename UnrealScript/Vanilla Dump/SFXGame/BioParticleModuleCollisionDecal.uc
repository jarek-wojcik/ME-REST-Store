Class BioParticleModuleCollisionDecal extends ParticleModuleCollision
    native
    editinlinenew
    collapsecategories;

var(Collision) export noclear string CollisionEmitter;
var(Parameters) export array<Name> ColorParams;
var(Collision) editinline export noclear BioDecalComponent DecalTemplate;
var ParticleSystem CollisionEmitterTemplate;
var(Collision) bool bEnableMultiHitDecal;

public event function CreateDecal(ParticleSystemComponent PSC, PrimitiveComponent HitComponent, Vector HitLocation, Vector HitNormal)
{
    local MaterialInstanceTimeVarying MITV;
    local MaterialInterface DecalMaterial;
    local Name Param;
    local ParticleSysParam PSParam;
    local LinearColor C;
    
    if (ColorParams.Length > 0)
    {
        MITV = new Class'MaterialInstanceTimeVarying';
        MITV.SetParent(DecalTemplate.GetDecalMaterial());
        foreach ColorParams(Param, )
        {
            foreach PSC.InstanceParameters(PSParam, )
            {
                if (PSParam.Name == Param)
                {
                    C.R = float(PSParam.Color.R);
                    C.G = float(PSParam.Color.G);
                    C.B = float(PSParam.Color.B);
                    C.A = float(PSParam.Color.A);
                    MITV.SetVectorParameterValue(Param, C);
                }
            }
        }
        foreach Class'SFXWeapon'.default.FadingParameters(Param, )
        {
            MITV.SetScalarStartTime(Param, 0.0);
        }
        DecalMaterial = MITV;
    }
    else
    {
        DecalMaterial = DecalTemplate.GetDecalMaterial();
    }
    if (bEnableMultiHitDecal)
    {
        HitComponent = None;
    }
    Class'Engine'.static.GetCurrentWorldInfo().MyDecalManager.SpawnDecal(DecalMaterial, HitLocation + HitNormal, Rotator(-HitNormal), DecalTemplate.Width, DecalTemplate.Height, 2.0 * DecalTemplate.FarPlane, DecalTemplate.bNoClip, FRand() * 360.0, HitComponent);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DistributionFloatConstant Name=DistributionDelayAmount
    End Template
    Begin Template Class=DistributionFloatConstant Name=DistributionParticleMass
    End Template
    Begin Template Class=DistributionFloatUniform Name=DistributionMaxCollisions
    End Template
    Begin Template Class=DistributionVectorConstant Name=DistributionDampingFactorRotation
    End Template
    Begin Template Class=DistributionVectorConstant Name=DistributionDampingFactorRotationRw
    End Template
    Begin Template Class=DistributionVectorUniform Name=DistributionDampingFactor
    End Template
    Begin Template Class=DistributionVectorUniform Name=DistributionDampingFactorRw
    End Template
    DampingFactorRw = {Distribution = DistributionDampingFactorRw}
    DampingFactorRotationRw = {Distribution = DistributionDampingFactorRotationRw}
    MaxCollisions = {Distribution = DistributionMaxCollisions}
    ParticleMass = {Distribution = DistributionParticleMass}
    DelayAmount = {Distribution = DistributionDelayAmount}
}