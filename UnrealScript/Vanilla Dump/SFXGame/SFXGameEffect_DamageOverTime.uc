Class SFXGameEffect_DamageOverTime extends SFXGameEffect;

var Class<SFXDamageType> DamageType;
var float DamageInterval;

public function OnRemoved()
{
    if (Owner != None)
    {
        Owner.ClearTimer('DoDamage', Self);
    }
}
public function DoDamage()
{
    local SFXModule_Damage DmgModule;
    
    if (Owner != None)
    {
        DmgModule = Owner.GetModule(Class'SFXModule_Damage');
        if (DmgModule != None)
        {
            BioPawn(Owner).TakeDamage(EffectValue * DamageInterval, Instigator, vect(0.0, 0.0, 0.0), vect(0.0, 0.0, 0.0), DamageType, , Causer);
        }
    }
}
public function OnApplied()
{
    if (Owner != None && DamageInterval > float(0))
    {
        Owner.SetTimer(DamageInterval, TRUE, 'DoDamage', Self);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DamageType = Class'SFXDamageType_Default'
    DamageInterval = 0.5
}