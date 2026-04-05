Class SFXModule_Timeline extends SFXModule;

var(SFXModule_Timeline) transient array<SFXTimelineData> Timelines;
var delegate<AOEEvalFunc> __AOEEvalFunc__Delegate;
var delegate<InputHandler> __InputHandler__Delegate;

public delegate function bool AOEEvalFunc(Actor ChkOwner, Actor ChkTarget)
{
    return TRUE;
}
public event simulated function HandlePreRemove()
{
    Super.HandlePreRemove();
    RemoveAllTimelines();
}
public delegate function InputHandler();

public static final function PrecacheVFX(SFXObjectPool ObjectPool, RvrClientEffectManager ClientEffects, SFXTimelineData Data)
{
    local int idx;
    
    if (Data != None)
    {
        for (idx = 0; idx != Data.Timeline.Length; ++idx)
        {
            if (Data.Timeline[idx].Type == ETimelineType.TLT_Visual)
            {
                ObjectPool.PrecacheGenericParticleSystemComponent(Data.Timeline[idx].PS_Template);
            }
            else if (Data.Timeline[idx].Type == ETimelineType.TLT_ClientEffect)
            {
                ClientEffects.Prime(Data.Timeline[idx].RVR_CrustTemplate);
            }
            if (Data.Timeline[idx].AOEImpactTimeline != None)
            {
                PrecacheVFX(ObjectPool, ClientEffects, Data.Timeline[idx].AOEImpactTimeline);
            }
            if (Data.Timeline[idx].TimelineTemplate != None)
            {
                PrecacheVFX(ObjectPool, ClientEffects, Data.Timeline[idx].TimelineTemplate);
            }
        }
    }
}
public simulated function Tick(float DeltaTime)
{
    local int idx;
    local SFXTimelineData CurrTimeline;
    
    if (Timelines.Length > 0)
    {
        for (idx = Timelines.Length - 1; idx >= 0; idx--)
        {
            CurrTimeline = Timelines[idx];
            UpdateTimeline(CurrTimeline, DeltaTime);
            CurrTimeline.LifetimeLeft -= DeltaTime;
            if (CurrTimeline.LifetimeLeft <= float(0))
            {
                RemoveTimeline(CurrTimeline);
            }
        }
    }
}
public final simulated function AddTimeline(SFXTimelineData Data, optional Object FuncOwner, optional Actor Source, optional Actor Target)
{
    Data.InitializeTimeline(FuncOwner);
    Data.LifetimeLeft = Data.Lifetime;
    Data.Source = Source;
    if (Data.Source == None)
    {
        Data.Source = ModuleOwner;
    }
    Data.Target = Target;
    Timelines.AddItem(Data);
}
public final simulated function ApplyTimelineEffect(SFXTimelineData Data, int idx)
{
    local SFXGame Info;
    local SFXObjectPool Pool;
    local ParticleSystemComponent PSC_Instance;
    local SFXPawn PawnTarget;
    local Actor ActorTarget;
    local SFXPlayerController PC;
    local Vector Momentum;
    local EReactionTypes TestReaction;
    local Controller Instigator;
    local Actor CollidingActor;
    local SFXPawn TargetPawn;
    local SFXPawn CollidingPawn;
    local Vector TargetLocation;
    local Actor BestTarget;
    local float TargetDistSq;
    local float BestTargetDistSq;
    local int MatchingInputIndex;
    local delegate<AOEEvalFunc> EvalAOE;
    local delegate<InputHandler> InputHandler;
    local RadialBlurComponent RBC_BlurInstance;
    local Vector ClientEffectParams;
    local int CEStartIndex;
    local Guid ClientEffectID;
    local SFXModule_GameEffectManager GEManager;
    
    Info = SFXGame(ModuleOwner.WorldInfo.Game);
    if (SFXGRI(ModuleOwner.WorldInfo.GRI) != None)
    {
        Pool = SFXGRI(ModuleOwner.WorldInfo.GRI).ObjectPool;
    }
    switch (Data.Timeline[idx].Type)
    {
        case ETimelineType.TLT_Visual:
            if (Pool != None && Data.Timeline[idx].PS_Template != None && Data.Timeline[idx].SocketName != 'None')
            {
                PSC_Instance = Pool.GetGenericParticleSystemComponent(Data.Timeline[idx].PS_Template);
                PawnTarget = SFXPawn(GetTargetActor(Data, idx));
                if (Data.Timeline[idx].bApplyBloodColorParam == TRUE)
                {
                    Pool.ApplyBloodColor(PSC_Instance, PawnTarget);
                }
                if (PSC_Instance != None)
                {
                    if (PawnTarget != None)
                    {
                        if (Data.Timeline[idx].bUseWeaponMesh == FALSE || PawnTarget.Weapon == None)
                        {
                            Pool.AttachParticleSystemComponentToSocket(PSC_Instance, PawnTarget.Mesh, Data.Timeline[idx].SocketName);
                        }
                        else
                        {
                            Pool.AttachParticleSystemComponentToSocket(PSC_Instance, PawnTarget.Weapon.Mesh, Data.Timeline[idx].SocketName);
                        }
                        PSC_Instance.SetRotation(Data.Timeline[idx].PS_Rotation);
                        PSC_Instance.SetActive(TRUE);
                        Data.Timeline[idx].PSC_Instance = PSC_Instance;
                    }
                }
            }
            break;
        case ETimelineType.TLT_ClientEffect:
            if (Data.Timeline[idx].RVR_CrustTemplate != None)
            {
                ActorTarget = GetTargetActor(Data, idx);
                if (ActorTarget != None)
                {
                    ClientEffectParams.X = Data.Timeline[idx].CrustDuration;
                    Data.Timeline[idx].ClientEffectID = Class'RvrClientEffectManager'.static.GetClientEffectManager().Start(Data.Timeline[idx].RVR_CrustTemplate, ActorTarget, ClientEffectParams);
                }
            }
            break;
        case ETimelineType.TLT_ClientEffect_Stop:
            if (Data.Timeline[idx].bCEStopAllMatching)
            {
                if (Data.Timeline[idx].RVR_CrustTemplate != None)
                {
                    ClientEffectID.A = 0;
                    ClientEffectID.B = 0;
                    ClientEffectID.C = 0;
                    ClientEffectID.D = 0;
                    Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(Data.Timeline[idx].RVR_CrustTemplate, ClientEffectID, Data.Timeline[idx].bCEAllowCooldown);
                }
            }
            else
            {
                CEStartIndex = Data.Timeline[idx].CEStartIndex;
                if (CEStartIndex >= 0 && CEStartIndex < Data.Timeline.Length)
                {
                    ClientEffectID = Data.Timeline[CEStartIndex].ClientEffectID;
                    if (ClientEffectID.A != 0 || ClientEffectID.B != 0 || ClientEffectID.C != 0 || ClientEffectID.D != 0)
                    {
                        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(Data.Timeline[idx].RVR_CrustTemplate, ClientEffectID, Data.Timeline[idx].bCEAllowCooldown);
                    }
                }
            }
            break;
        case ETimelineType.TLT_Sound:
            ActorTarget = GetTargetActor(Data, idx);
            if (ActorTarget != None)
            {
                if (Data.Timeline[idx].PlayerSound != None && Pawn(ModuleOwner) != None && Pawn(ModuleOwner).IsLocallyControlled() && Pawn(ModuleOwner).IsHumanControlled())
                {
                    ActorTarget.PlaySound(Data.Timeline[idx].PlayerSound, TRUE);
                }
                else if (Data.Timeline[idx].Sound != None)
                {
                    ActorTarget.PlaySound(Data.Timeline[idx].Sound, TRUE);
                }
            }
            break;
        case ETimelineType.TLT_Voc:
            if (Info != None && Data.Timeline[idx].VocID != ESFXVocalizationEventID.SFXVocalizationEvent_None)
            {
                if (Data.Timeline[idx].TargetType == ETimelineTarget.TRG_Source)
                {
                    SFXGRI(ModuleOwner.WorldInfo.GRI).TriggerVocalizationEvent(Data.Timeline[idx].VocID, SFXPawn(Data.Source), SFXPawn(Data.Target));
                }
                else if (Data.Timeline[idx].TargetType == ETimelineTarget.TRG_Target)
                {
                    SFXGRI(ModuleOwner.WorldInfo.GRI).TriggerVocalizationEvent(Data.Timeline[idx].VocID, SFXPawn(Data.Target), SFXPawn(Data.Source));
                }
            }
            break;
        case ETimelineType.TLT_Rumble:
            PC = GetTargetPlayer(Data, idx);
            if (PC != None && PC.IsLocalPlayerController())
            {
                if (Data.Timeline[idx].RumbleClass != None)
                {
                    PC.ClientPlayForceFeedbackWaveform(Data.Timeline[idx].RumbleClass.default.TheWaveForm);
                }
                else if (Data.Timeline[idx].Rumble != None)
                {
                    PC.ClientPlayForceFeedbackWaveform(Data.Timeline[idx].Rumble);
                }
            }
            break;
        case ETimelineType.TLT_ScreenShake:
            PC = GetTargetPlayer(Data, idx);
            if (PC != None && PC.PlayerCamera != None && PC.IsLocalPlayerController())
            {
                if (Data.Timeline[idx].ScreenShakeObject != None)
                {
                    SFXPlayerCamera(PC.PlayerCamera).AddScreenShake(Data.Timeline[idx].ScreenShakeObject.TheShake);
                }
                else if (Data.Timeline[idx].ScreenShakeClass != None)
                {
                    SFXPlayerCamera(PC.PlayerCamera).AddScreenShake(Data.Timeline[idx].ScreenShakeClass.default.TheShake);
                }
                else
                {
                    SFXPlayerCamera(PC.PlayerCamera).AddScreenShake(Data.Timeline[idx].ScreenShake);
                }
            }
            break;
        case ETimelineType.TLT_TimeDilation:
            if (Info != None && Data.Timeline[idx].TimeDilationLength > 0.0 && SFXGRI(Info.WorldInfo.GRI).bAllowTimeDilation)
            {
                Info.RequestTimeDilation(Data.Timeline[idx].TimeDilation, Data.Timeline[idx].TimeDilationLength, 'TimelineEffect');
                if (Data.Timeline[idx].bDilateSound == FALSE)
                {
                    Info.bDilateSound = FALSE;
                }
            }
            break;
        case ETimelineType.TLT_Ragdoll:
            if (Data.Timeline[idx].RagdollForce > 0.0)
            {
                if (Data.Timeline[idx].TargetType == ETimelineTarget.TRG_Source)
                {
                    PawnTarget = SFXPawn(Data.Source);
                    if (PawnTarget != None)
                    {
                        Momentum = Vector(Data.Source.Rotation) * -Data.Timeline[idx].RagdollForce;
                        if (Data.Target != None)
                        {
                            Momentum = Normal(Data.Source.location - Data.Target.location) * Data.Timeline[idx].RagdollForce;
                        }
                        PawnTarget.AddRagdollImpulse(Momentum, SFXPawn(Data.Target) != None ? SFXPawn(Data.Target).Controller : PawnTarget.Controller, , TRUE);
                    }
                }
                else if (Data.Timeline[idx].TargetType == ETimelineTarget.TRG_Target)
                {
                    PawnTarget = SFXPawn(Data.Target);
                    if (PawnTarget != None)
                    {
                        Momentum = Vector(Data.Target.Rotation) * -Data.Timeline[idx].RagdollForce;
                        if (Data.Target != None)
                        {
                            Momentum = Normal(Data.Target.location - Data.Source.location) * Data.Timeline[idx].RagdollForce;
                        }
                        PawnTarget.AddRagdollImpulse(Momentum, SFXPawn(Data.Source) != None ? SFXPawn(Data.Source).Controller : PawnTarget.Controller, , TRUE);
                    }
                }
            }
            break;
        case ETimelineType.TLT_Reaction:
            if (Data.Timeline[idx].Reactions.Length > 0)
            {
                if (Data.Timeline[idx].TargetType == ETimelineTarget.TRG_Source)
                {
                    PawnTarget = SFXPawn(Data.Source);
                    if (Pawn(Data.Target) != None)
                    {
                        Instigator = Pawn(Data.Target).Controller;
                    }
                }
                else if (Data.Timeline[idx].TargetType == ETimelineTarget.TRG_Target)
                {
                    PawnTarget = SFXPawn(Data.Target);
                    if (Pawn(Data.Source) != None)
                    {
                        Instigator = Pawn(Data.Source).Controller;
                    }
                }
                if (PawnTarget != None && PawnTarget.Role == ENetRole.ROLE_Authority)
                {
                    if (Data.Timeline[idx].Reactions.Length > 1)
                    {
                        TestReaction = Data.Timeline[idx].Reactions[Rand(Data.Timeline[idx].Reactions.Length)];
                    }
                    else
                    {
                        TestReaction = Data.Timeline[idx].Reactions[0];
                    }
                    if (PawnTarget.RequestReaction(TestReaction, Instigator))
                    {
                        PawnTarget.ReplicateAnimatedReaction(PawnTarget.CurrentCustomAction);
                    }
                }
            }
            break;
        case ETimelineType.TLT_Damage:
            if (ModuleOwner.Role < ENetRole.ROLE_Authority)
            {
                break;
            }
            if (Data.Timeline[idx].Damage > 0.0 && Data.Timeline[idx].DamageType != None)
            {
                ActorTarget = GetTargetActor(Data, idx);
                if (ActorTarget != None)
                {
                    Instigator = Pawn(Data.Target) != None ? Pawn(Data.Target).Controller : None;
                    if (Data.Timeline[idx].TargetType == ETimelineTarget.TRG_Target)
                    {
                        Instigator = Pawn(Data.Source) != None ? Pawn(Data.Source).Controller : None;
                    }
                    if (Instigator == None && Pawn(ModuleOwner) != None)
                    {
                        Instigator = Pawn(ModuleOwner).Controller;
                    }
                    ActorTarget.TakeDamage(Data.Timeline[idx].Damage, Instigator, ActorTarget.location, vect(0.0, 0.0, 0.0), Data.Timeline[idx].DamageType);
                }
            }
            break;
        case ETimelineType.TLT_AOE:
            if (Data.Timeline[idx].AOERadius > 0.0 && Data.Timeline[idx].AOEConeAngle >= -1.0 && Data.Timeline[idx].AOEImpactTimeline != None)
            {
                ActorTarget = GetTargetActor(Data, idx);
                if (ActorTarget != None)
                {
                    foreach ActorTarget.CollidingActors(Data.Timeline[idx].AOEFilterClass, CollidingActor, Data.Timeline[idx].AOERadius, , , , )
                    {
                        if (CollidingActor == ActorTarget || Data.Timeline[idx].bAOEAffectsTarget == FALSE && CollidingActor == Data.Target)
                        {
                            continue;
                        }
                        TargetPawn = SFXPawn(ActorTarget);
                        CollidingPawn = SFXPawn(CollidingActor);
                        if (TargetPawn != None && CollidingPawn != None && TargetPawn.IsFriendly(CollidingPawn))
                        {
                            continue;
                        }
                        if (TargetPawn.IsDead())
                        {
                            continue;
                        }
                        if (CollidingPawn != None && CollidingPawn.DrivenAtlas != None)
                        {
                            continue;
                        }
                        if (Data.Timeline[idx].AOEType == ETimelineAOEType.AOE_Cone)
                        {
                            if (Normal(CollidingActor.location - ActorTarget.location) Dot Vector(ActorTarget.Rotation) < Data.Timeline[idx].AOEConeAngle)
                            {
                                continue;
                            }
                        }
                        EvalAOE = Data.Timeline[idx].AOEFunc;
                        if (EvalAOE == None || EvalAOE(ActorTarget, CollidingActor))
                        {
                            BioCustomAction(Data.FuncOwner).OnTimelineImpact(CollidingActor);
                            SpawnTimeline(Data.Timeline[idx].AOEImpactTimeline, Data.FuncOwner, Data.Source, CollidingActor);
                        }
                    }
                }
            }
            break;
        case ETimelineType.TLT_AOEVisiblePawns:
            if (Data.Timeline[idx].AOERadius > 0.0 && Data.Timeline[idx].AOEConeAngle >= -1.0 && Data.Timeline[idx].AOEImpactTimeline != None)
            {
                ActorTarget = GetTargetActor(Data, idx);
                if (ActorTarget != None)
                {
                    foreach ActorTarget.WorldInfo.AllPawns(Class'SFXPawn', CollidingPawn, ActorTarget.location, Data.Timeline[idx].AOERadius)
                    {
                        if (ClassIsChildOf(CollidingPawn.Class, Data.Timeline[idx].AOEFilterClass) == FALSE)
                        {
                            continue;
                        }
                        if (CollidingPawn == ActorTarget || Data.Timeline[idx].bAOEAffectsTarget == FALSE && CollidingPawn == Data.Target)
                        {
                            continue;
                        }
                        TargetPawn = SFXPawn(ActorTarget);
                        if (TargetPawn != None && TargetPawn.IsFriendly(CollidingPawn))
                        {
                            continue;
                        }
                        if (CollidingPawn.DrivenAtlas != None)
                        {
                            continue;
                        }
                        if (TargetPawn.IsDead())
                        {
                            continue;
                        }
                        if (Data.Timeline[idx].AOEType == ETimelineAOEType.AOE_Cone)
                        {
                            if (Normal(CollidingPawn.location - ActorTarget.location) Dot Vector(ActorTarget.Rotation) < Data.Timeline[idx].AOEConeAngle)
                            {
                                continue;
                            }
                        }
                        if (CollidingPawn.GetAimNodeLocation(4, TargetLocation) == FALSE)
                        {
                            TargetLocation = CollidingPawn.location;
                        }
                        if (ActorTarget.FastTrace(TargetLocation, ActorTarget.location, , TRUE) == FALSE)
                        {
                            continue;
                        }
                        EvalAOE = Data.Timeline[idx].AOEFunc;
                        if (EvalAOE == None || EvalAOE(ActorTarget, CollidingPawn))
                        {
                            BioCustomAction(Data.FuncOwner).OnTimelineImpact(CollidingPawn);
                            SpawnTimeline(Data.Timeline[idx].AOEImpactTimeline, Data.FuncOwner, Data.Source, CollidingPawn);
                        }
                    }
                }
            }
            break;
        case ETimelineType.TLT_AOESingle:
            if (ModuleOwner.Role < ENetRole.ROLE_Authority)
            {
                break;
            }
            if (Data.Timeline[idx].AOERadius > 0.0 && Data.Timeline[idx].AOEConeAngle >= -1.0 && Data.Timeline[idx].AOEImpactTimeline != None)
            {
                ActorTarget = GetTargetActor(Data, idx);
                if (ActorTarget != None)
                {
                    BestTarget = None;
                    BestTargetDistSq = -1.0;
                    foreach ActorTarget.VisibleCollidingActors(Data.Timeline[idx].AOEFilterClass, CollidingActor, Data.Timeline[idx].AOERadius, , TRUE, , , , )
                    {
                        if (CollidingActor == ActorTarget)
                        {
                            continue;
                        }
                        TargetPawn = SFXPawn(ActorTarget);
                        CollidingPawn = SFXPawn(CollidingActor);
                        if (TargetPawn != None && CollidingPawn != None && TargetPawn.IsFriendly(CollidingPawn))
                        {
                            continue;
                        }
                        if (CollidingPawn != None && CollidingPawn.DrivenAtlas != None)
                        {
                            continue;
                        }
                        if (TargetPawn.IsDead())
                        {
                            continue;
                        }
                        if (Data.Timeline[idx].AOEType == ETimelineAOEType.AOE_Cone)
                        {
                            if (Normal(CollidingActor.location - ActorTarget.location) Dot Vector(ActorTarget.Rotation) < Data.Timeline[idx].AOEConeAngle)
                            {
                                continue;
                            }
                        }
                        TargetDistSq = VSizeSq(CollidingActor.location - ActorTarget.location);
                        if (BestTargetDistSq < float(0) || TargetDistSq < BestTargetDistSq)
                        {
                            BestTarget = CollidingActor;
                            BestTargetDistSq = TargetDistSq;
                        }
                    }
                    if (BestTarget != None)
                    {
                        BioCustomAction(Data.FuncOwner).OnTimelineImpact(BestTarget);
                        SpawnTimeline(Data.Timeline[idx].AOEImpactTimeline, Data.FuncOwner, Data.Source, BestTarget);
                    }
                }
            }
            break;
        case ETimelineType.TLT_SyncPartner:
            if (ModuleOwner.Role < ENetRole.ROLE_Authority)
            {
                break;
            }
            if (SFXCustomAction_ProceduralSync(Data.FuncOwner) != None)
            {
                ActorTarget = SFXCustomAction_ProceduralSync(Data.FuncOwner).SyncPartner;
            }
            if (ActorTarget != None)
            {
                BioCustomAction(Data.FuncOwner).OnTimelineImpact(ActorTarget);
                SpawnTimeline(Data.Timeline[idx].SyncPartnerImpactTimeline, Data.FuncOwner, Data.Source, ActorTarget);
            }
            break;
        case ETimelineType.TLT_Timeline:
            if (Data.Timeline[idx].TimelineTemplate != None)
            {
                ActorTarget = GetTargetActor(Data, idx);
                if (ActorTarget != None)
                {
                    SpawnTimeline(Data.Timeline[idx].TimelineTemplate, Data.FuncOwner, Data.Source, ActorTarget);
                }
            }
            break;
        case ETimelineType.TLT_InputOn:
            PC = GetTargetPlayer(Data, idx);
            if (PC != None && PC.IsLocalPlayerController() && BioPlayerInput(PC.PlayerInput) != None)
            {
                Data.Timeline[idx].bActiveInput = TRUE;
                Data.Timeline[idx].bReceivedInput = FALSE;
                BioPlayerInput(PC.PlayerInput).RegisterInputOverride(Data.Timeline[idx].InputAlias, Data.InputCallback, Data.Timeline[idx].bExclusive, Data.Timeline[idx].bOnPress);
            }
            break;
        case ETimelineType.TLT_InputOff:
            PC = GetTargetPlayer(Data, idx);
            if (PC != None && PC.IsLocalPlayerController() && BioPlayerInput(PC.PlayerInput) != None)
            {
                MatchingInputIndex = Data.Timeline[idx].nMatchedInputIndex;
                if (Data.Timeline[MatchingInputIndex].bBufferedInput && Data.Timeline[MatchingInputIndex].bReceivedInput)
                {
                    InputHandler = Data.Timeline[MatchingInputIndex].InputHandle;
                    if (InputHandler != None)
                    {
                        InputHandler();
                    }
                    Data.Timeline[MatchingInputIndex].bReceivedInput = FALSE;
                }
                Data.Timeline[MatchingInputIndex].bActiveInput = FALSE;
                BioPlayerInput(PC.PlayerInput).UnregisterInputOverride(Data.Timeline[MatchingInputIndex].InputAlias, Data.Timeline[MatchingInputIndex].bOnPress);
            }
            break;
        case ETimelineType.TLT_Function:
            if (Data.Timeline[idx].Func != 'None')
            {
                ModuleOwner.SetTimer(0.00100000005, FALSE, Data.Timeline[idx].Func, Data.FuncOwner);
            }
            break;
        case ETimelineType.TLT_RadialBlurOn:
            if (Data.Timeline[idx].SocketName != 'None')
            {
                PawnTarget = SFXPawn(GetTargetActor(Data, idx));
                if (PawnTarget != None)
                {
                    RBC_BlurInstance = new (Self) Class'RadialBlurComponent';
                    RBC_BlurInstance.SetMaterial(Data.Timeline[idx].BlurMaterial);
                    RBC_BlurInstance.SetBlurScale(Data.Timeline[idx].BlurScale);
                    RBC_BlurInstance.SetBlurFalloffExponent(Data.Timeline[idx].BlurFalloffExponent);
                    RBC_BlurInstance.SetBlurOpacity(Data.Timeline[idx].BlurOpacity);
                    PawnTarget.Mesh.AttachComponentToSocket(RBC_BlurInstance, Data.Timeline[idx].SocketName);
                    RBC_BlurInstance.SetEnabled(TRUE);
                    Data.Timeline[idx].RBC_BlurInstance = RBC_BlurInstance;
                }
            }
            break;
        case ETimelineType.TLT_RadialBlurOff:
            if (Data.Timeline[idx].RBC_BlurInstance != None)
            {
                Data.Timeline[idx].RBC_BlurInstance.SetEnabled(FALSE);
                Data.Timeline[idx].RBC_BlurInstance = None;
            }
            break;
        case ETimelineType.TLT_CameraAnim:
            PC = GetTargetPlayer(Data, idx);
            if (PC != None && SFXPlayerCamera(PC.PlayerCamera) != None && Data.Timeline[idx].CamAnim != None)
            {
                SFXPlayerCamera(PC.PlayerCamera).PlayCameraAnimEx(Data.Timeline[idx].CamAnim, Data.Timeline[idx].CamPlayRate, 1.0, Data.Timeline[idx].CamStartTime, Data.Timeline[idx].CamBlendInTime, Data.Timeline[idx].CamBlendOutTime, Data.Timeline[idx].bLoopCamAnim, FALSE, Data.Timeline[idx].CamDuration);
            }
            break;
        case ETimelineType.TLT_GameEffect:
            if (Data.Timeline[idx].GameEffectClass != None)
            {
                ActorTarget = GetTargetActor(Data, idx);
                if (ActorTarget != None)
                {
                    GEManager = ActorTarget.GetModule(Class'SFXModule_GameEffectManager');
                    if (GEManager != None)
                    {
                        GEManager.CreateAndApplyEffect(Data.Timeline[idx].GameEffectClass, Name, Data.Timeline[idx].GameEffectDuration, Data.Timeline[idx].GameEffectDuration == float(0) ? 2 : 1, Data.Timeline[idx].GameEffectValue, Pawn(Data.Source).Controller);
                    }
                }
            }
            break;
        default:
    }
}
public final simulated function CleanupTimeline(SFXTimelineData Data)
{
    local int idx;
    local SFXPlayerController PC;
    local Guid ClientEffectID;
    
    for (idx = 0; idx < Data.Timeline.Length; idx++)
    {
        switch (Data.Timeline[idx].Type)
        {
            case ETimelineType.TLT_Visual:
                if (Data.Timeline[idx].PSC_Instance != None)
                {
                    Data.Timeline[idx].PSC_Instance.SetActive(FALSE);
                    Data.Timeline[idx].PSC_Instance = None;
                }
                break;
            case ETimelineType.TLT_TimeDilation:
                if (Data.Timeline[idx].bDilateSound && ModuleOwner != None && SFXGame(ModuleOwner.WorldInfo.Game) != None)
                {
                    SFXGame(ModuleOwner.WorldInfo.Game).bDilateSound = TRUE;
                }
                break;
            case ETimelineType.TLT_InputOn:
                PC = GetTargetPlayer(Data, idx);
                if (PC != None && BioPlayerInput(PC.PlayerInput) != None)
                {
                    if (Data.Timeline[idx].bActiveInput)
                    {
                        Data.Timeline[idx].bActiveInput = FALSE;
                        BioPlayerInput(PC.PlayerInput).UnregisterInputOverride(Data.Timeline[idx].InputAlias, Data.Timeline[idx].bOnPress);
                    }
                }
                break;
            case ETimelineType.TLT_RadialBlurOn:
                if (Data.Timeline[idx].RBC_BlurInstance != None)
                {
                    Data.Timeline[idx].RBC_BlurInstance.SetEnabled(FALSE);
                    Data.Timeline[idx].RBC_BlurInstance.DetachFromAny();
                    Data.Timeline[idx].RBC_BlurInstance = None;
                }
                break;
            case ETimelineType.TLT_CameraAnim:
                PC = GetTargetPlayer(Data, idx);
                if (PC != None && PC.PlayerCamera != None && Data.Timeline[idx].CamAnim != None)
                {
                    PC.PlayerCamera.StopAllCameraAnimsByType(Data.Timeline[idx].CamAnim);
                }
                break;
            case ETimelineType.TLT_ClientEffect:
                if (Data.LifetimeLeft > 0.0 && Data.Timeline[idx].CrustDuration > 0.0 && ModuleOwner != None)
                {
                    ClientEffectID = Data.Timeline[idx].ClientEffectID;
                    if (ClientEffectID.A != 0 || ClientEffectID.B != 0 || ClientEffectID.C != 0 || ClientEffectID.D != 0)
                    {
                        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(Data.Timeline[idx].RVR_CrustTemplate, ClientEffectID, !ModuleOwner.bHidden);
                    }
                }
                break;
            default:
        }
    }
}
public final simulated function Actor GetTargetActor(SFXTimelineData Data, int idx)
{
    if (Data != None && idx >= 0 && idx < Data.Timeline.Length)
    {
        if (Data.Timeline[idx].TargetType == ETimelineTarget.TRG_Source)
        {
            return Data.Source;
        }
        else if (Data.Timeline[idx].TargetType == ETimelineTarget.TRG_Target)
        {
            return Data.Target;
        }
    }
    return None;
}
public final simulated function SFXPlayerController GetTargetPlayer(SFXTimelineData Data, int idx)
{
    if (Data != None && idx >= 0 && idx < Data.Timeline.Length)
    {
        if (Data.Timeline[idx].TargetType == ETimelineTarget.TRG_Source)
        {
            if (Pawn(Data.Source) != None && SFXPlayerController(Pawn(Data.Source).Controller) != None)
            {
                return SFXPlayerController(Pawn(Data.Source).Controller);
            }
        }
        else if (Data.Timeline[idx].TargetType == ETimelineTarget.TRG_Target)
        {
            if (Pawn(Data.Target) != None && SFXPlayerController(Pawn(Data.Target).Controller) != None)
            {
                return SFXPlayerController(Pawn(Data.Target).Controller);
            }
        }
    }
    return None;
}
public final simulated function RemoveAllTimelines()
{
    local int idx;
    
    for (idx = Timelines.Length - 1; idx >= 0; idx--)
    {
        RemoveTimeline(Timelines[idx]);
    }
}
public final simulated function RemoveTimeline(SFXTimelineData Data)
{
    if (Timelines.Find(Data) != -1)
    {
        CleanupTimeline(Data);
        Timelines.RemoveItem(Data);
    }
}
public final simulated function SFXTimelineData SpawnTimeline(SFXTimelineData Template, optional Object FuncOwner, optional Actor Source, optional Actor Target)
{
    local SFXTimelineData NewTimeline;
    
    NewTimeline = new (Outer) Class'SFXTimelineData' (Template);
    AddTimeline(NewTimeline, FuncOwner, Source, Target);
    return NewTimeline;
}
public final simulated function UpdateTimeline(SFXTimelineData Data, float DeltaTime)
{
    local int idx;
    
    for (idx = 0; idx < Data.Timeline.Length; idx++)
    {
        if (Data.Timeline[idx].bActivated == FALSE)
        {
            Data.Timeline[idx].TimeRemaining -= DeltaTime;
            if (Data.Timeline[idx].TimeRemaining <= 0.0)
            {
                ApplyTimelineEffect(Data, idx);
                Data.Timeline[idx].bActivated = TRUE;
            }
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}