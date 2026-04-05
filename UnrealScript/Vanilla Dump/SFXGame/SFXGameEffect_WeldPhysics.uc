Class SFXGameEffect_WeldPhysics extends SFXGameEffect_DeathEffect;

var BioPawn Caster;
var bool bFreezeSucceeded;
var EAICustomAction CustomActionType;

public function OnRemoved()
{
    local BioPawn oPawn;
    local BioCustomAction CurrentCustomAction;
    local SFXCustomAction_Frozen FrozenCustomAction;
    
    Super(SFXGameEffect).OnRemoved();
    if (!bFreezeSucceeded)
    {
        return;
    }
    oPawn = BioPawn(Owner);
    if (oPawn == None)
    {
        return;
    }
    if (oPawn.GetCurrentCustomAction(CurrentCustomAction) && CurrentCustomAction != None && CurrentCustomAction.Class == Class'SFXCustomAction_Frozen')
    {
        FrozenCustomAction = SFXCustomAction_Frozen(CurrentCustomAction);
        if (FrozenCustomAction != None)
        {
            FrozenCustomAction.UnWeldPhysicsAssetInstance();
        }
    }
}
public function OnApplied()
{
    local BioPawn oPawn;
    
    Super(SFXGameEffect).OnApplied();
    oPawn = BioPawn(Owner);
    if (oPawn == None)
    {
        return;
    }
    RemoveExistingWeldEffects();
    if (oPawn.StartCustomAction(int(CustomActionType)))
    {
        oPawn.LastAnimatedReactionTime = Owner.WorldInfo.GameTimeSeconds;
        bFreezeSucceeded = TRUE;
    }
}
private final function RemoveExistingWeldEffects()
{
    local int idx;
    local SFXGameEffect Effect;
    local SFXModule_GameEffectManager Manager;
    
    if (Owner == None)
    {
        return;
    }
    Manager = Owner.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    for (idx = Manager.GameEffects.Length - 1; idx >= 0; idx--)
    {
        Effect = Manager.GameEffects[idx];
        if (ClassIsChildOf(Effect.Class, Self.Class) && Effect != Self)
        {
            Effect.OnRemoved();
            Manager.GameEffects.Remove(idx, 1);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CustomActionType = EAICustomAction.CA_Frozen
    bPreventGibs = TRUE
}