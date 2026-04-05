Class SFXPawn_Liara extends SFXPawn_Henchman
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
        m_srGameName = $524654
    End Template
    Begin Template Class=SFXModule_Locomotion Name=Locomotion0
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
    Begin Template Class=SFXModule_Timeline Name=TimelineMod0
    End Template
    Begin Template Class=SFXModule_DamageParty Name=DmgMod1
        MaxHealth = {X = 200.0, Y = 200.0}
    End Template
    Begin Template Class=SFXModule_Radar Name=RadarMod1
    End Template
    Begin Template Class=SFXModule_Audio Name=AudioModule
    End Template
    Begin Template Class=SFXLoadoutData Name=HenchLoadout0
        Weapons = (Class'SFXWeapon_SMG_Tempest')
        ShieldLoadouts = ({
                           Shields = Class'SFXShield_Biotic_Player', 
                           ShieldLevelRange = {X = 0.0, Y = 0.0}, 
                           MaxShields = {X = 500.0, Y = 500.0}
                          }
                         )
    End Template
    Begin Template Class=SFXPowerManager Name=PowerMgr
    End Template
    m_GUI_Icon = Texture2D'GUI_Icons.CharacterPortraits.Icon_Liara0'
    PowerUnlockRequirements = ({RequiredPowerClass = None, PowerClass = Class'SFXPowerCustomAction_Stasis', Rank = 0.0, RequiredLevel = 3, CustomUnlockText = $0}, 
                               {RequiredPowerClass = None, PowerClass = Class'SFXPowerCustomAction_Warp', Rank = 0.0, RequiredLevel = 3, CustomUnlockText = $0}
                              )
    SquadScreenPowerOrder = (Class'SFXPowerCustomAction_Singularity', Class'SFXPowerCustomAction_Stasis', Class'SFXPowerCustomAction_WarpAmmo', Class'SFXPowerCustomAction_Warp', Class'SFXPowerCustomAction_LiaraPassive')
    StartingPowerRanks = ({PowerClass = Class'SFXPowerCustomAction_Singularity', Rank = 1.0}
                         )
    AutoLevelUpInfo = ({PowerClass = Class'SFXPowerCustomAction_Singularity', Rank = 1.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_WarpAmmo', Rank = 1.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Singularity', Rank = 2.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_WarpAmmo', Rank = 2.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Stasis', Rank = 1.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Warp', Rank = 1.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Singularity', Rank = 3.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Stasis', Rank = 2.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_LiaraPassive', Rank = 1.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Singularity', Rank = 4.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Warp', Rank = 2.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Stasis', Rank = 3.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Singularity', Rank = 5.0, EvolvedChoice = 2}, 
                       {PowerClass = Class'SFXPowerCustomAction_Stasis', Rank = 4.0, EvolvedChoice = 1}, 
                       {PowerClass = Class'SFXPowerCustomAction_LiaraPassive', Rank = 2.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Stasis', Rank = 5.0, EvolvedChoice = 3}, 
                       {PowerClass = Class'SFXPowerCustomAction_Singularity', Rank = 6.0, EvolvedChoice = 4}, 
                       {PowerClass = Class'SFXPowerCustomAction_Stasis', Rank = 6.0, EvolvedChoice = 5}, 
                       {PowerClass = Class'SFXPowerCustomAction_WarpAmmo', Rank = 3.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Warp', Rank = 3.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_LiaraPassive', Rank = 3.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_WarpAmmo', Rank = 4.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_Warp', Rank = 4.0, EvolvedChoice = 0}, 
                       {PowerClass = Class'SFXPowerCustomAction_LiaraPassive', Rank = 4.0, EvolvedChoice = 1}, 
                       {PowerClass = Class'SFXPowerCustomAction_WarpAmmo', Rank = 5.0, EvolvedChoice = 2}, 
                       {PowerClass = Class'SFXPowerCustomAction_Warp', Rank = 5.0, EvolvedChoice = 2}, 
                       {PowerClass = Class'SFXPowerCustomAction_LiaraPassive', Rank = 5.0, EvolvedChoice = 3}, 
                       {PowerClass = Class'SFXPowerCustomAction_WarpAmmo', Rank = 6.0, EvolvedChoice = 4}, 
                       {PowerClass = Class'SFXPowerCustomAction_Warp', Rank = 6.0, EvolvedChoice = 5}, 
                       {PowerClass = Class'SFXPowerCustomAction_LiaraPassive', Rank = 6.0, EvolvedChoice = 4}
                      )
    PrettyName = $362749
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
                           Class'SFXCustomAction_CoverSlipLeft', 
                           Class'SFXCustomAction_CoverSlipLeftStanding', 
                           Class'SFXCustomAction_CoverSlipRight', 
                           Class'SFXCustomAction_CoverSlipRightStanding', 
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
                           Class'SFXCustomAction_HenchRollLeft', 
                           Class'SFXCustomAction_HenchRollRight', 
                           Class'SFXCustomAction_HenchRollForward', 
                           Class'SFXCustomAction_HenchRollBackward', 
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
                           Class'SFXCustomAction_StaggerImpact', 
                           Class'SFXCustomAction_StaggerImpactII', 
                           Class'SFXCustomAction_StaggerImpactForward', 
                           Class'SFXCustomAction_StaggerImpactLeft', 
                           Class'SFXCustomAction_StaggerImpactRight', 
                           Class'SFXCustomAction_KnockbackImpact', 
                           Class'SFXCustomAction_KnockbackImpactForward', 
                           Class'SFXCustomAction_KnockbackImpactLeft', 
                           Class'SFXCustomAction_KnockbackImpactRight', 
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
                           Class'SFXCustomAction_HenchmanMelee', 
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
                                Class'SFXPowerCustomAction_Singularity', 
                                Class'SFXPowerCustomAction_Warp', 
                                None, 
                                Class'SFXPowerCustomAction_Stasis', 
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
                                Class'SFXPowerCustomAction_WarpAmmo', 
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
                                Class'SFXPowerCustomAction_LiaraPassive'
                               )
    CombatVocVariants = (SFXVocalizationBank'VocalizationBanks.hench_liara')
    HeadMesh = HeadMesh0
    m_oHairMesh = HairMesh0
    m_oHeadGearMesh = GearMesh0
    LightEnvironment = BioLightEnvComponent0
    ExplorationVoc = SFXVocalizationBank'VocalizationBanks.hench_liara_NonCombat'
    StealthVoc = SFXVocalizationBank'VocalizationBanks.hench_liara_Stealth'
    Loadout = HenchLoadout0
    BloodColor = {B = 6, G = 2, R = 10, A = 255}
    PowerManager = PowerMgr
    ControllerClass = Class'SFXAI_Liara'
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
    Tag = 'hench_liara'
    CollisionComponent = CollisionCylinder
}