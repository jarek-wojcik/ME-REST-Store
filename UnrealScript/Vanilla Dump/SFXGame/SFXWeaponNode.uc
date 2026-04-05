Class SFXWeaponNode extends SFXPointOfInterest
    placeable;

var(SFXWeaponNode) editinline export SkeletalMeshComponent SMC;
var(SFXWeaponNode) editinline export LightEnvironmentComponent LightEnvironment;

public function PostBeginPlay()
{
    local SFXWeaponUseModule WeaponUseModule;
    local SkeletalMeshComponent DefaultSMC;
    
    Super.PostBeginPlay();
    WeaponUseModule = GetModule(Class'SFXWeaponUseModule');
    if (WeaponUseModule == None || WeaponUseModule.WeaponClass == None)
    {
        return;
    }
    DefaultSMC = SkeletalMeshComponent(WeaponUseModule.WeaponClass.default.PickupFactoryMesh);
    if (DefaultSMC == None)
    {
        return;
    }
    SMC.SetSkeletalMesh(DefaultSMC.SkeletalMesh);
}
public function DisableWeaponNode()
{
    if (SMC == None)
    {
        return;
    }
    SMC.SetHidden(TRUE);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Object
    Begin Object Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
        WireframeColor = {B = 128, G = 128, R = 255, A = 255}
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
    End Object
    Begin Object Class=SFXWeaponUseModule Name=WeaponUseModule0
        LightEnvironment = MyLightEnvironment
        PickupMesh = SkeletalMeshComponent0
        m_bTargetable = TRUE
    End Object
    SMC = SkeletalMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (None, MyLightEnvironment, SkeletalMeshComponent0)
    Modules = (WeaponUseModule0)
}