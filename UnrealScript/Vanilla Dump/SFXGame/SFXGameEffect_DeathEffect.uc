Class SFXGameEffect_DeathEffect extends SFXGameEffect;

var Class<SFXDamageType> PlayExclusivelyForDamageType;
var RvrClientEffectInterface CE_DeathEffectTemplate;
var WwiseEvent DeathSoundEffect;
var int Priority;
var bool bCorpseDestroyed;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Priority = 1
}