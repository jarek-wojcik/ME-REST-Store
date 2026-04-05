Class SFXWeaponMod_NativeBase
    native;

var editinline export PrimitiveComponent PickupFactoryMesh;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=StaticMeshComponent Name=PickupMesh
        StaticMesh = StaticMesh'bioapl_ind_batpack01.BatteryPack01'
        ReplacementPrimitive = None
        CollideActors = FALSE
    End Object
    PickupFactoryMesh = PickupMesh
}