Class PhysicalMaterial
    native
    collapsecategories;

enum EPhysEffectType
{
    EPMET_Impact,
    EPMET_Slide,
};

var(Advanced) Vector AnisoFrictionDir;
var(BioSound) Name m_nmPhysicsCollisionSound;
var transient int MaterialIndex;
var(PhysicalMaterial) float Friction;
var(PhysicalMaterial) float Restitution;
var(Advanced) float FrictionV;
var(PhysicalMaterial) float Density;
var(PhysicalMaterial) float AngularDamping;
var(PhysicalMaterial) float LinearDamping;
var(PhysicalMaterial) float MagneticResponse;
var(PhysicalMaterial) float WindResponse;
var(Impact) float ImpactThreshold;
var(Impact) float ImpactReFireDelay;
var(Impact) ParticleSystem ImpactEffect;
var(Impact) SoundCue ImpactSound;
var(Slide) float SlideThreshold;
var(Slide) float SlideReFireDelay;
var(Slide) ParticleSystem SlideEffect;
var(Slide) SoundCue SlideSound;
var(Fracture) SoundCue FractureSoundExplosion;
var(Fracture) SoundCue FractureSoundSingle;
var(PhysicalMaterial) float AudioObstruction;
var(PhysicalMaterial) float AudioOcclusion;
var(Parent) PhysicalMaterial Parent;
var(PhysicalProperties) export PhysicalMaterialPropertyBase PhysicalMaterialProperty;
var(PhysicalMaterial) bool bForceConeFriction;
var(Advanced) bool bEnableAnisotropicFriction;
var(BioSound) bool m_bIgnoreSelfCollisions;

public static final iterator native function AllPhysicalMaterials(out PhysicalMaterial OutPhysMat);

public native function PhysEffectInfo FindPhysEffectInfo(EPhysEffectType Type);

public simulated function FindFractureSounds(out SoundCue OutSoundExplosion, out SoundCue OutSoundSingle)
{
    local PhysicalMaterial TestMat;
    
    OutSoundExplosion = None;
    OutSoundSingle = None;
    TestMat = Self;
    while ((OutSoundExplosion == None || OutSoundSingle == None) && TestMat != None)
    {
        if (OutSoundSingle == None)
        {
            OutSoundSingle = TestMat.FractureSoundSingle;
        }
        if (OutSoundExplosion == None)
        {
            OutSoundExplosion = TestMat.FractureSoundExplosion;
        }
        TestMat = TestMat.Parent;
    }
}
public simulated function PhysicalMaterialPropertyBase GetPhysicalMaterialProperty(Class<PhysicalMaterialPropertyBase> DesiredClass)
{
    if (PhysicalMaterialProperty != None && ClassIsChildOf(PhysicalMaterialProperty.Class, DesiredClass))
    {
        return PhysicalMaterialProperty;
    }
    else if (Parent != None)
    {
        return Parent.GetPhysicalMaterialProperty(DesiredClass);
    }
    else
    {
        return None;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Friction = 0.699999988
    Restitution = 0.300000012
    Density = 1.0
    LinearDamping = 0.00999999978
}