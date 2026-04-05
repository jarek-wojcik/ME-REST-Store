Class SFXVocalizationBank
    native;

struct native SFXVocalizationEventV2 
{
    var array<SFXVocalizationLineV2> Lines;
};
struct native SFXVocalizationLineV2 
{
    var SFXVocalizationParam Instigator;
    var SFXVocalizationParam Recipient;
    var SFXVocalizationParam ThirdParam;
    var biononship string DebugText;
    var WwiseEvent Sound;
};
struct native SFXVocalizationParam 
{
    var(SFXVocalizationParam) array<ESFXVocalizationVariationType> SpecificType;
    var(SFXVocalizationParam) array<int> SpecificValue;
};
struct native SFXVocalizationRole 
{
    var(SFXVocalizationRole) array<SFXVocalizationVariation> Roles;
};
struct native SFXVocalizationVariation 
{
    var(SFXVocalizationVariation) array<SFXVocalizationLine> Variations;
};
struct native SFXVocalizationLine 
{
    var(SFXVocalizationLine) array<ESFXVocalizationVariationType> SpecificType;
    var(SFXVocalizationLine) array<int> SpecificValue;
    var(SFXVocalizationLine) WwiseEvent Sound;
};

var(SFXVocalizationBank) array<SFXVocalizationRole> Vocalizations;
var array<SFXVocalizationEventV2> VocalizationsV2;

public event function MakeEntry(Name Role, Name Event, Name Type, Name Variation, WwiseEvent Sound)
{
    local int EventIndex;
    local int RoleIndex;
    local int TypeIndex;
    local int VariationIndex;
    local Object Obj;
    
    ImportBadOldType(Type, Variation);
    EventIndex = GetEnumIndex(Enum'SFXVocalizationManager.ESFXVocalizationEventID', Name("SFXVocalizationEvent_" $ Event));
    RoleIndex = GetEnumIndex(Enum'SFXVocalizationTypes.ESFXVocalizationRole', Name("SFXVocalizationRole_" $ Role));
    TypeIndex = GetEnumIndex(Enum'SFXVocalizationTypes.ESFXVocalizationVariationType', Name("SFXVocalization" $ Type));
    if (TypeIndex == 0)
    {
        VariationIndex = 0;
    }
    else
    {
        Obj = Class'SFXVocalizationTypes'.default.EnumForType[TypeIndex];
        if (TypeIndex == 3 || TypeIndex == 4 || TypeIndex == 7)
        {
            VariationIndex = GetEnumIndex(Obj, Variation);
        }
        else
        {
            VariationIndex = GetEnumIndex(Obj, Name("SFXVocalization" $ Variation));
        }
    }
    if (VariationIndex == -1 || TypeIndex == -1)
    {
        VariationIndex = 0;
        TypeIndex = 0;
    }
    EnsureArrays(EventIndex, RoleIndex);
    Vocalizations[EventIndex].Roles[RoleIndex].Variations.Add(1);
    Vocalizations[EventIndex].Roles[RoleIndex].Variations[Vocalizations[EventIndex].Roles[RoleIndex].Variations.Length - 1].SpecificType[0] = byte(TypeIndex);
    Vocalizations[EventIndex].Roles[RoleIndex].Variations[Vocalizations[EventIndex].Roles[RoleIndex].Variations.Length - 1].SpecificValue[0] = VariationIndex;
    Vocalizations[EventIndex].Roles[RoleIndex].Variations[Vocalizations[EventIndex].Roles[RoleIndex].Variations.Length - 1].Sound = Sound;
}
public function EnsureArrays(int i, int J)
{
    if (Vocalizations.Length <= i)
    {
        Vocalizations.Add(i + 1 - Vocalizations.Length);
    }
    if (Vocalizations[i].Roles.Length <= J)
    {
        Vocalizations[i].Roles.Add(J + 1 - Vocalizations[i].Roles.Length);
    }
}
public function ImportBadOldType(out Name Type, out Name Variation)
{
    local string Suffix;
    
    if (Type == 'SpecificType_Character')
    {
        Type = 'SpecificType_CharacterName';
    }
    else if (Type == 'SpecificType' && Variation == 'None')
    {
        Type = 'SpecificType_None';
    }
    else if (Type == 'SpecificType_Race' || Type == 'SpecificType_EnemyType')
    {
        Type = 'SpecificType_CharacterType';
        Suffix = Right(string(Variation), Len(string(Variation)) - InStr(string(Variation), "_", , , ));
        if (Suffix == "_Mech")
        {
            Suffix = "_LightMech";
            Variation = Name("CharacterType" $ Suffix);
        }
        else if (Suffix == "_Geth")
        {
            Suffix = "_GethInfantry";
            Variation = Name("CharacterType" $ Suffix);
        }
        else if (Suffix == "_Merc")
        {
            Type = 'SpecificType_Group';
            Suffix = "_GenericMerc";
            Variation = Name("GroupType" $ Suffix);
        }
        else
        {
            Variation = Name("CharacterType" $ Suffix);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}