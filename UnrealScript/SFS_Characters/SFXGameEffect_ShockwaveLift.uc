Class SFXGameEffect_ShockwaveLift extends SFXGameEffect_PhysicsPower;

var float GravityValue;
var float ForceDrag;

public function OnRemoved()
{
    Super(SFXGameEffect).OnRemoved();
    if (!HasOtherGravityEffects())
    {
        Owner.m_fGravityScaling = 1.0;
    }
}
public function OnUpdate(float DeltaSeconds)
{
    local Vector Force;
    
    Super(SFXGameEffect).OnUpdate(DeltaSeconds);
    if (Owner.CollisionComponent != None)
    {
        Force = -Owner.Velocity * ForceDrag * DeltaSeconds;
        Owner.CollisionComponent.AddForce(Force, Owner.location, 'None');
    }
}
public function OnApplied()
{
    Super(SFXGameEffect).OnApplied();
    Owner.m_fGravityScaling = GravityValue;
}
public function bool HasOtherGravityEffects()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect oEffect;
    
    if (Owner == None)
    {
        return FALSE;
    }
    Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        foreach Manager.GameEffects(oEffect, )
        {
            if (oEffect.Class == Class'SFXGameEffect_AntiGravity' && oEffect.Category != Category)
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ForceDrag = 0.75
}