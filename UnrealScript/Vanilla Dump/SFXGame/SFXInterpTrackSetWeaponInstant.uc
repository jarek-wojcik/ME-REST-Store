Class SFXInterpTrackSetWeaponInstant extends SFXGameInterpTrackCustom
    native
    collapsecategories;

struct native SFXWeaponClassData 
{
    var(SFXWeaponClassData) Class<SFXWeapon> cWeapon;
};

var(SFXInterpTrackSetWeaponInstant) array<SFXWeaponClassData> m_aWeaponClassKeyData;
var(SFXInterpTrackSetWeaponInstant) BioSeqVar_ObjectFindByTag m_PawnRefTag;
var transient BioPawn m_Pawn;

public static event function bool AllowKeyNaming()
{
    return TRUE;
}
public static event function string KeyDataArrayName()
{
    return "m_aWeaponClassKeyData";
}
public static event function string KeyDataDisplayName()
{
    return "Weapon Key Data";
}
public static event function string NewKeyDefaultName()
{
    return "Weapon";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TrackInstClass = Class'SFXGameInterpTrackInstCustom'
    TrackTitle = "Set Weapon(Instant)"
}