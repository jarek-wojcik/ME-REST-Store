Class SFXDoor extends SkeletalMeshActor
    native
    placeable;

struct native ClientEffectWithGUID 
{
    var Guid EffectGUID;
    var RvrClientEffectInterface EffectInterface;
};
enum ESFXDoorState
{
    EDS_Closed,
    EDS_Open,
    EDS_Hackable,
    EDS_PlotLocked,
    EDS_Disabled,
    EDS_Delayed,
    EDS_DelayedActive,
};
enum ESFXDoorType
{
    EDT_Manual,
    EDT_Proximity,
    EDT_AutoEntrance,
    EDT_AutoExit,
};

var(SFXDoor) array<SFXDoorMarker> m_aDoorMarker;
var(SFXDoor_GUI) array<Name> m_aIconSocket;
var transient array<ClientEffectWithGUID> m_ActiveIconEffects;
var(Save) const Guid MyGuid;
var Guid OmniGuid;
var(SFXDoor_Animation) Name m_TransitionOpen;
var(SFXDoor_Animation) Name m_TransitionClose;
var int m_nIndex;
var(SFXDoor_GUI) RvrClientEffectInterface CE_IconClosed;
var(SFXDoor_GUI) RvrClientEffectInterface CE_IconHackable;
var(SFXDoor_GUI) RvrClientEffectInterface CE_IconPlotLocked;
var(SFXDoor_GUI) RvrClientEffectInterface CE_IconDelayed;
var(SFXDoor_GUI) RvrClientEffectInterface CE_IconDelayedActive;
var(SFXDoor_GUI) RvrClientEffectInterface CE_IconPlotHacking;
var(SFXDoor_Sound) WwiseEvent m_Wwise_Transition_Open;
var(SFXDoor_Sound) WwiseEvent m_Wwise_Transition_Close;
var(SFXDoor_Sound) WwiseEvent m_Wwise_GUI_Success_Opening;
var(SFXDoor_Sound) WwiseEvent m_Wwise_GUI_Delayed_Opening;
var(SFXDoor_Sound) WwiseEvent m_Wwise_GUI_Failure_PlotLocked;
var(SFXDoor_Sound) WwiseEvent m_Wwise_GUI_Failure_HackLocked;
var(SFXDoor_Sound) WwiseEvent m_Wwise_GUI_Kismet_Locked;
var(SFXDoor_Sound) WwiseEvent m_Wwise_GUI_Kismet_UnLocked;
var(SFXDoor_Sound) WwiseEvent m_Wwise_GUI_Kismet_Enabled;
var(SFXDoor_Sound) WwiseEvent m_Wwise_GUI_Kismet_Disabled;
var(SFXDoor_Sound) WwiseEvent m_Wwise_GUI_Kismet_Delayed;
var(SFXDoor) float HackDuration;
var RvrClientEffectInterface OmniToolTemplate;
var SFXPawn_Player LastUser;
var float HackStartTime;
var float HackRange;
var float HackUpdateTime;
var float HackAnimTime;
var(SFXDoor) bool m_bOpenWhenInteractedWhileUnlocked;
var transient bool m_bIsTransitioning;
var transient bool bCollisionTemporarilyDisabled;
var(Save) bool bSaveMe;
var bool bRevertToDelayed;
var(SFXDoor) ESFXDoorState m_CurrentDoorState;
var ESFXDoorState m_PreviousDoorState;
var(SFXDoor) ESFXDoorType m_DoorType;
var(SFXDoor_Plot) EBioRegionAutoSet Region;
var(SFXDoor_Plot) EBioPlotAutoSet Plot;
var(SFXDoor_Plot) EBioAutoSet PlotInt;
var(SFXDoor_GUI) export ETargetTipText m_TargetTipTextClosed;
var(SFXDoor_GUI) export ETargetTipText m_TargetTipTextHackLocked;
var(SFXDoor_GUI) export ETargetTipText m_TargetTipTextPlotLocked;
var(SFXDoor_GUI) export ETargetTipText m_TargetTipTextDelayed;
var transient ESFXDoorState m_PendingDoorState;

public event simulated function OnTransitionEnd()
{
    switch (m_CurrentDoorState)
    {
        case ESFXDoorState.EDS_Closed:
            if (m_DoorType == ESFXDoorType.EDT_Manual || m_DoorType == ESFXDoorType.EDT_AutoExit)
            {
                GetModule(Class'SFXSelectionModule').m_bTargetable = TRUE;
            }
            else
            {
                GetModule(Class'SFXSelectionModule').m_bTargetable = FALSE;
            }
            SetDoorIcon(CE_IconClosed);
            GetModule(Class'SFXSelectionModule').m_TargetTipText = m_TargetTipTextClosed;
            break;
        case ESFXDoorState.EDS_Open:
            SetDoorMarkerState(TRUE);
            break;
        case ESFXDoorState.EDS_Hackable:
            GetModule(Class'SFXSelectionModule').m_bTargetable = TRUE;
            SetDoorIcon(CE_IconHackable);
            GetModule(Class'SFXSelectionModule').m_TargetTipText = m_TargetTipTextHackLocked;
            break;
        case ESFXDoorState.EDS_PlotLocked:
            GetModule(Class'SFXSelectionModule').m_bTargetable = TRUE;
            SetDoorIcon(CE_IconPlotLocked);
            GetModule(Class'SFXSelectionModule').m_TargetTipText = m_TargetTipTextPlotLocked;
            break;
        case ESFXDoorState.EDS_Disabled:
            SetDoorIcon(None);
            GetModule(Class'SFXSelectionModule').m_bTargetable = FALSE;
            break;
        case ESFXDoorState.EDS_Delayed:
            GetModule(Class'SFXSelectionModule').m_bTargetable = TRUE;
            SetDoorIcon(CE_IconDelayed);
            GetModule(Class'SFXSelectionModule').m_TargetTipText = m_TargetTipTextDelayed;
            break;
        default:
    }
}
private final simulated function PlayAnim(Name InAnimSeqName, optional bool bSkipToEnd = FALSE)
{
    local AnimNodeSequence SeqNode;
    
    SkeletalMeshComponent.SetFrozen(FALSE);
    SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
    if (SeqNode != None)
    {
        if (SeqNode.AnimSeqName != InAnimSeqName)
        {
            SeqNode.SetAnim(InAnimSeqName);
        }
        if (bSkipToEnd)
        {
            SeqNode.PlayAnim(FALSE, SeqNode.Rate, SeqNode.AnimSeq.SequenceLength);
        }
        else
        {
            SeqNode.PlayAnim(FALSE, SeqNode.Rate, 0.0);
        }
    }
    m_bIsTransitioning = TRUE;
}
public native function PlayWiseEvent(WwiseEvent oWwiseEvent);

public simulated function PostBeginPlay()
{
    local AnimNodeSequence SeqNode;
    
    Super.PostBeginPlay();
    SFXSimpleUseModule(GetModule(Class'SFXSelectionModule')).__OnUsed__Delegate = OnUse;
    m_PendingDoorState = m_CurrentDoorState;
    if (m_CurrentDoorState == ESFXDoorState.EDS_Open)
    {
        OpenDoor(TRUE);
    }
    if (m_CurrentDoorState == ESFXDoorState.EDS_DelayedActive)
    {
        SetDoorState(5, None, TRUE);
    }
    if (SkeletalMeshComponent != None)
    {
        SeqNode = AnimNodeSequence(SkeletalMeshComponent.Animations);
        if (SeqNode != None && SeqNode.AnimSeq != None)
        {
            SeqNode.SetPosition(SeqNode.AnimSeq.SequenceLength, FALSE);
            SeqNode.StopAnim();
        }
        SkeletalMeshComponent.SetFrozen(TRUE);
    }
    OnTransitionEnd();
}
public event function RestoreDoorStates()
{
    local BioGlobalVariableTable oGV;
    local int nPlotState;
    local int nCurrentState;
    local int nPrevState;
    
    if (m_nIndex >= 0)
    {
        oGV = BioWorldInfo(WorldInfo).GetGlobalVariables();
        nPlotState = oGV.GetInt(m_nIndex);
        if ((1 & nPlotState) != 0)
        {
            nCurrentState = 255 & nPlotState >> 1;
            nPrevState = 255 & nPlotState >> 9;
            m_CurrentDoorState = byte(nCurrentState);
            m_PreviousDoorState = byte(nPrevState);
        }
    }
}
public event simulated function SetDoorIcon(RvrClientEffectInterface ClientEffect)
{
    local ClientEffectWithGUID CurrentIcon;
    local Name nmSocket;
    local RvrClientEffectTarget CETarget;
    
    foreach m_ActiveIconEffects(CurrentIcon, )
    {
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(CurrentIcon.EffectInterface, CurrentIcon.EffectGUID, TRUE);
    }
    m_ActiveIconEffects.Length = 0;
    if (ClientEffect != None)
    {
        foreach m_aIconSocket(nmSocket, )
        {
            CETarget.Instigator = Self;
            CETarget.HitBone = nmSocket;
            CurrentIcon.EffectGUID = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(ClientEffect, CETarget, Self);
            CurrentIcon.EffectInterface = ClientEffect;
            m_ActiveIconEffects.AddItem(CurrentIcon);
        }
    }
}
public event simulated function SetDoorState(ESFXDoorState ToState, optional Actor User, optional bool bInstantTransition = FALSE)
{
    if (m_bIsTransitioning)
    {
        m_PendingDoorState = ToState;
        return;
    }
    if (int(ToState) == int(m_CurrentDoorState))
    {
        if (ToState == ESFXDoorState.EDS_Delayed && GetModule(Class'SFXSelectionModule').m_bTargetable == FALSE)
        {
            OnTransitionEnd();
        }
        return;
    }
    if (ToState == ESFXDoorState.EDS_Closed && (m_DoorType == ESFXDoorType.EDT_AutoExit || m_DoorType == ESFXDoorType.EDT_Proximity) && bRevertToDelayed == TRUE)
    {
        bRevertToDelayed = FALSE;
        ToState = ESFXDoorState.EDS_Delayed;
    }
    switch (ToState)
    {
        case ESFXDoorState.EDS_Closed:
            switch (m_CurrentDoorState)
            {
                case ESFXDoorState.EDS_Hackable:
                case ESFXDoorState.EDS_PlotLocked:
                case ESFXDoorState.EDS_Delayed:
                    PlayWiseEvent(m_Wwise_GUI_Kismet_UnLocked);
                    break;
                case ESFXDoorState.EDS_Open:
                    CloseDoor(bInstantTransition);
                    break;
                case ESFXDoorState.EDS_Disabled:
                    PlayWiseEvent(m_Wwise_GUI_Kismet_Enabled);
                    break;
                default:
            }
            break;
        case ESFXDoorState.EDS_Open:
            switch (m_CurrentDoorState)
            {
                case ESFXDoorState.EDS_Disabled:
                case ESFXDoorState.EDS_Closed:
                case ESFXDoorState.EDS_Hackable:
                case ESFXDoorState.EDS_PlotLocked:
                case ESFXDoorState.EDS_Delayed:
                    OpenDoor(bInstantTransition);
                    break;
                case ESFXDoorState.EDS_DelayedActive:
                    if (m_DoorType == ESFXDoorType.EDT_AutoExit || m_DoorType == ESFXDoorType.EDT_Proximity)
                    {
                        bRevertToDelayed = TRUE;
                    }
                    OpenDoor(bInstantTransition);
                    break;
                default:
            }
            break;
        case ESFXDoorState.EDS_Hackable:
            PlayWiseEvent(m_Wwise_GUI_Kismet_Locked);
            switch (m_CurrentDoorState)
            {
                case ESFXDoorState.EDS_Open:
                    CloseDoor(bInstantTransition);
                    break;
                case ESFXDoorState.EDS_Disabled:
                    PlayWiseEvent(m_Wwise_GUI_Kismet_Enabled);
                    break;
                default:
            }
            break;
        case ESFXDoorState.EDS_PlotLocked:
            PlayWiseEvent(m_Wwise_GUI_Kismet_Locked);
            switch (m_CurrentDoorState)
            {
                case ESFXDoorState.EDS_Open:
                    CloseDoor(bInstantTransition);
                    break;
                case ESFXDoorState.EDS_Disabled:
                    PlayWiseEvent(m_Wwise_GUI_Kismet_Enabled);
                    break;
                default:
            }
            break;
        case ESFXDoorState.EDS_Disabled:
            PlayWiseEvent(m_Wwise_GUI_Kismet_Disabled);
            switch (m_CurrentDoorState)
            {
                case ESFXDoorState.EDS_Open:
                    CloseDoor(bInstantTransition);
                    break;
                default:
            }
            break;
        case ESFXDoorState.EDS_Delayed:
            PlayWiseEvent(m_Wwise_GUI_Kismet_Delayed);
            switch (m_CurrentDoorState)
            {
                case ESFXDoorState.EDS_Open:
                    CloseDoor(bInstantTransition);
                    break;
                case ESFXDoorState.EDS_Disabled:
                    PlayWiseEvent(m_Wwise_GUI_Kismet_Enabled);
                    break;
                default:
            }
            break;
        default:
    }
    m_PreviousDoorState = m_CurrentDoorState;
    m_CurrentDoorState = ToState;
    m_PendingDoorState = m_CurrentDoorState;
    SaveDoorStates();
    if (!m_bIsTransitioning)
    {
        OnTransitionEnd();
    }
    TriggerStateChange(User);
}
public function CheckInterrupt()
{
    local BioCustomAction CustomAction;
    local SFXCustomAction_HackDoor CustomAction_HackDoor;
    
    if (LastUser == None)
    {
        return;
    }
    if (VSize(LastUser.location - location) > HackRange || PlayerTookDamageRecently())
    {
        StopHacking();
        LastUser.GetCurrentCustomAction(CustomAction);
        CustomAction_HackDoor = SFXCustomAction_HackDoor(CustomAction);
        if (CustomAction_HackDoor != None)
        {
            CustomAction_HackDoor.EndThisCustomAction();
        }
        return;
    }
    SetTimer(HackUpdateTime, FALSE, 'CheckInterrupt', );
}
public simulated function bool CloseDoor(optional bool bInstant)
{
    SkeletalMeshComponent.SetRBCollidesWithChannel(2, TRUE);
    SkeletalMeshComponent.SetRBCollidesWithChannel(16, TRUE);
    PlayAnim(m_TransitionClose, bInstant);
    if (!bInstant)
    {
        PlayWiseEvent(m_Wwise_Transition_Close);
    }
    SetDoorMarkerState(FALSE);
    return TRUE;
}
public function FinishHack()
{
    local BioCustomAction CustomAction;
    local SFXCustomAction_HackDoor CA_HackDoor;
    
    if (LastUser == None)
    {
        return;
    }
    ClearTimer('CheckInterrupt');
    ClearTimer('OpenDoor');
    LastUser.GetCurrentCustomAction(CustomAction);
    CA_HackDoor = SFXCustomAction_HackDoor(CustomAction);
    if (CA_HackDoor != None)
    {
        CA_HackDoor.EndThisCustomAction();
    }
    ClearTimer('RefreshCustomAction');
    SetDoorState(1, LastUser);
}
public function array<RvrClientEffectInterface> GetActiveClientEffects()
{
    local array<RvrClientEffectInterface> ClientEffectsArray;
    local ClientEffectWithGUID CurrentIcon;
    
    foreach m_ActiveIconEffects(CurrentIcon, )
    {
        ClientEffectsArray.AddItem(CurrentIcon.EffectInterface);
    }
    return ClientEffectsArray;
}
public function OnUse(Actor User)
{
    local SFXSimpleUseModule UseMod;
    
    LastUser = SFXPawn_Player(User);
    TriggerInteraction(User);
    switch (m_CurrentDoorState)
    {
        case ESFXDoorState.EDS_Closed:
            PlayWiseEvent(m_Wwise_GUI_Success_Opening);
            break;
        case ESFXDoorState.EDS_Hackable:
            UseMod = GetModule(Class'SFXSimpleUseModule');
            PlayWiseEvent(m_Wwise_GUI_Failure_HackLocked);
            StartHacking();
            UseMod.bPlayUseAnimation = TRUE;
            break;
        case ESFXDoorState.EDS_PlotLocked:
            PlayWiseEvent(m_Wwise_GUI_Failure_PlotLocked);
            break;
        case ESFXDoorState.EDS_Delayed:
            PlayWiseEvent(m_Wwise_GUI_Delayed_Opening);
            GetModule(Class'SFXSelectionModule').m_bTargetable = FALSE;
            SetDoorIcon(CE_IconDelayedActive);
            SetDoorState(6, User);
            break;
        default:
    }
    if (m_bOpenWhenInteractedWhileUnlocked && m_CurrentDoorState == ESFXDoorState.EDS_Closed)
    {
        SetDoorState(1, User);
    }
}
public simulated function bool OpenDoor(optional bool bInstant)
{
    local SFXEngine LocalEngine;
    
    PlayAnim(m_TransitionOpen, bInstant);
    if (!bInstant)
    {
        PlayWiseEvent(m_Wwise_Transition_Open);
    }
    GetModule(Class'SFXSelectionModule').m_bTargetable = FALSE;
    SetDoorIcon(None);
    LocalEngine = SFXEngine(Class'SFXEngine'.static.GetEngine());
    if (LocalEngine != None)
    {
        LocalEngine.TriggerLargeOcclusionChange();
    }
    SkeletalMeshComponent.SetRBCollidesWithChannel(2, FALSE);
    SkeletalMeshComponent.SetRBCollidesWithChannel(16, FALSE);
    return TRUE;
}
public function bool PlayerTookDamageRecently()
{
    local SFXShield_Base Shield;
    local float TimeSinceLastHit;
    
    if (LastUser == None)
    {
        return FALSE;
    }
    Shield = LastUser.GetShields();
    if (Shield != None && Shield.ShieldRegenTimer > float(0))
    {
        TimeSinceLastHit = Shield.GetShieldRegenDelay() - Shield.ShieldRegenTimer;
        if (TimeSinceLastHit < HackDuration && LastUser.WorldInfo.TimeSeconds - HackStartTime > TimeSinceLastHit)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function RefreshCustomAction()
{
    if (LastUser == None)
    {
        return;
    }
    if (IsTimerActive('FinishHack') == TRUE)
    {
        LastUser.StartCustomAction(17, , TRUE);
        SetTimer(HackAnimTime, FALSE, 'RefreshCustomAction', );
    }
}
public function SaveDoorStates()
{
    local BioGlobalVariableTable oGV;
    local int nCombined;
    local int nCurrentState;
    local int nPrevState;
    
    if (m_nIndex >= 0)
    {
        nCurrentState = int(m_CurrentDoorState);
        nPrevState = int(m_PreviousDoorState);
        nCombined = nPrevState << 9 | nCurrentState << 1 | 1;
        oGV = BioWorldInfo(WorldInfo).GetGlobalVariables();
        oGV.SetInt(m_nIndex, nCombined);
    }
}
public simulated function SetDoorMarkerState(bool bOpen)
{
    local int i;
    
    for (i = 0; i < m_aDoorMarker.Length; i++)
    {
        if (bOpen)
        {
            m_aDoorMarker[i].DoorOpened();
            continue;
        }
        m_aDoorMarker[i].DoorClosed();
    }
}
public function StartHacking()
{
    if (LastUser == None)
    {
        return;
    }
    SetDoorIcon(CE_IconPlotHacking);
    SetTimer(HackUpdateTime, FALSE, 'CheckInterrupt', );
    SetTimer(HackDuration, FALSE, 'FinishHack', );
    SetTimer(HackAnimTime, FALSE, 'RefreshCustomAction', );
    LastUser.StartCustomAction(17);
}
public function StopHacking()
{
    local BioCustomAction CustomAction;
    local SFXCustomAction_HackDoor CA_HackDoor;
    
    if (LastUser == None)
    {
        return;
    }
    SetDoorIcon(CE_IconHackable);
    ClearTimer('RefreshCustomAction');
    ClearTimer('FinishHack');
    ClearTimer('CheckInterrupt');
    LastUser.GetCurrentCustomAction(CustomAction);
    CA_HackDoor = SFXCustomAction_HackDoor(CustomAction);
    if (CA_HackDoor != None)
    {
        CA_HackDoor.EndThisCustomAction();
    }
    ClearTimer('RefreshCustomAction');
}
public function TriggerInteraction(Actor EventInstigator)
{
    local int i;
    
    for (i = 0; i < GeneratedEvents.Length; i++)
    {
        if (ClassIsChildOf(GeneratedEvents[i].Class, Class'SFXSeqEvt_SFXDoorInteraction'))
        {
            SFXSeqEvt_SFXDoorInteraction(GeneratedEvents[i]).TriggerInteraction(m_CurrentDoorState, EventInstigator);
        }
    }
}
public function TriggerStateChange(Actor EventInstigator)
{
    local int i;
    
    for (i = 0; i < GeneratedEvents.Length; i++)
    {
        if (ClassIsChildOf(GeneratedEvents[i].Class, Class'SFXSeqEvt_SFXDoorInteraction'))
        {
            SFXSeqEvt_SFXDoorInteraction(GeneratedEvents[i]).TriggerStateChange(m_CurrentDoorState, m_PreviousDoorState, EventInstigator);
        }
    }
}

replication
{
    if (bNetDirty && Role == ENetRole.ROLE_Authority)
        m_PendingDoorState;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Object Class=SFXSimpleUseModule Name=SelMod01
    End Object
    Begin Template Class=SkeletalMeshComponent Name=SkeletalMeshComponent0
        Begin Template Class=AnimNodeSequence Name=AnimNodeSeq0
        End Template
        Animations = AnimNodeSeq0
        bHasPhysicsAssetInstance = TRUE
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
        BlockRigidBody = TRUE
        RBCollideWithChannels = {Pawn = TRUE, DeadPawn = TRUE}
    End Template
    m_aIconSocket = ('Socket_Icon01', 'Socket_Icon02')
    m_TransitionOpen = 'trans_closed_opened'
    m_TransitionClose = 'trans_opened_closed'
    m_nIndex = -1
    CE_IconClosed = RvrClientEffect'BioVFX_Env_Hologram.Particles.door.Holo_Door_Green_CVFX'
    CE_IconHackable = RvrClientEffect'BioVFX_Env_Hologram.Particles.door.Holo_Door_Red_CVFX'
    CE_IconPlotLocked = RvrClientEffect'BioVFX_Env_Hologram.Particles.door.Holo_Door_Red2_CVFX'
    CE_IconDelayed = RvrClientEffect'BioVFX_Env_Hologram.Particles.door.Holo_Door_Green_Delay_CVFX'
    CE_IconDelayedActive = RvrClientEffect'BioVFX_Env_Hologram.Particles.door.Holo_Door_Green_Delay_Active_CVFX'
    CE_IconPlotHacking = RvrClientEffect'BioVFX_Env_Hologram.Particles.door.Holo_Door_Hacking'
    m_Wwise_GUI_Failure_PlotLocked = WwiseEvent'Wwise_Generic_GUI.Play_gui_door_failure_locked_generic'
    m_Wwise_GUI_Failure_HackLocked = WwiseEvent'Wwise_Generic_GUI.Play_gui_door_failure_hackable_generic'
    m_Wwise_GUI_Kismet_Locked = WwiseEvent'Wwise_Generic_GUI.Play_gui_door_locked_generic'
    m_Wwise_GUI_Kismet_UnLocked = WwiseEvent'Wwise_Generic_GUI.Play_gui_door_unlocked_generic'
    m_Wwise_GUI_Kismet_Enabled = WwiseEvent'Wwise_Generic_GUI.Play_gui_door_enabled_generic'
    m_Wwise_GUI_Kismet_Disabled = WwiseEvent'Wwise_Generic_GUI.Play_gui_door_disabled_generic'
    m_Wwise_GUI_Kismet_Delayed = WwiseEvent'Wwise_Generic_GUI.Play_gui_door_enabled_generic'
    HackDuration = 5.0
    OmniToolTemplate = RvrClientEffectMulti'BioVFX_T_TechPowers._OmniTool.VCFX.OmniTool_LeftFull_VCFX_M'
    HackRange = 500.0
    HackUpdateTime = 0.100000001
    HackAnimTime = 2.5
    m_bOpenWhenInteractedWhileUnlocked = TRUE
    bSaveMe = TRUE
    m_DoorType = ESFXDoorType.EDT_Proximity
    m_TargetTipTextClosed = ETargetTipText.TargetTipText_Open
    m_TargetTipTextHackLocked = ETargetTipText.TargetTipText_Bypass
    m_TargetTipTextPlotLocked = ETargetTipText.TargetTipText_Examine
    m_TargetTipTextDelayed = ETargetTipText.TargetTipText_Open
    SkeletalMeshComponent = SkeletalMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, SkeletalMeshComponent0)
    Modules = (SelMod01)
    CollisionComponent = SkeletalMeshComponent0
    bWorldGeometry = TRUE
    bCollideActors = TRUE
    bBlockActors = TRUE
    bPathColliding = TRUE
    RemoteRole = ENetRole.ROLE_SimulatedProxy
    CollisionType = ECollisionType.COLLIDE_BlockAll
}