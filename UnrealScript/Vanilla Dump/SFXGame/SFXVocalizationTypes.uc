Class SFXVocalizationTypes
    native
    abstract;

enum ESFXVocalizationWeapon
{
    SFXVocalizationWeapon_None,
    SFXVocalizationWeapon_Pistol,
    SFXVocalizationWeapon_SMG,
    SFXVocalizationWeapon_AssaultRifle,
    SFXVocalizationWeapon_Shotgun,
    SFXVocalizationWeapon_SniperRifle,
    SFXVocalizationWeapon_HeavyWeapon,
};
enum ESFXVocalizationGender
{
    SFXVocalizationGender_None,
    SFXVocalizationGender_Male,
    SFXVocalizationGender_Female,
};
enum ESFXVocalizationName
{
    SFXVocalizationCharacter_None,
    SFXVocalizationCharacter_Shepard,
    SFXVocalizationCharacter_Garrus,
    SFXVocalizationCharacter_Tali,
    SFXVocalizationCharacter_Legion,
    SFXVocalizationCharacter_Samara,
    SFXVocalizationCharacter_Morinth,
    SFXVocalizationCharacter_Jacob,
    SFXVocalizationCharacter_Miranda,
    SFXVocalizationCharacter_Grunt,
    SFXVocalizationCharacter_Mordin,
    SFXVocalizationCharacter_Thane,
    SFXVocalizationCharacter_Jack,
    SFXVocalizationCharacter_Kasumi,
    SFXVocalizationCharacter_Zaeed,
};
enum ESFXVocalizationLocation
{
    SFXVocalizationLocation_None,
    SFXVocalizationLocation_Above,
    SFXVocalizationLocation_Below,
    SFXVocalizationLocation_Right,
    SFXVocalizationLocation_Left,
    SFXVocalizationLocation_Ahead,
    SFXVocalizationLocation_Behind,
    SFXVocalizationLocation_Specific,
};
enum ESFXVocalizationBool
{
    SFXVocalizationBool_False,
    SFXVocalizationBool_True,
};
enum ESFXVocalizationVariationType
{
    SFXVocalizationSpecificType_None,
    SFXVocalizationSpecificType_Location,
    SFXVocalizationSpecificType_CharacterName,
    SFXVocalizationSpecificType_CharacterType,
    SFXVocalizationSpecificType_Affiliation,
    SFXVocalizationSpecificType_Gender,
    SFXVocalizationSpecificType_Weapon,
    SFXVocalizationSpecificType_Challenge,
    SFXVocalizationSpecificType_Me,
    SFXVocalizationSpecificType_IsFriendly,
};
enum ESFXVocalizationRole
{
    SFXVocalizationRole_None,
    SFXVocalizationRole_Instigator,
    SFXVocalizationRole_Instigator_NonCombat,
    SFXVocalizationRole_Instigator_Stealth,
    SFXVocalizationRole_Recipient,
    SFXVocalizationRole_EnemyWitness,
    SFXVocalizationRole_TeammateWitness,
    SFXVocalizationRole_HenchmanWitness,
    SFXVocalizationRole_ReferencedPawn,
};

var array<Object> EnumForType;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EnumForType = (None, 
                   Enum'SFXVocalizationTypes.ESFXVocalizationLocation', 
                   Enum'SFXVocalizationTypes.ESFXVocalizationName', 
                   Enum'BioDefine.ECharacterType', 
                   Enum'BioDefine.EAffiliationType', 
                   Enum'SFXVocalizationTypes.ESFXVocalizationGender', 
                   Enum'SFXVocalizationTypes.ESFXVocalizationWeapon', 
                   Enum'BioDefine.EChallengeType'
                  )
}