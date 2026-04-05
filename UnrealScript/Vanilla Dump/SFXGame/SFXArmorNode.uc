Class SFXArmorNode extends SFXPointOfInterest
    placeable;

var(SFXArmorNode) editinline export StaticMeshComponent SMC;
var(SFXArmorNode) editinline export LightEnvironmentComponent LightEnvironment;

public function DisableArmorNode()
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
    Begin Object Class=SFXArmorUseModule Name=ArmorUseModule0
        m_bTargetable = TRUE
    End Object
    Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
        StaticMesh = StaticMesh'BioApl_Con_AmmoBox04.Ammo_Box04_A'
        WireframeColor = {B = 128, G = 128, R = 255, A = 255}
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        RBChannel = ERBCollisionChannel.RBCC_Nothing
        BlockRigidBody = FALSE
        Scale = 0.300000012
    End Object
    SMC = StaticMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, StaticMeshComponent0)
    Modules = (ArmorUseModule0)
}