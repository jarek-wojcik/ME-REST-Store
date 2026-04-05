Class SFXWeaponNode_BonusWeapon extends SFXWeaponNode
    placeable;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Object Class=SFXWeaponUseModule_BonusWeapon Name=WeaponUseModule1
        LightEnvironment = MyLightEnvironment
        PickupMesh = SkeletalMeshComponent0
        m_bTargetable = TRUE
    End Object
    Begin Template Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
    End Template
    SMC = SkeletalMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (None, MyLightEnvironment, SkeletalMeshComponent0)
    Modules = (WeaponUseModule1)
}