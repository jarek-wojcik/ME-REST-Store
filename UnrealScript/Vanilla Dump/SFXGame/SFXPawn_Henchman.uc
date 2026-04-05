Class SFXPawn_Henchman extends SFXPawn_PlayerParty
    placeable
    abstract
    config(Game);

var(SFXPawn_Henchman) array<Class<SFXGameEffect>> ArmorBonuses;
var(SFXPawn_Henchman) array<stringref> ArmorBonusStrings;
var config array<HenchmanInfoStruct> HenchmenInfo;
var(SFXPawn_Henchman) Name m_nmMappedPower;
var transient float PowerUseDelay;
var(SFXPawn_Henchman) Texture2D m_GUI_Icon;

public event simulated function BioBaseRemovedFromWorld()
{
    local string Msg;
    local SFXAI_Henchman AI;
    
    if (Role == ENetRole.ROLE_Authority)
    {
        AI = SFXAI_Henchman(Controller);
        if (AI != None && AI.m_bResetHenchman)
        {
            return;
        }
        if (bNoTick || bTickIsDisabled)
        {
        }
        else if (Physics == EPhysics.PHYS_Interpolating)
        {
        }
        else if (Class'SFXModule_Conversation'.static.ScriptIsInConversation(Self))
        {
        }
        else
        {
            if (WorldInfo.IsShippingPCBuild() == FALSE)
            {
                Msg = Self.Tag $ " lost its flooring. The henchman will be teleported to the player.";
                appScreenDebugMessage(Msg);
            }
            EnsurePawnIsUpright(TRUE);
        }
    }
}
public event simulated function FellOutOfWorld(Class<DamageType> dmgType)
{
    local string Msg;
    local SFXAI_Henchman AI;
    
    if (Role == ENetRole.ROLE_Authority)
    {
        AI = SFXAI_Henchman(Controller);
        if (AI != None && AI.m_bResetHenchman)
        {
            return;
        }
        if (bNoTick || bTickIsDisabled)
        {
        }
        else if (Physics == EPhysics.PHYS_Interpolating)
        {
        }
        else if (Class'SFXModule_Conversation'.static.ScriptIsInConversation(Self))
        {
        }
        else if (InCombat() && IsDead())
        {
        }
        else
        {
            if (WorldInfo.IsShippingPCBuild() == FALSE)
            {
                Msg = Self.Tag $ " fell out of world. The henchman will be teleported to the player.";
                appScreenDebugMessage(Msg);
            }
            EnsurePawnIsUpright(TRUE);
        }
    }
}
public function Texture2D GetGUIIcon()
{
    return m_GUI_Icon;
}
public simulated function bool InCombat()
{
    local SFXGRI GRI;
    
    GRI = SFXGRI(WorldInfo.GRI);
    if (GRI != None)
    {
        return GRI.InCombat();
    }
    return FALSE;
}
public event simulated function OutsideWorldBounds()
{
    local string Msg;
    local SFXAI_Henchman AI;
    
    if (Role == ENetRole.ROLE_Authority)
    {
        AI = SFXAI_Henchman(Controller);
        if (AI != None && AI.m_bResetHenchman)
        {
            return;
        }
        if (WorldInfo.IsShippingPCBuild() == FALSE)
        {
            Msg = Self.Tag $ " moved out of world bounds. The henchman will be teleported to the player.";
            appScreenDebugMessage(Msg);
        }
        EnsurePawnIsUpright(TRUE);
    }
}
public simulated function PostBeginPlay()
{
    local SFXModule_Radar RadarMod;
    local SFXDifficultyHandler DH;
    local SFXModule_GameEffectManager Manager;
    
    if (GetModule(Class'SFXModule_Radar') == None)
    {
        RadarMod = new (Self) Class'SFXModule_Radar';
        RadarMod.RadarType = EBioRadarType.BRT_Pawn_Friendly;
        AddSFXModule(RadarMod);
    }
    DH = SFXGRI(WorldInfo.GRI).DifficultyHandler;
    Manager = GetModule(Class'SFXModule_GameEffectManager');
    if (DH != None && Manager != None)
    {
        Manager.CreateAndApplyEffect(Class'SFXGameEffect_DamageTakenBonus', 'HenchDamageTaken', 0.0, 2, DH.GetFloat('HenchDamageTaken', 'Global'), Controller, Self);
    }
    Super.PostBeginPlay();
}
public event function bool Resurrect(float PercentOfHealthRegained, bool bIsInstantaneous)
{
    if (IsDead() == FALSE)
    {
        return FALSE;
    }
    if (Physics != EPhysics.PHYS_RigidBody && Mesh == CollisionComponent)
    {
        SetPhysics(10);
    }
    return Super.Resurrect(PercentOfHealthRegained, bIsInstantaneous);
}
public function bool ValidateRagdoll()
{
    return TRUE;
}
public function ApplyArmorBonuses()
{
    local Class<SFXGameEffect> EffectClass;
    local SFXModule_GameEffectManager GEManager;
    
    GEManager = GetModule(Class'SFXModule_GameEffectManager');
    if (GEManager == None)
    {
        return;
    }
    GEManager.RemoveEffectsByCategory('HenchmanArmorBonus');
    foreach ArmorBonuses(EffectClass, )
    {
        GEManager.CreateAndApplyEffect(EffectClass, 'HenchmanArmorBonus', 0.0, 2, EffectClass.default.EffectValue, Self.Controller);
    }
}
public simulated function bool CanPlayDeathEffect()
{
    return FALSE;
}
public function bool CreateWeapon(Class<SFXWeapon> WeaponClass, optional bool bEquipWeapon = FALSE)
{
    local bool bRetval;
    local SFXEngine Engine;
    local int idx;
    local int Idx2;
    local SFXModule_WeaponModManager ModManager;
    local SFXWeapon NewWeapon;
    local Class<SFXWeaponMod> ModClass;
    local int HenchRecordIndex;
    local int ModLevel;
    
    bRetval = Super(BioPawn).CreateWeapon(WeaponClass, bEquipWeapon);
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Engine == None)
    {
        return bRetval;
    }
    if (Engine != None)
    {
        Engine.CurrentSaveGame.EnsureHenchmanRecordExists(Self);
        for (idx = 0; idx < Engine.HenchmanRecords.Length; idx++)
        {
            if (Engine.HenchmanRecords[idx].Tag == Tag)
            {
                HenchRecordIndex = idx;
                break;
            }
        }
    }
    idx = Engine.HenchmanRecords[HenchRecordIndex].WeaponMods.Find('WeaponClassName', Name(PathName(WeaponClass)));
    if (idx >= 0 && InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXWeapon', NewWeapon)
        {
            if (NewWeapon.Class != WeaponClass)
            {
                continue;
            }
            ModManager = NewWeapon.GetModule(Class'SFXModule_WeaponModManager');
            if (ModManager == None)
            {
                continue;
            }
            ModManager.RemoveAllMods();
            for (Idx2 = 0; Idx2 < Engine.HenchmanRecords[HenchRecordIndex].WeaponMods[idx].WeaponModClassNames.Length; Idx2++)
            {
                ModClass = Class'SFXWeaponMod'.static.LoadModClass(string(Engine.HenchmanRecords[HenchRecordIndex].WeaponMods[idx].WeaponModClassNames[Idx2]));
                if (ModClass != None && ModClass.static.IsUnlocked(ModLevel))
                {
                    ModManager.AddMod(ModClass, ModLevel);
                }
            }
        }
    }
    return bRetval;
}
public function CreateWeapons(SFXLoadoutData ChkLoadout, optional bool bForceFromEngineLoadout)
{
    local int i;
    local BioPlayerController PC;
    local SFXEngine Engine;
    local Class<SFXWeapon> WClass;
    local int HenchRecordIndex;
    local Name WClassName;
    
    PC = BioWorldInfo(WorldInfo).GetLocalPlayerController();
    Engine = SFXEngine(PC.Player.Outer);
    if (Engine != None)
    {
        Engine.CurrentSaveGame.EnsureHenchmanRecordExists(Self);
        for (i = 0; i < Engine.HenchmanRecords.Length; i++)
        {
            if (Engine.HenchmanRecords[i].Tag == Tag)
            {
                HenchRecordIndex = i;
                break;
            }
        }
    }
    for (i = 0; i < 6; i++)
    {
        if (Class'SFXPlayerSquadLoadoutData'.static.CanHenchmanUseWeaponGroup(Tag, byte(i)))
        {
            if (Engine != None && Engine.HenchmanRecords[HenchRecordIndex].LoadoutWeapons[i] != 'None')
            {
                WClassName = Engine.HenchmanRecords[HenchRecordIndex].LoadoutWeapons[i];
            }
            else
            {
                WClassName = Class'SFXPlayerSquadLoadoutData'.static.GetWeaponGroup(i)[0].className;
                if (Engine != None)
                {
                    Engine.HenchmanRecords[HenchRecordIndex].LoadoutWeapons[i] = WClassName;
                }
            }
            WClass = Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(WClassName);
            if (WClass != None)
            {
                CreateWeapon(WClass);
            }
        }
    }
}
public function bool GetAttackOrderPower(out SFXPowerCustomActionBase Power)
{
    Power = PowerManager.GetPower(m_nmMappedPower);
    return Power != None;
}
public static function GetDefaultLoadout(Name HTag, out Name DLoadout[6])
{
    local array<LoadoutWeaponInfo> WeaponGroup;
    local LoadoutWeaponInfo WeaponInfo;
    local int idx;
    local int WIdx;
    local Name WClassName;
    
    for (idx = 0; idx < 6; idx++)
    {
        if (Class'SFXPlayerSquadLoadoutData'.static.CanHenchmanUseWeaponGroup(HTag, byte(idx)))
        {
            WeaponGroup = Class'SFXPlayerSquadLoadoutData'.static.GetWeaponGroup(idx);
            WClassName = 'None';
            for (WIdx = 0; WIdx < WeaponGroup.Length; WIdx++)
            {
                WeaponInfo = WeaponGroup[WIdx];
                if (Class'SFXPlayerSquadLoadoutData'.static.CanHenchmanUseWeaponClass2(HTag, WeaponInfo.className))
                {
                    if (Class'SFXPlayerSquadLoadoutData'.static.FindWeaponClass(WeaponInfo.className) != None)
                    {
                        WClassName = WeaponInfo.className;
                        break;
                    }
                }
            }
            if (WClassName != 'None')
            {
                DLoadout[idx] = WClassName;
            }
        }
    }
}
public function int GetScaledLevel()
{
    return 1;
}
public function Name GetUIAppearanceTag()
{
    return Tag;
}
public function InitializeHenchman(int DesiredLevel)
{
    local BioWorldInfo BWI;
    local BioPlayerController PC;
    local SFXEngine Engine;
    local int idx;
    local int WeaponIdx;
    local SFXWeapon CurrentWeapon;
    local SFXPowerCustomAction_AmmoPowerBase AmmoPower;
    local SFXPowerCustomActionBase PowerBase;
    local SFXPowerCustomAction Power;
    
    BWI = BioWorldInfo(WorldInfo);
    PC = BWI.GetLocalPlayerController();
    if (PC != None)
    {
        Engine = SFXEngine(PC.Player.Outer);
    }
    Engine.CurrentSaveGame.LoadHenchman(Self);
    SpawnDefaultWeapons();
    if (CharacterLevel != DesiredLevel)
    {
        Class'BioLevelUpSystem'.static.LevelUpBioPawn(Self, DesiredLevel);
    }
    ApplyArmorBonuses();
    if (InvManager != None)
    {
        idx = Engine.HenchmanRecords.Find('Tag', Tag);
        if (idx != -1)
        {
            foreach InvManager.InventoryActors(Class'SFXWeapon', CurrentWeapon)
            {
                if (SFXHeavyWeapon(CurrentWeapon) == None)
                {
                    WeaponIdx = Engine.HenchmanRecords[idx].Weapons.Find('WeaponClassName', CurrentWeapon.Class.Name);
                    if (WeaponIdx != -1)
                    {
                        if (Engine.HenchmanRecords[idx].Weapons[WeaponIdx].AmmoPowerName != 'None' && Engine.HenchmanRecords[idx].Weapons[WeaponIdx].AmmoPowerSourceTag != 'None')
                        {
                            AmmoPower = Class'SFXPowerCustomAction_AmmoPowerBase'.static.GetSourceAmmoPower(Engine.HenchmanRecords[idx].Weapons[WeaponIdx].AmmoPowerName, Engine.HenchmanRecords[idx].Weapons[WeaponIdx].AmmoPowerSourceTag);
                            if (AmmoPower != None)
                            {
                                AmmoPower.ReloadAmmoPower(Self, CurrentWeapon);
                            }
                        }
                        if (Engine.HenchmanRecords[idx].Weapons[WeaponIdx].bCurrentWeapon && InvManager != None)
                        {
                            SFXInventoryManager(InvManager).CurrentWeaponSelection = CurrentWeapon.Class;
                        }
                    }
                }
            }
        }
    }
    foreach PowerManager.Powers(PowerBase, )
    {
        Power = SFXPowerCustomAction(PowerBase);
        if (Power != None)
        {
            Power.RestoreSaveState();
        }
    }
}
public simulated function PlayDeathVocalization(BioPawn Killer)
{
    SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(23, Self, Killer);
    SFXGRI(WorldInfo.GRI).TriggerVocalizationEvent(27, Self, Killer, 2.0);
}
public function Revive(Actor User)
{
    Self.Resurrect(1.0, FALSE);
}
public simulated function ShieldsDown()
{
    local SFXModule_GameEffectManager Manager;
    
    if (HasAnyShieldResistance())
    {
        return;
    }
    Manager = GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        if (Manager.HasEffectOfCategory('ShieldsDown'))
        {
            return;
        }
    }
}
public simulated function ShieldsUp()
{
    local SFXModule_GameEffectManager Manager;
    
    if (HasAnyShieldResistance() == FALSE)
    {
        return;
    }
    Manager = GetModule(Class'SFXModule_GameEffectManager');
    if (Manager != None)
    {
        Manager.RemoveEffectsByCategory('ShieldsDown');
    }
}
public function SpawnDefaultWeapons()
{
    local SFXInventoryManager InventoryManager;
    local SFXWeapon DefaultWeapon;
    local BioPawn PlayerPawn;
    
    InventoryManager = SFXInventoryManager(InvManager);
    if (InventoryManager != None && InventoryManager.FindInventoryType(Class'SFXWeapon', TRUE) == None)
    {
        CreateWeapons(None);
        ScaleWeapons(Loadout, GetScaledLevel());
        DefaultWeapon = SFXWeapon(InventoryManager.FindInventoryType(Class'SFXWeapon', TRUE));
        if (DefaultWeapon != None)
        {
            InventoryManager.CurrentWeaponSelection = DefaultWeapon.Class;
        }
    }
    if (Squad != None && Squad.Members.Length > 0)
    {
        PlayerPawn = BioPawn(Squad.Members[0]);
    }
    if (PlayerPawn == None || PlayerPawn.bCombatPawn)
    {
        InventoryManager.SetWeaponBySelected();
    }
}

simulated state Downed 
{
    public event simulated function EndState(Name NextStateName)
    {
        local SFXModule_Marker ModuleMarkerIter;
        local SFXModule ModuleIter;
        local SFXModule_MarkerPlayer ModuleMarkerPlayer;
        
        Super.EndState(NextStateName);
        ModuleMarkerPlayer = GetModule(Class'SFXModule_MarkerPlayer');
        if (ModuleMarkerPlayer != None)
        {
            ModuleMarkerPlayer.UpdatePlayerDownState(FALSE);
            ModuleMarkerPlayer.Deactivate();
            RemoveSFXModule(ModuleMarkerPlayer);
        }
        foreach Modules(ModuleIter, )
        {
            ModuleMarkerIter = SFXModule_Marker(ModuleIter);
            if (ModuleMarkerIter != None && ModuleMarkerIter != ModuleMarkerPlayer)
            {
                ModuleMarkerIter.Activate();
            }
        }
    }
    public event simulated function BeginState(Name PreviousStateName)
    {
        local SFXModule_Marker ModuleMarkerIter;
        local SFXModule ModuleIter;
        local SFXModule_MarkerPlayer ModuleMarkerPlayer;
        
        Super.BeginState(PreviousStateName);
        foreach Modules(ModuleIter, )
        {
            ModuleMarkerIter = SFXModule_Marker(ModuleIter);
            if (ModuleMarkerIter != None && ModuleMarkerIter.bActive)
            {
                ModuleMarkerIter.Deactivate();
            }
        }
        ModuleMarkerPlayer = new Class'SFXModule_MarkerPlayer';
        if (ModuleMarkerPlayer != None)
        {
            ModuleMarkerPlayer.GUIMarkerClass = Class'SFXGUIValue_MarkerHenchman';
            ModuleMarkerPlayer.MarkerType = "Henchman";
            AddSFXModule(ModuleMarkerPlayer);
            ModuleMarkerPlayer.Activate();
            ModuleMarkerPlayer.UpdatePlayerDownState(TRUE);
        }
    }
    public event simulated function bool CanDoCustomAction(int CAction, optional Pawn Sync, optional bool bForced, optional int PowerCustomAction)
    {
        if (CAction != 0)
        {
            return FALSE;
        }
        return Global.CanDoCustomAction(CAction, Sync, bForced, PowerCustomAction);
    }
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BioDynamicLightEnvironmentComponent Name=BioLightEnvComponent0
    End Template
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=FootstepShakeFF0
    End Template
    Begin Object Class=SFXLoadoutData Name=HenchLoadout0
    End Object
    Begin Template Class=SFXModule_AimAssistTarget Name=AimAssistMod
    End Template
    Begin Template Class=SFXModule_Audio Name=AudioModule
    End Template
    Begin Template Class=SFXModule_Conversation Name=ConvoMod01
    End Template
    Begin Object Class=SFXModule_DamageParty Name=DmgMod1
        MaxHealth = {X = 500.0, Y = 500.0}
    End Object
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_Gestures Name=GestMod01
        Begin Template Class=BioGestureAnimSetMgr Name=oAnimSetMgr
        End Template
        m_pAnimSetMgr = oAnimSetMgr
    End Template
    Begin Template Class=SFXModule_Locomotion Name=Locomotion0
    End Template
    Begin Template Class=SFXModule_LookAt Name=LookAtMod01
    End Template
    Begin Object Class=SFXModule_Radar Name=RadarMod1
        RadarType = EBioRadarType.BRT_Pawn_Friendly
    End Object
    Begin Template Class=SFXModule_Radar Name=RadarModule
    End Template
    Begin Template Class=SFXModule_Timeline Name=TimelineMod0
    End Template
    Begin Template Class=SFXPowerManager Name=PowerMgr
    End Template
    Begin Template Class=SkeletalMeshComponent Name=BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=GearMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=HairMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=HeadMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    HenchmenInfo = ({
                     className = 'SFXPawn_Garrus', 
                     Tag = 'hench_garrus', 
                     PrettyName = $178197, 
                     AlternatePrettyName = $0, 
                     AlternateHenchNamePlotFlag = 'None', 
                     HenchAcquiredPlotID = 17681, 
                     HenchInSquadPlotID = 17666, 
                     HenchmanImage = "GUI_Codex_Images.Garrus_512"
                    }, 
                    {
                     className = 'SFXPawn_Tali', 
                     Tag = 'hench_tali', 
                     PrettyName = $178203, 
                     AlternatePrettyName = $0, 
                     AlternateHenchNamePlotFlag = 'None', 
                     HenchAcquiredPlotID = 17838, 
                     HenchInSquadPlotID = 17836, 
                     HenchmanImage = "GUI_Codex_Images.Tali_512"
                    }, 
                    {
                     className = 'SFXPawn_Liara', 
                     Tag = 'hench_liara', 
                     PrettyName = $362749, 
                     AlternatePrettyName = $0, 
                     AlternateHenchNamePlotFlag = 'None', 
                     HenchAcquiredPlotID = 17678, 
                     HenchInSquadPlotID = 17663, 
                     HenchmanImage = ""
                    }, 
                    {
                     className = 'SFXPawn_Ashley', 
                     Tag = 'hench_ashley', 
                     PrettyName = $206249, 
                     AlternatePrettyName = $0, 
                     AlternateHenchNamePlotFlag = 'None', 
                     HenchAcquiredPlotID = 17680, 
                     HenchInSquadPlotID = 17665, 
                     HenchmanImage = ""
                    }, 
                    {
                     className = 'SFXPawn_Kaidan', 
                     Tag = 'hench_kaidan', 
                     PrettyName = $188702, 
                     AlternatePrettyName = $0, 
                     AlternateHenchNamePlotFlag = 'None', 
                     HenchAcquiredPlotID = 17679, 
                     HenchInSquadPlotID = 17664, 
                     HenchmanImage = ""
                    }, 
                    {
                     className = 'SFXPawn_EDI', 
                     Tag = 'hench_edi', 
                     PrettyName = $188353, 
                     AlternatePrettyName = $0, 
                     AlternateHenchNamePlotFlag = 'None', 
                     HenchAcquiredPlotID = 17682, 
                     HenchInSquadPlotID = 17667, 
                     HenchmanImage = ""
                    }, 
                    {
                     className = 'SFXPawn_Prothean', 
                     Tag = 'hench_prothean', 
                     PrettyName = $500142, 
                     AlternatePrettyName = $0, 
                     AlternateHenchNamePlotFlag = 'None', 
                     HenchAcquiredPlotID = 17683, 
                     HenchInSquadPlotID = 17668, 
                     HenchmanImage = ""
                    }, 
                    {
                     className = 'SFXPawn_Marine', 
                     Tag = 'hench_marine', 
                     PrettyName = $500147, 
                     AlternatePrettyName = $0, 
                     AlternateHenchNamePlotFlag = 'None', 
                     HenchAcquiredPlotID = 17694, 
                     HenchInSquadPlotID = 17692, 
                     HenchmanImage = ""
                    }, 
                    {
                     className = 'SFXPawn_Anderson', 
                     Tag = 'hench_anderson', 
                     PrettyName = $505372, 
                     AlternatePrettyName = $0, 
                     AlternateHenchNamePlotFlag = 'None', 
                     HenchAcquiredPlotID = 0, 
                     HenchInSquadPlotID = 0, 
                     HenchmanImage = ""
                    }
                   )
    PowerUseDelay = 5.0
    FootstepForceFeedback = FootstepShakeFF0
    bAllowHeadGib = FALSE
    bCanPartialLean = TRUE
    CustomActionClasses = (None, 
                           Class'SFXCustomAction_Ragdoll', 
                           None, 
                           Class'SFXCustomAction_SyncPawnPartner_Base', 
                           None, 
                           None, 
                           None, 
                           None, 
                           Class'SFXCustomAction_Frozen', 
                           None, 
                           Class'SFXCustomAction_MountedGunReload', 
                           Class'SFXCustomAction_HolsterWeapon', 
                           Class'SFXCustomAction_DrawWeapon', 
                           Class'SFXCustomAction_EnterMountedGun', 
                           Class'SFXCustomAction_ExitMountedGun', 
                           None, 
                           Class'SFXCustomAction_PrecisionMove', 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           Class'SFXCustomAction_MoveAlongCover', 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           Class'SFXCustomAction_SwatTurn_Left', 
                           Class'SFXCustomAction_SwatTurn_Right'
                          )
    SupportedCustomReachSpecs = (Class'SFXLadderReachSpec', Class'SFXJumpReachSpec', Class'SFXJumpDownReachSpec')
    HeadMesh = HeadMesh0
    m_oHairMesh = HairMesh0
    m_oHeadGearMesh = GearMesh0
    LightEnvironment = BioLightEnvComponent0
    m_fPowerUsePercent = 0.5
    Loadout = HenchLoadout0
    PowerManager = PowerMgr
    bOverrideBodyMats = TRUE
    bShouldSpawnWeapons = FALSE
    bScalePowers = FALSE
    ControllerClass = Class'SFXAI_Henchman'
    MeleeRange = 50.0
    Mesh = BioPawnSkeletalMeshComponent
    CylinderComponent = CollisionCylinder
    bCanMantle = TRUE
    bCanClimbUp = TRUE
    bCanSwatTurn = TRUE
    bCanCoverSlip = TRUE
    Components = (CollisionCylinder, None, BioLightEnvComponent0, BioPawnSkeletalMeshComponent, HeadMesh0, HairMesh0, GearMesh0)
    Modules = (GEMod0, 
               RadarModule, 
               AimAssistMod, 
               GestMod01, 
               ConvoMod01, 
               LookAtMod01, 
               AudioModule, 
               TimelineMod0, 
               Locomotion0, 
               RadarMod1, 
               DmgMod1
              )
    CollisionComponent = CollisionCylinder
}