Class SFXGameEffect_UniqueArmor_Base extends SFXGameEffect;

struct UniqueArmorEffects 
{
    var Class<SFXGameEffect> childClass;
    var float Value;
};

var array<UniqueArmorEffects> Children;

public function OnApplied()
{
    local int idx;
    local SFXModule_GameEffectManager GEManager;
    
    Super.OnApplied();
    GEManager = SFXModule_GameEffectManager(Outer);
    if (GEManager == None)
    {
        return;
    }
    for (idx = 0; idx < Children.Length; idx++)
    {
        GEManager.CreateAndApplyEffect(Children[idx].childClass, Category, 0.0, 2, Children[idx].Value, Instigator);
    }
    GEManager.RemoveEffectsByTypeAndCategory(Self.Class, Category);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}