Class SFXModule_GameEffectManager_NativeBase extends SFXModule
    native;

var(SFXModule_GameEffectManager_NativeBase) clearcrosslevel array<SFXGameEffect> GameEffects;
var(SFXModule_GameEffectManager_NativeBase) bool EffectListLocked;

public event native function HandlePreRemove();

public event simulated function RemoveAllEffects();

public simulated native function Tick(float DeltaSeconds);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}