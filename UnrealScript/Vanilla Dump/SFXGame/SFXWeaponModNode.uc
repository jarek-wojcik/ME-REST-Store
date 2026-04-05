Class SFXWeaponModNode extends SFXPointOfInterest
    placeable;

var(SFXWeaponModNode) editinline export StaticMeshComponent SMC;
var(SFXWeaponModNode) editinline export LightEnvironmentComponent LightEnvironment;

public function DisableWeaponModNode()
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
    Begin Object Class=SFXWeaponModUseModule Name=WeaponModUseModule0
        m_TargetOffset = {X = 0.0, Y = 0.0, Z = 20.0}
        m_bTargetable = TRUE
        m_TargetTipText = ETargetTipText.TargetTipText_PickUp
    End Object
    Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
        StaticMesh = StaticMesh'bioapl_ind_batpack01.BatteryPack01'
        WireframeColor = {B = 128, G = 128, R = 255, A = 255}
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        RBChannel = ERBCollisionChannel.RBCC_Nothing
        BlockRigidBody = FALSE
    End Object
    SMC = StaticMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, StaticMeshComponent0)
    Modules = (WeaponModUseModule0)
}