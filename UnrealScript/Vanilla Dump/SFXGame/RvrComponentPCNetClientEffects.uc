Class RvrComponentPCNetClientEffects extends ActorComponent
    native;

public event native function SpawnClientEffectOnClient(RvrClientEffectInterface pEffect, RvrClientEffectTarget oTarget, optional Actor pOwner);

public event native function SpawnClientEffectOnServer(PlayerController oInstigator, RvrClientEffectInterface pEffect, RvrClientEffectTarget oTarget, optional Actor pOwner);

public event native function StopClientEffectOnClient(RvrClientEffectInterface pEffect, Guid Id, bool bAllowCooldown);

public event native function StopClientEffectOnServer(PlayerController oInstigator, RvrClientEffectInterface pEffect, Guid Id, bool bAllowCooldown);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}