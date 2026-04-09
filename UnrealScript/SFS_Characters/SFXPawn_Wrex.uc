Class SFXPawn_Wrex extends SFXPawn_Henchman_Citadel
    placeable
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    Begin Template Class=BioDynamicLightEnvironmentComponent Name=BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=SkeletalMeshComponent Name=HeadMesh0
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
    Begin Template Class=SkeletalMeshComponent Name=GearMesh0
        ParentAnimComponent = BioPawnSkeletalMeshComponent
        ShadowParent = BioPawnSkeletalMeshComponent
        ReplacementPrimitive = None
        LightEnvironment = BioLightEnvComponent0
    End Template
    Begin Template Class=ForceFeedbackWaveform Name=FootstepShakeFF0
    End Template
    Begin Template Class=SFXModule_GameEffectManager Name=GEMod0
    End Template
    Begin Template Class=SFXModule_Radar Name=RadarModule
    End Template
    Begin Template Class=SFXModule_AimAssistTarget Name=AimAssistMod
        m_srGameName = $214249
    End Template
    Begin Template Class=SFXModule_Gestures Name=GestMod01
        Begin Template Class=BioGestureAnimSetMgr Name=oAnimSetMgr
        End Template
        m_pAnimSetMgr = oAnimSetMgr
    End Template
    Begin Template Class=SFXModule_Conversation Name=ConvoMod01
    End Template
    Begin Template Class=SFXModule_LookAt Name=LookAtMod01
    End Template
    Begin Template Class=SFXModule_Audio Name=AudioModule
    End Template
    Begin Template Class=SFXModule_Timeline Name=TimelineMod0
    End Template
    Begin Template Class=SFXModule_Locomotion Name=Locomotion0
    End Template
    Begin Template Class=SFXModule_Radar Name=RadarMod1
    End Template
    Begin Template Class=SFXModule_DamageParty Name=DmgMod1
        MaxHealth = {X = 1000.0, Y = 1000.0}
    End Template
    Begin Template Class=SFXLoadoutData Name=HenchLoadout0
        Weapons = (Class'SFXWeapon_Shotgun_Graal')
        ShieldLoadouts = ({
                           Shields = Class'SFXShield_Biotic_Player', 
                           ShieldLevelRange = {X = 0.0, Y = 0.0}, 
                           MaxShields = {X = 600.0, Y = 600.0}
                          }
                         )
    End Template
    Begin Template Class=SFXPowerManager Name=PowerMgr
    End Template
    m_GUI_Icon = Texture2D'DLC_MPImages.GUI_Portrait.Icon_Wrex'
    SquadScreenPowerOrder = (Class'SFXPowerCustomAction_Carnage', Class'SFXPowerCustomAction_LiftGrenade', Class'SFXPowerCustomAction_Barrier', Class'SFXPowerCustomAction_StimPack', Class'SFXPowerCustomAction_WrexPassive')
    AutoLevelUpInfo = ({PowerClass = Class'SFXPowerCustomAction_Carnage', Rank = 1.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_LiftGrenade', Rank = 1.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_StimPack', Rank = 1.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_WrexPassive', Rank = 1.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Carnage', Rank = 2.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_LiftGrenade', Rank = 2.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Carnage', Rank = 3.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_StimPack', Rank = 2.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_WrexPassive', Rank = 2.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Carnage', Rank = 4.0, EvolvedChoice = 1}, 
                       {PowerClass = Class'SFXPowerCustomAction_LiftGrenade', Rank = 3.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Carnage', Rank = 5.0, EvolvedChoice = 3}, 
                       {PowerClass = Class'SFXPowerCustomAction_Barrier', Rank = 1.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_LiftGrenade', Rank = 4.0, EvolvedChoice = 1}, 
                       {PowerClass = Class'SFXPowerCustomAction_LiftGrenade', Rank = 5.0, EvolvedChoice = 2}, 
                       {PowerClass = Class'SFXPowerCustomAction_WrexPassive', Rank = 3.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_WrexPassive', Rank = 4.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_WrexPassive', Rank = 5.0, EvolvedChoice = 3}, 
                       {PowerClass = Class'SFXPowerCustomAction_WrexPassive', Rank = 6.0, EvolvedChoice = 5}, 
                       {PowerClass = Class'SFXPowerCustomAction_StimPack', Rank = 3.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_StimPack', Rank = 4.0, EvolvedChoice = 1}, 
                       {PowerClass = Class'SFXPowerCustomAction_StimPack', Rank = 5.0, EvolvedChoice = 2}, 
                       {PowerClass = Class'SFXPowerCustomAction_Barrier', Rank = 2.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Barrier', Rank = 3.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Barrier', Rank = 4.0, EvolvedChoice = 1}, 
                       {PowerClass = Class'SFXPowerCustomAction_Barrier', Rank = 5.0, EvolvedChoice = 3}, 
                       {PowerClass = Class'SFXPowerCustomAction_Barrier', Rank = 6.0, EvolvedChoice = 4}, 
                       {PowerClass = Class'SFXPowerCustomAction_LiftGrenade', Rank = 6.0, EvolvedChoice = 5}, 
                       {PowerClass = Class'SFXPowerCustomAction_StimPack', Rank = 6.0, EvolvedChoice = 5}, 
                       {PowerClass = Class'SFXPowerCustomAction_Carnage', Rank = 6.0, EvolvedChoice = 5}
                      )
    PrettyName = $214249
    FootstepForceFeedback = FootstepShakeFF0
    CustomActionClasses = (None, 
                           Class'SFXCustomAction_Ragdoll', 
                           None, 
                           Class'SFXCustomAction_SyncPawnPartner_Base', 
                           None, 
                           None, 
                           None, 
                           None, 
                           Class'SFXCustomAction_Frozen', 
                           Class'SFXCustomAction_Reload', 
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
                           Class'SFXCustomAction_StandingGapJump', 
                           None, 
                           Class'SFXCustomAction_JumpDown', 
                           Class'SFXCustomAction_AIMantleOverCover', 
                           None, 
                           Class'SFXCustomAction_AIMantleUp', 
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
                           Class'SFXCustomAction_SwatTurn_Right', 
                           Class'SFXCustomAction_AILadderClimbUp', 
                           Class'SFXCustomAction_AILadderClimbDown', 
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
                           Class'SFXCustomAction_StandardImpact', 
                           Class'SFXCustomAction_StandardImpactII', 
                           Class'SFXCustomAction_StandardImpactForward', 
                           Class'SFXCustomAction_StandardImpactLeft', 
                           Class'SFXCustomAction_StandardImpactRight', 
                           Class'SFXCustomAction_StandardImpactKnee', 
                           Class'SFXCustomAction_StandardImpact', 
                           Class'SFXCustomAction_StandardImpactII', 
                           Class'SFXCustomAction_StandardImpactForward', 
                           Class'SFXCustomAction_StandardImpactLeft', 
                           Class'SFXCustomAction_StandardImpactRight', 
                           Class'SFXCustomAction_StandardImpact', 
                           Class'SFXCustomAction_StandardImpactForward', 
                           Class'SFXCustomAction_StandardImpactLeft', 
                           Class'SFXCustomAction_StandardImpactRight', 
                           Class'SFXCustomAction_Meleed', 
                           Class'SFXCustomAction_MeleedForward', 
                           Class'SFXCustomAction_MeleedLeft', 
                           Class'SFXCustomAction_MeleedRight', 
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
                           Class'SFXCustomAction_WrexPunch', 
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
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           None, 
                           Class'SFXCustomAction_HenchOmniTool', 
                           Class'SFXCustomAction_HenchStandTyping', 
                           Class'SFXCustomAction_CustomLoopingInteraction', 
                           Class'SFXCustomAction_HenchBeckonFront', 
                           Class'SFXCustomAction_HenchBeckonRear', 
                           Class'SFXCustomAction_HenchOmniToolCrouch', 
                           Class'SFXCustomAction_HenchCrouch', 
                           Class'SFXCustomAction_HenchInteractLow', 
                           Class'SFXCustomAction_HenchStandIdle'
                          )
    PowerCustomActionClasses = (None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                None, 
                                Class'SFXPowerCustomAction_Barrier', 
                                None, 
                                Class'SFXPowerCustomAction_LiftGrenade', 
                                None, 
                                None, 
                                Class'SFXPowerCustomAction_Carnage', 
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
                                None, 
                                None, 
                                None, 
                                None, 
                                Class'SFXPowerCustomAction_StimPack', 
                                None, 
                                None, 
                                None, 
                                Class'SFXPowerCustomAction_WrexPassive'
                               )
    CombatVocVariants = (SFXVocalizationBank'AIBarks_DLC_Shared.hench_wrex')
    HeadMesh = HeadMesh0
    m_oHairMesh = HairMesh0
    m_oHeadGearMesh = GearMesh0
    LightEnvironment = BioLightEnvComponent0
    ExplorationVoc = SFXVocalizationBank'AIBarks_DLC_Shared.hench_wrex_NonCombat'
    StealthVoc = SFXVocalizationBank'AIBarks_DLC_Shared.hench_wrex_Stealth'
    Loadout = HenchLoadout0
    PowerManager = PowerMgr
    ControllerClass = Class'SFXAI_Wrex'
    Mesh = BioPawnSkeletalMeshComponent
    CylinderComponent = CollisionCylinder
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
    Tag = 'hench_wrex'
    CollisionComponent = CollisionCylinder
}