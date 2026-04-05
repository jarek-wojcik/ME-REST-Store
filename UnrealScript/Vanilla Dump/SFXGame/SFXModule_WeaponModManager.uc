Class SFXModule_WeaponModManager extends SFXModule
    editinlinenew;

struct ExtraMeshComponent 
{
    var editinline export array<StaticMeshComponent> ExtraMeshes;
    var SFXWeaponMod Mod;
};
const MaxWeaponMods = 2;

var(SFXModule_WeaponModManager) array<SFXWeaponMod> WeaponMods;
var editinline transient array<ExtraMeshComponent> ExtraMeshComponents;

public function bool AddMod(Class<SFXWeaponMod> ModClass, int nLevel)
{
    local SFXWeapon Weapon;
    local SkeletalMeshComponent oSkeletalMesh;
    local SFXModule_GameEffectManager GEManager;
    local int nIndex;
    local int nOverrideIndex;
    local int idx;
    local BioPawn Pawn;
    local SFXGameEffect Effect;
    local SFXWeaponMod Mod;
    local bool bSocketOverride;
    local StaticMeshComponent ExtraMesh;
    local ExtraMeshComponent ExtraMeshStruct;
    local MeshComponent MeshToLight;
    local Class<SFXGameEffect> EffectClass;
    
    Weapon = SFXWeapon(Outer);
    if (Weapon == None)
    {
        return FALSE;
    }
    Pawn = BioPawn(Weapon.Instigator);
    if (Pawn == None)
    {
        return FALSE;
    }
    GEManager = Weapon.GetModule(Class'SFXModule_GameEffectManager');
    if (GEManager == None)
    {
        return FALSE;
    }
    oSkeletalMesh = SkeletalMeshComponent(Weapon.Mesh);
    if (oSkeletalMesh == None)
    {
        return FALSE;
    }
    if (nLevel <= 0)
    {
        return FALSE;
    }
    Mod = new (Self) ModClass;
    Mod.MyWeapon = Weapon;
    Mod.Level = nLevel;
    if (Mod.Meshes.Length > 0 && Mod.SocketName != 'None')
    {
        if (Mod.Level > Mod.Meshes.Length)
        {
            nIndex = Mod.Meshes.Length - 1;
        }
        else
        {
            nIndex = Mod.Level - 1;
        }
        if (Mod.Meshes[nIndex] != None)
        {
            if (Weapon.WeaponModMeshOverrides.Length > 0)
            {
                nOverrideIndex = Weapon.WeaponModMeshOverrides.Find('SocketName', Mod.SocketName);
                if (nOverrideIndex != -1)
                {
                    bSocketOverride = TRUE;
                    for (idx = 0; idx < Weapon.WeaponModMeshOverrides[nOverrideIndex].SocketOverrideNames.Length; idx++)
                    {
                        if (oSkeletalMesh.GetSocketByName(Weapon.WeaponModMeshOverrides[nOverrideIndex].SocketOverrideNames[idx]) != None)
                        {
                            if (idx > 0)
                            {
                                ExtraMesh = new (Self) Class'StaticMeshComponent';
                                ExtraMesh.SetStaticMesh(StaticMeshComponent(Mod.Meshes[nIndex]).StaticMesh);
                                oSkeletalMesh.AttachComponentToSocket(ExtraMesh, Weapon.WeaponModMeshOverrides[nOverrideIndex].SocketOverrideNames[idx]);
                                ExtraMeshStruct.Mod = Mod;
                                ExtraMeshStruct.ExtraMeshes.AddItem(ExtraMesh);
                                ExtraMeshComponents.AddItem(ExtraMeshStruct);
                                MeshToLight = ExtraMesh;
                            }
                            else
                            {
                                oSkeletalMesh.AttachComponentToSocket(Mod.Meshes[nIndex], Weapon.WeaponModMeshOverrides[nOverrideIndex].SocketOverrideNames[idx]);
                                MeshToLight = Mod.Meshes[nIndex];
                            }
                            MeshToLight.SetShadowParent(oSkeletalMesh);
                            MeshToLight.SetLightEnvironment(oSkeletalMesh.LightEnvironment);
                            MeshToLight.SetDepthPriorityGroup(oSkeletalMesh.DepthPriorityGroup);
                        }
                    }
                }
            }
            if (!bSocketOverride && oSkeletalMesh.GetSocketByName(Mod.SocketName) != None)
            {
                oSkeletalMesh.AttachComponentToSocket(Mod.Meshes[nIndex], Mod.SocketName);
                Mod.Meshes[nIndex].SetShadowParent(oSkeletalMesh);
                Mod.Meshes[nIndex].SetLightEnvironment(oSkeletalMesh.LightEnvironment);
                Mod.Meshes[nIndex].SetDepthPriorityGroup(oSkeletalMesh.DepthPriorityGroup);
            }
        }
    }
    if (Mod.bMaterialEmissiveChange)
    {
        Weapon.SetWeaponModEmissiveValue(Mod.Level);
    }
    if (Mod.bMaterialBodyColorChange)
    {
        Weapon.SetWeaponModBodyColour(Mod.Level);
    }
    if (Mod.bMaterialGripColorChange)
    {
        Weapon.SetWeaponModGripColour(Mod.Level);
    }
    for (nIndex = 0; nIndex < Mod.GameEffects.Length; nIndex++)
    {
        EffectClass = Mod.GetGameEffectClass(Mod.GameEffects[nIndex].EffectClassName);
        if (EffectClass != None && nLevel == Mod.GameEffects[nIndex].Level)
        {
            Effect = GEManager.CreateEffect(EffectClass, Mod.Name, 0.0, 2, Mod.GameEffects[nIndex].EffectValue, Pawn.Controller);
            if (Effect != None)
            {
                Effect.OnApplied();
            }
        }
    }
    if (Mod.Reticules.Length > 0)
    {
        if (Mod.Level > Mod.Reticules.Length)
        {
            nIndex = Mod.Reticules.Length - 1;
        }
        else
        {
            nIndex = Mod.Level - 1;
        }
        Weapon.GUIZoomReticleClass = Mod.Reticules[nIndex];
    }
    if (Mod.AimModes.Length > 0)
    {
        if (Mod.Level > Mod.AimModes.Length)
        {
            nIndex = Mod.AimModes.Length - 1;
        }
        else
        {
            nIndex = Mod.Level - 1;
        }
        Weapon.AimModes.Length = 0;
        Weapon.AimModes.AddItem(Mod.AimModes[nIndex]);
    }
    if (Mod.Camera != None)
    {
        Weapon.CameraSetup = Mod.Camera;
    }
    Mod.ApplyEffects();
    WeaponMods.AddItem(Mod);
    SetWeaponModHidden(TRUE);
    return TRUE;
}
public final function RemoveAllMods()
{
    local int idx;
    
    for (idx = WeaponMods.Length - 1; idx >= 0; idx--)
    {
        RemoveMod(WeaponMods[idx].Class);
    }
}
public function bool RemoveMod(Class<SFXWeaponMod> ModClass)
{
    local SFXWeapon Weapon;
    local SkeletalMeshComponent oSkeletalMesh;
    local SFXModule_GameEffectManager GEManager;
    local int nIndex;
    local SFXWeaponMod Mod;
    local MeshComponent MeshComp;
    local int ExtraMeshIdx;
    local Class<SFXGameEffect> EffectClass;
    
    for (nIndex = WeaponMods.Length - 1; nIndex >= 0; nIndex--)
    {
        if (WeaponMods[nIndex].Class == ModClass)
        {
            Mod = WeaponMods[nIndex];
            WeaponMods.Remove(nIndex, 1);
            break;
        }
    }
    if (Mod == None)
    {
        return FALSE;
    }
    Weapon = SFXWeapon(Outer);
    if (Weapon == None)
    {
        return FALSE;
    }
    GEManager = Weapon.GetModule(Class'SFXModule_GameEffectManager');
    if (GEManager == None)
    {
        return FALSE;
    }
    oSkeletalMesh = SkeletalMeshComponent(Weapon.Mesh);
    if (oSkeletalMesh != None && Mod.Meshes.Length > 0)
    {
        foreach Mod.Meshes(MeshComp, )
        {
            oSkeletalMesh.DetachComponent(MeshComp);
        }
        ExtraMeshIdx = ExtraMeshComponents.Find('Mod', Mod);
        if (ExtraMeshIdx != -1)
        {
            for (nIndex = 0; nIndex < ExtraMeshComponents[ExtraMeshIdx].ExtraMeshes.Length; nIndex++)
            {
                oSkeletalMesh.DetachComponent(ExtraMeshComponents[ExtraMeshIdx].ExtraMeshes[nIndex]);
            }
            ExtraMeshComponents.Remove(ExtraMeshIdx, 1);
        }
    }
    for (nIndex = 0; nIndex < Mod.GameEffects.Length; nIndex++)
    {
        EffectClass = Mod.GetGameEffectClass(Mod.GameEffects[nIndex].EffectClassName);
        if (EffectClass != None)
        {
            GEManager.RemoveEffectsByTypeAndCategory(EffectClass, Mod.Name);
        }
    }
    Mod.RemoveEffects();
    Weapon.ClearWeaponModMaterialParameters();
    Weapon.GUIZoomReticleClass = Weapon.default.GUIZoomReticleClass;
    Weapon.AimModes = Weapon.default.AimModes;
    Weapon.CameraSetup = Weapon.default.CameraSetup;
    return TRUE;
}
public final function SetWeaponModHidden(bool bHidden)
{
    local SFXWeaponMod Mod;
    local MeshComponent MeshComp;
    local int idx;
    local int ExtraMeshIdx;
    
    foreach WeaponMods(Mod, )
    {
        foreach Mod.Meshes(MeshComp, )
        {
            MeshComp.SetHidden(bHidden);
        }
        ExtraMeshIdx = ExtraMeshComponents.Find('Mod', Mod);
        if (ExtraMeshIdx != -1)
        {
            for (idx = 0; idx < ExtraMeshComponents[ExtraMeshIdx].ExtraMeshes.Length; idx++)
            {
                ExtraMeshComponents[ExtraMeshIdx].ExtraMeshes[idx].SetHidden(bHidden);
            }
        }
        Mod.OnVisibilityChanged(bHidden);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}