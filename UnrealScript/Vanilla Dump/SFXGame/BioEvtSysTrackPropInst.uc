Class BioEvtSysTrackPropInst extends SFXGameActorInterpTrackInst
    native;

struct native BioPropPreviewResource 
{
    var native Map_Mirror mapActions;
    var Name nmProp;
    var editinline export MeshComponent pPropCmp;
    var bool bEquipped;
};
struct native BioActionPreviewResource 
{
    var Name nmAction;
    var Name nmAnimation;
    var editinline export ParticleSystemComponent pPartSysCmp;
    var AnimSet pAnimSet;
    var bool bEquipped;
};

var transient native Map_Mirror m_mapFoundWeapons;
var transient native Map_Mirror m_mapUsedMeshProps;
var transient bool m_bBelongsToConversation;

public native function AddWeaponData(Class<Object> cWeapon, Object pWep, bool bSpawned, bool bCurrentlyEquipped);

public native function Object FindWeaponData(Class<Object> cWeapon, out int nSpawned, bool bCurrentlyEquipped);

public static event function string GetWeaponName(Object pWeaponIn)
{
    local SFXWeapon pWeapon;
    
    pWeapon = SFXWeapon(pWeaponIn);
    if (pWeapon != None)
    {
        return string(pWeapon.Name);
    }
    return "";
}
public native function RemoveWeaponData(Class<Object> cWeapon);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}