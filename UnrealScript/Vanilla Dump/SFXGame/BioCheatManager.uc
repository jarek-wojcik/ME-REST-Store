Class BioCheatManager extends CheatManager within BioPlayerController
    native
    transient
    config(Game);

struct native GFxWatchData 
{
    var string Path;
    var string Value;
    var Name movie;
};
struct native ProfileData 
{
    var string Header;
    var string Description;
    var delegate<ProfileHandler> Func;
    var delegate<ProfileUtility> Utility;
    var Name Keyword;
    var bool bNoTarget;
};
enum EProfileType
{
    Profile_None,
    Profile_AI,
    Profile_Camera,
    Profile_Combat,
    Profile_MPGame,
    Profile_Weapon,
    Profile_CombatStats,
    Profile_Difficulty,
    Profile_Angst,
    Profile_Cooldown,
    Profile_Damage,
    Profile_Pawn,
    Profile_Power,
    Profile_Tech,
    Profile_Treasure,
    Profile_Locomotion,
    Profile_AnimTree,
    Profile_Ticket,
    Profile_Vehicle,
    Profile_Henchmen,
    Profile_Settings,
    Profile_Effects,
    Profile_Scaleform,
    Profile_SaveGame,
    Profile_GAWAssets,
    Profile_GAWAssets_Military,
    Profile_GAWAssets_Device,
    Profile_GAWAssets_Intel,
    Profile_GAWAssets_Salvage,
    Profile_GAWAssets_Artifact,
    Profile_Focus,
    Profile_LoadSeekFreeAsync,
    Profile_Placeable,
    Profile_Reinforcements,
    Profile_Anim,
    Profile_Cover,
    Profile_Door,
    Profile_Conversation,
    Profile_ConversationBug,
    Profile_Gestures,
    Profile_Bonuses,
    Profile_Multipliers,
    Profile_LookAt,
    Profile_Wwise,
    Profile_Kinect,
    Profile_AnimPreload,
    Profile_Galaxy,
};

var array<ProfileData> AllProfiles;
var string PendingLoadGameDebugName;
var string PendingSaveGameFileName;
var string PendingSendToHost;
var array<GFxWatchData> GFxWatchValues;
var config string CE_Destructible_Name;
var delegate<ProfileHandler> __ProfileHandler__Delegate;
var delegate<ProfileUtility> __ProfileUtility__Delegate;
var Guid CoverGuid;
var Name ProfileSubTarget;
var Vector2D TopLeft;
var Actor ProfileTarget;
var int CurrentColumn;
var float ColumnWidth;
var Color ProfileTitleColor;
var Color ProfileHeaderColor;
var Color ProfileTextColor;
var Color ProfileHighlightColor;
var float ProfilesTime;
var float ProfilesDisplayTime;
var Color GAWTextColor;
var Color GAWHighlightColor;
var Color GAWHighlightColor2;
var int PendingSendToPort;
var int m_nMiniNotificationTest;
var SFXGUIHelper_ConsoleKeyboard m_TestKeyboard;
var transient RvrClientEffectInterface CE_Destructible;
var config bool bProfileHidesGUI;
var bool bCoverGuidShowing;
var bool m_bShowPowerAiming;
var bool m_bEnablePowerCooldown;
var bool bDebugAllLevels;
var EProfileType CurrentProfile;

public exec function Actors(Class<Actor> ActorClass)
{
    local Actor TheActor;
    local Vector vOrigin;
    local Vector vExtent;
    local Vector vStart;
    local Vector vEnd;
    
    foreach Outer.AllActors(ActorClass, TheActor, )
    {
        if (TheActor != None && TheActor.CollisionComponent != None)
        {
            vOrigin = TheActor.CollisionComponent.Bounds.Origin;
            vExtent = TheActor.CollisionComponent.Bounds.BoxExtent;
            Outer.DrawDebugBox(vOrigin, vExtent, 0, 255, 0, TRUE);
            vStart = vOrigin;
            vStart.X -= float(10);
            vEnd = vOrigin;
            vEnd.X += float(10);
            Outer.DrawDebugLine(vStart, vEnd, 0, 255, 0, TRUE);
            vStart = vOrigin;
            vStart.Y -= float(10);
            vEnd = vOrigin;
            vEnd.Y += float(10);
            Outer.DrawDebugLine(vStart, vEnd, 0, 255, 0, TRUE);
            vStart = vOrigin;
            vStart.Z -= float(10);
            vEnd = vOrigin;
            vEnd.Z += float(10);
            Outer.DrawDebugLine(vStart, vEnd, 0, 255, 0, TRUE);
        }
    }
}
public final exec native function AdvanceQuest(string sQuestName);

public exec function AILog(string nmPawn, bool bEnable)
{
    local BioPawn oPawn;
    local BioAiController oController;
    
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None)
    {
        return;
    }
    oController = BioAiController(oPawn.Controller);
    if (oController == None)
    {
        return;
    }
    oController.bAILogging = bEnable;
    oPawn.bWeaponDebug_Accuracy = bEnable;
    if (bEnable)
    {
    }
}
public final exec native function ASyncSkeletal(optional string Param);

public exec native function BioClearCrossLevelReferences(Level pLevel);

public exec native function BioLoadState(int nSaveStateSlot);

public exec native function BioSaveState(int nSaveStateSlot);

public exec native function BioTransition(int nTransition, int nParam);

public exec native function BlazeTestAcceptTOS(bool bAccept);

public exec native function BlazeTestDisconnect();

public exec native function BlazeTestReconnect(SFXOnlineConnectMode connectMode);

public exec native function BlazeTestSetCerberusRefused(bool bArg, optional bool bSave = FALSE);

public exec native function BlazeTestSetNucleusRefused(bool bArg, optional bool bSave = FALSE);

public exec native function BlazeTestSetNucleusSuccessful(bool bArg, optional bool bSave = FALSE);

public final exec function CancelHint()
{
    Class'SFXGUIInteraction'.static.GetInstance().CancelHint();
}
public exec native function CodexAudit();

public exec function Damage(string Target, float Amount)
{
    local Actor MyTarget;
    
    MyTarget = GetActorFromString(Target);
    if (MyTarget != None)
    {
        MyTarget.TakeDamage(Amount, None, MyTarget.location, vect(0.0, 0.0, 0.0), Class'SFXDamageType_Default');
    }
}
public native function DebugSpawnPrefab(int nTestNum);

public exec native function DisableGUIDCheck();

public exec native function DisplayStringID(bool i_bDisplay);

public exec function DisplayTime()
{
}
public exec function Distance(string nmActor1, string nmActor2)
{
    local Actor oActor1;
    local Actor oActor2;
    
    oActor1 = GetActorFromString(nmActor1);
    if (oActor1 == None)
    {
        return;
    }
    oActor2 = GetActorFromString(nmActor2);
    if (oActor2 == None)
    {
        return;
    }
    Outer.ClientMessage("The distance is " $ VSize(oActor1.location - oActor2.location));
    Outer.DrawDebugLine(oActor1.location, oActor2.location, 0, 0, 255, TRUE);
}
private final native function DoSetLocation(string sDesintation);

public exec function DownloadContent()
{
    ShowMarketplaceUI();
}
public final event function DrawBrightText(coerce string Text, optional int Highlight = 0, optional bool bFinishLine = FALSE)
{
    local Canvas Canvas;
    local float OldCurY;
    
    Canvas = Outer.myHUD.Canvas;
    if (Canvas != None)
    {
        switch (Highlight)
        {
            case 1:
                Canvas.DrawColor = GAWHighlightColor;
                break;
            case 2:
                Canvas.DrawColor = GAWHighlightColor2;
                break;
            default:
                Canvas.DrawColor = GAWTextColor;
        }
        OldCurY = Canvas.CurY;
        Canvas.DrawText(Text, bFinishLine);
        if (!bFinishLine)
        {
            Canvas.CurY = OldCurY;
        }
        else
        {
            Canvas.CurX = GetProfileColumnCoord();
        }
    }
}
public final event function DrawProfileHeaderText(coerce string Text, optional bool Highlight = FALSE)
{
    local Canvas Canvas;
    local float OldCurY;
    
    Canvas = Outer.myHUD.Canvas;
    if (Canvas != None)
    {
        Canvas.DrawColor = Highlight ? ProfileHighlightColor : ProfileHeaderColor;
        OldCurY = Canvas.CurY;
        Canvas.DrawText(Text, FALSE);
        Canvas.CurY = OldCurY;
    }
}
public final event function DrawProfileText(coerce string Text, optional bool Highlight = FALSE)
{
    local Canvas Canvas;
    
    Canvas = Outer.myHUD.Canvas;
    if (Canvas != None)
    {
        Canvas.DrawColor = Highlight ? ProfileHighlightColor : ProfileTextColor;
        Canvas.DrawText(Text);
        Canvas.CurX = GetProfileColumnCoord();
    }
}
public exec function EmptyInventory()
{
    local BioPawn PlayerPawn;
    local SFXInventoryManager oInventory;
    
    PlayerPawn = SFXPawn_Player(Outer.Pawn);
    if (PlayerPawn == None)
    {
        return;
    }
    oInventory = SFXInventoryManager(Outer.Pawn.InvManager);
    oInventory.EmptyInventory();
}
public exec function EnableAI(Name nmPawn, bool bEnable)
{
    local Pawn oPawn;
    local SFXAI_Core oController;
    
    if (nmPawn == 'All')
    {
        EnableAllAI(bEnable);
        return;
    }
    foreach Outer.AllActors(Class'Pawn', oPawn, )
    {
        if (nmPawn == oPawn.Name)
        {
            break;
        }
    }
    if (oPawn == None)
    {
        return;
    }
    oController = SFXAI_Core(oPawn.Controller);
    if (oController == None)
    {
        return;
    }
    oController.EnableAI(bEnable, 1);
    if (bEnable)
    {
    }
}
public exec function EnableDamage(bool B)
{
    local BioRemoteLogger GLogger;
    
    SFXGRI(Outer.WorldInfo.GRI).EnableDamage = B;
    Outer.ClientMessage("Damage" @ (B ? "Enabled" : "Disabled"));
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None)
    {
        GLogger.SendInvalidPlaythrough("EnableDamage");
    }
}
public exec native function ForceEnableCCD(bool bValue);

public exec function ForceEndRagdoll()
{
    BioPawn(Outer.Pawn).ForceEndRagdoll();
}
public final native function Actor GetActorFromString(string Str);

public event function Actor GetHenchmanByName(string sName)
{
    local BioPawn PlayerPawn;
    local BioPawn SquadMember;
    local int nIndex;
    
    PlayerPawn = BioPawn(Outer.Pawn);
    if (PlayerPawn != None && PlayerPawn.Squad != None)
    {
        for (nIndex = 0; nIndex < PlayerPawn.Squad.Members.Length; nIndex++)
        {
            SquadMember = BioPawn(PlayerPawn.Squad.Members[nIndex]);
            if (SquadMember != None && SquadMember != None)
            {
                if (InStr(Caps(SquadMember.GetActorGameName()), Caps(sName), , , ) != -1)
                {
                    return SquadMember;
                }
            }
        }
    }
    return None;
}
public final native function string GetLatentAction(Controller AI);

public final native function int GetNumStates(Controller AI);

public final event function float GetProfileColumnCoord()
{
    return TopLeft.X + float(CurrentColumn) * ColumnWidth;
}
public final exec native function GetPronunciations(string word);

public final native function string GetStateNameByIdx(Controller AI, int idx);

public final native function Actor GetUIWorldActor();

public exec native function GrantAllCodex();

public final exec function HideHint()
{
    Class'SFXGUIInteraction'.static.GetInstance().HideHint();
}
public exec function HideLoadingMessage()
{
    local SFXSaveLoadWidgetProxy oProxy;
    
    oProxy = Class'SFXGUIInteraction'.static.GetInstance().m_oSavingLoadingDisplayProxy;
    oProxy.HideLoadingMessage(TRUE);
}
public exec function HideSavingMessage()
{
    local SFXSaveLoadWidgetProxy oProxy;
    
    oProxy = Class'SFXGUIInteraction'.static.GetInstance().m_oSavingLoadingDisplayProxy;
    oProxy.HideSavingMessage(TRUE);
}
public exec native function HideStrings(bool i_bHide);

public final native function bool ImportAllCareersXenon(int TargetDeviceId);

public exec native function JournalAudit();

public final exec native function LoadExternalSave(string SavePath);

public final exec native function LoadSaveGameFrom(string Host, int Port);

public exec function LockAccomplishment(int AccomplishmentIndex);

public final exec native function LogActorArtPlaceables();

public final exec native function LogActorClasses();

public final exec native function LogActorEmitters();

public final exec native function LogActorPawns();

public final exec native function LogActorPrefabInstances();

public final exec native function LogActorSkelMeshes();

public final exec native function LogActorUnclassified();

public final exec native function LogAnimSequences();

public final exec native function LogPermanentObjects();

public final exec native function LogProperties();

public exec native function Mark(string sComment);

public exec native function NotFun();

public function OnConsumeResult(BWConsumableId aID, int nCopies, int nResult)
{
    Outer.ClientMessage("OnConsumeResult - " $ aID.nID $ "@" $ nCopies $ " - " $ nResult);
}
public function OnGrantEntitlementResult(BWEntitlementId aID, int nResult)
{
    Outer.ClientMessage("OnGrantEntitlementResult - " $ aID.nID $ " - " $ nResult);
}
public function OnPromptRedeemCodeResult(int nResult)
{
    Outer.ClientMessage("OnPromptRedeemCodeResult - " $ nResult);
}
public function OnPurchaseOfferIdResult(int nResult)
{
    Outer.ClientMessage("OnPurchaseOfferIdResult - " $ nResult);
}
public function OnRefreshDigitalRightsResult(int nResult)
{
    Outer.ClientMessage("OnRefreshDigitalRightsResult - " $ nResult);
    TestEchoDigitalRights();
}
public exec native function OutputBugReportXML(bool bCreateSavegame, bool bCreateScreenshot);

public final native function bool ParseVectorFromFlexibleFormat(string sInput, out Vector vResult);

public final native function PerformanceLog(string Msg);

public final native function Double PerformanceTimerStart();

public final native function float PerformanceTimerStop(Double StartTime);

public final exec native function PlayBinkMovie(string MovieName, optional bool Stream = FALSE, optional bool Preload = TRUE, optional float LoopDuration = 0.0);

public final exec native function PrintMuzzleLoc(string Target);

public exec function Profile(Name Keyword, optional string Target, optional Name SubTarget)
{
    local EProfileType OldProfile;
    local int idx;
    
    OldProfile = CurrentProfile;
    if (Keyword != 'None')
    {
        idx = AllProfiles.Find('Keyword', Keyword);
        if (idx != -1)
        {
            ProfileTarget = GetActorFromString(Target);
            if (ProfileTarget != None || AllProfiles[idx].bNoTarget)
            {
                CurrentProfile = byte(idx);
                ProfileSubTarget = SubTarget;
            }
            else
            {
                Outer.ClientMessage("profile target '" $ Target $ "' not found");
                CurrentProfile = EProfileType.Profile_None;
            }
        }
    }
    else
    {
        CurrentProfile = EProfileType.Profile_None;
    }
    if (CurrentProfile != EProfileType.Profile_None)
    {
        BioHUD(Outer.myHUD).AddDebugDraw(DebugDraw_CurrentProfile);
        if (OldProfile == EProfileType.Profile_None && bProfileHidesGUI)
        {
            Outer.ConsoleCommand("show scaleform");
        }
    }
    else if (OldProfile != EProfileType.Profile_None)
    {
        BioHUD(Outer.myHUD).ClearDebugDraw(DebugDraw_CurrentProfile);
        if (bProfileHidesGUI)
        {
            Outer.ConsoleCommand("show scaleform");
        }
    }
}
public function ProfileAnim()
{
    BioHUD(Outer.myHUD).ProfileAnim(ProfileTarget);
}
public function ProfileAnimPreload()
{
    BioHUD(Outer.myHUD).ProfileAnimPreload(None);
}
public final native function ProfileAnimTree();

public function ProfileConversation()
{
    BioHUD(Outer.myHUD).ProfileConversation(None);
}
public function ProfileConversationBug()
{
    BioHUD(Outer.myHUD).ProfileConversationBug(None);
}
public function ProfileCover()
{
    local BioPawn TargetPawn;
    
    TargetPawn = BioPawn(ProfileTarget);
    if (TargetPawn == None)
    {
        return;
    }
    BioHUD(Outer.myHUD).ProfileCover(TargetPawn);
}
public function ProfileGestures()
{
    BioHUD(Outer.myHUD).ProfileGestures(ProfileTarget);
}
public delegate function ProfileHandler();

public function ProfileKinect()
{
    BioHUD(Outer.myHUD).ProfileKinect(None);
}
public final native function ProfileLoadSeekFreeAsync();

public final native function ProfileLocomotion();

public function ProfileLookAt()
{
    BioHUD(Outer.myHUD).ProfileLookAt(ProfileTarget);
}
public exec function Profiles(optional float TimeToDisplay)
{
    if (TimeToDisplay == 0.0)
    {
        TimeToDisplay = 10.0;
    }
    if (BioHUD(Outer.myHUD).IsDrawing(DebugDraw_Profiles))
    {
        BioHUD(Outer.myHUD).ClearDebugDraw(DebugDraw_Profiles);
    }
    else
    {
        BioHUD(Outer.myHUD).AddDebugDraw(DebugDraw_Profiles);
        ProfilesDisplayTime = TimeToDisplay;
        ProfilesTime = Outer.WorldInfo.TimeSeconds;
    }
}
public delegate function ProfileUtility();

public function ProfileWwise()
{
    BioHUD(Outer.myHUD).ProfileWwise(None);
}
public exec function PromptRedeemCode()
{
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().PromptRedeemCode(OnPromptRedeemCodeResult);
}
public exec function RemoveAllEffects(string nmPawn)
{
    local BioPawn oPawn;
    local SFXModule_GameEffectManager Manager;
    
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None || oPawn.PowerManager == None)
    {
        Outer.ClientMessage("Unable to get effect - " $ nmPawn $ " is not a valid pawn name");
        return;
    }
    Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        Outer.ClientMessage("Unable to get effect - " $ nmPawn $ " does not have an SFXModule_GameEffectManager");
        return;
    }
    Manager.RemoveAllEffects();
    Outer.ClientMessage("All effects have been removed");
}
public final exec native function ResetMPPlayerVariables();

public final exec function RestoreHint()
{
    Class'SFXGUIInteraction'.static.GetInstance().RestoreHint();
}
public final exec function SaveGame(string SaveName)
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Outer.Player.Outer);
    if (Len(Engine.GetCurrentSaveDescriptor().Career) == 0)
    {
        Engine.CreateCareerInternal("Invalid", "Invalid", 1, 1, 2001, 1, 1, 0);
    }
    Engine.CurrentSaveGame.DebugName = SaveName;
    Engine.QueueSaveGameCommand(2, , SaveGame_Callback);
}
public final exec native function SendSaveGameTo(string Host, int Port);

private final native function SendSaveGameTo_Callback(SFXSaveGameCommandEventArgs Args);

public final exec native function SendScreenshotTo(string Host, int Port);

public exec function SetBoolByName(Name nmVar, bool nValue)
{
    local BioGlobalVariableTable oGV;
    
    oGV = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    if (oGV != None && nmVar != 'None')
    {
        oGV.SetBoolByName(nmVar, nValue);
    }
}
public exec function SetEffectsMaterial(string Target, Name Effect)
{
    local Actor TargetActor;
    local MeshComponent Comp;
    
    TargetActor = GetActorFromString(Target);
    if (TargetActor != None)
    {
        foreach TargetActor.AllOwnedComponents(Class'MeshComponent', Comp)
        {
            Comp.SetEffectsMaterial(Effect);
        }
    }
}
public exec native function SetGCDebugPackage(string sPackageName);

public event exec function SetHostViabilityEnabled(bool Enabled)
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        if (oOnlineSubsystem.GetComponentGame() != None)
        {
            Outer.ClientMessage("Host viability: " $ (Enabled ? "enabled" : "disabled"));
            oOnlineSubsystem.GetComponentGame().SetHostViabilityEnabled(Enabled);
        }
    }
}
public exec function SetIntByName(Name nmVar, int nValue)
{
    local BioGlobalVariableTable oGV;
    local SFXPlotTreasure oTreasure;
    local STech stTech;
    
    oGV = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    oTreasure = BioWorldInfo(Outer.WorldInfo).m_oTreasure;
    if (oGV != None && nmVar != 'None')
    {
        stTech = oTreasure.Tech(nmVar);
        if (stTech.nmTech != 'None')
        {
            oGV.SetIntByName(nmVar, nValue - 1);
            oTreasure.AwardTech(nmVar);
        }
        else
        {
            oGV.SetIntByName(nmVar, nValue);
        }
    }
}
public final exec native function SetLexicalLookup(bool enable);

public exec function SetLocation(string sDestination)
{
    local BioRemoteLogger GLogger;
    
    if (Outer.Role != ENetRole.ROLE_Authority)
    {
        Outer.DispatchCommand("SetLocation " $ sDestination);
    }
    else
    {
        GLogger = Class'BioRemoteLogger'.static.GetLogger();
        if (GLogger != None)
        {
            GLogger.SendInvalidPlaythrough("SetLocation");
        }
        DoSetLocation(sDestination);
    }
}
public event exec function SetMMBotModeEnabled(bool Enabled)
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        if (oOnlineSubsystem.GetComponentMatchMakingBot() != None)
        {
            oOnlineSubsystem.GetComponentMatchMakingBot().SetEnabled(Enabled);
        }
    }
}
public final event function SetProfileColumn(int ColumnIdx)
{
    CurrentColumn = ColumnIdx;
    if (Outer.myHUD.Canvas != None)
    {
        if (ColumnIdx == 0)
        {
            Outer.myHUD.Canvas.SetPos(TopLeft.X, TopLeft.Y);
        }
        else
        {
            Outer.myHUD.Canvas.SetPos(GetProfileColumnCoord(), TopLeft.Y);
        }
    }
}
public exec native function SetVehicleCamRadiusPoint(int nIndex, float fDegVal, float fScaleVal);

public exec function ShowGFxLog(bool bShow)
{
    Class'SFXGUIInteraction'.static.GetInstance().ShowGFxLog(bShow);
}
public final exec function ShowHint()
{
    Class'SFXGUIInteraction'.static.GetInstance().ShowHint($552680, -1.0, 0, 0);
}
public native function ShowMarketplaceUI();

public exec native function SimulateFreeze(float freezeTimeSec);

public exec native function SkynetSavegame(string sFilename);

private final native function SkynetSavegame_Callback(SFXSaveGameCommandEventArgs Args);

public exec native function SkynetScreenshot(string sFilename);

public exec native function SkynetToggleNucleusTelemetry();

public exec native function SkynetToggleQAPaths();

public exec native function SkynetToggleSessionDisplay();

public exec native function SkynetToggleSilentMode();

public exec native function SkynetToggleVerboseMode();

public final exec native function StartRecordKinectSpeech(optional bool SendToServer = TRUE);

public final exec native function StartVerboseKinectLogging();

public final exec native function StopRecordKinectSpeech();

public final exec native function StopVerboseKinectLogging();

public exec native function TestRagdoll(coerce string sWhitespaceDelimitedArguments);

public final exec native function ToggleActorVis(string Target, optional string Vis);

public exec function UnlockAccomplishment(int AccomplishmentIndex);

public exec native function Unreaper();

public final native function UpdateGFxWatchValues();

public native function UpdateSplitscreenPlayers(bool bCreatePlayers);

public exec function UsePower(Name nmPawn, Name nmPower)
{
    local Pawn oPawn;
    local BioBaseSquad oPlayerSquad;
    
    if (nmPawn == 'Player' || nmPawn == 'Self')
    {
        oPawn = Outer.Pawn;
    }
    else
    {
        foreach Outer.AllActors(Class'Pawn', oPawn, )
        {
            if (nmPawn == oPawn.Name)
            {
                break;
            }
        }
    }
    if (oPawn == None)
    {
        return;
    }
    oPlayerSquad = BioPawn(Outer.Pawn).Squad;
    if (oPlayerSquad != None && oPlayerSquad.bIsPlayerSquad)
    {
        Outer.SquadOrderUsePower(nmPower, oPawn);
        Outer.ApplyTacticalOrders();
    }
}
public exec function DebugAI(optional coerce Name Category)
{
    if (Outer.GameModeManager2.IsActive(15))
    {
        Outer.GameModeManager2.DisableMode(15);
    }
    else
    {
        Outer.GameModeManager2.EnableMode(15);
    }
}
public exec function God()
{
    local BioRemoteLogger GLogger;
    
    if (Outer.Role != ENetRole.ROLE_Authority)
    {
        Outer.DispatchCommand("God");
        PlayerController(Outer.Pawn.Controller).bGodMode = !PlayerController(Outer.Pawn.Controller).bGodMode;
    }
    else
    {
        GLogger = Class'BioRemoteLogger'.static.GetLogger();
        if (GLogger != None)
        {
            GLogger.SendInvalidPlaythrough("God");
        }
        Super.God();
    }
}
public native function InitCheatManager();

public exec function Respawn()
{
    local PlayerController PC;
    
    if (Outer.Role != ENetRole.ROLE_Authority)
    {
        Outer.DispatchCommand("Respawn");
    }
    else
    {
        PC = PlayerController(Outer.Pawn.Controller);
        if (PC != None && Outer.WorldInfo.Game != None)
        {
            Outer.WorldInfo.Game.RestartPlayer(PC);
            Outer.Pawn.SetLocation(Outer.Pawn.Anchor.location, );
            Outer.Pawn.SetRotation(Outer.Pawn.Anchor.Rotation);
        }
    }
}
public exec function Slomo(float T)
{
    if (Outer.WorldInfo != None && Outer.WorldInfo.Game != None)
    {
        SFXGame(Outer.WorldInfo.Game).TimeDilationOverride = FMax(T, 0.00999999978);
    }
}
public exec function Splitscreen()
{
    local SFXPlayerController PC;
    
    UpdateSplitscreenPlayers(TRUE);
    foreach SFXGame(Outer.WorldInfo.Game).LocalPlayerControllers(Class'SFXPlayerController', PC)
    {
        if (PC.Pawn == None)
        {
            PC.ServerBecomeActivePlayer();
        }
    }
}
public exec function AddAIFilter(Name nmFilter)
{
    local BioAiController oController;
    local int nIndex;
    local bool bFound;
    
    foreach Outer.AllActors(Class'BioAiController', oController, )
    {
        if (oController != None)
        {
            bFound = FALSE;
            for (nIndex = 0; nIndex < oController.AILogFilter.Length; nIndex++)
            {
                if (oController.AILogFilter[nIndex] == nmFilter)
                {
                    bFound = TRUE;
                    break;
                }
            }
            if (!bFound)
            {
                oController.AILogFilter[oController.AILogFilter.Length] = nmFilter;
            }
        }
    }
}
public exec function AddBar(Name Id, float X, float Y, float Width, optional float Lifetime = 3600.0, optional int C = 0, optional bool Grows = FALSE, optional bool Shrinks = FALSE)
{
    local BioHUD HUD;
    
    HUD = BioHUD(Outer.myHUD);
    HUD.AddBar(Id, X, Y, Width, Lifetime, C, Grows, Shrinks);
}
public exec function AddText(Name N, string S, float X, float Y, optional float Timer = 0.0, optional float Scale = 2.0, optional bool Center = TRUE)
{
    local BioHUD HUD;
    
    HUD = BioHUD(Outer.myHUD);
    HUD.AddDesignerText(N, S, X, Y, Timer, Scale, Center);
    HUD.bDesignerHud = TRUE;
}
public final exec function AdjustCredits(int nCreditAdjust)
{
    local BioPawn oBioPawn;
    
    oBioPawn = BioPawn(Outer.Pawn);
    if (oBioPawn == None)
    {
        return;
    }
    oBioPawn.AdjustCredits(nCreditAdjust);
}
public final exec function AdjustMediGel(int nMediGelAdjust)
{
    local BioPawn oBioPawn;
    
    oBioPawn = BioPawn(Outer.Pawn);
    if (oBioPawn == None)
    {
        return;
    }
    oBioPawn.AdjustMediGel(nMediGelAdjust);
}
public final exec function AdjustWeaponUIPawnOffset(Name nmAppearanceTag, float fX, float fY, float fZ, int nYaw)
{
    local SFXGUIInteraction oGUI;
    local SFXGUI_WeaponSelection oWeapGUI;
    local int N;
    local Vector V;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    oWeapGUI = oGUI.CastGetMovie(Class'SFXGUI_WeaponSelection', Outer, oGUI.MovieTag_WeaponSelect);
    V.X = fX;
    V.Y = fY;
    V.Z = fZ;
    if (oWeapGUI != None)
    {
        if (nmAppearanceTag == 'None')
        {
            oWeapGUI.BasePositionOffset = V;
            oWeapGUI.BaseRotationOffset.Yaw = nYaw;
        }
        else
        {
            for (N = 0; N < oWeapGUI.AppearancePositions.Length; ++N)
            {
                if (oWeapGUI.AppearancePositions[N].Tag == nmAppearanceTag)
                {
                    oWeapGUI.AppearancePositions[N].PositionOffset = V;
                    oWeapGUI.AppearancePositions[N].RotationOffset.Yaw = nYaw;
                    break;
                }
            }
        }
        oWeapGUI.UpdateUIWorldPawnPosition();
    }
}
public exec function ApplyAchPartyDamageBonus()
{
    local BioPawn PlayerPawn;
    local SFXModule_GameEffectManager Manager;
    local Class<SFXGameEffect> EffectClass;
    local SFXGameEffect Effect;
    
    PlayerPawn = BioPawn(Outer.Pawn);
    if (PlayerPawn != None)
    {
        Manager = PlayerPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            EffectClass = FindSFXGameEffectClass("SFXGameContent.SFXGameEffect_AchievementPartyDamageBonus");
            Effect = Manager.CreateEffect(EffectClass, EffectClass.default.Category, 0.0, 2, EffectClass.default.EffectValue);
            if (Effect != None)
            {
                Effect.OnApplied();
            }
        }
    }
}
public exec function ApplyAchPartyHealthBonus()
{
    local BioPawn PlayerPawn;
    local SFXModule_GameEffectManager Manager;
    local Class<SFXGameEffect> EffectClass;
    local SFXGameEffect Effect;
    
    PlayerPawn = BioPawn(Outer.Pawn);
    if (PlayerPawn != None)
    {
        Manager = PlayerPawn.GetModule(Class'SFXModule_GameEffectManager');
        if (Manager != None)
        {
            EffectClass = FindSFXGameEffectClass("SFXGameContent.SFXGameEffect_AchievementPartyHealthBonus");
            Effect = Manager.CreateEffect(EffectClass, EffectClass.default.Category, 0.0, 2, EffectClass.default.EffectValue);
            if (Effect != None)
            {
                Effect.OnApplied();
            }
        }
    }
}
public exec function AwardCredits(int nCredits, optional string Level = "")
{
    SFXGame(Outer.WorldInfo.Game).AwardCredits(nCredits, Level);
}
public exec function AwardItem(Name ItemName, optional string Level = "")
{
    if (SFXGame(Outer.WorldInfo.Game).AwardItem(ItemName, Level))
    {
        Outer.ClientMessage("Awarded " $ ItemName);
    }
    else
    {
        Outer.ClientMessage("Error awarding " $ ItemName);
    }
}
public exec function AwardTreasure(int nTreasureId)
{
    local SFXPlotTreasure oTreasure;
    
    oTreasure = BioWorldInfo(Outer.WorldInfo).m_oTreasure;
    oTreasure.AwardTreasure(nTreasureId, TRUE);
}
public exec function AwardXP(int nXP, optional string Level = "")
{
    SFXGame(Outer.WorldInfo.Game).AwardXP(nXP, Level);
}
public exec function BasicWeapons()
{
    local BioPlayerController oController;
    local SFXInventoryManager oInventory;
    local Weapon oWeapon;
    
    oController = Outer;
    oInventory = SFXInventoryManager(BioPawn(oController.Pawn).InvManager);
    foreach oInventory.InventoryActors(Class'Weapon', oWeapon)
    {
        oInventory.RemoveFromInventory(oWeapon);
    }
    GiveItem("self", 'AssaultRifle');
    GiveItem("self", 'Shotgun');
    GiveItem("self", 'HeavyPistol');
    GiveItem("self", 'SniperRifle');
    GiveItem("self", 'GrenadeLauncher');
}
public exec function BiasCEMaxDistance(float fBias)
{
    local RvrClientEffectManager Manager;
    
    Manager = Class'RvrClientEffectManager'.static.GetClientEffectManager();
    if (Manager != None)
    {
        Manager.m_fMaxDistance_Debug_Bias = fBias;
    }
}
public function BinaryHttpResult(SFXOnlineImageRequest Image)
{
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentImageManager().ClearReferences();
}
public exec function BlazeTest_CreateGui()
{
    local SFXGUIInteraction oSFMgr;
    local SFXOnlineComponentUI oBlaze;
    
    oSFMgr = Class'SFXGUIInteraction'.static.GetInstance();
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze.m_oGUI == None)
    {
        if (oSFMgr != None)
        {
            oBlaze.SetGui(oSFMgr.CreateNetworkGUI(oBlaze.HandlerId, Outer));
        }
    }
}
public exec function BlazeTest_DestroyGui()
{
    local SFXGUIInteraction oSFMgr;
    local SFXOnlineComponentUI oBlaze;
    
    oSFMgr = Class'SFXGUIInteraction'.static.GetInstance();
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oSFMgr != None && oBlaze != None)
    {
        oBlaze.ClearGui();
        oSFMgr.DestroyNetworkGUI(oBlaze.HandlerId, Outer);
    }
}
public exec function BlazeTest_ShowAccountDemographics()
{
    local SFXOnlineComponentUI oBlaze;
    local array<string> m_CountryCodeList;
    local array<string> m_CountryDisplayList;
    
    m_CountryCodeList.AddItem("CND");
    m_CountryDisplayList.AddItem("Canada");
    m_CountryCodeList.AddItem("US");
    m_CountryDisplayList.AddItem("United States");
    m_CountryCodeList.AddItem("JPN");
    m_CountryDisplayList.AddItem("Japan");
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowAccountDemographics(m_CountryCodeList, m_CountryDisplayList);
        }
    }
}
public exec function BlazeTest_ShowCerberusIntro()
{
    local SFXOnlineComponentUI oBlaze;
    
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowCerberusIntro();
        }
    }
}
public exec function BlazeTest_ShowCerberusWelcomeMessage()
{
    local SFXOnlineComponentUI oBlaze;
    
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowCerberusWelcomeMessage();
        }
    }
}
public exec function BlazeTest_ShowCreateNucleusAccount(string sEmail, string sPassword, optional bool bEAProducts = FALSE, optional bool bThirdParty = FALSE, optional bool bRegisterProduct = FALSE, optional bool bBioWareProducts = FALSE, optional bool bUnderage = FALSE)
{
    local SFXOnlineComponentUI oBlaze;
    
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowCreateNucleusAccount(sEmail, sPassword, bEAProducts, bThirdParty, bRegisterProduct, bBioWareProducts, bUnderage);
        }
    }
}
public exec function BlazeTest_ShowCreateNucleusAccountEx(string sEmail, string sPassword, bool bEAProducts, bool bThirdParty, bool bBioWareProducts, string i_sCountryCode, int BirthDay, int BirthMonth, int BirthYear)
{
    local SFXOnlineComponentUI oBlaze;
    local array<string> m_CountryCodeList;
    local array<string> m_CountryDisplayList;
    
    m_CountryCodeList.AddItem("CND");
    m_CountryDisplayList.AddItem("Canada");
    m_CountryCodeList.AddItem("US");
    m_CountryDisplayList.AddItem("United States");
    m_CountryCodeList.AddItem("JPN");
    m_CountryDisplayList.AddItem("Japan");
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowCreateNucleusAccountEx(sEmail, sPassword, bEAProducts, bThirdParty, bBioWareProducts, i_sCountryCode, BirthDay, BirthMonth, BirthYear, "", m_CountryCodeList, m_CountryDisplayList);
        }
    }
}
public exec function BlazeTest_ShowEmailPasswordMismatch(string email, string Password)
{
    local SFXOnlineComponentUI oBlaze;
    
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowEmailPasswordMismatch(email, Password);
        }
    }
}
public exec function BlazeTest_ShowIntroPage()
{
    local SFXOnlineComponentUI oBlaze;
    
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowIntroPage();
        }
    }
}
public exec function BlazeTest_ShowMessageBox(string sTitle, string sMessage, optional string sButton1Text, optional string sButton2Text, optional string sButton3Text)
{
    local SFXOnlineComponentUI oBlaze;
    
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowMessageBox(sTitle, sMessage, sButton1Text, sButton2Text, sButton3Text);
        }
    }
}
public exec function BlazeTest_ShowNucleusLogin(string email, string Password, int eScreenState)
{
    local SFXOnlineComponentUI oBlaze;
    
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowNucleusLogin(email, Password, eScreenState);
        }
    }
}
public exec function BlazeTest_ShowNucleusWelcomeMessage()
{
    local SFXOnlineComponentUI oBlaze;
    
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowNucleusWelcomeMessage();
        }
    }
}
public exec function BlazeTest_ShowParentEmail()
{
    local SFXOnlineComponentUI oBlaze;
    
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowParentEmail();
        }
    }
}
public exec function BlazeTest_ShowRedeemCode()
{
    local SFXOnlineComponentUI oBlaze;
    
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowRedeemCode();
        }
    }
}
public exec function BlazeTest_ShowTermsOfService(optional string i_sTermsOfService = "Sample Terms of Service", optional string i_sPrivacyPolicy = "Sample Privacy Policy", optional bool bTOSChanged = FALSE)
{
    local SFXOnlineComponentUI oBlaze;
    
    oBlaze = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentUserInterface();
    if (oBlaze != None)
    {
        if (oBlaze.m_oGUI != None)
        {
            oBlaze.ShowTermsOfService(i_sTermsOfService, i_sPrivacyPolicy, bTOSChanged);
        }
    }
}
public exec function BlazeTestConsumeCode(string sCode)
{
    local bool bMember;
    
    bMember = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentLogin().IsCerberusMember();
    Outer.ClientMessage("User is an entitled member of Cerberus Network:" @ bMember);
    if (!bMember)
    {
        Outer.ClientMessage("Consuming code" @ sCode);
        Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentLogin().SubmitRedeemCode(TRUE, sCode);
    }
    else
    {
        Outer.ClientMessage("Already a member, not consuming code.");
    }
}
public exec function BlazeTestSetAutoLoginOption(bool bAutoLogin)
{
    if (Outer.ProfileSettings != None)
    {
        Outer.ProfileSettings.SetProfileSettingValueId(45, int(bAutoLogin));
        Outer.bProfileSettingsUpdated = TRUE;
    }
}
public exec function CastPower(Name PowerName)
{
    local SFXPowerCustomAction PowerAction;
    local int i;
    local Actor oTarget;
    local Vector vTargetLocation;
    local BioPawn oPlayerPawn;
    
    oPlayerPawn = BioPawn(Outer.Pawn);
    if (oPlayerPawn != None)
    {
        for (i = 0; i < oPlayerPawn.PowerCustomActionClasses.Length; i++)
        {
            oPlayerPawn.CanDoCustomAction(132, , , i);
        }
        for (i = 0; i < oPlayerPawn.PowerCustomActions.Length; i++)
        {
            PowerAction = SFXPowerCustomAction(oPlayerPawn.PowerCustomActions[i]);
            if (PowerAction != None && PowerAction.PowerName == PowerName)
            {
                PowerAction.ChoosePowerTarget(oTarget, vTargetLocation);
                oPlayerPawn.StartCustomAction(132, , , i);
                return;
            }
        }
    }
}
public final function ChoiceDialogResult(BioSFHandler_MessageBox oMsgBox, int nChoiceID, bool bCancelled)
{
    TestString("Results: Option=" $ nChoiceID $ ", cancelled=" $ bCancelled);
}
public exec function ClearDebugLines()
{
    if (Outer.Pawn != None)
    {
        Outer.Pawn.FlushPersistentDebugLines();
    }
}
public exec function ClearFaceCodes()
{
    SFXEngine(Class'Engine'.static.GetEngine()).MPSaveManager.ClearFaceCodes();
    SFXEngine(Class'Engine'.static.GetEngine()).MPSaveManager.SaveRecords();
}
public final exec function ClearTraces()
{
    BioHUD(Outer.myHUD).ClearTraceStrips();
}
public exec function CloseGui(Name HandlerId)
{
    Class'SFXGUIInteraction'.static.GetInstance().RemoveMovie(Outer, HandlerId);
}
public exec function CompleteGame(int Ending)
{
    SFXGame(Outer.WorldInfo.Game).OnGameCompleted(Ending);
}
public exec function Cooldown(bool bEnable)
{
    EnablePowerCooldown(bEnable);
}
public exec function CoverPlayer(optional string HenchmanName)
{
    local Pawn Henchman;
    local BioPawn PlayerPawn;
    local int Index;
    
    if (Len(HenchmanName) == 0)
    {
        Outer.QuickCommandCoverPlayer(-1);
        return;
    }
    PlayerPawn = BioPawn(Outer.Pawn);
    if (PlayerPawn == None || PlayerPawn.Squad == None)
    {
        return;
    }
    Henchman = Pawn(GetActorFromString(HenchmanName));
    if (Henchman == None)
    {
        return;
    }
    Index = PlayerPawn.Squad.Members.Find(Henchman);
    if (Index == -1)
    {
        return;
    }
    Outer.QuickCommandCoverPlayer(Index);
}
public final exec function DebugAdhesion()
{
    local BioHUD HUD;
    local SFXModule_AimAssist AimAssist;
    
    AimAssist = Outer.GetModule(Class'SFXModule_AimAssist');
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None && AimAssist != None)
    {
        HUD.ToggleDebugDraw(AimAssist.DebugDraw_Adhesion);
        Outer.ClientMessage("DebugAdhesion" @ HUD.IsDrawing(AimAssist.DebugDraw_Adhesion));
    }
}
public final exec function DebugAIVals()
{
    local BioHUD HUD;
    
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None)
    {
        HUD.ToggleDebugDraw(DebugDraw_AIVals);
        Outer.ClientMessage("DebugAIVals" @ HUD.IsDrawing(DebugDraw_AIVals));
    }
}
public exec function DebugCoverCheck()
{
    local BioHUD HUD;
    local BioPlayerController oController;
    
    oController = Outer;
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None)
    {
        HUD.ToggleDebugDraw(oController.DebugDraw_CoverCheck);
        Outer.ClientMessage("DebugCoverCheck" @ HUD.IsDrawing(oController.DebugDraw_CoverCheck));
    }
}
private final function DebugDraw_AIVals(BioHUD HUD)
{
    local Vector CamLoc;
    local Rotator CamRot;
    local BioAiController AI;
    
    HUD.Canvas.SetDrawColor(255, 255, 255);
    Outer.GetPlayerViewPoint(CamLoc, CamRot);
    foreach Outer.WorldInfo.AllControllers(Class'BioAiController', AI)
    {
        if (AI.Pawn != None && (AI.Pawn.location - CamLoc) Dot Vector(CamRot) > 0.0)
        {
            AI.DrawDebug(HUD);
        }
    }
}
public final function DebugDraw_AngstIcons(BioHUD HUD)
{
    DisplayAngstInfo(TRUE, FALSE);
}
public final function DebugDraw_CurrentProfile(BioHUD HUD)
{
    local delegate<ProfileHandler> ProfileFunc;
    local delegate<ProfileUtility> UtilityFunc;
    
    if ((ProfileTarget != None || AllProfiles[int(CurrentProfile)].bNoTarget != FALSE) && CurrentProfile > EProfileType.Profile_None && int(CurrentProfile) < 47)
    {
        DrawProfileTitle();
        ProfileFunc = AllProfiles[int(CurrentProfile)].Func;
        if (ProfileFunc != None)
        {
            ProfileFunc();
        }
        UtilityFunc = AllProfiles[int(CurrentProfile)].Utility;
        if (UtilityFunc != None)
        {
            UtilityFunc();
        }
    }
}
public final function DebugDraw_GFxWatchValues(BioHUD HUD)
{
    local int N;
    local Canvas Canvas;
    
    Canvas = HUD.Canvas;
    if (Canvas == None)
    {
        return;
    }
    if (GFxWatchValues.Length == 0)
    {
        return;
    }
    UpdateGFxWatchValues();
    Canvas.DrawColor = ProfileTitleColor;
    Canvas.Font = Class'Engine'.static.GetSmallFont();
    if (Outer.WorldInfo.IsConsoleBuild())
    {
        Canvas.SetPos(HUD.SafeAreaRatioX * float(Canvas.SizeX), HUD.SafeAreaRatioY * float(Canvas.SizeY));
    }
    else
    {
        Canvas.SetPos(2.0, 2.0);
    }
    for (N = 0; N < GFxWatchValues.Length; ++N)
    {
        Canvas.DrawText(GFxWatchValues[N].movie $ ":" $ GFxWatchValues[N].Path $ " = " $ GFxWatchValues[N].Value);
    }
}
public function DebugDraw_Profiles(BioHUD HUD)
{
    local int idx;
    
    if (Outer.WorldInfo.IsConsoleBuild())
    {
        TopLeft.X = float(Outer.myHUD.Canvas.SizeX) * BioHUD(Outer.myHUD).SafeAreaRatioX;
        TopLeft.Y = float(Outer.myHUD.Canvas.SizeY) * BioHUD(Outer.myHUD).SafeAreaRatioY;
    }
    else
    {
        TopLeft.X = 2.0;
        TopLeft.Y = 0.0;
    }
    SetProfileColumn(0);
    DrawProfileHeaderText("Syntax: ");
    DrawProfileText("profile <keyword> <self/target/camera>");
    for (idx = 0; idx < AllProfiles.Length; idx++)
    {
        DrawProfileHeaderText("Keyword: ");
        DrawProfileText(AllProfiles[idx].Keyword $ "    " @ AllProfiles[idx].Description);
    }
    if (Outer.WorldInfo.TimeSeconds - ProfilesTime > ProfilesDisplayTime)
    {
        HUD.ClearDebugDraw(DebugDraw_Profiles);
    }
}
private final function DebugDraw_Wounds(BioHUD HUD)
{
    local Vector CamLoc;
    local Rotator CamRot;
    local Actor ChkActor;
    local Pawn ChkPawn;
    local SFXModule_Wound WoundMod;
    local int idx;
    local BoxSphereBounds WoundBox;
    local float X;
    local float Y;
    local float YL;
    
    HUD.Canvas.SetDrawColor(255, 255, 255);
    Outer.GetPlayerViewPoint(CamLoc, CamRot);
    X = HUD.Canvas.CurX;
    Y = HUD.Canvas.CurY;
    YL = HUD.Canvas.CurYL;
    foreach Outer.DynamicActors(Class'Actor', ChkActor, )
    {
        ChkPawn = Pawn(ChkActor);
        if (ChkPawn != None && (ChkPawn.location - CamLoc) Dot Vector(CamRot) > 0.0 && ChkPawn.WorldInfo.TimeSeconds - ChkPawn.LastRenderTime < 1.0)
        {
            WoundMod = ChkPawn.GetModule(Class'SFXModule_Wound');
            if (WoundMod != None)
            {
                for (idx = 0; idx < WoundMod.m_aWoundSpecs.Length; idx++)
                {
                    WoundBox = WoundMod.GetWoundBox(idx);
                    Outer.DrawDebugBox(WoundBox.Origin, WoundBox.BoxExtent, 255, 0, 0, FALSE);
                }
            }
        }
    }
    HUD.Canvas.CurX = X;
    HUD.Canvas.CurY = Y;
    HUD.Canvas.CurYL = YL;
}
public final exec function DebugFriction()
{
    local BioHUD HUD;
    local SFXModule_AimAssist AimAssist;
    
    AimAssist = Outer.GetModule(Class'SFXModule_AimAssist');
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None && AimAssist != None)
    {
        HUD.ToggleDebugDraw(AimAssist.DebugDraw_Friction);
        Outer.ClientMessage("DebugFriction" @ HUD.IsDrawing(AimAssist.DebugDraw_Friction));
    }
}
public final exec function DebugMagnetism()
{
    local BioHUD HUD;
    local SFXModule_AimAssist AimAssist;
    
    AimAssist = Outer.GetModule(Class'SFXModule_AimAssist');
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None && AimAssist != None)
    {
        HUD.ToggleDebugDraw(AimAssist.DebugDraw_Magnetism);
        Outer.ClientMessage("DebugAdhesion" @ HUD.IsDrawing(AimAssist.DebugDraw_Magnetism));
    }
}
public exec function DebugSecondController();

public exec function DebugSetPlotState(Name Type, Name plotVarName, float Value)
{
    local BioGlobalVariableTable oGV;
    
    oGV = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    if (Type == 'Float')
    {
        oGV.SetFloatByName(plotVarName, Value);
    }
    else if (Type == 'Int')
    {
        oGV.SetIntByName(plotVarName, int(Value));
    }
    else if (Type == 'Bool')
    {
        oGV.SetIntByName(plotVarName, int(Value));
    }
}
public final exec function DebugVoc()
{
    local BioHUD HUD;
    local SFXModule_AimAssist AimAssist;
    
    AimAssist = Outer.GetModule(Class'SFXModule_AimAssist');
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None && SFXGRI(Outer.WorldInfo.GRI).VocManager != None)
    {
        HUD.ToggleDebugDraw(SFXGRI(Outer.WorldInfo.GRI).VocManager.DebugDraw);
        Outer.ClientMessage("DebugFriction" @ HUD.IsDrawing(AimAssist.DebugDraw_Friction));
    }
}
public exec function DebugVocLine(string inInstigator, string Recipient, string eventStr)
{
    local BioPawn Inst;
    local BioPawn Recp;
    local ESFXVocalizationEventID EventId;
    local SFXVocalizationEvent Voc;
    
    EventId = byte(GetEnumIndex(Enum'SFXVocalizationManager.ESFXVocalizationEventID', Name(eventStr)));
    Inst = BioPawn(GetActorFromString(inInstigator));
    Recp = BioPawn(GetActorFromString(Recipient));
    Voc.DebugIndex = -1;
    Voc.DelayTimeRemainingSec = 0.0;
    Voc.Instigator = Inst;
    Voc.Recipient = Recp;
    Voc.Id = int(EventId);
    SFXGRI(Outer.WorldInfo.GRI).VocManager.HandleSFXVocalizationEvent(Voc);
}
public exec function DebugVocSystem(bool bEnable)
{
    SFXGRI(Outer.WorldInfo.GRI).VocManager.bDebugging = bEnable;
}
public final exec function DebugWeapon()
{
    if (BioPawn(Outer.Pawn) != None)
    {
        BioPawn(Outer.Pawn).bWeaponDebug_Accuracy = !BioPawn(Outer.Pawn).bWeaponDebug_Accuracy;
        Outer.ClientMessage("DebugWeapon" @ BioPawn(Outer.Pawn).bWeaponDebug_Accuracy);
    }
}
public final exec function DebugWounds()
{
    local BioHUD HUD;
    
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None)
    {
        HUD.ToggleDebugDraw(DebugDraw_Wounds);
        Outer.ClientMessage("DebugWounds" @ HUD.IsDrawing(DebugDraw_Wounds));
    }
}
public final exec function DebugZoomSnap()
{
    local BioHUD HUD;
    local SFXModule_AimAssist AimAssist;
    
    AimAssist = Outer.GetModule(Class'SFXModule_AimAssist');
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None && AimAssist != None)
    {
        HUD.ToggleDebugDraw(AimAssist.DebugDraw_ZoomSnap);
        Outer.ClientMessage("DebugZoomSnap" @ HUD.IsDrawing(AimAssist.DebugDraw_ZoomSnap));
    }
}
public final function DisplayAngstInfo(bool bShowIcons, bool bShowProfileData)
{
    local BioPawn oPawn;
    
    foreach Outer.WorldInfo.AllPawns(Class'BioPawn', oPawn)
    {
        if (oPawn != Outer.Pawn)
        {
            DisplayAngstWeaponRange(oPawn, bShowIcons, bShowProfileData && oPawn == ProfileTarget);
        }
    }
}
public final function DisplayAngstWeaponRange(BioPawn oPawn, bool bShowIcons, bool bShowProfileData)
{
    local SFXAI_Core oCont;
    local SFXWeapon oWeapon;
    local float fDistanceToTarget;
    
    oCont = SFXAI_Core(oPawn.Controller);
    if (oCont == None || oCont.IsInFightingState())
    {
        return;
    }
    oWeapon = SFXWeapon(oPawn.Weapon);
    if (oCont.FireTarget != None && oWeapon != None)
    {
        if (bShowProfileData)
        {
            DrawProfileHeaderText("Weapon Range (Short: " @ oWeapon.IdealMinRange / 100.0 @ ",Long: " @ oWeapon.IdealMaxRange / 100.0 @ " )");
        }
        fDistanceToTarget = VSize(oCont.FireTarget.location - oPawn.location);
        if (fDistanceToTarget > oWeapon.IdealMaxRange)
        {
            if (bShowIcons)
            {
                DrawAngstIcon(oPawn);
            }
            if (bShowProfileData)
            {
                DrawProfileText("FireTarget " @ oCont.FireTarget @ " @ " @ fDistanceToTarget / 100.0 @ " m is too far away.");
            }
        }
        else if (bShowProfileData)
        {
            DrawProfileText("FireTarget " @ oCont.FireTarget @ " @ " @ fDistanceToTarget / 100.0 @ " m is within range");
        }
    }
    else
    {
        if (bShowProfileData)
        {
            DrawProfileHeaderText("Weapon Range :");
        }
        if (bShowProfileData)
        {
            DrawProfileText("Invalid Fire target or weapon!");
        }
    }
}
public exec function DisplayNegotiate()
{
    local SFXPawn_Player MyPawn;
    
    MyPawn = SFXPawn_Player(Outer.Pawn);
    if (MyPawn != None && MyPawn != None)
    {
        Outer.ClientMessage("Negotiate skill is " $ MyPawn.GetIntimidateSkill());
    }
}
public function DrawAIUtility()
{
    local BioPawn TargetPawn;
    local NavigationPoint Nav;
    local NavigationPoint LastNav;
    local BioAiController AI;
    local Color DrawColor;
    
    TargetPawn = BioPawn(ProfileTarget);
    if (TargetPawn == None)
    {
        return;
    }
    if (TargetPawn.Controller != None)
    {
        if (TargetPawn.Controller.RouteCache.Length > 0)
        {
            LastNav = NavigationPoint(TargetPawn.Controller.MoveTarget);
            foreach TargetPawn.Controller.RouteCache(Nav, )
            {
                if (LastNav != None)
                {
                    Outer.DrawDebugLine(LastNav.location, Nav.location, 0, 0, 255);
                }
                LastNav = Nav;
            }
        }
    }
    AI = BioAiController(TargetPawn.Controller);
    if (AI != None)
    {
        if (AI.MoveTarget != None)
        {
            Outer.DrawDebugLine(TargetPawn.location, AI.MoveTarget.location, 255, 255, 255);
        }
        if (AI.FireTarget != None)
        {
            Outer.DrawDebugLine(TargetPawn.GetPawnViewLocation(), AI.FireTarget.location, 255, 0, 0);
        }
        if (AI.Focus != None)
        {
            Outer.DrawDebugLine(TargetPawn.GetPawnViewLocation(), AI.Focus.location, 255, 255, 0);
        }
        else if (IsZero(AI.GetFocalPoint()) == FALSE)
        {
            DrawColor.R = 255;
            DrawColor.G = 128;
            DrawColor.B = 0;
            Outer.DrawDebugLine(TargetPawn.GetPawnViewLocation(), AI.GetFocalPoint(), DrawColor.R, DrawColor.G, DrawColor.B);
            Outer.DrawDebugCone(AI.GetFocalPoint(), vect(0.0, 0.0, 1.0), 100.0, 0.5, 0.5, 10, DrawColor);
        }
    }
}
private final function DrawAngstIcon(Actor oActor)
{
    local Vector ScreenCoords;
    local float X;
    local float Y;
    local float YL;
    local Vector CamLoc;
    local Rotator CamRot;
    
    if (Outer.WorldInfo == None || Outer.WorldInfo.bShowDebugText == FALSE)
    {
        return;
    }
    Outer.GetPlayerViewPoint(CamLoc, CamRot);
    if (oActor != None && Outer.WorldInfo.TimeSeconds - oActor.LastRenderTime < 1.0 && (oActor.location - CamLoc) Dot Vector(CamRot) > 0.0)
    {
        X = Outer.myHUD.Canvas.CurX;
        Y = Outer.myHUD.Canvas.CurY;
        YL = Outer.myHUD.Canvas.CurYL;
        ScreenCoords = Outer.myHUD.Canvas.Project(oActor.location);
        Outer.myHUD.Canvas.CurX = ScreenCoords.X;
        Outer.myHUD.Canvas.CurY = ScreenCoords.Y;
        Outer.myHUD.Canvas.DrawText(":( - Angst");
        Outer.myHUD.Canvas.CurX = X;
        Outer.myHUD.Canvas.CurY = Y;
        Outer.myHUD.Canvas.CurYL = YL;
    }
}
public function DrawLine(coerce string s1, optional coerce string s2)
{
    s1 = Len(s1) < 1 ? " " : s1;
    s2 = Len(s2) < 1 ? " " : s2;
    DrawProfileHeaderText(s1);
    DrawProfileText(s2);
}
public function DrawProfileTitle()
{
    local float XL;
    local float YL;
    local Canvas Canvas;
    
    Canvas = Outer.myHUD.Canvas;
    if (Canvas == None)
    {
        return;
    }
    Canvas.bCenter = TRUE;
    Canvas.DrawColor = ProfileTitleColor;
    Canvas.Font = Class'Engine'.static.GetSmallFont();
    Canvas.TextSize("A", XL, YL);
    if (Outer.WorldInfo.IsConsoleBuild())
    {
        Canvas.SetPos(BioHUD(Outer.myHUD).SafeAreaRatioX * float(Canvas.SizeX), BioHUD(Outer.myHUD).SafeAreaRatioY * float(Canvas.SizeY));
    }
    else
    {
        Canvas.SetPos(2.0, 0.0);
    }
    if (AllProfiles[int(CurrentProfile)].bNoTarget == FALSE)
    {
        Canvas.DrawText(AllProfiles[int(CurrentProfile)].Header @ "<<" @ ProfileTarget @ ">>" @ "(" $ ProfileTarget.Tag $ ")");
    }
    else
    {
        Canvas.DrawText(AllProfiles[int(CurrentProfile)].Header);
    }
    Canvas.DrawText(AllProfiles[int(CurrentProfile)].Description);
    Canvas.Draw2DLine(0.0, Canvas.CurY, Canvas.ClipX, Canvas.CurY, Canvas.DrawColor);
    if (Outer.WorldInfo.IsConsoleBuild())
    {
        TopLeft.X = BioHUD(Outer.myHUD).SafeAreaRatioX * float(Canvas.SizeX);
    }
    else
    {
        TopLeft.X = 2.0;
    }
    TopLeft.Y = Canvas.CurY + YL;
    SetProfileColumn(0);
    Canvas.bCenter = FALSE;
}
public final function DrawSafeFrame(BioHUD HUD)
{
    local float fRatio;
    local float fSafeMarginW;
    local float fSafeMarginH;
    local Canvas Canvas;
    local Color DrawColor;
    
    Canvas = HUD.Canvas;
    if (Canvas == None)
    {
        return;
    }
    Canvas.Font = Class'Engine'.static.GetSmallFont();
    if (Outer.WorldInfo.IsConsoleBuild(2) == FALSE)
    {
        fRatio = 0.0500000007;
        DrawColor.R = 0;
        DrawColor.G = 255;
        DrawColor.B = 0;
        DrawColor.A = 255;
        fSafeMarginW = Canvas.ClipX * fRatio;
        fSafeMarginH = Canvas.ClipY * fRatio;
        Canvas.DrawColor = DrawColor;
        Canvas.SetPos(fSafeMarginW + float(2), fSafeMarginH + float(1));
        Canvas.DrawText("XBOX");
        Canvas.Draw2DLine(fSafeMarginW, fSafeMarginH, Canvas.ClipX - fSafeMarginW, fSafeMarginH, DrawColor);
        Canvas.Draw2DLine(fSafeMarginW, Canvas.ClipY - fSafeMarginH, Canvas.ClipX - fSafeMarginW, Canvas.ClipY - fSafeMarginH, DrawColor);
        Canvas.Draw2DLine(Canvas.ClipX - fSafeMarginW, fSafeMarginH, Canvas.ClipX - fSafeMarginW, Canvas.ClipY - fSafeMarginH, DrawColor);
        Canvas.Draw2DLine(fSafeMarginW, fSafeMarginH, fSafeMarginW, Canvas.ClipY - fSafeMarginH, DrawColor);
    }
    if (Outer.WorldInfo.IsConsoleBuild(1) == FALSE)
    {
        fRatio = 0.075000003;
        DrawColor.R = 0;
        DrawColor.G = 64;
        DrawColor.B = 255;
        DrawColor.A = 255;
        fSafeMarginW = Canvas.ClipX * fRatio;
        fSafeMarginH = Canvas.ClipY * fRatio;
        Canvas.DrawColor = DrawColor;
        Canvas.SetPos(fSafeMarginW + float(2), fSafeMarginH + float(1));
        Canvas.DrawText("PS3");
        Canvas.Draw2DLine(fSafeMarginW, fSafeMarginH, Canvas.ClipX - fSafeMarginW, fSafeMarginH, DrawColor);
        Canvas.Draw2DLine(fSafeMarginW, Canvas.ClipY - fSafeMarginH, Canvas.ClipX - fSafeMarginW, Canvas.ClipY - fSafeMarginH, DrawColor);
        Canvas.Draw2DLine(Canvas.ClipX - fSafeMarginW, fSafeMarginH, Canvas.ClipX - fSafeMarginW, Canvas.ClipY - fSafeMarginH, DrawColor);
        Canvas.Draw2DLine(fSafeMarginW, fSafeMarginH, fSafeMarginW, Canvas.ClipY - fSafeMarginH, DrawColor);
    }
}
public function DrawTargetLineUtility()
{
    local Vector EndPoint;
    
    if (ProfileTarget == None)
    {
        return;
    }
    EndPoint = ProfileTarget.location + vect(0.0, 0.0, 300.0);
    Outer.DrawDebugLine(ProfileTarget.location, EndPoint, 255, 255, 0);
}
public exec function DumpPlotManagerValueByIndex(int nIndex, string sVariableType);

public exec function EbisuCheckOnline()
{
}
public exec function EbisuCheckout(string offerId)
{
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentOrigin().Checkout(offerId);
}
public exec function EbisuRequestAuthToken()
{
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentOrigin().RequestAuthToken();
}
public exec function EbisuRequestFriendsList()
{
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentOrigin().RequestFriendsList();
}
public exec function EbisuShowCheckoutOverlay(string offerId)
{
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentOrigin().ShowCheckoutOverlay(offerId);
}
public exec function EbisuShowFriendsOverlay()
{
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentOrigin().ShowFriendsOverlay();
}
public exec function EbisuShowStoreOverlay(string categoryId)
{
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentOrigin().ShowStoreOverlay(categoryId);
}
public final exec function EchoStrref(int StrRef)
{
    local string strval;
    
    Outer.ClientMessage("strref" $ StrRef $ ":");
    strval = Class'SFXGame'.static.GetSimpleString(stringref(StrRef));
    Outer.ClientMessage(strval);
}
public exec function EnableAllAI(bool bEnable)
{
    local SFXAI_Core oController;
    local BioRemoteLogger GLogger;
    
    foreach Outer.AllActors(Class'SFXAI_Core', oController, )
    {
        if (oController != None)
        {
            oController.EnableAI(bEnable, 1);
        }
    }
    if (bEnable)
    {
    }
    else
    {
        GLogger = Class'BioRemoteLogger'.static.GetLogger();
        if (GLogger != None)
        {
            GLogger.SendInvalidPlaythrough("EnableAllAI");
        }
    }
}
public exec function EnableFaceFX(bool bEnable)
{
    local Pawn oPawn;
    
    foreach Outer.AllActors(Class'Pawn', oPawn, )
    {
        if (oPawn.Mesh != None)
        {
            oPawn.Mesh.BioEnableFaceFX(bEnable);
        }
    }
}
public exec function EnableHenchmanPowers(bool Enabled, optional int HenchmanIndex = -1)
{
    local BioBaseSquad PlayerSquad;
    local BioPawn PlayerPawn;
    local BioPawn HenchmanPawn;
    local BioAiController SquadAI;
    local int idx;
    
    idx = 0;
    PlayerSquad = SFXGame(Outer.WorldInfo.Game).PlayerSquad;
    if (PlayerSquad != None)
    {
        PlayerPawn = PlayerSquad.CachedPlayerPawn;
    }
    if (PlayerPawn != None)
    {
        foreach PlayerPawn.Squad.SquadMembers(SquadAI)
        {
            HenchmanPawn = BioPawn(SquadAI.Pawn);
            if (HenchmanPawn != PlayerSquad.CachedPlayerPawn)
            {
                if (idx == HenchmanIndex || HenchmanIndex == -1)
                {
                    HenchmanPawn.m_fPowerUsePercent = Enabled ? 0.5 : -1.0;
                }
                ++idx;
            }
        }
    }
}
public final exec function EnableHenchmanPowersByGameName(bool Enabled, optional string Spawn)
{
    local BioBaseSquad PlayerSquad;
    local BioPawn PlayerPawn;
    local BioPawn HenchmanPawn;
    local BioAiController SquadAI;
    
    PlayerSquad = SFXGame(Outer.WorldInfo.Game).PlayerSquad;
    if (PlayerSquad != None)
    {
        PlayerPawn = PlayerSquad.CachedPlayerPawn;
    }
    if (PlayerPawn != None)
    {
        foreach PlayerPawn.Squad.SquadMembers(SquadAI)
        {
            HenchmanPawn = BioPawn(SquadAI.Pawn);
            if (HenchmanPawn != PlayerSquad.CachedPlayerPawn)
            {
                if (Len(Spawn) == 0 || Spawn == HenchmanPawn.GetActorGameName())
                {
                    HenchmanPawn.m_fPowerUsePercent = Enabled ? 0.5 : -1.0;
                }
            }
        }
    }
}
public exec function EnablePowerCooldown(bool bEnable)
{
    local BioRemoteLogger GLogger;
    
    if (Outer.Role != ENetRole.ROLE_Authority)
    {
        m_bEnablePowerCooldown = bEnable;
        Outer.DispatchCommand("EnablePowerCooldown " $ bEnable);
        return;
    }
    m_bEnablePowerCooldown = bEnable;
    if (!bEnable)
    {
        GLogger = Class'BioRemoteLogger'.static.GetLogger();
        if (GLogger != None)
        {
            GLogger.SendInvalidPlaythrough("EnablePowerCooldown");
        }
    }
}
public exec function EvalCover()
{
    local BioAiController oCont;
    local Pawn oPawn;
    
    oPawn = Pawn(ProfileTarget);
    if (oPawn != None)
    {
        oCont = BioAiController(oPawn.Controller);
        if (oCont != None)
        {
            oCont.bAcquireNewCover = TRUE;
            return;
        }
    }
}
private final function Class<SFXPowerCustomActionBase> FindPowerClass(string PowerClassName)
{
    return Class<SFXPowerCustomActionBase>(Class'SFXEngine'.static.GetSeekFreeObject(PowerClassName, Class'Class'));
}
public function Class<SFXGameEffect> FindSFXGameEffectClass(string className)
{
    return Class<SFXGameEffect>(Class'SFXEngine'.static.GetSeekFreeObject(className, Class'Class'));
}
private final function Class<SFXWeapon> FindWeaponClass(string WeaponClassName)
{
    return Class<SFXWeapon>(Class'SFXEngine'.static.GetSeekFreeObject(WeaponClassName, Class'Class'));
}
public exec function FlushTelemetry(optional bool bAnonymous = FALSE)
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    local ISFXOnlineComponentTelemetry oOnlineTelemetry;
    
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        oOnlineTelemetry = oOnlineSubsystem.GetComponentTelemetry();
        if (oOnlineTelemetry != None)
        {
            oOnlineTelemetry.Flush(bAnonymous ? 1 : 0);
        }
    }
}
public exec function GameOver()
{
    Class'SFXGUIInteraction'.static.GetInstance().ShowGameOverGui($-1, Outer);
}
public function GaWHTTPResult(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode)
{
}
public exec function GetCharm()
{
    Outer.ClientMessage("The player's charm skill is " $ SFXPawn_Player(Outer.Pawn).GetCharmSkill());
}
public exec function GetFireTeam()
{
    local string Henchman;
    local int HenchmanIndex;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanIndex = GVars.GetIntByName('FireTeamLeader') - 1;
    if (HenchmanIndex == -1)
    {
        Outer.ClientMessage("Fire team leader is not set");
    }
    else
    {
        Henchman = GetHenchName(HenchmanIndex);
        Outer.ClientMessage("Fire team leader is" @ Henchman);
    }
}
public exec function GetGaWSecurityRatings()
{
    local SFXOnlineComponentGalaxyAtWar galaxyAtWar;
    
    galaxyAtWar = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentGalaxyAtWar();
    galaxyAtWar.GetRatings(TRUE, FALSE, GetGaWSecurityRatingsResult);
}
public function GetGaWSecurityRatingsResult(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode)
{
    local int i;
    
    if (errorCode != 0)
    {
        return;
    }
    for (i = 0; i < updatedSecurityRatings.Length; i++)
    {
    }
}
public function string GetHenchCodename(string Henchman)
{
    switch (Henchman)
    {
        case "Garrus":
            return "Garrus";
        case "Kaidan":
            return "Kaidan";
        case "EDI":
            return "EDI";
        case "Tali":
            return "Tali";
        case "Liara":
            return "Liara";
        case "Prothean":
            return "Prothean";
        case "James":
        case "Jimmy":
        case "Marine":
            return "Marine";
        case "Ashley":
            return "Ashley";
        default:
    }
    return "";
}
public function int GetHenchIndex(string Henchman)
{
    switch (Henchman)
    {
        case "Miranda":
            return 0;
        case "Jacob":
            return 1;
        case "Jack":
            return 2;
        case "Legion":
            return 3;
        case "Kasumi":
            return 4;
        case "Garrus":
            return 5;
        case "Thane":
            return 6;
        case "Tali":
            return 7;
        case "Mordin":
            return 8;
        case "Grunt":
            return 9;
        case "Samara":
            return 10;
        case "Zaeed":
            return 11;
        default:
    }
    return -1;
}
public function int GetHenchIsDeadGVarIndex(string Henchman)
{
    switch (Henchman)
    {
        case "Miranda":
            return 195;
        case "Jacob":
            return 196;
        case "Jack":
            return 197;
        case "Legion":
            return 198;
        case "Kasumi":
            return 199;
        case "Garrus":
            return 200;
        case "Thane":
            return 201;
        case "Tali":
            return 202;
        case "Mordin":
            return 203;
        case "Grunt":
            return 204;
        case "Samara":
            return 205;
        case "Zaeed":
            return 206;
        default:
    }
    return -1;
}
public exec function GetHenchmanAppearance(string Henchman)
{
    local string HenchmanCodename;
    local int Appearance;
    local Name nmLabel;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanCodename = GetHenchCodename(Henchman);
    if (HenchmanCodename != "")
    {
        nmLabel = Name("Appearance" $ HenchmanCodename);
        Appearance = GVars.GetIntByName(nmLabel);
        Outer.ClientMessage(Henchman @ "appearance is" @ Appearance);
    }
    else
    {
        Outer.ClientMessage(Henchman @ "is not a Henchman name!");
    }
}
public exec function GetHenchmanAvailable(string Henchman)
{
    local string HenchmanCodename;
    local bool available;
    local Name nmLabel;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanCodename = GetHenchCodename(Henchman);
    if (HenchmanCodename != "")
    {
        nmLabel = Name("IsSelectable" $ HenchmanCodename);
        available = GVars.GetBoolByName(nmLabel);
        Outer.ClientMessage(Henchman @ "is" @ (available ? "" : "not") @ "available.");
    }
    else
    {
        Outer.ClientMessage(Henchman @ "is not a Henchman name!");
    }
}
public exec function GetHenchmanDead(string Henchman)
{
    local int GVarIndex;
    local bool bIsDead;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    GVarIndex = GetHenchIsDeadGVarIndex(Henchman);
    if (GVarIndex != -1)
    {
        bIsDead = GVars.GetBool(GVarIndex);
        Outer.ClientMessage(Henchman @ "is" @ (bIsDead ? "" : "not") @ "dead.");
    }
    else
    {
        Outer.ClientMessage(Henchman @ "is not a Henchman name!");
    }
}
public exec function GetHenchmanKnown(string Henchman)
{
    local string HenchmanCodename;
    local bool known;
    local Name nmLabel;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanCodename = GetHenchCodename(Henchman);
    if (HenchmanCodename != "")
    {
        nmLabel = Name("KnowExist" $ HenchmanCodename);
        known = GVars.GetBoolByName(nmLabel);
        Outer.ClientMessage(Henchman @ "is" @ (known ? "" : "not") @ "known.");
    }
    else
    {
        Outer.ClientMessage(Henchman @ "is not a Henchman name!");
    }
}
public exec function GetHenchmanLoyalty(string Henchman)
{
    local string HenchmanCodename;
    local bool loyalty;
    local Name nmLabel;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanCodename = GetHenchCodename(Henchman);
    if (HenchmanCodename != "")
    {
        nmLabel = Name("IsLoyal" $ HenchmanCodename);
        loyalty = GVars.GetBoolByName(nmLabel);
        Outer.ClientMessage(Henchman @ "is" @ (loyalty ? "" : "not") @ "loyal.");
    }
    else
    {
        Outer.ClientMessage(Henchman @ "is not a Henchman name!");
    }
}
public exec function GetHenchmanSpecialization(string Henchman)
{
    local string HenchmanCodename;
    local bool specialized;
    local Name nmLabel;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanCodename = GetHenchCodename(Henchman);
    if (HenchmanCodename != "")
    {
        nmLabel = Name("IsSpecialized" $ HenchmanCodename);
        specialized = GVars.GetBoolByName(nmLabel);
        Outer.ClientMessage(Henchman @ "is" @ (specialized ? "" : "not") @ "specialized.");
    }
    else
    {
        Outer.ClientMessage(Henchman @ "is not a Henchman name!");
    }
}
public function string GetHenchName(int Henchman)
{
    switch (Henchman)
    {
        case 0:
            return "Miranda";
        case 1:
            return "Jacob";
        case 2:
            return "Jack";
        case 3:
            return "Legion";
        case 4:
            return "Kasumi";
        case 5:
            return "Garrus";
        case 6:
            return "Thane";
        case 7:
            return "Tali";
        case 8:
            return "Mordin";
        case 9:
            return "Grunt";
        case 10:
            return "Samara";
        case 11:
            return "Zaeed";
        default:
    }
    return "";
}
public exec function GetIntimidate()
{
    Outer.ClientMessage("The player's intimidate skill is " $ SFXPawn_Player(Outer.Pawn).GetIntimidateSkill());
}
public exec function GetLocation()
{
    local string sLocation;
    
    sLocation = "PlayerLocation: (" $ Outer.Pawn.location.X $ ", " $ Outer.Pawn.location.Y $ ", " $ Outer.Pawn.location.Z $ ").  Consider using ShowLocation.";
    Outer.ClientMessage(sLocation);
}
public exec function GetMorinth()
{
    local BioGlobalVariableTable GVars;
    local bool Value;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    Value = GVars.GetBoolByName('Morinth_not_Samara');
    Outer.ClientMessage(Value ? "Morinth" : "Samara");
}
public exec function GetParagon()
{
    local SFXGame Game;
    local SFXPawn_Player PlayerPawn;
    local PlayerController PlayerController;
    
    Game = Outer.WorldInfo != None ? SFXGame(Outer.WorldInfo.Game) : None;
    if (Outer.WorldInfo != None)
    {
        PlayerController = Outer.WorldInfo.GetALocalPlayerController();
    }
    if (PlayerController == None)
    {
        return;
    }
    PlayerPawn = SFXPawn_Player(PlayerController.Pawn);
    if (Game != None && PlayerPawn != None)
    {
        Outer.ClientMessage("The player has " $ Game.GetParagonPoints() $ " unmodified paragon points");
        Outer.ClientMessage("The player has " $ PlayerPawn.GetCharmSkill() $ " paragon points after bonuses");
    }
}
public exec function GetPlotVariableID(Name plotVarName)
{
    local BioGlobalVariableTable oGV;
    local int Index;
    
    oGV = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    oGV.oNameLookupTable.GetIntEntryNN(plotVarName, 'Index', Index);
    Outer.ClientMessage("" $ Index);
}
public final exec function GetProductDetails(int aList)
{
    local BWOfferId aOffer;
    local array<BWOfferId> aOffers;
    
    aOffer.nID = aList;
    aOffers.AddItem(aOffer);
    Outer.ClientMessage("GetProductDetails adding offers");
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().FetchOfferDetails(aOffers, GetProductDetailsComplete);
}
private final function GetProductDetailsComplete()
{
    Outer.ClientMessage("GetProductDetails: Complete.");
}
public exec function GetRenegade()
{
    local SFXGame Game;
    local SFXPawn_Player PlayerPawn;
    local PlayerController PlayerController;
    
    Game = Outer.WorldInfo != None ? SFXGame(Outer.WorldInfo.Game) : None;
    if (Outer.WorldInfo != None)
    {
        PlayerController = Outer.WorldInfo.GetALocalPlayerController();
    }
    if (PlayerController == None)
    {
        return;
    }
    PlayerPawn = SFXPawn_Player(PlayerController.Pawn);
    if (Game != None && PlayerPawn != None)
    {
        Outer.ClientMessage("The player has " $ Game.GetRenegadePoints() $ " unmodified renegade points");
        Outer.ClientMessage("The player has " $ PlayerPawn.GetIntimidateSkill() $ " renegade points after bonuses");
    }
}
public exec function GetSpecialist()
{
    local string Henchman;
    local int HenchmanIndex;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanIndex = GVars.GetIntByName('Specialist') - 1;
    Henchman = GetHenchName(HenchmanIndex);
    if (HenchmanIndex == -1)
    {
        Outer.ClientMessage("Specialist is not set");
    }
    else
    {
        Henchman = GetHenchName(HenchmanIndex);
        Outer.ClientMessage("Specialist is" @ Henchman);
    }
}
public exec function GetVocalizationBankInfo(string Target)
{
    local SFXVocalizationBank combatbank;
    local array<SFXVocalizationBank> combatbankvariants;
    local SFXVocalizationBank explorebank;
    local SFXVocalizationBank stealthbank;
    local BioPawn AIBarkPawn;
    local SFXModule_QAModule m_BarkModule;
    local int i;
    
    AIBarkPawn = BioPawn(GetActorFromString(Target));
    if (AIBarkPawn == None)
    {
        Outer.ClientMessage("Cannot profile target");
        return;
    }
    combatbank = AIBarkPawn.CombatVoc;
    combatbankvariants = AIBarkPawn.CombatVocVariants;
    explorebank = AIBarkPawn.ExplorationVoc;
    stealthbank = AIBarkPawn.StealthVoc;
    Outer.ClientMessage("Retrieving Combat Vocalization bank for " $ AIBarkPawn.Name);
    Outer.ClientMessage("See Log file for full list of AI barks");
    if (combatbank != None)
    {
        Outer.ClientMessage("Pawn uses AI Bark Vocalization Bank (Combat) " $ combatbank.Name);
    }
    else
    {
        Outer.ClientMessage("No combat AI bark vocalization banks on selected pawn");
    }
    if (combatbankvariants.Length != 0)
    {
        for (i = 0; i < combatbankvariants.Length; i++)
        {
            Outer.ClientMessage("Pawn uses AI Bark Vocalization Bank (Combat Variant) " $ combatbankvariants[i].Name);
        }
    }
    else
    {
        Outer.ClientMessage("No combat variation vocalization banks on selected pawn");
    }
    if (explorebank != None)
    {
        Outer.ClientMessage("Pawn uses AI Bark Vocalization Bank (Exploration) " $ explorebank.Name);
    }
    else
    {
        Outer.ClientMessage("No exploration AI bark vocalization bank on selected pawn");
    }
    if (stealthbank != None)
    {
        Outer.ClientMessage("Pawn uses AI Bark Vocalization Bank (Stealth) " $ stealthbank.Name);
    }
    else
    {
        Outer.ClientMessage("No stealth AI bark vocalization bank on selected pawn");
    }
    m_BarkModule = new Class'SFXModule_QAModule';
    AIBarkPawn.AddSFXModule(m_BarkModule, TRUE);
}
public final exec function GFxWatch(Name nmMovie, optional string sPath)
{
    local int N;
    local int nInsertLoc;
    
    if (nmMovie == 'None')
    {
        GFxWatchValues.Length = 0;
        BioHUD(Outer.myHUD).ClearDebugDraw(DebugDraw_GFxWatchValues);
    }
    else if (Len(sPath) > 0)
    {
        for (N = 0; N < GFxWatchValues.Length; ++N)
        {
            if (GFxWatchValues[N].movie == nmMovie)
            {
                if (GFxWatchValues[N].Path == sPath)
                {
                    return;
                }
                nInsertLoc = N + 1;
            }
        }
        if (nInsertLoc == 0)
        {
            nInsertLoc = GFxWatchValues.Length;
        }
        GFxWatchValues.Insert(nInsertLoc, 1);
        GFxWatchValues[nInsertLoc].movie = nmMovie;
        GFxWatchValues[nInsertLoc].Path = sPath;
        BioHUD(Outer.myHUD).AddDebugDraw(DebugDraw_GFxWatchValues);
    }
}
public final exec function GiveAllGAWAssets()
{
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.UnlockAllGAWAssets();
}
public exec function GiveCredits(int nCredits)
{
    GiveResource(0, nCredits);
}
public exec function GiveEffect(string nmPawn, string EffectClassName)
{
    local BioPawn oPawn;
    local SFXGameEffect Effect;
    local Class<SFXGameEffect> EffectClass;
    local SFXModule_GameEffectManager Manager;
    
    EffectClass = FindSFXGameEffectClass(EffectClassName);
    if (EffectClass == None)
    {
        EffectClass = FindSFXGameEffectClass("SFXGame." $ EffectClassName);
        if (EffectClass == None)
        {
            EffectClass = FindSFXGameEffectClass("SFXGameContent." $ EffectClassName);
            if (EffectClass == None)
            {
                Outer.ClientMessage("Unable to give effect - Failed to load effect " $ EffectClassName);
                return;
            }
        }
    }
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None)
    {
        Outer.ClientMessage("Unable to give effect - " $ nmPawn $ " is not a valid pawn name");
        return;
    }
    Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        Outer.ClientMessage("Unable to give effect - " $ nmPawn $ " does not have an SFXModule_GameEffectManager");
        return;
    }
    Effect = Manager.CreateEffect(EffectClass, EffectClass.default.Category, 0.0, 2, EffectClass.default.EffectValue);
    if (Effect != None)
    {
        Outer.ClientMessage("The effect has been given to the pawn");
        Effect.OnApplied();
    }
    else
    {
        Outer.ClientMessage("Failed to create the effect");
    }
}
public exec function GiveEffectWithValue(string nmPawn, string EffectClassName, float Value)
{
    local BioPawn oPawn;
    local SFXGameEffect Effect;
    local Class<SFXGameEffect> EffectClass;
    local SFXModule_GameEffectManager Manager;
    
    EffectClass = FindSFXGameEffectClass(EffectClassName);
    if (EffectClass == None)
    {
        EffectClass = FindSFXGameEffectClass("SFXGame." $ EffectClassName);
        if (EffectClass == None)
        {
            EffectClass = FindSFXGameEffectClass("SFXGameContent." $ EffectClassName);
            if (EffectClass == None)
            {
                Outer.ClientMessage("Unable to give effect - Failed to load effect " $ EffectClassName);
                return;
            }
        }
    }
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None)
    {
        Outer.ClientMessage("Unable to give effect - " $ nmPawn $ " is not a valid pawn name");
        return;
    }
    Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        Outer.ClientMessage("Unable to give effect - " $ nmPawn $ " does not have an SFXModule_GameEffectManager");
        return;
    }
    Effect = Manager.CreateEffect(EffectClass, EffectClass.default.Category, 0.0, 2, Value);
    if (Effect != None)
    {
        Outer.ClientMessage("The effect has been given to the pawn");
        Effect.OnApplied();
    }
    else
    {
        Outer.ClientMessage("Failed to create the effect");
    }
}
public final exec function GiveExplorationGawAsset()
{
    local bool bAssetUnlocked;
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    bAssetUnlocked = GAWHandler.UnlockExplorationGAWAsset();
    if (!bAssetUnlocked)
    {
        Outer.ClientMessage("No Available Assets. Check back later.");
    }
}
public final exec function GiveGAWAsset(int Id)
{
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.UnlockGAWAsset(Id);
}
public final exec function GiveGAWAssetByName(string AssetName)
{
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.UnlockGAWAssetByAssetName(AssetName);
}
public final exec function GiveGAWCredits(int Id)
{
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.GiveGAWCreditsForAsset(Id);
}
public exec function GiveItem(string sTarget, Name nmItemLabel)
{
    local BioPawn oPawn;
    local Class<SFXWeapon> cWeapon;
    local SFXWeapon Weapon;
    local SFXEngine Engine;
    local SFXModule_GameEffectManager GEManager;
    local SFXGameEffect GameEffect;
    local BioGlobalVariableTable VarTable;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    if (Outer.Role != ENetRole.ROLE_Authority)
    {
        Outer.DispatchCommand("GiveItem" @ sTarget @ nmItemLabel);
    }
    else
    {
        oPawn = BioPawn(GetActorFromString(sTarget));
        if (oPawn == None)
        {
            return;
        }
        cWeapon = FindWeaponClass(string(nmItemLabel));
        if (cWeapon == None)
        {
            cWeapon = FindWeaponClass("SFXGameContent." $ nmItemLabel);
        }
        if (cWeapon == None)
        {
            cWeapon = FindWeaponClass("SFXGameContent.SFXWeapon_" $ nmItemLabel);
        }
        if (cWeapon == None)
        {
            cWeapon = FindWeaponClass("SFXGameContent.SFXWeapon_Heavy_" $ nmItemLabel);
        }
        if (cWeapon == None)
        {
            cWeapon = FindWeaponClass("SFXGameContent.SFXWeapon_AssaultRifle_" $ nmItemLabel);
        }
        if (cWeapon == None)
        {
            cWeapon = FindWeaponClass("SFXGameContent.SFXWeapon_Shotgun_" $ nmItemLabel);
        }
        if (cWeapon == None)
        {
            cWeapon = FindWeaponClass("SFXGameContent.SFXWeapon_SniperRifle_" $ nmItemLabel);
        }
        if (cWeapon == None)
        {
            cWeapon = FindWeaponClass("SFXGameContent.SFXWeapon_Pistol_" $ nmItemLabel);
        }
        if (cWeapon == None)
        {
            cWeapon = FindWeaponClass("SFXGameContent.SFXWeapon_SMG_" $ nmItemLabel);
        }
        if (cWeapon == None)
        {
            return;
        }
        if (SFXPawn_Player(oPawn) != None)
        {
            if (Engine.GetPlayerVariable(Name(PathName(cWeapon))) < 1)
            {
                Engine.SetPlayerVariable(Name(PathName(cWeapon)), 1);
            }
            Weapon = Outer.Spawn(cWeapon);
            if (Weapon.WeaponAcquiredID != 0 && BioWorldInfo(Outer.WorldInfo) != None)
            {
                VarTable = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
                if (VarTable != None)
                {
                    VarTable.SetBool(Weapon.WeaponAcquiredID, TRUE, FALSE);
                }
            }
            GEManager = SFXPawn_Player(oPawn).GetModule(Class'SFXModule_GameEffectManager');
            if (GEManager != None)
            {
                foreach GEManager.GameEffects(GameEffect, )
                {
                    if (SFXGameEffect_PassiveWeaponBonus(GameEffect) != None)
                    {
                        SFXGameEffect_PassiveWeaponBonus(GameEffect).ApplyBonus(Weapon);
                    }
                }
            }
            SFXPawn_Player(oPawn).GiveWeaponToPlayer(Weapon);
        }
        else
        {
            oPawn.CreateWeapon(cWeapon);
            oPawn.SetWeaponImmediatelyByClass(cWeapon);
        }
    }
}
public final exec function GiveNextGawAsset(string Type)
{
    local bool bAssetUnlocked;
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    if (Caps(Type) == "MILITARY")
    {
        bAssetUnlocked = GAWHandler.UnlockNextGAWAsset(0);
    }
    else if (Caps(Type) == "INTEL")
    {
        bAssetUnlocked = GAWHandler.UnlockNextGAWAsset(2);
    }
    else if (Caps(Type) == "SALVAGE")
    {
        bAssetUnlocked = GAWHandler.UnlockNextGAWAsset(4);
    }
    else if (Caps(Type) == "ARTIFACT")
    {
        bAssetUnlocked = GAWHandler.UnlockNextGAWAsset(3);
    }
    if (!bAssetUnlocked)
    {
        Outer.ClientMessage("No Appropriate Asset Found :'(");
    }
}
public exec function GivePower(string nmPawn, string PowerClassName)
{
    local Class<SFXPowerCustomActionBase> PowerClass;
    local BioPawn oPawn;
    local SFXPowerCustomActionBase oPower;
    
    PowerClass = FindPowerClass(PowerClassName);
    if (PowerClass == None)
    {
        PowerClass = FindPowerClass("SFXGameContent." $ PowerClassName);
    }
    if (PowerClass == None)
    {
        PowerClass = FindPowerClass("SFXGameMPContent." $ PowerClassName);
    }
    if (PowerClass == None)
    {
        PowerClass = FindPowerClass("SFXGameContent.SFXPowerCustomAction_" $ PowerClassName);
    }
    if (PowerClass == None)
    {
        PowerClass = FindPowerClass("SFXGameMPContent.SFXPowerCustomAction_" $ PowerClassName);
    }
    if (PowerClass == None)
    {
        Outer.ClientMessage("Unable to give power - Failed to load power " $ PowerClassName);
        return;
    }
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None || oPawn.PowerManager == None)
    {
        Outer.ClientMessage("Unable to give power - " $ nmPawn $ " is not a valid pawn name");
        return;
    }
    oPawn.PowerManager.AddPower(PowerClass);
    oPower = oPawn.PowerManager.GetPowerByClass(PowerClass);
    if (oPower != None)
    {
        Outer.ClientMessage("The power has been given to the pawn");
        oPower.Rank = 1.0;
        oPower.OnPowerRankIncreased();
    }
    else
    {
        Outer.ClientMessage("Unable to give the power to the pawn");
    }
}
public exec function GiveResource(EInventoryResourceTypes eResourceType, int nAmt)
{
    local BioPawn oPlayerPawn;
    local SFXInventoryManager oInventory;
    
    oPlayerPawn = BioPawn(Outer.Pawn);
    if (oPlayerPawn == None || oPlayerPawn.InvManager == None)
    {
        return;
    }
    oInventory = SFXInventoryManager(oPlayerPawn.InvManager);
    if (oInventory == None)
    {
        return;
    }
    oInventory.AdjustResource(eResourceType, nAmt, TRUE, TRUE);
}
public exec function GiveSuperGun()
{
    local BioPlayerController oController;
    local BioPawn oPlayer;
    local SFXWeapon oWeapon;
    local BioRemoteLogger GLogger;
    
    oController = Outer;
    oPlayer = BioPawn(oController.Pawn);
    oWeapon = SFXWeapon(oPlayer.Weapon);
    oWeapon.bSuperDamage = TRUE;
    oWeapon.MagSize.Value = 9999.0;
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None)
    {
        GLogger.SendInvalidPlaythrough("SuperGun");
    }
}
public exec function GiveTalentPoints(int nNumPoints)
{
    local BioPawn TalentPlayer;
    local BioPawn SquadMember;
    local int nIndex;
    
    TalentPlayer = BioPawn(Outer.Pawn);
    if (TalentPlayer != None && TalentPlayer.Squad != None)
    {
        for (nIndex = 0; nIndex < TalentPlayer.Squad.Members.Length; nIndex++)
        {
            SquadMember = BioPawn(TalentPlayer.Squad.Members[nIndex]);
            if (SquadMember != None)
            {
                SquadMember.AddTalentPoints(nNumPoints);
            }
        }
    }
    Outer.ClientMessage(nNumPoints $ " talent points given to each squad member");
}
public exec function GiveXP(float XPValue)
{
    Outer.GrantXP(XPValue);
}
public exec function GUICMD(Name nmPanelTag, string sCmd, optional string sArg1, optional string sArg2)
{
    Outer.ClientMessage("GUICMD: Disabled due to Gfx integration. Sorry.");
}
public exec function HasChangedDifficulty()
{
    local BioGlobalVariableTable VarTable;
    
    VarTable = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    if (VarTable != None)
    {
        if (!VarTable.GetBoolByName('ChangedDifficulty'))
        {
            Outer.ClientMessage("Difficulty has not been changed.");
        }
        else
        {
            Outer.ClientMessage("Difficulty has been changed.");
        }
    }
    else
    {
        Outer.ClientMessage("Could not get the variable table.");
    }
}
public exec function HenchmanUseNode(string HenchmanName, Name NodeName, bool StartUsingNode)
{
    local Pawn Henchman;
    local SFXAI_Henchman AI;
    local SFXNav_InteractionPoint Node;
    local int Busy;
    
    Henchman = Pawn(GetActorFromString(HenchmanName));
    if (Henchman == None)
    {
        return;
    }
    AI = SFXAI_Henchman(Henchman.Controller);
    if (AI == None)
    {
        return;
    }
    if (StartUsingNode)
    {
        foreach Outer.WorldInfo.AllNavigationPoints(Class'SFXNav_InteractionPoint', Node)
        {
            if (NodeName == Node.Name)
            {
                break;
            }
        }
        if (Node == None)
        {
            return;
        }
        AI.UseInteractionPoint(Node, 60.0, None, None, Busy);
        Outer.ClientMessage(HenchmanName $ " will use " $ NodeName);
    }
    else
    {
        AI.StopInteraction();
        Outer.ClientMessage(HenchmanName $ " will stop using " $ NodeName);
    }
}
public exec function HideActionIndicator()
{
    local SFXSFHandler_HUD HUD;
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    HUD = oGUI.CastGetMovie(Class'SFXSFHandler_HUD', Outer, oGUI.MovieTag_HUD);
    HUD.HideActionIndicator();
}
public exec function HideAudioEmitter(string nmAudioEmitter)
{
    local Actor AudioActor;
    local WwiseAmbientSound AudioEmitter;
    
    AudioActor = GetActorFromString(nmAudioEmitter);
    AudioEmitter = WwiseAmbientSound(AudioActor);
    if (AudioEmitter != None)
    {
        AudioEmitter.HideEmitter();
    }
}
public exec function HideAudioVolume(string nmAudioVolume)
{
    local Actor AudioActor;
    local WwiseAudioVolume AudioVolume;
    
    AudioActor = GetActorFromString(nmAudioVolume);
    AudioVolume = WwiseAudioVolume(AudioActor);
    if (AudioVolume != None)
    {
        AudioVolume.HideVolume();
    }
}
public exec function HideInterruptUI()
{
    local SFXGUIInteraction pSFManager;
    local BioSFHandler_Conversation pConv;
    
    pSFManager = Class'SFXGUIInteraction'.static.GetInstance();
    pConv = pSFManager.CastGetMovie(Class'BioSFHandler_Conversation', Outer, pSFManager.MovieTag_Conversation);
    if (pConv != None)
    {
        pConv.AS_SetRenegadeInterrupt(FALSE);
        pConv.AS_SetParagonInterrupt(FALSE);
    }
}
public exec function HideMicrophone()
{
    Class'WwiseAudioComponent'.static.SetDrawMic(FALSE);
}
public exec function HidePOIIndicator()
{
    local SFXSFHandler_HUD HUD;
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    HUD = oGUI.CastGetMovie(Class'SFXSFHandler_HUD', Outer, oGUI.MovieTag_HUD);
    HUD.SetPOIState(0);
}
public exec function HideWwiseVolumeLocations(string nmVolume)
{
    local WwiseAudioVolume AudioVolume;
    
    AudioVolume = WwiseAudioVolume(GetActorFromString(nmVolume));
    if (AudioVolume != None)
    {
        AudioVolume.DrawSoundLocations = FALSE;
        AudioVolume.m_oTrackTimer.SetTimer(0.0500000007, TRUE, , );
        Outer.ClientMessage("Hiding sound locations for" @ nmVolume);
    }
}
public exec function HolsterWeapon(string nmPawn)
{
    local BioPawn oPawn;
    local SFXAI_Core oController;
    
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None)
    {
        return;
    }
    oController = SFXAI_Core(oPawn.Controller);
    if (oController == None)
    {
        return;
    }
    if (oPawn.IsReloading(TRUE))
    {
        return;
    }
    if (oPawn.InCombat())
    {
        return;
    }
    if (oPawn.IsInCover())
    {
        oPawn.LeaveCover();
    }
}
public function HTTPResult(SFXOnlineHTTPRequest request)
{
}
public exec function IgnorePlayer(bool bIgnore)
{
    local BioPawn PlayerPawn;
    local BioAiController AI;
    
    PlayerPawn = SFXGame(Outer.WorldInfo.Game).PlayerSquad.CachedPlayerPawn;
    foreach Outer.WorldInfo.AllControllers(Class'BioAiController', AI)
    {
        if (SFXAI_Henchman(AI) == None)
        {
            if (bIgnore)
            {
                AI.AddIgnoredTarget(PlayerPawn);
            }
            else
            {
                AI.RemoveIgnoredTarget(PlayerPawn);
            }
        }
    }
    if (bIgnore)
    {
        Outer.ClientMessage("The player has been ignored");
    }
    else
    {
        Outer.ClientMessage("The player has not been ignored");
    }
}
public final exec function ImportAllCareers()
{
    local BioPlayerController PC;
    local OnlineSubsystem OnlineSS;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local int ControllerId;
    
    if (!Class'WorldInfo'.static.IsConsoleBuild(1))
    {
        return;
    }
    PC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    OnlineSS = Class'GameEngine'.static.GetOnlineSubsystem();
    if (PC != None && OnlineSS != None)
    {
        PlayerIntEx = OnlineSS.PlayerInterfaceEx;
        ControllerId = LocalPlayer(PC.Player).ControllerId;
        if (PlayerIntEx != None)
        {
            PlayerIntEx.AddDeviceSelectionDoneDelegate(byte(ControllerId), ImportAllCareers_OnDeviceSelectionComplete);
            if (PlayerIntEx.ShowDeviceSelectionUI(byte(ControllerId), 1048576, TRUE))
            {
                return;
            }
            else
            {
                PlayerIntEx.ClearDeviceSelectionDoneDelegate(byte(ControllerId), ImportAllCareers_OnDeviceSelectionComplete);
            }
        }
    }
}
public final function ImportAllCareers_OnDeviceSelectionComplete(bool bWasSuccessful, bool bWasBlocked)
{
    local BioPlayerController PC;
    local OnlineSubsystem OnlineSS;
    local OnlinePlayerInterfaceEx PlayerIntEx;
    local int ControllerId;
    local int DeviceID;
    local string DeviceName;
    
    PC = Outer;
    OnlineSS = Class'GameEngine'.static.GetOnlineSubsystem();
    if (PC != None && OnlineSS != None)
    {
        PlayerIntEx = OnlineSS.PlayerInterfaceEx;
        ControllerId = LocalPlayer(PC.Player).ControllerId;
        if (PlayerIntEx != None)
        {
            PlayerIntEx.ClearDeviceSelectionDoneDelegate(byte(ControllerId), ImportAllCareers_OnDeviceSelectionComplete);
            if (bWasSuccessful)
            {
                DeviceID = PlayerIntEx.GetDeviceSelectionResults(byte(ControllerId), DeviceName);
                ImportAllCareersXenon(DeviceID);
                return;
            }
        }
    }
}
public exec function IncrementGrinder(int AccomplishmentProgressIndex, optional int Amount)
{
    local SFXAccomplishmentManager AccomplishmentManager;
    local int CurProgress;
    local Name AccomplishmentProgressName;
    
    if (Amount <= 0)
    {
        Amount = 1;
    }
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager != None)
    {
        AccomplishmentProgressName = AccomplishmentManager.AccomplishmentProgressIndexToName(AccomplishmentProgressIndex);
        CurProgress = AccomplishmentManager.GetGrinderAccomplishmentProgress(AccomplishmentProgressName, Outer);
        CurProgress += Amount;
        Outer.SetAccomplishmentProgression(AccomplishmentProgressName, CurProgress, TRUE);
    }
}
public exec function InitAmmo(int nAmmo)
{
    local BioPlayerController Controller;
    local SFXInventoryManager InvManager;
    local SFXWeapon Weapon;
    
    Controller = Outer;
    InvManager = SFXInventoryManager(Controller.Pawn.InvManager);
    foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
    {
        if (SFXHeavyWeapon(Weapon) != None)
        {
            SFXHeavyWeapon(Weapon).AddHeavyAmmo(nAmmo);
        }
        else
        {
            Weapon.AddAmmo(nAmmo);
        }
    }
}
public exec function InitCredits(int nCredits)
{
    InitResource(0, nCredits);
}
public exec function InitEezo(int nResource)
{
    InitResource(4, nResource);
}
public exec function InitFuel(float fAmt)
{
    local SFXInventoryManager oInventory;
    
    oInventory = SFXInventoryManager(BioPawn(Outer.Pawn).InvManager);
    oInventory.CurrentFuel = FMin(oInventory.CurrentFuel + fAmt, oInventory.GetMaxFuel());
}
public exec function InitFuelEfficiency(float fEff)
{
    local SFXInventoryManager oInventory;
    
    oInventory = SFXInventoryManager(BioPawn(Outer.Pawn).InvManager);
    oInventory.FuelEfficiency = fEff;
}
public exec function InitGrenades(int nGrenade)
{
    local BioPawn oSquadMember;
    local BioPawn oPlayerPawn;
    local SFXInventoryManager oInventory;
    local int Index;
    
    oPlayerPawn = BioPawn(Outer.Pawn);
    for (Index = 0; Index < oPlayerPawn.Squad.Members.Length; Index++)
    {
        oSquadMember = BioPawn(oPlayerPawn.Squad.Members[Index]);
        if (oSquadMember != None)
        {
            oInventory = SFXInventoryManager(oSquadMember.InvManager);
            if (oInventory != None)
            {
                oInventory.AdjustResource(3, nGrenade, FALSE, FALSE);
            }
        }
    }
}
public exec function InitIridium(int nResource)
{
    InitResource(5, nResource);
}
public exec function InitMaxFuel(float FMax)
{
    local SFXInventoryManager oInventory;
    
    oInventory = SFXInventoryManager(BioPawn(Outer.Pawn).InvManager);
    oInventory.SetMaxFuel(FMax);
    oInventory.CurrentFuel = FMin(oInventory.CurrentFuel, oInventory.GetMaxFuel());
}
public exec function InitMedigel(int nMedigel)
{
    InitResource(1, nMedigel);
}
public exec function InitPalladium(int nResource)
{
    InitResource(6, nResource);
}
public exec function InitPlatinum(int nResource)
{
    InitResource(7, nResource);
}
public exec function InitPlotManagerValueByIndex(int nIndex, string sVariableType, float fValue)
{
    local BioGlobalVariableTable gv;
    local int nValue;
    local bool bValue;
    
    gv = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    if (sVariableType == "bool")
    {
        bValue = TRUE;
        if (fValue == 0.0)
        {
            bValue = FALSE;
        }
        gv.SetBool(nIndex, bValue);
    }
    else if (sVariableType == "int")
    {
        nValue = int(fValue);
        gv.SetInt(nIndex, nValue);
    }
    else if (sVariableType == "float")
    {
        gv.SetFloat(nIndex, fValue);
    }
}
public exec function InitProbes(int nResource)
{
    InitResource(8, nResource);
}
public exec function InitResource(EInventoryResourceTypes eResourceType, int nAmt)
{
    local int nAmtIncrease;
    local BioPawn oPlayerPawn;
    local SFXInventoryManager oInventory;
    
    oPlayerPawn = BioPawn(Outer.Pawn);
    if (oPlayerPawn == None || oPlayerPawn.InvManager == None)
    {
        return;
    }
    oInventory = SFXInventoryManager(oPlayerPawn.InvManager);
    if (oInventory == None)
    {
        return;
    }
    nAmtIncrease = nAmt - oInventory.GetResource(eResourceType);
    oInventory.AdjustResource(eResourceType, nAmtIncrease, TRUE, TRUE);
}
public exec function InitSalvage(int nSalvage)
{
    InitResource(2, nSalvage);
}
public exec function IsBonusPowerUnlocked(int BonusPowerID)
{
    local SFXProfileSettings Profile;
    
    Profile = Outer.ProfileSettings;
    if (Profile != None)
    {
        if (Profile.IsBonusPowerUnlocked(BonusPowerID))
        {
            Outer.ClientMessage("Power is unlocked");
        }
        else
        {
            Outer.ClientMessage("Power is not unlocked");
        }
    }
}
public final function KeyboardTestEntryComplete(bool bOK, string sText)
{
    if (!bOK)
    {
        TestString("Keyboard input cancelled");
    }
    else
    {
        TestString("Keyboard Input=\"" $ sText $ "\"");
    }
    m_TestKeyboard = None;
}
public exec function KillEnemies()
{
    local BioPawn ChkPawn;
    local BioRemoteLogger GLogger;
    
    foreach Outer.WorldInfo.AllPawns(Class'BioPawn', ChkPawn)
    {
        if (ChkPawn.IsHostile(Outer.Pawn))
        {
            ChkPawn.Died(Outer, Class'SFXDamageType_CheatKill', ChkPawn.location);
        }
    }
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None)
    {
        GLogger.SendInvalidPlaythrough("KillEnemies");
    }
}
public exec function KillParty()
{
    local BioPawn ChkPawn;
    
    foreach Outer.WorldInfo.AllPawns(Class'BioPawn', ChkPawn)
    {
        if (ChkPawn.Squad == BioPawn(Outer.Pawn).Squad && ChkPawn != Outer.Pawn)
        {
            ChkPawn.Died(Outer, Class'SFXDamageType_Suicide', ChkPawn.location);
        }
    }
}
public exec function KillSelf()
{
    local Pawn PlayerPawn;
    
    if (Outer.Pawn != None)
    {
        if (Vehicle(Outer.Pawn) == None)
        {
            PlayerPawn = Outer.Pawn;
        }
        else
        {
            PlayerPawn = Vehicle(Outer.Pawn).Driver;
        }
    }
    if (PlayerPawn != None)
    {
        PlayerPawn.Died(Outer, Class'SFXDamageType_Suicide', Outer.location);
    }
    else
    {
        Outer.ClientMessage("KillSelf: Failed to find player pawn");
    }
}
public exec function KillTarget()
{
    local Actor MyTarget;
    
    MyTarget = Outer.m_oPlayerSelection.m_oCurrentSelectionTarget;
    if (Pawn(MyTarget) != None)
    {
        Pawn(MyTarget).Died(Outer, Class'SFXDamageType_CheatKill', MyTarget.location);
    }
}
public final exec function LoadGame(string LoadName)
{
    PendingLoadGameDebugName = LoadName;
    SFXEngine(Outer.Player.Outer).QueueSaveGameCommand(7, , SaveCommandCallback_LoadGame);
}
public exec function LockAllAccomplishments();

public exec function LogKeyBindings()
{
    Outer.GameModeManager2.LogKeyBindings();
}
public exec function MainMenu_AddCerberusItem(string i_sTitle, string i_sInfo, int nDlcID, int nMessageId)
{
    local SFXGUIInteraction oManager;
    local BioSFHandler_MainMenu oHandler;
    
    oManager = Class'SFXGUIInteraction'.static.GetInstance();
    if (oManager != None)
    {
        oHandler = oManager.GetMainMenuHandler(Outer);
        if (oHandler != None)
        {
            oHandler.AddNetworkImageMessageItem(i_sTitle, i_sInfo, "", 0, nDlcID, nMessageId);
        }
    }
}
public exec function MainMenu_ClearNotifications()
{
    local SFXGUIInteraction oManager;
    local BioSFHandler_MainMenu oHandler;
    
    oManager = Class'SFXGUIInteraction'.static.GetInstance();
    if (oManager != None)
    {
        oHandler = oManager.GetMainMenuHandler(Outer);
        if (oHandler != None)
        {
            oHandler.ClearNotifications();
        }
    }
}
public exec function MainMenu_FailImageAssets()
{
    local SFXGUIInteraction oManager;
    local BioSFHandler_MainMenu oHandler;
    
    oManager = Class'SFXGUIInteraction'.static.GetInstance();
    if (oManager != None)
    {
        oHandler = oManager.GetMainMenuHandler(Outer);
        if (oHandler != None)
        {
            oHandler.MainMenu_FailImageAssets();
        }
    }
}
public exec function MainMenu_OutputMessages()
{
    local SFXGUIInteraction oManager;
    local BioSFHandler_MainMenu oHandler;
    
    oManager = Class'SFXGUIInteraction'.static.GetInstance();
    if (oManager != None)
    {
        oHandler = oManager.GetMainMenuHandler(Outer);
        if (oHandler != None)
        {
            oHandler.OutputMessages();
        }
    }
}
public exec function MapPower(Name PowerName)
{
    if (BioPlayerInput(Outer.PlayerInput).m_nmMappedPower != PowerName)
    {
        BioPlayerInput(Outer.PlayerInput).m_nmMappedPower2 = BioPlayerInput(Outer.PlayerInput).m_nmMappedPower;
        BioPlayerInput(Outer.PlayerInput).m_nmMappedPower = PowerName;
    }
    Outer.ClientMessage("Mapped powers set to" @ PowerName @ " and " @ BioPlayerInput(Outer.PlayerInput).m_nmMappedPower2);
}
public exec function Min1Health(bool B)
{
    local BioRemoteLogger GLogger;
    
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None)
    {
        GLogger.SendInvalidPlaythrough("SetPlayerSquadMin1Health");
    }
    if (Outer.Role != ENetRole.ROLE_Authority)
    {
        Outer.DispatchCommand("Min1Health" @ B);
    }
    else if (BioPawn(Outer.Pawn) != None)
    {
        BioPawn(Outer.Pawn).m_bMin1Health = B;
        Outer.ClientMessage("Min1Health set to" @ B);
    }
}
public function OnAutoGrantComplete()
{
    Outer.ClientMessage("OnAutoGrantComplete");
}
public exec function OpenGui(Name HandlerId)
{
    Class'SFXGUIInteraction'.static.GetInstance().OpenMovie(Outer, HandlerId, TRUE);
}
private final function OutputGAWAssetsFromIDs(const out array<GAWAsset> Assets, optional int TotalStrength, optional int AssetCount)
{
    local array<GAWAsset> ModifierAssets;
    local int CurrentStrength;
    local int idx;
    local int Idx2;
    local int Idx3;
    local int EntryCount;
    local int ProfileColumn;
    local int MaxEntries;
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.GetGAWAssetsByType(7, ModifierAssets);
    ProfileHeaderColor = GAWTextColor;
    ProfileHighlightColor = GAWHighlightColor;
    ProfileColumn = 1;
    MaxEntries = 62;
    DrawBrightText("Total Strength: ", 1);
    DrawBrightText(string(TotalStrength), 2, TRUE);
    EntryCount++;
    DrawBrightText("Number of Assets: ", 1);
    DrawBrightText(string(AssetCount), 2, TRUE);
    EntryCount++;
    DrawProfileText(" ");
    EntryCount++;
    for (idx = 0; idx < Assets.Length; idx++)
    {
        if (EntryCount >= MaxEntries)
        {
            ProfileColumn++;
            SetProfileColumn(ProfileColumn);
            MaxEntries += 62;
        }
        if (GAWHandler.IsGAWAssetUnlocked(Assets[idx].Id, CurrentStrength) != FALSE && Assets[idx].Type != EGAWAssetType.GAWAssetType_Modifier)
        {
            DrawBrightText(Assets[idx].AssetName $ ", ", 1);
            DrawBrightText(string(CurrentStrength), 2);
            DrawBrightText(" Current Strength, " $ Assets[idx].StartingStrength $ " Starting Strength, " $ "ID: " $ Assets[idx].Id, 0, TRUE);
            EntryCount++;
            if (EntryCount >= MaxEntries)
            {
                ProfileColumn++;
                SetProfileColumn(ProfileColumn);
                MaxEntries += 62;
            }
            for (Idx2 = 0; Idx2 < ModifierAssets.Length; Idx2++)
            {
                if (ModifierAssets[Idx2].Type == EGAWAssetType.GAWAssetType_Modifier)
                {
                    for (Idx3 = 0; Idx3 < ModifierAssets[Idx2].ModTargets.Length; Idx3++)
                    {
                        if (Assets[idx].Id == ModifierAssets[Idx2].ModTargets[Idx3].TargetID)
                        {
                            DrawBrightText("    " $ ModifierAssets[Idx2].AssetName $ ", ", 0);
                            DrawBrightText(string(ModifierAssets[Idx2].ModTargets[Idx3].Value), 2);
                            DrawBrightText(", " $ "ID: " $ ModifierAssets[Idx2].Id, 0, TRUE);
                            EntryCount++;
                            if (EntryCount >= MaxEntries)
                            {
                                ProfileColumn++;
                                SetProfileColumn(ProfileColumn);
                                MaxEntries += 62;
                            }
                        }
                    }
                }
            }
        }
    }
    DrawBrightText("All Modifiers", 1, TRUE);
    EntryCount++;
    if (EntryCount >= MaxEntries)
    {
        ProfileColumn++;
        SetProfileColumn(ProfileColumn);
        MaxEntries += 62;
    }
    for (idx = 0; idx < ModifierAssets.Length; idx++)
    {
        if (GAWHandler.IsGAWAssetUnlocked(ModifierAssets[idx].Id) == FALSE)
        {
            continue;
        }
        DrawBrightText(ModifierAssets[idx].AssetName $ " " $ ModifierAssets[idx].ModTargets[Idx3].Value $ " ID: " $ ModifierAssets[idx].Id, 0, TRUE);
        EntryCount++;
        if (EntryCount >= MaxEntries)
        {
            ProfileColumn++;
            SetProfileColumn(ProfileColumn);
            MaxEntries += 62;
        }
    }
    ProfileHeaderColor = default.ProfileHeaderColor;
    ProfileHighlightColor = default.ProfileHighlightColor;
}
public exec function OverrideCEMaxDistance(bool bOverride, float fValue)
{
    local RvrClientEffectManager Manager;
    
    Manager = Class'RvrClientEffectManager'.static.GetClientEffectManager();
    if (Manager != None)
    {
        Manager.m_bMaxDistance_Debug_Override = bOverride;
        Manager.m_fMaxDistance_Debug_Override_Value = fValue;
    }
}
public exec function OverrideCEOnVisible(bool bOverride, bool bValue)
{
    local RvrClientEffectManager Manager;
    
    Manager = Class'RvrClientEffectManager'.static.GetClientEffectManager();
    if (Manager != None)
    {
        Manager.m_bOnVisible_Debug_Override = bOverride;
        Manager.m_bOnVisible_Debug_Override_Value = bValue;
    }
}
public exec function PartyMin1Health(bool B)
{
    local BioBaseSquad Squad;
    local int idx;
    local BioRemoteLogger GLogger;
    
    Outer.ClientMessage("PartyMin1Health set to" @ B);
    Squad = BioPawn(Outer.Pawn).Squad;
    for (idx = 0; idx < Squad.Members.Length; idx++)
    {
        BioPawn(Squad.Members[idx]).m_bMin1Health = B;
    }
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None)
    {
        GLogger.SendInvalidPlaythrough("SetPlayerSquadMin1Health");
    }
}
public exec function PauseNotifications(bool bPause)
{
    local BioHintSystem oHintSystem;
    local BioPlayerController oController;
    
    oController = Outer;
    oHintSystem = BioHintSystem(oController.HintSystem);
    if (oHintSystem != None)
    {
        oHintSystem.SetNotificationPaused(bPause);
    }
}
public final exec function PauseTraceStrips()
{
    BioHUD(Outer.myHUD).TraceStripsPaused = !BioHUD(Outer.myHUD).TraceStripsPaused;
}
public final exec function PermanentBonus(Name UniqueName)
{
    local SFXPawn_Player PlayerPawn;
    
    PlayerPawn = SFXPawn_Player(Outer.Pawn);
    if (PlayerPawn == None)
    {
        return;
    }
    if (PlayerPawn.ApplyPermanentPlayerGameEffect(UniqueName) == TRUE)
    {
        Outer.ClientMessage("Permanent bonus added - " $ UniqueName);
    }
}
public final function PlayLine(BioSimpleDialog DialogPlayer, string EventName, int Index)
{
    DialogPlayer.PlayVOEventLine(Name(EventName), Index, SFXPlayerController(Outer));
}
public exec function Playpens()
{
    local BioPlaypenVolume oPlaypen;
    local int nRed;
    local int nGreen;
    local Vector vOrigin;
    local Vector vExtent;
    local Vector vStart;
    local Vector vEnd;
    
    foreach Outer.AllActors(Class'BioPlaypenVolume', oPlaypen, )
    {
        if (oPlaypen != None && oPlaypen.CollisionComponent != None)
        {
            if (oPlaypen.bSubtractive)
            {
                nRed = 255;
                nGreen = 0;
            }
            else
            {
                nRed = 0;
                nGreen = 255;
            }
            vOrigin = oPlaypen.CollisionComponent.Bounds.Origin;
            vExtent = oPlaypen.CollisionComponent.Bounds.BoxExtent;
            Outer.DrawDebugBox(vOrigin, vExtent, byte(nRed), byte(nGreen), 0, TRUE);
            vStart = vOrigin;
            vStart.X -= float(10);
            vEnd = vOrigin;
            vEnd.X += float(10);
            Outer.DrawDebugLine(vStart, vEnd, byte(nRed), byte(nGreen), 0, TRUE);
            vStart = vOrigin;
            vStart.Y -= float(10);
            vEnd = vOrigin;
            vEnd.Y += float(10);
            Outer.DrawDebugLine(vStart, vEnd, byte(nRed), byte(nGreen), 0, TRUE);
            vStart = vOrigin;
            vStart.Z -= float(10);
            vEnd = vOrigin;
            vEnd.Z += float(10);
            Outer.DrawDebugLine(vStart, vEnd, byte(nRed), byte(nGreen), 0, TRUE);
        }
    }
}
public exec function PowersWhileVisible()
{
    local BioBaseSquad PlayerSquad;
    local BioAiController Controller;
    local SFXAI_Henchman Henchman;
    local bool bEnabled;
    
    PlayerSquad = SFXGame(Outer.WorldInfo.Game).PlayerSquad;
    if (PlayerSquad != None)
    {
        foreach PlayerSquad.SquadMembers(Controller)
        {
            Henchman = SFXAI_Henchman(Controller);
            if (Henchman != None)
            {
                Henchman.m_bAllowInstantPowerWhileVisible = !Henchman.m_bAllowInstantPowerWhileVisible;
                if (Henchman.m_bAllowInstantPowerWhileVisible)
                {
                    bEnabled = TRUE;
                }
            }
        }
    }
    if (bEnabled)
    {
        Outer.ClientMessage("The henchmen can use powers instantly");
    }
    else
    {
        Outer.ClientMessage("The henchmen can not use powers instantly");
    }
}
public static final function string PrettyFloat(float F, optional int decimals = 1)
{
    return Class'BioDefine'.static.PrettyFloat(F, decimals);
}
public function string PrettySF(ScaledFloat V)
{
    return "(" $ V.X $ "," $ V.Y $ ")";
}
public function string PrettyV2D(Vector2D V, optional int digits)
{
    return "(" $ PrettyFloat(V.X, digits) $ "," $ PrettyFloat(V.Y, digits) $ ")";
}
public exec function PrintFaceCodesStoredOnline()
{
}
public exec function PrintGui(Name HandlerId)
{
    local SFXGUIMovie movie;
    
    movie = Class'SFXGUIInteraction'.static.GetInstance().GetMovie(Outer, HandlerId);
    if (movie != None)
    {
        movie.Invoke0("PrintMovieHierarchy");
    }
}
public function ProfileAngst()
{
    DisplayAngstInfo(FALSE, TRUE);
}
public final function ProfileArtifactGAWAssets()
{
    local array<GAWAsset> Assets;
    local int AssetCount;
    local int TotalStrength;
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.GetGAWAssetsByType(3, Assets);
    TotalStrength = GAWHandler.GetTotalStrengthByType(3, AssetCount);
    OutputGAWAssetsFromIDs(Assets, TotalStrength, AssetCount);
}
public function ProfileCamera()
{
    local PlayerController Controller;
    local SFXPlayerCamera Camera;
    
    Controller = Outer;
    Camera = SFXPlayerCamera(Controller.PlayerCamera);
    DrawProfileText("Camera:" @ Camera);
    DrawProfileText("Active:" @ Camera.CurrentCameraMode);
    DrawProfileText("Actual POV: (Rotation=" @ Camera.CameraCache.POV.Rotation @ ", Location=" @ Camera.CameraCache.POV.location @ ", FOV=" @ Camera.CameraCache.POV.FOV);
    DrawProfileText("Target POV: (Rotation=" @ Camera.ViewTarget.POV.Rotation @ ", Location=" @ Camera.ViewTarget.POV.location @ ", FOV=" @ Camera.ViewTarget.POV.FOV);
    Camera.CurrentCameraMode.DrawHUD(Self);
}
public function ProfileCombat()
{
    local BioPawn CombatPawn;
    local Actor Target;
    local SFXWeapon Weapon;
    local SFXWeapon TargetWeapon;
    local SFXShield_Base Shield;
    local SFXLoadoutData Loadout;
    local Class<SFXWeapon> WeaponClass;
    local SFXInventoryManager InvManager;
    local SFXAI_Core AI;
    local BioAiController SquadAI;
    local EnemyInfo EnemyInfo;
    local NavigationPoint Nav;
    local SFXModule_DamageParty PartyDmgModule;
    local Class<SFXDamageType> DamageType;
    local GameAICommand AICmd;
    local EAICustomAction CurrentCustomAction;
    local EPowerCustomAction CurrentPowerCustomAction;
    local Controller BaseController;
    
    if (ProfileTarget != None)
    {
        if (Vehicle(ProfileTarget) != None)
        {
            CombatPawn = BioPawn(Vehicle(ProfileTarget).Driver);
        }
        else
        {
            CombatPawn = BioPawn(ProfileTarget);
        }
        if (CombatPawn.DrivenVehicle != None)
        {
            BaseController = CombatPawn.DrivenVehicle.Controller;
        }
        else
        {
            BaseController = CombatPawn.Controller;
        }
    }
    if (CombatPawn == None)
    {
        return;
    }
    Loadout = CombatPawn.Loadout;
    if (BioAiController(BaseController) != None)
    {
        Target = BioAiController(BaseController).FireTarget;
    }
    if (BioPlayerController(BaseController) != None)
    {
        Target = BioPlayerController(BaseController).m_oPlayerSelection.m_oCurrentSelectionTarget;
    }
    DrawProfileHeaderText("Combat State: ");
    if (SFXGRI(Outer.WorldInfo.GRI).InCombat())
    {
        DrawProfileText("In Combat");
    }
    else
    {
        DrawProfileText("Out Of Combat ");
    }
    DrawProfileHeaderText("Actor Type: ");
    DrawProfileText(string(CombatPawn.Name));
    DrawProfileHeaderText("Controller: ");
    DrawProfileText(string(BaseController));
    DrawProfileHeaderText("In Combat: ");
    DrawProfileText(string(CombatPawn.InCombat()));
    DrawProfileHeaderText("Anchor: ");
    DrawProfileText(string(CombatPawn.Anchor));
    DrawProfileHeaderText("Latent Action: ");
    DrawProfileText(GetLatentAction(BaseController));
    DrawProfileHeaderText("Physics: ");
    DrawProfileText(string(CombatPawn.Physics));
    DrawProfileHeaderText("Port Arms: ");
    DrawProfileText(string(CombatPawn.bInPortArms));
    DrawProfileText(" ");
    DrawProfileHeaderText("Focus: ");
    DrawProfileText(string(BaseController != None ? BaseController.Focus : None));
    DrawProfileHeaderText("FocalPoint: ");
    DrawProfileText(string(BaseController != None ? BaseController.GetFocalPoint() : vect(0.0, 0.0, 0.0)));
    DrawProfileHeaderText("FireTarget:");
    DrawProfileText(string(Target));
    DrawProfileHeaderText("Target Distance: ");
    DrawProfileText(string(Target != None ? VSize(Target.location - CombatPawn.location) : -1.0));
    AI = SFXAI_Core(BaseController);
    if (AI != None)
    {
        DrawProfileHeaderText("ForcedTarget:");
        DrawProfileText(string(AI.ForcedTarget));
        DrawProfileHeaderText("PreferredTarget:");
        DrawProfileText(string(AI.PreferredTarget));
        DrawProfileText(" ");
        DrawProfileHeaderText("Sight Radius: ");
        DrawProfileText(PrettyFloat(CombatPawn.SightRadius));
        DrawProfileHeaderText("Hearing Radius: ");
        DrawProfileText(PrettyFloat(CombatPawn.HearingThreshold));
        foreach AI.EnemyList(EnemyInfo, )
        {
            DrawProfileHeaderText("EnemyList: ");
            DrawProfileText("Pawn:" @ EnemyInfo.Pawn @ "Visible:" @ EnemyInfo.bVisible);
        }
    }
    DrawProfileText(" ");
    DrawProfileHeaderText("Is Dead: ");
    DrawProfileText(string(CombatPawn.IsDead()));
    DrawProfileHeaderText("Current Health: ");
    DrawProfileText(PrettyFloat(CombatPawn.GetCurrentHealth()) @ "/" @ PrettyFloat(CombatPawn.GetMaxHealth()));
    if (SFXPawn_PlayerParty(CombatPawn) != None)
    {
        PartyDmgModule = CombatPawn.GetModule(Class'SFXModule_DamageParty');
        if (PartyDmgModule != None)
        {
            DrawProfileHeaderText("Bleedout State: ");
            DrawProfileText(string(PartyDmgModule.CurrentBleedoutState));
        }
    }
    DrawProfileText(" ");
    DrawProfileHeaderText("Shields: ");
    DrawProfileText(PrettyFloat(CombatPawn.GetCurrentShields(), 4) @ "/" @ PrettyFloat(CombatPawn.GetMaxShields()));
    DrawProfileHeaderText("Shield Regen Delay: ");
    DrawProfileText(PrettyFloat(CombatPawn.GetShieldRegenDelay()));
    DrawProfileHeaderText("Shield Regen %/second: ");
    DrawProfileText(PrettyFloat(CombatPawn.GetShieldRegenPct()));
    DrawProfileText(" ");
    DrawProfileHeaderText("Physics Level: ");
    DrawProfileText(string(CombatPawn.m_nPhysicsLevel));
    SetProfileColumn(++CurrentColumn);
    Weapon = SFXWeapon(CombatPawn != None ? CombatPawn.Weapon : None);
    TargetWeapon = SFXWeapon(BioPawn(Target) != None ? BioPawn(Target).Weapon : None);
    DrawProfileHeaderText("Current Weapon: ");
    DrawProfileText(Weapon != None ? string(Weapon.Class) : "None");
    DrawProfileHeaderText("Weapon Level: ");
    DrawProfileText(Weapon != None ? PrettyFloat(Weapon.WeaponLevel) : "-");
    DrawProfileHeaderText("Weapon Damage: ");
    DrawProfileText(Weapon != None ? PrettyFloat(Weapon.GetFireModeBaseDamage()) : "-");
    DamageType = Weapon != None ? Weapon.GetDamageType(0) : None;
    InvManager = BioPawn(Target) != None ? SFXInventoryManager(BioPawn(Target).InvManager) : None;
    if (InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXShield_Base', Shield)
        {
            DrawProfileHeaderText("  Target Shield: ");
            DrawProfileText("" $ Shield.Class);
            DrawProfileHeaderText("  Penetration(Target Shield): ");
            DrawProfileText(PrettyFloat(Shield.GetDamageResistance(DamageType) * float(100)) $ "%");
        }
    }
    else
    {
        DrawProfileHeaderText("  Penetration(vs Target): ");
        DrawProfileText(" - ");
    }
    DrawProfileHeaderText("Rate Of Fire: ");
    DrawProfileText(Weapon != None ? string(Weapon.GetRateOfFire()) : "-");
    DrawProfileHeaderText("Magazine Size: ");
    DrawProfileText(Weapon != None ? string(Weapon.GetMagazineSize()) : "-");
    DrawProfileHeaderText("Infinite Ammo: ");
    DrawProfileText(Weapon != None ? string(Weapon.bInfiniteAmmo) : "-");
    DrawProfileHeaderText("Aim Error: ");
    if (Weapon != None)
    {
        DrawProfileText(PrettyFloat(Weapon.GetWeaponAimErrorRange().X) @ "-" @ PrettyFloat(Weapon.GetWeaponAimErrorRange().Y));
    }
    else
    {
        DrawProfileText("-");
    }
    DrawProfileText(" ");
    DrawProfileHeaderText("Bursts To Fire: ");
    DrawProfileText(Weapon != None ? string(Weapon.GetBurstsToFire()) : "-");
    DrawProfileHeaderText("Remaining: ");
    DrawProfileText(Weapon != None ? string(Weapon.RemainingBurstsToFire) : "-");
    DrawProfileHeaderText("AI Burst Fire Count: ");
    DrawProfileText(Weapon != None ? int(Weapon.AI_BurstFireCount.X) @ "-" @ int(Weapon.AI_BurstFireCount.Y) : "-");
    DrawProfileHeaderText("Remaining: ");
    DrawProfileText(Weapon != None ? string(Weapon.RemainingBurstFireCount) : "-");
    DrawProfileHeaderText("Clip size: ");
    DrawProfileText(Weapon != None ? string(int(Weapon.MagSize.Value)) : "-");
    DrawProfileHeaderText("Remaining: ");
    DrawProfileText(Weapon != None ? string(int(Weapon.MagSize.Value - float(Weapon.AmmoUsedCount))) : "-");
    DrawProfileText(" ");
    InvManager = SFXInventoryManager(CombatPawn.InvManager);
    if (InvManager != None)
    {
        DamageType = None;
        if (TargetWeapon != None)
        {
            DamageType = TargetWeapon.GetDamageType(0);
        }
        foreach InvManager.InventoryActors(Class'SFXShield_Base', Shield)
        {
            DrawProfileHeaderText("Current Shield: ");
            DrawProfileText(string(Shield));
            DrawProfileHeaderText("  Shield Strength: ");
            DrawProfileText(Shield.GetCurrentShields() $ " / " $ Shield.GetMaxShields());
            DrawProfileHeaderText("  Damage Resistance (vs Target): ");
            DrawProfileText(PrettyFloat(Shield.GetDamageResistance(DamageType) * float(100)) $ "%");
        }
    }
    DrawProfileText(" ");
    DrawProfileHeaderText("Loadout: ");
    DrawProfileText(string(Loadout));
    if (Loadout != None)
    {
        foreach Loadout.Weapons(WeaponClass, )
        {
            DrawProfileHeaderText("Loadout Weapon: ");
            DrawProfileText(string(WeaponClass));
        }
    }
    DrawProfileText(" ");
    if (InvManager != None)
    {
        foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
        {
            if (Weapon == CombatPawn.Weapon)
            {
                DrawProfileHeaderText("Inventory Weapon: -> ");
            }
            else
            {
                DrawProfileHeaderText("Inventory Weapon: ");
            }
            DrawProfileText(string(Weapon.Class));
        }
        DrawProfileText("  ");
    }
    DrawProfileText(" ");
    DrawProfileHeaderText("Squad: ");
    if (CombatPawn.Squad != None)
    {
        DrawProfileText(string(CombatPawn.Squad));
        DrawProfileHeaderText("Has Playpen: ");
        DrawProfileText(string(CombatPawn.Squad.HasPlaypen()));
        foreach CombatPawn.Squad.SquadMembers(SquadAI)
        {
            DrawProfileHeaderText("Squad Member: ");
            DrawProfileText(string(SquadAI.Pawn));
            DrawProfileHeaderText("    AI/State: ");
            DrawProfileText(SquadAI @ "/" @ SquadAI.GetStateName());
        }
    }
    else
    {
        DrawProfileText("Squad");
    }
    DrawProfileText(" ");
    SetProfileColumn(++CurrentColumn);
    if (BaseController != None)
    {
        DrawProfileHeaderText("Current State: ");
        DrawProfileText(string(BaseController.GetStateName()));
    }
    if (AI != None)
    {
        AICmd = AI.CommandList;
        while (AICmd != None)
        {
            DrawProfileHeaderText("AICommand: ");
            DrawProfileText(AICmd.GetDumpString() $ ":" $ AICmd.GetStateName());
            AICmd = AICmd.ChildCommand;
        }
    }
    DrawProfileText(" ");
    CurrentCustomAction = byte(CombatPawn.CurrentCustomAction);
    DrawProfileHeaderText("Custom Action: ");
    DrawProfileText(string(CurrentCustomAction));
    CurrentPowerCustomAction = byte(CombatPawn.CurrentPowerCustomAction);
    DrawProfileHeaderText("Power Custom Action: ");
    DrawProfileText(string(CurrentPowerCustomAction));
    if (AI != None)
    {
        DrawProfileHeaderText("Combat Mood: ");
        DrawProfileText(string(AI.CombatMood));
        DrawProfileText(" ");
        DrawProfileHeaderText("Kismet Order: ");
        DrawProfileText(string(AI.GetCurrentKismetOrder()));
        if (AI.MoveGoal != None)
        {
            DrawProfileText(" ");
            DrawProfileHeaderText("Move Target: ");
            DrawProfileText(string(AI.MoveTarget));
            DrawProfileHeaderText("Move Goal: ");
            DrawProfileText(string(AI.MoveGoal));
        }
    }
    DrawProfileText(" ");
    if (AI != None && AI.RouteCache.Length > 0)
    {
        foreach BaseController.RouteCache(Nav, )
        {
            DrawProfileHeaderText("Route Cache: ");
            DrawProfileText(string(Nav));
        }
    }
}
public function ProfileCombatStats()
{
    local SFXPRI Stats;
    local BioPawn CombatPawn;
    local float SourceBonusMultiplier;
    local float TargetBonusMultiplier;
    local float DifficultyMultiplier;
    local DamageCalculationAlgorithm LastWeaponCalculation;
    local DamageCalculationAlgorithm LastPowerCalculation;
    
    if (BioPawn(ProfileTarget) == None)
    {
        return;
    }
    CombatPawn = BioPawn(ProfileTarget);
    Stats = SFXPRI(CombatPawn.PlayerReplicationInfo);
    if (Stats == None)
    {
        return;
    }
    LastWeaponCalculation = Stats.LastWeaponDamage;
    DrawProfileText("Last Weapon Damage Stats:");
    DrawProfileText(" ");
    DrawProfileText("Target: " $ LastWeaponCalculation.TargetName);
    DrawProfileText("Damage Type: " $ LastWeaponCalculation.DamageClassName);
    DrawProfileText("Base Damage: " $ LastWeaponCalculation.BaseDamage);
    DrawProfileText(" ");
    DrawProfileText("Source Bonus:");
    SourceBonusMultiplier = 1.0;
    DrawProfileText("   Pawn Game Effects (Powers, Armor): " $ LastWeaponCalculation.Weapon_PawnEffectsDamageMultiplier);
    SourceBonusMultiplier += LastWeaponCalculation.Weapon_PawnEffectsDamageMultiplier;
    DrawProfileText("   Pawn Game Effects (Powers, Armor) - Head Shot Bonus: " $ LastWeaponCalculation.Weapon_PawnEffectsHeadshotDamageMultiplier);
    SourceBonusMultiplier += LastWeaponCalculation.Weapon_PawnEffectsHeadshotDamageMultiplier;
    DrawProfileText("   Weapon Game Effects (Weapon Mods): " $ LastWeaponCalculation.Weapon_WeaponEffectsDamageMultiplier);
    SourceBonusMultiplier += LastWeaponCalculation.Weapon_WeaponEffectsDamageMultiplier;
    DrawProfileText("   Stealth: " $ LastWeaponCalculation.Weapon_StealthDamageMultiplier);
    SourceBonusMultiplier += LastWeaponCalculation.Weapon_StealthDamageMultiplier;
    DrawProfileText(" ");
    DrawProfileText("TargetBonus:");
    TargetBonusMultiplier = 1.0;
    DrawProfileText("    Cover Reduction Bonus: " $ LastWeaponCalculation.Global_CoverMultiplier);
    TargetBonusMultiplier += LastWeaponCalculation.Global_CoverMultiplier;
    DrawProfileText("    Player Popup Reduction Bonus: " $ LastWeaponCalculation.Global_PlayerPopupMultiplier);
    TargetBonusMultiplier += LastWeaponCalculation.Global_PlayerPopupMultiplier;
    DrawProfileText("    Out of Cover Damage Bonus: " $ LastWeaponCalculation.Global_OutOfCoverMultiplier);
    TargetBonusMultiplier += LastWeaponCalculation.Global_OutOfCoverMultiplier;
    DrawProfileText("   Target Weapon Damage Bonus: " $ LastWeaponCalculation.Weapon_DamageTakenMultiplier);
    TargetBonusMultiplier += LastWeaponCalculation.Weapon_DamageTakenMultiplier;
    DrawProfileText("   Range Bonus: " $ LastWeaponCalculation.Weapon_RangeMultiplier);
    TargetBonusMultiplier += LastWeaponCalculation.Weapon_RangeMultiplier;
    DrawProfileText("   Weapon Mods - Head Shot Damage Bonus: " $ LastWeaponCalculation.Weapon_HeadshotDamageMultiplier);
    TargetBonusMultiplier += LastWeaponCalculation.Weapon_HeadshotDamageMultiplier;
    DrawProfileText("   Target Damage Module Headshot Multiplier: " $ LastWeaponCalculation.Global_HeadshotTakenMultiplier);
    TargetBonusMultiplier += LastWeaponCalculation.Global_HeadshotTakenMultiplier;
    DrawProfileText("   Target Damage Module Modifier: " $ LastWeaponCalculation.Global_DamageTakenMultiplier);
    TargetBonusMultiplier += LastWeaponCalculation.Global_DamageTakenMultiplier;
    DrawProfileText("   Target in Ragdoll Bonus: " $ LastWeaponCalculation.Weapon_RagdollDamageMultiplier);
    TargetBonusMultiplier += LastWeaponCalculation.Weapon_RagdollDamageMultiplier;
    DrawProfileText(" ");
    DrawProfileText("DifficultyBonus:");
    DifficultyMultiplier = 1.0;
    DrawProfileText("   Difficulty: " $ LastWeaponCalculation.Global_DifficultyMultiplier);
    DifficultyMultiplier += LastWeaponCalculation.Global_DifficultyMultiplier;
    DrawProfileText(" ---- ");
    DrawProfileText("Total Multiplier (internally calculated): " $ Class'SFXDamageType'.static.CalculateDamageMultiplier(LastWeaponCalculation));
    DrawProfileText("Total: Base (" $ LastWeaponCalculation.BaseDamage $ ") x Source(" $ SourceBonusMultiplier $ ") x Target(" $ TargetBonusMultiplier $ ") x Difficulty(" $ DifficultyMultiplier $ ") = " $ LastWeaponCalculation.BaseDamage * SourceBonusMultiplier * TargetBonusMultiplier * DifficultyMultiplier);
    DrawProfileText("Damage Dealt: " $ LastWeaponCalculation.ActualDamageDealt);
    DrawProfileText("Damage absorbed by target: " $ LastWeaponCalculation.ActualDamageApplied);
    DrawProfileText(" ");
    LastPowerCalculation = Stats.LastPowerDamage;
    SetProfileColumn(2);
    DrawProfileText("Last Power Damage Stats:");
    DrawProfileText(" ");
    DrawProfileText("Target: " $ LastPowerCalculation.TargetName);
    DrawProfileText("Damage Type: " $ LastPowerCalculation.DamageClassName);
    DrawProfileText("Base Damage: " $ LastPowerCalculation.BaseDamage);
    DrawProfileText(" ");
    DrawProfileText("Source Bonus:");
    SourceBonusMultiplier = 1.0;
    DrawProfileText("   Weapon Mod - Melee Damage Bonus: " $ LastPowerCalculation.Power_WeaponMeleeDamageMultiplier);
    SourceBonusMultiplier += LastPowerCalculation.Power_WeaponMeleeDamageMultiplier;
    DrawProfileText(" ");
    DrawProfileText("TargetBonus:");
    TargetBonusMultiplier = 1.0;
    DrawProfileText("   Target Power Damage Bonus: " $ LastPowerCalculation.Power_DamageTakenMultiplier);
    TargetBonusMultiplier += LastPowerCalculation.Power_DamageTakenMultiplier;
    DrawProfileText("   Target Damage Module Modifier: " $ LastPowerCalculation.Global_DamageTakenMultiplier);
    TargetBonusMultiplier += LastPowerCalculation.Global_DamageTakenMultiplier;
    DrawProfileText(" ");
    DrawProfileText("DifficultyBonus:");
    DifficultyMultiplier = 1.0;
    DrawProfileText("   Difficulty: " $ LastPowerCalculation.Global_DifficultyMultiplier);
    DifficultyMultiplier += LastPowerCalculation.Global_DifficultyMultiplier;
    DrawProfileText(" ---- ");
    DrawProfileText("Total Multiplier (internally calculated): x" $ Class'SFXDamageType'.static.CalculateDamageMultiplier(LastPowerCalculation));
    DrawProfileText("Total: Base (" $ LastPowerCalculation.BaseDamage $ ") x Source (" $ SourceBonusMultiplier $ ") x Target (" $ TargetBonusMultiplier $ ") x Difficulty (" $ DifficultyMultiplier $ ") = " $ LastPowerCalculation.BaseDamage * SourceBonusMultiplier * TargetBonusMultiplier * DifficultyMultiplier);
    DrawProfileText("Damage Dealt: " $ LastPowerCalculation.ActualDamageDealt);
    DrawProfileText("Damage absorbed by target: " $ LastPowerCalculation.ActualDamageApplied);
    DrawProfileText(" ");
}
public function ProfileCooldown()
{
    local BioPawn TargetPawn;
    local int nIndex;
    local float Cooldown;
    local string CooldownBar;
    local SFXPowerCustomActionBase Power;
    
    Cooldown = 0.0;
    TargetPawn = BioPawn(ProfileTarget);
    if (TargetPawn == None || TargetPawn.PowerManager == None)
    {
        return;
    }
    for (nIndex = 0; nIndex < TargetPawn.PowerManager.Powers.Length; nIndex++)
    {
        Power = TargetPawn.PowerManager.Powers[nIndex];
        if (Power != None)
        {
            if (Power.UsesSharedCooldown)
            {
                Cooldown = Power.CurrentCooldownTime;
                break;
            }
        }
    }
    DrawProfileHeaderText("Power Cooldown: ");
    DrawProfileText(Cooldown @ " sec");
    CooldownBar = "     ";
    SetProfileColumn(++CurrentColumn);
    for (nIndex = 0; float(nIndex) < Cooldown; nIndex++)
    {
        CooldownBar = CooldownBar @ "*";
    }
    for (nIndex = 0; nIndex < 32; nIndex++)
    {
        DrawProfileText(" ");
    }
    DrawProfileText(CooldownBar);
    DrawProfileText(CooldownBar);
}
public final function ProfileDeviceGAWAssets()
{
    local array<GAWAsset> Assets;
    local int AssetCount;
    local int TotalStrength;
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.GetGAWAssetsByType(1, Assets);
    TotalStrength = GAWHandler.GetTotalStrengthByType(1, AssetCount);
    OutputGAWAssetsFromIDs(Assets, TotalStrength, AssetCount);
}
public function ProfileDifficulty()
{
    local SFXGRI GRI;
    local SFXDifficultyHandler DH;
    local SFXPawn P;
    local SFXAI_Core AI;
    local SFXModule_Damage DmgMod;
    
    GRI = SFXGRI(Outer.WorldInfo.GRI);
    if (GRI == None || GRI.DifficultyHandler == None)
    {
        return;
    }
    P = SFXPawn(ProfileTarget);
    if (P == None || P.Controller == None)
    {
        return;
    }
    DH = GRI.DifficultyHandler;
    DrawProfileHeaderText("Difficulty Setting: ");
    DrawProfileText(string(DH.CurrentDifficulty));
    DrawProfileHeaderText("Player Level: ");
    DrawProfileText(string(DH.CurrentLevel));
    DrawProfileHeaderText("Difficulty Score: ");
    DrawProfileText(string(DH.DifficultyScore));
    DrawProfileHeaderText("Difficulty Handler: ");
    DrawProfileText(string(DH));
    DrawProfileText(" ");
    DrawProfileHeaderText("AI Damage Scale" @ DH.OutAIDamageScale @ "(" @ DH.GetMinFloat('OutAIDamageScale', 'Global') @ ":" @ DH.GetMaxFloat('OutAIDamageScale', 'Global') @ ")");
    DrawProfileText(" ");
    DmgMod = P.GetModule(Class'SFXModule_Damage');
    if (DmgMod != None)
    {
        DrawProfileHeaderText("Armour Damage Reduction: " @ DmgMod.AIArmorDamageReduction.Value @ "(" @ DH.GetMinFloat('AIArmorDamageReduction', 'Global') @ ":" @ DH.GetMaxFloat('AIArmorDamageReduction', 'Global') @ ")");
        DrawProfileText(" ");
    }
    AI = SFXAI_Core(P.Controller);
    if (AI != None)
    {
        AI.DrawDifficulty(Self);
    }
    if (SFXPawn_Player(P) != None)
    {
        SetProfileColumn(++CurrentColumn);
        DrawProfileHeaderText("Hench Damage Scale: " @ DH.OutHenchDamageScale @ "(" @ DH.GetMinFloat('OutHenchDamageScale', 'Global') @ ":" @ DH.GetMaxFloat('OutHenchDamageScale', 'Global') @ ")");
        DrawProfileText(" ");
        DrawProfileHeaderText("Ammo Refill: " @ DH.AmmoPct @ "(" @ DH.GetMinFloat('AmmoPct', 'Global') @ ":" @ DH.GetMaxFloat('AmmoPct', 'Global') @ ")");
        DrawProfileText(" ");
        DrawProfileHeaderText("Grenades Per Pickup: " @ DH.GrenadesPerDrop @ "(" @ DH.GetMinFloat('GrenadesPerDrop', 'Global') @ ":" @ DH.GetMaxFloat('GrenadesPerDrop', 'Global') @ ")");
        DrawProfileText(" ");
        DrawProfileHeaderText("Medigel Heal Amount: " @ DH.GetFloat('MedigelHealAmount', 'SPGlobal') @ "(" @ DH.GetMinFloat('MedigelHealAmount', 'SPGlobal') @ ":" @ DH.GetMaxFloat('MedigelHealAmount', 'SPGlobal') @ ")");
        DrawProfileText(" ");
        DrawProfileHeaderText("Player Shield Regen %/sec: " @ DH.GetFloat('PlayerShieldRegenPct', 'Global') @ "(" @ DH.GetMinFloat('PlayerShieldRegenPct', 'Global') @ ":" @ DH.GetMaxFloat('PlayerShieldRegenPct', 'Global') @ ")");
        DrawProfileText(" ");
        DrawProfileHeaderText("Player Shield Regen Delay (Min): " @ DH.GetFloat('PlayerShieldRegenDelayFromDestroyed', 'Global') @ "(" @ DH.GetMinFloat('PlayerShieldRegenDelayFromDestroyed', 'Global') @ ":" @ DH.GetMaxFloat('PlayerShieldRegenDelayFromDestroyed', 'Global') @ ")");
        DrawProfileText(" ");
        DrawProfileHeaderText("Player Shield Regen Delay (Max): " @ DH.GetFloat('PlayerShieldRegenDelayFromDestroyed', 'Global') @ "(" @ DH.GetMinFloat('PlayerShieldRegenDelayFromDestroyed', 'Global') @ ":" @ DH.GetMaxFloat('PlayerShieldRegenDelayFromDestroyed', 'Global') @ ")");
        DrawProfileText(" ");
        DrawProfileHeaderText("Player Shield Regen Delay (Partial): " @ DH.GetFloat('PlayerShieldRegenDelayFromPartial', 'Global') @ "(" @ DH.GetMinFloat('PlayerShieldRegenDelayFromPartial', 'Global') @ ":" @ DH.GetMaxFloat('PlayerShieldRegenDelayFromPartial', 'Global') @ ")");
        DrawProfileText(" ");
        DrawProfileHeaderText("XP For Excess Medigel: " @ DH.GetFloat('XPForExcessMedigel', 'SPGlobal') @ "(" @ DH.GetMinFloat('XPForExcessMedigel', 'SPGlobal') @ ":" @ DH.GetMaxFloat('XPForExcessMedigel', 'SPGlobal') @ ")");
        DrawProfileText(" ");
    }
}
public function ProfileDoor()
{
    local SFXDoor door;
    local array<RvrClientEffectInterface> ActiveEffects;
    local RvrClientEffectInterface CurrentEffect;
    
    door = SFXDoor(ProfileTarget);
    if (door == None)
    {
        return;
    }
    DrawProfileHeaderText("Role:");
    DrawProfileText(string(door.m_DoorType));
    DrawProfileHeaderText("Current State:");
    DrawProfileText(string(door.m_CurrentDoorState));
    DrawProfileHeaderText("Previous State:");
    DrawProfileText(string(door.m_PreviousDoorState));
    DrawProfileText(" ");
    DrawProfileHeaderText("Is Transitioning ?:");
    DrawProfileText(string(door.m_bIsTransitioning));
    DrawProfileText(" ");
    DrawProfileHeaderText("Door Icons:");
    ActiveEffects = door.GetActiveClientEffects();
    foreach ActiveEffects(CurrentEffect, )
    {
        if (CurrentEffect != None)
        {
            DrawProfileText(string(CurrentEffect.Name));
        }
        else
        {
            DrawProfileText("None");
        }
    }
}
public exec function ProfileEffects()
{
    local SFXModule_GameEffectManager Manager;
    local SFXGameEffect Effect;
    local string Output;
    local string Parameter;
    
    if (ProfileTarget == None)
    {
        return;
    }
    Manager = ProfileTarget.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        return;
    }
    foreach Manager.GameEffects(Effect, )
    {
        DrawProfileHeaderText("Class: ");
        Parameter = "";
        if (SFXGameEffect_PowerBonus(Effect) != None)
        {
            Parameter = string(SFXGameEffect_PowerBonus(Effect).AffectedParameter);
        }
        Output = string(Effect.Class);
        if (Parameter != "")
        {
            Output = Output $ " - " $ Parameter;
        }
        Output = Output $ "    Category: " $ Effect.Category $ "    Value: " $ Effect.EffectValue;
        if (Effect.Instigator != None)
        {
            Output = Output $ "    Instigator: " $ Effect.Instigator.Name;
        }
        if (Effect.DurationType == EDurationType.DurationType_Temporary)
        {
            Output = Output $ "    Duration: " $ Effect.Duration - Effect.CurrentTime;
        }
        DrawProfileText(Output);
    }
}
public function ProfileFocus()
{
    local BioPawn TargetPawn;
    local Actor Target;
    local Controller BaseController;
    
    TargetPawn = BioPawn(ProfileTarget);
    if (TargetPawn == None)
    {
        return;
    }
    if (ProfileTarget != None)
    {
        if (TargetPawn.DrivenVehicle != None)
        {
            BaseController = TargetPawn.DrivenVehicle.Controller;
        }
        else
        {
            BaseController = TargetPawn.Controller;
        }
    }
    if (BioAiController(BaseController) != None)
    {
        Target = BioAiController(BaseController).FireTarget;
    }
    if (BioPlayerController(BaseController) != None)
    {
        Target = BioPlayerController(BaseController).m_oPlayerSelection.m_oCurrentSelectionTarget;
    }
    if (TargetPawn.IsHumanControlled())
    {
        DrawProfileHeaderText("Name: ");
        DrawProfileText(SFXPawn_Player(TargetPawn).firstName);
    }
    DrawProfileHeaderText("Female: ");
    DrawProfileText(string(TargetPawn.bIsFemale));
    DrawProfileHeaderText("Race: ");
    DrawProfileText(string(TargetPawn.RaceType));
    DrawProfileText(" ");
    DrawProfileHeaderText("In Stasis: ");
    DrawProfileText(string(TargetPawn.bTickIsDisabled));
    DrawProfileHeaderText("Location: ");
    DrawProfileText(string(TargetPawn.location));
    DrawProfileHeaderText("Rotation: ");
    DrawProfileText(string(TargetPawn.Rotation));
    DrawProfileHeaderText("Crouched: ");
    DrawProfileText(string(TargetPawn.bIsCrouched));
    DrawProfileHeaderText("Anchor: ");
    DrawProfileText(string(TargetPawn.Anchor));
    DrawProfileHeaderText("Velocity: ");
    DrawProfileText(TargetPawn.Velocity @ "Magnitude:" @ VSize(TargetPawn.Velocity));
    DrawProfileHeaderText("Acceleration: ");
    DrawProfileText(TargetPawn.Acceleration @ "Magnitude:" @ VSize(TargetPawn.Acceleration));
    DrawProfileHeaderText("Base: ");
    DrawProfileText(string(TargetPawn.Base));
    DrawProfileHeaderText("Floor: ");
    DrawProfileText(string(TargetPawn.Floor));
    DrawProfileHeaderText("Physics: ");
    DrawProfileText(string(TargetPawn.Physics));
    DrawProfileHeaderText("Can Crouch: ");
    DrawProfileText(string(TargetPawn.bCanCrouch));
    DrawProfileHeaderText("Can Strafe: ");
    DrawProfileText(string(TargetPawn.bCanStrafe));
    DrawProfileText(" ");
    DrawProfileHeaderText("Desired Speed: ");
    DrawProfileText(string(TargetPawn.DesiredSpeed));
    DrawProfileHeaderText("Desired Rotation: ");
    DrawProfileText(string(TargetPawn.DesiredRotation));
    DrawProfileText(" ");
    DrawProfileHeaderText("Focus: ");
    DrawProfileText(string(BaseController != None ? BaseController.Focus : None));
    DrawProfileHeaderText("FocalPoint: ");
    DrawProfileText(string(BaseController != None ? BaseController.GetFocalPoint() : vect(0.0, 0.0, 0.0)));
    DrawProfileHeaderText("FireTarget:");
    DrawProfileText(string(Target));
    DrawProfileHeaderText("Target Distance: ");
    DrawProfileText(string(Target != None ? VSize(Target.location - TargetPawn.location) : -1.0));
    SetProfileColumn(++CurrentColumn);
}
public final function ProfileGalaxy()
{
    local BioCameraBehaviorGalaxy oGalaxy;
    local SFXGalaxyMapObject oObject;
    local BioPlanet oPlanet;
    
    if (Outer.GameModeManager2.IsActive(11))
    {
        oGalaxy = SFXGameModeGalaxy(Outer.GameModeManager2.GameModes[11]).GalaxyCam;
    }
    if (oGalaxy == None)
    {
        DrawProfileHeaderText("Not in galaxy");
        return;
    }
    DrawProfileText(" ");
    DrawProfileText(" ");
    DrawProfileText(" ");
    DrawProfileText(" ");
    DrawProfileText(" ");
    DrawProfileText(" ");
    if (oGalaxy.m_pCurrentCluster != None)
    {
        DrawProfileHeaderText("Cluster:   ");
        DrawProfileText(oGalaxy.m_pCurrentCluster.GetMapTag() $ " ID:" $ oGalaxy.m_pCurrentCluster.TableID);
    }
    if (oGalaxy.m_pCurrentSystem != None)
    {
        DrawProfileHeaderText("System:    ");
        DrawProfileText(oGalaxy.m_pCurrentSystem.GetMapTag() $ " ID:" $ oGalaxy.m_pCurrentSystem.TableID);
    }
    if (oGalaxy.m_pCurrentPlanet != None)
    {
        DrawProfileHeaderText("Planet:    ");
        DrawProfileText(oGalaxy.m_pCurrentPlanet.GetMapTag() $ " ID:" $ oGalaxy.m_pCurrentPlanet.TableID);
        DrawProfileHeaderText("WorldID:   ");
        DrawProfileText(string(oGalaxy.m_pCurrentPlanet.ActiveWorld));
    }
    if (oGalaxy.m_pSelectedObject != None)
    {
        oObject = oGalaxy.FindGalaxyMapObjectFromActor(oGalaxy.m_pSelectedObject);
        if (oObject != None)
        {
            DrawProfileText(" ");
            DrawProfileHeaderText("Selected Object: " $ oObject.GetMapTag() $ " (" $ oObject $ ")");
            DrawProfileText(" ");
            DrawProfileHeaderText("  Usable: ");
            DrawProfileText((oObject.IsUsable() ? "true" : "false") $ " conditional=" $ oObject.UsableConditional $ " conditionalparam=" $ oObject.UsableParameter);
            DrawProfileHeaderText("  Visible: ");
            DrawProfileText((oObject.IsVisible() ? "true" : "false") $ " conditional=" $ oObject.VisibleConditional $ " conditionalparam=" $ oObject.VisibleParameter);
            oPlanet = BioPlanet(oObject);
            if (oPlanet != None)
            {
                DrawProfileHeaderText("  Landable: ");
                DrawProfileText((oPlanet.CanBeInteractedWith() ? "true" : "false") $ " conditional=" $ oPlanet.PlanetLandCondition);
                DrawProfileHeaderText("  Multiland: ");
                DrawProfileText(oPlanet.IsMultiLand() ? "true" : "false");
                DrawProfileHeaderText("  Scannable: ");
                DrawProfileText(oPlanet.CanBeScanned() ? "true" : "false");
                DrawProfileHeaderText("  Visited: ");
                DrawProfileText(oPlanet.IsVisited() ? "true" : "false");
                DrawProfileHeaderText("  Scan Objs: ");
                DrawProfileText(string(oPlanet.CountFeatures(6, FALSE, TRUE, FALSE)));
                DrawProfileHeaderText("  WorldID: ");
                DrawProfileText(string(oPlanet.ActiveWorld));
                DrawProfileHeaderText("  Map Name: ");
                DrawProfileText(oPlanet.MapName);
            }
        }
    }
}
public function ProfileGameSettings()
{
    if (Outer.ProfileSettings != None)
    {
        DrawProfileHeaderText("Controller Vibration:");
        DrawProfileText(string(Outer.ProfileSettings.GetControllerVibrationOption()));
        DrawProfileHeaderText("Y Axis Inverted:");
        DrawProfileText(string(Outer.ProfileSettings.GetInvertYOption()));
        DrawProfileHeaderText("Controller Sensitivity:");
        DrawProfileText(string(Outer.ProfileSettings.GetControllerSensitivityValue()));
        DrawProfileHeaderText("Stick Config:");
        DrawProfileText(string(Outer.ProfileSettings.GetStickConfigOption()));
        DrawProfileHeaderText("Trigger Config:");
        DrawProfileText(string(Outer.ProfileSettings.GetTriggerConfigOption()));
        DrawProfileHeaderText("Subtitles:");
        DrawProfileText(string(Outer.ProfileSettings.GetSubtitleConfigOption()));
        DrawProfileHeaderText("Aim Assist:");
        DrawProfileText(string(Outer.ProfileSettings.GetAimAssistValue()));
        DrawProfileHeaderText("Difficulty:");
        DrawProfileText(string(Outer.ProfileSettings.GetDifficultyConfigOption()));
        DrawProfileHeaderText("Auto Levelup:");
        DrawProfileText(string(Outer.ProfileSettings.GetAutoLevelConfigOption()));
        DrawProfileHeaderText("Squad Power Use:");
        DrawProfileText(string(Outer.ProfileSettings.GetSquadPowerConfigOption()));
        DrawProfileHeaderText("Auto Save:");
        DrawProfileText(string(Outer.ProfileSettings.GetAutoSaveConfigOption()));
        DrawProfileHeaderText("Auto Login:");
        DrawProfileText(string(Outer.ProfileSettings.GetAutoLoginConfigOption()));
        DrawProfileHeaderText("Music Volume:");
        DrawProfileText(string(Outer.ProfileSettings.GetMusicVolume()));
        DrawProfileHeaderText("FX Volume:");
        DrawProfileText(string(Outer.ProfileSettings.GetFXVolume()));
        DrawProfileHeaderText("Dialog Volume:");
        DrawProfileText(string(Outer.ProfileSettings.GetDialogVolume()));
        DrawProfileHeaderText("Motion Blur:");
        DrawProfileText(string(Outer.ProfileSettings.GetMotionBlurConfigOption()));
        DrawProfileHeaderText("Film Grain:");
        DrawProfileText(string(Outer.ProfileSettings.GetFilmgrainConfigOption()));
        DrawProfileHeaderText("Save Device:");
        DrawProfileText(string(Outer.ProfileSettings.GetCurrentDeviceID()));
        DrawProfileHeaderText("DisplayGamma:");
        DrawProfileText(string(Outer.ProfileSettings.GetDisplayGamma()));
        DrawProfileHeaderText("SwappedCrossCircle:");
        DrawProfileText(string(Outer.ProfileSettings.GetSwappedCrossCircle()));
        DrawProfileHeaderText("SwappedTriggersShoulders:");
        DrawProfileText(string(Outer.ProfileSettings.GetSwappedTriggersShoulders()));
        SetProfileColumn(++CurrentColumn);
    }
    else
    {
        DrawProfileHeaderText("Profile Error!");
        DrawProfileText("ProfileSettings object is null!!");
    }
    DrawProfileHeaderText("Current career name:");
    DrawProfileText(SFXEngine(Outer.Player.Outer).GetCurrentSaveDescriptor().Career);
}
public final function ProfileGAWAssets();

public function ProfileHenchmen()
{
    local BioBaseSquad PlayerSquad;
    local BioAiController AIController;
    local SFXAI_Henchman Controller;
    local SFXPawn_Henchman HenchmanPawn;
    local GameAICommand AICmd;
    
    PlayerSquad = SFXGame(Outer.WorldInfo.Game).PlayerSquad;
    if (PlayerSquad == None)
    {
        return;
    }
    foreach PlayerSquad.SquadMembers(AIController)
    {
        Controller = SFXAI_Henchman(AIController);
        if (Controller != None)
        {
            HenchmanPawn = SFXPawn_Henchman(Controller.Pawn);
            if (HenchmanPawn != None || HenchmanPawn != None)
            {
                DrawProfileHeaderText("Henchman: ");
                DrawProfileText(HenchmanPawn.GetActorGameName(), TRUE);
                DrawProfileText(" ");
                DrawProfileHeaderText("Controller: ");
                DrawProfileText(string(Controller.Name));
                DrawProfileText(" ");
                DrawProfileHeaderText("Current State: ");
                DrawProfileText(string(Controller.GetStateName()));
                AICmd = Controller.CommandList;
                while (AICmd != None)
                {
                    DrawProfileHeaderText("AICommand: ");
                    DrawProfileText(AICmd.GetDumpString() $ ":" $ AICmd.GetStateName());
                    AICmd = AICmd.ChildCommand;
                }
                DrawProfileText(" ");
                DrawProfileHeaderText("Fire Target: ");
                DrawProfileText(Controller.FireTarget $ " (Melee = " $ Controller.m_bMeleeAttacker $ ")");
                if (Controller.FireTarget != None)
                {
                    DrawProfileHeaderText("Distance: ");
                    DrawProfileText(PrettyFloat(VSize(Controller.FireTarget.location - HenchmanPawn.location) / float(100), 2) $ "m");
                }
                DrawProfileText(" ");
                DrawProfileHeaderText("Acquire New Cover: ");
                DrawProfileText(string(Controller.bAcquireNewCover));
                DrawProfileHeaderText("Too far to attack: ");
                DrawProfileText(string(Controller.m_bTooFarToAttack));
                DrawProfileText(" ");
                DrawProfileHeaderText("Follow Player: ");
                DrawProfileText(string(Controller.m_bFollowPlayer));
                DrawProfileHeaderText("Hold Position: ");
                DrawProfileText(string(Controller.m_bHoldingPosition));
                DrawProfileHeaderText("Hold Location: ");
                DrawProfileText(string(Controller.m_vHoldLocation));
                DrawProfileHeaderText("Forced Target: ");
                DrawProfileText(string(Controller.PreferredTarget));
                DrawProfileHeaderText("Preferred Target: ");
                DrawProfileText(string(Controller.ForcedTarget));
                DrawProfileHeaderText("Number of orders: ");
                DrawProfileText(string(Controller.m_Orders.Length));
                DrawProfileText(" ");
                DrawProfileHeaderText("In Cover: ");
                DrawProfileText(string(HenchmanPawn.IsInCover()));
                DrawProfileHeaderText("In Combat: ");
                DrawProfileText(string(HenchmanPawn.InCombat()));
                DrawProfileHeaderText("Move Goal: ");
                DrawProfileText(string(Controller.MoveGoal));
                DrawProfileText(" ");
                DrawProfileHeaderText("Current Weapon: ");
                DrawProfileText(HenchmanPawn.Weapon != None ? string(HenchmanPawn.Weapon.Class) : "None");
                DrawProfileHeaderText("Current Health: ");
                DrawProfileText(PrettyFloat(HenchmanPawn.GetCurrentHealth()) $ " / " $ PrettyFloat(HenchmanPawn.GetMaxHealth()));
                DrawProfileHeaderText("Shields: ");
                DrawProfileText(PrettyFloat(HenchmanPawn.GetCurrentShields()) $ " / " $ PrettyFloat(HenchmanPawn.GetMaxShields()));
                DrawProfileText(" ");
                DrawProfileHeaderText("Time since last render: ");
                DrawProfileText(string(HenchmanPawn.GetTimeSinceLastRender()));
                DrawProfileText(" ");
                SetProfileColumn(CurrentColumn + 2);
            }
        }
    }
}
public final function ProfileIntelGAWAssets()
{
    local array<GAWAsset> Assets;
    local int AssetCount;
    local int TotalStrength;
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.GetGAWAssetsByType(2, Assets);
    TotalStrength = GAWHandler.GetTotalStrengthByType(2, AssetCount);
    OutputGAWAssetsFromIDs(Assets, TotalStrength, AssetCount);
}
public final function ProfileMilitaryGAWAssets()
{
    local array<GAWAsset> Assets;
    local int AssetCount;
    local int TotalStrength;
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.GetGAWAssetsByType(0, Assets);
    TotalStrength = GAWHandler.GetTotalStrengthByType(0, AssetCount);
    OutputGAWAssetsFromIDs(Assets, TotalStrength, AssetCount);
}
public function ProfileMPGame();

public function ProfilePawn()
{
    local BioPawn TargetPawn;
    local string Reason;
    local SFXGRI GRI;
    local BioBaseSquad oPlayerSquad;
    
    TargetPawn = BioPawn(ProfileTarget);
    if (TargetPawn == None)
    {
        return;
    }
    GRI = SFXGRI(Outer.WorldInfo.GRI);
    oPlayerSquad = TargetPawn.Squad;
    if (TargetPawn.IsHumanControlled())
    {
        DrawProfileHeaderText("Name: ");
        DrawProfileText(SFXPawn_Player(TargetPawn).firstName);
    }
    DrawProfileHeaderText("Female: ");
    DrawProfileText(string(TargetPawn.bIsFemale));
    DrawProfileHeaderText("Race: ");
    DrawProfileText(string(TargetPawn.RaceType));
    DrawProfileText(" ");
    DrawProfileHeaderText("In Stasis: ");
    DrawProfileText(string(TargetPawn.bTickIsDisabled));
    DrawProfileHeaderText("Location: ");
    DrawProfileText(string(TargetPawn.location));
    DrawProfileHeaderText("Rotation: ");
    DrawProfileText(string(TargetPawn.Rotation));
    DrawProfileHeaderText("Crouched: ");
    DrawProfileText(string(TargetPawn.bIsCrouched));
    DrawProfileHeaderText("Anchor: ");
    DrawProfileText(string(TargetPawn.Anchor));
    DrawProfileHeaderText("Velocity: ");
    DrawProfileText(TargetPawn.Velocity @ "Magnitude:" @ VSize(TargetPawn.Velocity));
    DrawProfileHeaderText("Acceleration: ");
    DrawProfileText(TargetPawn.Acceleration @ "Magnitude:" @ VSize(TargetPawn.Acceleration));
    DrawProfileHeaderText("Base: ");
    DrawProfileText(string(TargetPawn.Base));
    DrawProfileHeaderText("Floor: ");
    DrawProfileText(string(TargetPawn.Floor));
    DrawProfileHeaderText("Physics: ");
    DrawProfileText(string(TargetPawn.Physics));
    DrawProfileHeaderText("Can Crouch: ");
    DrawProfileText(string(TargetPawn.bCanCrouch));
    DrawProfileHeaderText("Can Strafe: ");
    DrawProfileText(string(TargetPawn.bCanStrafe));
    DrawProfileText(" ");
    DrawProfileHeaderText("Desired Speed: ");
    DrawProfileText(string(TargetPawn.DesiredSpeed));
    DrawProfileHeaderText("Desired Rotation: ");
    DrawProfileText(string(TargetPawn.DesiredRotation));
    DrawProfileText(" ");
    if (oPlayerSquad != None && oPlayerSquad.bIsPlayerSquad && oPlayerSquad.m_bCombatEnabled)
    {
        DrawProfileHeaderText("Max Storm Duration: ");
        DrawProfileText(string(GRI.StormStamina));
        DrawProfileHeaderText("Storm Regen Rate: ");
        DrawProfileText(string(GRI.StormRegen));
    }
    else
    {
        DrawProfileHeaderText("Max Storm Duration: ");
        DrawProfileText(string(GRI.StormStaminaNonCombat));
        DrawProfileHeaderText("Storm Regen Rate: ");
        DrawProfileText(string(GRI.StormRegen));
    }
    DrawProfileText(" ");
    DrawProfileHeaderText("Walk Speed: ");
    DrawProfileText(string(TargetPawn.WalkSpeed));
    DrawProfileHeaderText("Ground Speed: ");
    DrawProfileText(string(TargetPawn.GroundSpeed));
    DrawProfileHeaderText("Combat Walk Speed: ");
    DrawProfileText(string(TargetPawn.CombatWalkSpeed));
    DrawProfileHeaderText("Combat Ground Speed: ");
    DrawProfileText(string(TargetPawn.CombatGroundSpeed));
    DrawProfileHeaderText("Cover Ground Speed: ");
    DrawProfileText(string(TargetPawn.CoverGroundSpeed));
    DrawProfileHeaderText("Low Cover Ground Speed: ");
    DrawProfileText(string(TargetPawn.CoverCrouchGroundSpeed));
    DrawProfileHeaderText("Tight Aim Ground Speed: ");
    DrawProfileText(string(TargetPawn.TightAimGroundSpeed));
    DrawProfileHeaderText("Crouch Ground Speed: ");
    DrawProfileText(string(TargetPawn.CrouchGroundSpeed));
    DrawProfileHeaderText("Storm Speed: ");
    DrawProfileText(string(TargetPawn.StormSpeed));
    DrawProfileHeaderText("Air Speed: ");
    DrawProfileText(string(TargetPawn.AirSpeed));
    DrawProfileHeaderText("Accel Rate: ");
    DrawProfileText(string(TargetPawn.AccelRate));
    if (TargetPawn.IsHumanControlled())
    {
        DrawProfileText(" ");
        DrawProfileHeaderText("Left Stick: ");
        DrawProfileText(Outer.PlayerInput.RawJoyRight @ Outer.PlayerInput.RawJoyUp);
        DrawProfileHeaderText("Right Stick: ");
        DrawProfileText(Outer.PlayerInput.RawJoyLookRight @ Outer.PlayerInput.RawJoyLookUp);
    }
    SetProfileColumn(++CurrentColumn);
    DrawProfileHeaderText("Root Motion Mode: ");
    DrawProfileText(TargetPawn.Mesh != None ? string(TargetPawn.Mesh.RootMotionMode) : "-");
    DrawProfileHeaderText("Root Motion Start State: ");
    DrawProfileText(string(TargetPawn.m_eAnimStartState));
    DrawProfileHeaderText("Root Motion Skid State: ");
    DrawProfileText(string(TargetPawn.m_eAnimSkidState));
    DrawProfileHeaderText("Root Motion Stop State: ");
    DrawProfileText(string(TargetPawn.m_eAnimStopState));
    DrawProfileHeaderText("Root Motion Rotation Mode: ");
    DrawProfileText(TargetPawn.Mesh != None ? string(TargetPawn.Mesh.RootMotionRotationMode) : "-");
    DrawProfileText(" ");
    DrawProfileHeaderText("Forced LOD: ");
    DrawProfileText(TargetPawn.Mesh != None ? string(TargetPawn.Mesh.ForcedLodModel) : "-");
    DrawProfileHeaderText("Predicted LOD: ");
    DrawProfileText(TargetPawn.Mesh != None ? string(TargetPawn.Mesh.PredictedLODLevel) : "-");
    DrawProfileHeaderText("Old Predicted LOD: ");
    DrawProfileText(TargetPawn.Mesh != None ? string(TargetPawn.Mesh.OldPredictedLODLevel) : "-");
    DrawProfileText(" ");
    DrawProfileHeaderText("In Cover: ");
    DrawProfileText(string(TargetPawn.IsInCover()));
    DrawProfileHeaderText("Cover Link: ");
    DrawProfileText(string(TargetPawn.CurrentLink));
    DrawProfileHeaderText("Current Slot Idx: ");
    DrawProfileText(string(TargetPawn.CurrentSlotIdx));
    DrawProfileHeaderText("Cover Type: ");
    DrawProfileText(string(TargetPawn.CoverType));
    DrawProfileHeaderText("Cover Action: ");
    DrawProfileText(string(TargetPawn.CoverAction));
    DrawProfileHeaderText("Cover Direction: ");
    DrawProfileText(string(TargetPawn.CoverDirection));
    DrawProfileText(" ");
    if (TargetPawn.IsHumanControlled())
    {
        DrawProfileText(" ");
        DrawProfileHeaderText("Can Currently Save: ");
        DrawProfileText(string(Outer.CanSave(Reason)));
        DrawProfileHeaderText("Reason: ");
        DrawProfileText(Reason);
    }
    SetProfileColumn(++CurrentColumn);
}
public final function ProfilePlaceable()
{
    local SFXPlaceableBase PlaceableTarget;
    local SFXModule_Damage DamageModule;
    local array<string> PlaceableDebugStrings;
    local string PlaceableDebugString;
    local array<string> PlaceableDifficultyDebugStrings;
    local SFXDifficultyHandler DH;
    
    PlaceableTarget = SFXPlaceableBase(ProfileTarget);
    if (PlaceableTarget == None)
    {
        return;
    }
    DamageModule = PlaceableTarget.GetModule(Class'SFXModule_Damage');
    if (DamageModule == None)
    {
        return;
    }
    DrawProfileText(" ");
    DrawProfileText(" ");
    DrawProfileText(" ");
    DrawProfileText(" ");
    DrawProfileText(" ");
    DrawProfileText(" ");
    DrawBrightText("SFXPlaceable_", 0, FALSE);
    DrawBrightText(string(PlaceableTarget.Class.Name), 1, TRUE);
    DrawBrightText("CurrentHealth = ", 0, FALSE);
    DrawBrightText(string(DamageModule.CurrentHealth), 1, TRUE);
    DrawBrightText("bIsDestroyed = ", 0, FALSE);
    DrawBrightText(string(PlaceableTarget.bIsDestroyed), 1, TRUE);
    DrawBrightText("bIsDeactivated = ", 0, FALSE);
    DrawBrightText(string(PlaceableTarget.bIsDeactivated), 1, TRUE);
    DrawProfileText(" ");
    DrawProfileText(" ");
    PlaceableTarget.GetDebugStrings(PlaceableDebugStrings);
    if (PlaceableDebugStrings.Length > 0)
    {
        DrawBrightText("Specific Placeable Info: ", 0, FALSE);
        DrawBrightText(string(PlaceableTarget.Name), 1, TRUE);
    }
    foreach PlaceableDebugStrings(PlaceableDebugString, )
    {
        DrawBrightText("    " $ PlaceableDebugString, 1, TRUE);
    }
    PlaceableTarget.GetDifficultyDebugStrings(PlaceableDifficultyDebugStrings);
    if (PlaceableDifficultyDebugStrings.Length > 0)
    {
        DH = Class'SFXDifficultyHandler'.static.GetDifficultyHandler();
        if (DH != None)
        {
            DrawBrightText("Difficulty Info:", 0, FALSE);
        }
        DrawBrightText(string(DH.CurrentDifficulty), 1, TRUE);
    }
    foreach PlaceableDifficultyDebugStrings(PlaceableDebugString, )
    {
        DrawBrightText("    " $ PlaceableDebugString, 1, TRUE);
    }
}
public function ProfilePower()
{
    local BioPawn TargetPawn;
    local SFXPowerCustomActionBase PowerBase;
    local SFXPowerCustomAction Power;
    local int Index;
    
    TargetPawn = BioPawn(ProfileTarget);
    if (TargetPawn == None || TargetPawn.PowerManager == None)
    {
        return;
    }
    if (ProfileSubTarget == 'None')
    {
        foreach TargetPawn.PowerManager.Powers(PowerBase, )
        {
            Power = SFXPowerCustomAction(PowerBase);
            DrawProfileHeaderText("Power: ");
            DrawProfileText(string(Power.PowerName));
            DrawProfileHeaderText("Enabled: ");
            DrawProfileText(string(Power.IsEnabled()));
            DrawProfileHeaderText("Rank: ");
            DrawProfileText(string(Power.Rank));
            DrawProfileHeaderText("Type: ");
            DrawProfileText(string(Power.Discipline));
            DrawProfileHeaderText("Cooldown: ");
            DrawProfileText(string(Power.CurrentCooldownTime));
            if (Outer.myHUD.Canvas.CurY >= Outer.myHUD.Canvas.ClipY - float(96))
            {
                SetProfileColumn(++CurrentColumn);
            }
            else
            {
                DrawProfileText(" ");
            }
        }
    }
    else
    {
        Power = SFXPowerCustomAction(TargetPawn.PowerManager.GetPower(ProfileSubTarget));
        DrawProfileHeaderText("Power: ");
        DrawProfileText(Power != None ? string(Power.PowerName) : "Error");
        if (Power != None)
        {
            DrawProfileText(" ");
            DrawProfileHeaderText("Enabled: ");
            DrawProfileText(string(Power.IsEnabled()));
            DrawProfileHeaderText("Rank: ");
            DrawProfileText(string(Power.Rank));
            DrawProfileHeaderText("Type: ");
            DrawProfileText(string(Power.Discipline));
            DrawProfileHeaderText("Release Time: ");
            DrawProfileText(string(Power.ReleaseTime));
            DrawProfileHeaderText("Uses Shared Cooldown: ");
            DrawProfileText(string(Power.UsesSharedCooldown));
            DrawProfileHeaderText("Current Cooldown Time: ");
            DrawProfileText(string(Power.CurrentCooldownTime));
            DrawProfileHeaderText("Cooldown Time: ");
            DrawProfileText(string(Power.CooldownTime.CurrentValue));
            DrawProfileHeaderText("Henchman Cooldown Time: ");
            DrawProfileText(string(Power.HenchmanCooldownTime.CurrentValue));
            DrawProfileHeaderText("Min Range: ");
            DrawProfileText(string(Power.MinimumRange.CurrentValue));
            DrawProfileHeaderText("Max Range: ");
            DrawProfileText(string(Power.MaximumRange.CurrentValue));
            DrawProfileHeaderText("Impact Radius: ");
            DrawProfileText(string(Power.ImpactRadius.CurrentValue));
            DrawProfileHeaderText("Effect Duration: ");
            DrawProfileText(string(Power.EffectDuration.CurrentValue));
            DrawProfileHeaderText("Damage: ");
            DrawProfileText(string(Power.Damage.CurrentValue));
            DrawProfileHeaderText("Force: ");
            DrawProfileText(string(Power.Force.CurrentValue));
            DrawProfileHeaderText("VFX Intensity: ");
            DrawProfileText(string(Power.VFXIntensity.CurrentValue));
            DrawProfileHeaderText("Projectile Speed: ");
            DrawProfileText(string(Power.ProjectileSpeed.CurrentValue));
            DrawProfileHeaderText("Projectile Radius: ");
            DrawProfileText(string(Power.ProjectileRadius));
            DrawProfileHeaderText("Cone Half Angle: ");
            DrawProfileText(string(Power.ConeHalfAngle.CurrentValue));
            DrawProfileHeaderText("Impacts Dead Pawns: ");
            DrawProfileText(string(Power.ImpactDeadPawns));
            DrawProfileHeaderText("Impacts Friends: ");
            DrawProfileText(string(Power.ImpactFriends));
            DrawProfileHeaderText("Impacts Placeables: ");
            DrawProfileText(string(Power.ImpactPlaceables));
            DrawProfileHeaderText("Buff Applies to Squad: ");
            DrawProfileText(string(Power.BuffAppliesToSquad));
            DrawProfileHeaderText("Projectile Attach Point: ");
            DrawProfileText(string(Power.ProjectileAttachPoint));
            DrawProfileHeaderText("Lean Out to Cast: ");
            DrawProfileText(string(Power.LeanOutToCast));
            DrawProfileHeaderText("Restore Cover Action: ");
            DrawProfileText(string(Power.RestoreCoverAction));
            DrawProfileHeaderText("Power Started: ");
            DrawProfileText(string(Power.bPowerStarted));
            DrawProfileHeaderText("Power Released: ");
            DrawProfileText(string(Power.bPowerReleased));
            DrawProfileHeaderText("AI Selectable: ");
            DrawProfileText(string(Power.AISelectable));
            DrawProfileHeaderText("Delay Before First Use: ");
            DrawProfileText(string(Power.DelayBeforeFirstUse));
            DrawProfileHeaderText("Delay Between Uses: ");
            DrawProfileText(string(Power.DelayBetweenUses));
            DrawProfileHeaderText("Time Until Next Use: ");
            DrawProfileText(string(Power.TimeUntilNextUse));
            DrawProfileHeaderText("Evolved Choices: ");
            DrawProfileText(" ");
            for (Index = 0; Index < 6; Index++)
            {
                DrawProfileText("Evolved Choice" $ Index $ " " $ Power.EvolvedChoices[Index]);
            }
        }
    }
}
public final function ProfileSalvageGAWAssets()
{
    local array<GAWAsset> Assets;
    local int AssetCount;
    local int TotalStrength;
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.GetGAWAssetsByType(4, Assets);
    TotalStrength = GAWHandler.GetTotalStrengthByType(4, AssetCount);
    OutputGAWAssetsFromIDs(Assets, TotalStrength, AssetCount);
}
public function ProfileSaveGame()
{
    local SFXEngine Engine;
    local SFXSaveGame SaveGame;
    local int Index;
    local int Count;
    
    if (Outer.Player == None || Outer.Player.Outer == None)
    {
        return;
    }
    Engine = SFXEngine(Outer.Player.Outer);
    if (Engine == None)
    {
        return;
    }
    SaveGame = Engine.CurrentSaveGame;
    if (SaveGame == None)
    {
        return;
    }
    DrawProfileText("Player Record", TRUE);
    DrawProfileText(" ");
    DrawProfileHeaderText("bIsFemale: ");
    DrawProfileText(string(SaveGame.PlayerRecord.bIsFemale));
    DrawProfileText(" ");
    DrawProfileHeaderText("bCombatPawn: ");
    DrawProfileText(string(SaveGame.PlayerRecord.bCombatPawn));
    DrawProfileText(" ");
    DrawProfileHeaderText("PlayerClassName: ");
    DrawProfileText(string(SaveGame.PlayerRecord.PlayerClassName));
    DrawProfileHeaderText("PlayerClass: ");
    DrawProfileText(string(SaveGame.PlayerRecord.PlayerClass));
    DrawProfileHeaderText("srClassFriendlyName: ");
    DrawProfileText(string(SaveGame.PlayerRecord.srClassFriendlyName));
    DrawProfileText(" ");
    DrawProfileHeaderText("Level: ");
    DrawProfileText(string(SaveGame.PlayerRecord.Level));
    DrawProfileHeaderText("CurrentXP: ");
    DrawProfileText(string(SaveGame.PlayerRecord.CurrentXP));
    DrawProfileHeaderText("TalentPoints: ");
    DrawProfileText(string(SaveGame.PlayerRecord.TalentPoints));
    DrawProfileText(" ");
    DrawProfileHeaderText("FirstName: ");
    DrawProfileText(SaveGame.PlayerRecord.firstName);
    DrawProfileHeaderText("LastName: ");
    DrawProfileText(string(SaveGame.PlayerRecord.LastName));
    DrawProfileText(" ");
    DrawProfileHeaderText("Origin: ");
    DrawProfileText(string(SaveGame.PlayerRecord.Origin));
    DrawProfileHeaderText("Notoriety: ");
    DrawProfileText(string(SaveGame.PlayerRecord.Notoriety));
    DrawProfileText(" ");
    DrawProfileHeaderText("Difficulty: ");
    DrawProfileText(string(SaveGame.Difficulty));
    DrawProfileText(" ");
    DrawProfileHeaderText("MappedPower1: ");
    DrawProfileText(string(SaveGame.PlayerRecord.MappedPower1));
    DrawProfileHeaderText("MappedPower2: ");
    DrawProfileText(string(SaveGame.PlayerRecord.MappedPower2));
    DrawProfileHeaderText("MappedPower3: ");
    DrawProfileText(string(SaveGame.PlayerRecord.MappedPower3));
    DrawProfileText(" ");
    DrawProfileHeaderText("Credits: ");
    DrawProfileText(string(SaveGame.PlayerRecord.Credits));
    DrawProfileHeaderText("Medigel: ");
    DrawProfileText(string(SaveGame.PlayerRecord.Medigel));
    DrawProfileHeaderText("FaceCode: ");
    DrawProfileText(SaveGame.PlayerRecord.faceCode);
    SetProfileColumn(++CurrentColumn);
    DrawProfileText("Player Powers Record", TRUE);
    DrawProfileText(" ");
    Count = SaveGame.PlayerRecord.Powers.Length;
    for (Index = 0; Index < Count; Index++)
    {
        DrawProfileHeaderText("PowerName: ");
        DrawProfileText(string(SaveGame.PlayerRecord.Powers[Index].PowerName));
        DrawProfileHeaderText("CurrentRank: ");
        DrawProfileText(string(SaveGame.PlayerRecord.Powers[Index].CurrentRank));
        DrawProfileHeaderText("EvolvedChoices: ");
        DrawProfileText(SaveGame.PlayerRecord.Powers[Index].EvolvedChoices[0] $ ", " $ SaveGame.PlayerRecord.Powers[Index].EvolvedChoices[1] $ ", " $ SaveGame.PlayerRecord.Powers[Index].EvolvedChoices[2] $ ", " $ SaveGame.PlayerRecord.Powers[Index].EvolvedChoices[3] $ ", " $ SaveGame.PlayerRecord.Powers[Index].EvolvedChoices[4] $ ", " $ SaveGame.PlayerRecord.Powers[Index].EvolvedChoices[5]);
        DrawProfileText(" ");
    }
    SetProfileColumn(++CurrentColumn);
    DrawProfileText("Player Weapons Record", TRUE);
    DrawProfileText(" ");
    Count = SaveGame.PlayerRecord.Weapons.Length;
    for (Index = 0; Index < Count; Index++)
    {
        DrawProfileHeaderText("WeaponClassName: ");
        DrawProfileText(string(SaveGame.PlayerRecord.Weapons[Index].WeaponClassName));
        DrawProfileHeaderText("bLastWeapon: ");
        DrawProfileText(string(SaveGame.PlayerRecord.Weapons[Index].bLastWeapon));
        DrawProfileHeaderText("bCurrentWeapon: ");
        DrawProfileText(string(SaveGame.PlayerRecord.Weapons[Index].bCurrentWeapon));
        DrawProfileHeaderText("AmmoPowerName: ");
        DrawProfileText(string(SaveGame.PlayerRecord.Weapons[Index].AmmoPowerName));
        DrawProfileHeaderText("AmmoPowerSourceTag: ");
        DrawProfileText(string(SaveGame.PlayerRecord.Weapons[Index].AmmoPowerSourceTag));
        DrawProfileText(" ");
    }
}
public function ProfileScaleform()
{
    local float fUpdateTime;
    local float fRenderTime;
    local float fAdvanceTime;
    local float fUpdateTotal;
    local float fRenderTotal;
    local float fAdvanceTotal;
    local SFXGUIInteraction pSFManager;
    local int nMovie;
    local array<SFXGUIMovie> aOpenMovies;
    local array<SFXGUIMovie> aTextureMovies;
    local int nMoviesInColumn;
    local SFXGUIMovie pFocusMovie;
    local string sTemp;
    
    pSFManager = Class'SFXGUIInteraction'.static.GetInstance();
    if (pSFManager == None)
    {
        return;
    }
    pFocusMovie = pSFManager.GetFocusMovieForPlayerController(Outer);
    pSFManager.GetAllMovies(aOpenMovies, aTextureMovies);
    nMoviesInColumn = 0;
    for (nMovie = 0; nMovie < aOpenMovies.Length; ++nMovie)
    {
        if (nMoviesInColumn >= 6)
        {
            SetProfileColumn(++CurrentColumn);
            nMoviesInColumn = 0;
        }
        aOpenMovies[nMovie].GetProfileTimes(fUpdateTime, fRenderTime, fAdvanceTime);
        sTemp = aOpenMovies[nMovie] == pFocusMovie ? "(focus)" : "";
        DrawProfileHeaderText(aOpenMovies[nMovie].nmTag @ sTemp $ ":", aOpenMovies[nMovie] == pFocusMovie);
        DrawProfileText(" ");
        DrawProfileHeaderText("  Update:  ");
        DrawProfileText(fUpdateTime * float(1000) $ "ms");
        DrawProfileHeaderText("  Render:  ");
        DrawProfileText(fRenderTime * float(1000) $ "ms");
        DrawProfileHeaderText("  Advance: ");
        DrawProfileText(fAdvanceTime * float(1000) $ "ms");
        DrawProfileHeaderText("  Total:   ");
        DrawProfileText((fUpdateTime + fRenderTime + fAdvanceTime) * float(1000) $ "ms");
        DrawProfileText(" ");
        fUpdateTotal += fUpdateTime;
        fRenderTotal += fRenderTime;
        fAdvanceTotal += fAdvanceTime;
        ++nMoviesInColumn;
    }
    for (nMovie = 0; nMovie < aTextureMovies.Length; ++nMovie)
    {
        if (nMoviesInColumn >= 7)
        {
            SetProfileColumn(++CurrentColumn);
            nMoviesInColumn = 0;
        }
        aTextureMovies[nMovie].GetProfileTimes(fUpdateTime, fRenderTime, fAdvanceTime);
        sTemp = aTextureMovies[nMovie] == pFocusMovie ? "(focus)" : "";
        DrawProfileHeaderText(aTextureMovies[nMovie].nmTag @ sTemp @ "(texture):", aTextureMovies[nMovie] == pFocusMovie);
        DrawProfileText(" ");
        DrawProfileHeaderText("  Update:  ");
        DrawProfileText(fUpdateTime * float(1000) $ "ms");
        DrawProfileHeaderText("  Render:  ");
        DrawProfileText(fRenderTime * float(1000) $ "ms");
        DrawProfileHeaderText("  Advance: ");
        DrawProfileText(fAdvanceTime * float(1000) $ "ms");
        DrawProfileHeaderText("  Total:   ");
        DrawProfileText((fUpdateTime + fRenderTime + fAdvanceTime) * float(1000) $ "ms");
        DrawProfileText(" ");
        fUpdateTotal += fUpdateTime;
        fRenderTotal += fRenderTime;
        fAdvanceTotal += fAdvanceTime;
        ++nMoviesInColumn;
    }
    SetProfileColumn(++CurrentColumn);
    DrawProfileHeaderText("Total Update:   ");
    DrawProfileText(fUpdateTotal * float(1000) $ "ms");
    DrawProfileHeaderText("Total Render:   ");
    DrawProfileText(fRenderTotal * float(1000) $ "ms");
    DrawProfileHeaderText("Total Advance:  ");
    DrawProfileText(fAdvanceTotal * float(1000) $ "ms");
    DrawProfileText(" ");
    DrawProfileHeaderText("Total Scaleform:");
    DrawProfileText((fAdvanceTotal + fRenderTotal + fUpdateTotal) * float(1000) $ "ms");
}
public function ProfileTech()
{
    local BioGlobalVariableTable VariableTable;
    local BioWorldInfo oWorldInfo;
    local SFXPlotTreasure oTreasure;
    local int i;
    local int Row;
    local int nTechLevel;
    local Name nmTech;
    
    VariableTable = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    if (VariableTable == None)
    {
        return;
    }
    oWorldInfo = BioWorldInfo(Outer.WorldInfo);
    oTreasure = oWorldInfo.m_oTreasure;
    for (i = 0; i != oTreasure.oPlotTreasureTech2DA.GetNumRows(); ++i)
    {
        oTreasure.oPlotTreasureTech2DA.GetNameEntryIN(i, 'nmTech', nmTech);
        nTechLevel = oWorldInfo.GetGlobalVariables().GetIntByName(nmTech);
        DrawProfileHeaderText("" $ nmTech $ ":");
        DrawProfileText(string(nTechLevel), nTechLevel > 0);
        Row++;
        if (Row >= 38)
        {
            Row = 0;
            SetProfileColumn(++CurrentColumn);
        }
    }
}
public function ProfileTicket()
{
    local BioPawn PlayerPawn;
    local BioPawn HenchmanPawn;
    local BioAiController SquadAI;
    
    PlayerPawn = BioPawn(Outer.GetALocalPlayerController().Pawn);
    if (PlayerPawn != None)
    {
        DrawProfileHeaderText("Player target tickets: ");
        DrawProfileText(string(PlayerPawn.m_nTargetTickets));
        DrawProfileHeaderText("Player attack tickets: ");
        DrawProfileText(string(PlayerPawn.m_nAttackTickets));
        DrawProfileHeaderText("Player max target tickets: ");
        DrawProfileText(string(PlayerPawn.GetMaxTargetTickets()));
        DrawProfileHeaderText("Player max attack tickets: ");
        DrawProfileText(string(PlayerPawn.GetMaxAttackTickets()));
        DrawProfileText(" ");
        foreach PlayerPawn.Squad.SquadMembers(SquadAI)
        {
            HenchmanPawn = BioPawn(SquadAI.Pawn);
            if (HenchmanPawn != PlayerPawn)
            {
                DrawProfileHeaderText("Squadmate target tickets: ");
                DrawProfileText(string(HenchmanPawn.m_nTargetTickets));
                DrawProfileHeaderText("Squadmate attack tickets: ");
                DrawProfileText(string(HenchmanPawn.m_nAttackTickets));
                DrawProfileHeaderText("Squadmate max target tickets: ");
                DrawProfileText(string(HenchmanPawn.GetMaxTargetTickets()));
                DrawProfileHeaderText("Squadmate max attack tickets: ");
                DrawProfileText(string(HenchmanPawn.GetMaxAttackTickets()));
                DrawProfileText(" ");
            }
        }
    }
}
public function ProfileTreasure();

public function ProfileVehicle()
{
    local SFXVehicleHover Vehicle;
    
    Vehicle = SFXVehicleHover(ProfileTarget);
    if (Vehicle == None)
    {
        return;
    }
    DrawProfileHeaderText("In Stasis: ");
    DrawProfileText(string(Vehicle.bTickIsDisabled));
    DrawProfileHeaderText("Location: ");
    DrawProfileText(string(Vehicle.location));
    DrawProfileHeaderText("Rotation: ");
    DrawProfileText(string(Vehicle.Rotation));
    DrawProfileHeaderText("Velocity: ");
    DrawProfileText(Vehicle.Velocity @ "Magnitude:" @ VSize(Vehicle.Velocity));
    DrawProfileHeaderText("Physics: ");
    DrawProfileText(string(Vehicle.Physics));
    if (Vehicle.GetModule(Class'SFXModule_Damage') != None)
    {
        DrawProfileHeaderText("Current Health: ");
        DrawProfileText(PrettyFloat(Vehicle.GetModule(Class'SFXModule_Damage').GetCurrentHealth()) @ "/" @ PrettyFloat(Vehicle.GetModule(Class'SFXModule_Damage').GetMaxHealth()));
    }
    DrawProfileText(" ");
    if (BioPlayerController(Vehicle.Controller) != None)
    {
        DrawProfileHeaderText("Jumping: ");
        DrawProfileText(string(BioPlayerController(Vehicle.Controller).bJump));
        DrawProfileHeaderText("Boosting: ");
        DrawProfileText(string(BioPlayerController(Vehicle.Controller).bBoost));
    }
    DrawProfileHeaderText("Thrust Remaining: ");
    DrawProfileText(string(Vehicle.CurrentThrustJuice));
    DrawProfileHeaderText("Max Thrust Duration: ");
    DrawProfileText(string(Vehicle.MaxThrustJuice));
    DrawProfileHeaderText("Thrust Regeneration Factor: ");
    DrawProfileText(string(Vehicle.ThrustRegenerationFactor));
    DrawProfileText(" ");
    DrawProfileHeaderText("Vehicle on Ground: ");
    DrawProfileText(string(Vehicle.bVehicleOnGround));
}
public function ProfileWeapon()
{
    local BioPawn CombatPawn;
    local SFXWeapon Weapon;
    local SFXModule_WeaponModManager ModManager;
    local SFXWeaponMod Mod;
    local SFXModule_GameEffectManager GEManager;
    local SFXGameEffect Effect;
    
    CombatPawn = BioPawn(ProfileTarget);
    if (Outer.Pawn == None)
    {
        return;
    }
    Weapon = SFXWeapon(CombatPawn != None ? CombatPawn.Weapon : None);
    if (Weapon == None)
    {
        DrawProfileHeaderText("No Weapon");
        return;
    }
    DrawLine("FIRING");
    DrawLine("------");
    DrawLine("Damage: ", PrettyFloat(Weapon.Damage.Value));
    DrawLine("Mod Damage Bonus: ", PrettyFloat((Weapon.GetModule(Class'SFXModule_GameEffectManager').WeaponModDamageBonus.Value - 1.0) * 100.0, 1) $ "%");
    DrawLine(" ");
    DrawLine("AMMO");
    DrawLine("----");
    DrawLine("MagSize: ", Weapon.bInfiniteAmmo ? "*" : PrettyFloat(Weapon.MagSize.X, 0));
    DrawLine("MaxSpareAmmo: ", Weapon.bInfiniteAmmo ? "*" : PrettyFloat(Weapon.MaxSpareAmmo.Value, 0));
    DrawLine("Initial Ammo: ", Weapon.bInfiniteAmmo ? "infinite" : PrettyFloat(Weapon.MaxSpareAmmo.Value, 0));
    DrawLine(" ");
    DrawLine("RECOIL");
    DrawLine("------");
    DrawLine("Recoil: ", PrettyFloat(Weapon.Recoil.Value, 0));
    DrawLine("Recoil Interp: ", PrettyFloat(Weapon.RecoilInterpSpeed, 2));
    DrawLine("Recoil Fade: ", PrettyFloat(Weapon.RecoilFadeSpeed, 2));
    DrawLine("Zoom Recoil: ", PrettyFloat(Weapon.ZoomRecoil.Value, 2));
    DrawLine("Zoom Recoil Fade: ", PrettyFloat(Weapon.RecoilZoomFadeSpeed, 2));
    DrawLine(" ");
    DrawLine("ACCURACY");
    DrawLine("--------");
    DrawLine("Aim Error", "(" $ PrettyFloat(Weapon.MinAimError.Value, 1) $ "," $ PrettyFloat(Weapon.MaxAimError.Value, 1) $ ")");
    if (SFXWeapon_Shotgun_Base(Weapon) != None)
    {
        DrawLine("Shotgun Accuracy Bonus: ", PrettyFloat(SFXWeapon_Shotgun_Base(Weapon).AccuracyBonus.Value, 2));
    }
    DrawLine("Accuracy Penalty: ", PrettyFloat(Weapon.AccFirePenalty.Value, 2));
    DrawLine("Accuracy Interp: ", PrettyFloat(Weapon.AccFireInterpSpeed.Value, 2));
    DrawLine("Crosshairs: ", PrettyFloat(Weapon.MinCrosshairRange.Value, 2));
    DrawLine(" ");
    DrawLine("ZOOM ACCURACY");
    DrawLine("-------------");
    DrawLine("Aim Error", "(" $ PrettyFloat(Weapon.MinZoomAimError.Value, 1) $ "," $ PrettyFloat(Weapon.MaxZoomAimError.Value, 1) $ ")");
    if (SFXWeapon_Shotgun_Base(Weapon) != None)
    {
        DrawLine("Shotgun Accuracy Bonus: ", PrettyFloat(SFXWeapon_Shotgun_Base(Weapon).ZoomAccuracyBonus.Value, 2));
    }
    DrawLine("Accuracy Penalty: ", PrettyFloat(Weapon.ZoomAccFirePenalty.Value, 2));
    DrawLine("Accuracy Interp: ", PrettyFloat(Weapon.ZoomAccFireInterpSpeed.Value, 2));
    DrawLine("Crosshairs: ", PrettyFloat(Weapon.MinZoomCrosshairRange.Value, 2));
    DrawLine(" ");
    SetProfileColumn(++CurrentColumn);
    DrawLine("AI");
    DrawLine("--");
    DrawLine("Rate of Fire: ", PrettyFloat(Weapon.RateOfFireAI));
    DrawLine("Hench Damage: ", PrettyFloat(Weapon.DamageHench * float(100), 0) $ "%");
    DrawLine("Burst Count: ", PrettyV2D(Weapon.AI_BurstFireCount));
    DrawLine("Burst Delay: ", PrettyV2D(Weapon.AI_BurstFireDelay, 2));
    DrawLine("Aim Delay: ", PrettyV2D(Weapon.AI_AimDelay));
    DrawLine("Accuracy: ", PrettySF(Weapon.AI_AccCone_Min));
    DrawLine(" ");
    DrawLine("GUI");
    DrawLine("---");
    DrawLine("PrettyName: ", Left(Class'SFXGame'.static.GetSimpleString(Weapon.PrettyName), 40) $ " " $ Weapon.WeaponLevel);
    DrawLine("GUIClassName: ", Left(Class'SFXGame'.static.GetSimpleString(Weapon.GUIClassName), 40));
    DrawLine("GUIClassD: ", Left(Class'SFXGame'.static.GetSimpleString(Weapon.GUIClassDescription), 40));
    DrawLine("ShortD: ", Left(Class'SFXGame'.static.GetSimpleString(Weapon.ShortDescription), 40));
    DrawLine("GeneralD: ", Left(Class'SFXGame'.static.GetSimpleString(Weapon.GeneralDescription), 40));
    DrawLine("Icon: ", "" $ Weapon.IconRef);
    DrawLine(" ");
    DrawLine("ART");
    DrawLine("---");
    DrawLine("Mesh: ", string(Weapon.Mesh));
    DrawLine("Pickup Mesh: ", string(Weapon.PickupFactoryMesh));
    DrawLine("Muzzle Flash: ", string(Weapon.PSC_MuzFlashEmitter));
    DrawLine("Tracer: ", string(Weapon.TracerInfo.StaticMesh));
    DrawLine("Reload Vent: ", string(Weapon.PSC_ReloadVent));
    DrawLine("Shell Casing: ", string(Weapon.PSC_ShellCasing));
    DrawLine(" ");
    DrawLine("SOUND");
    DrawLine("-----");
    DrawLine("Fire Sound: ", string(Weapon.FireSound));
    DrawLine("Player Fire Sound: ", string(Weapon.PlayerFireSound));
    DrawLine("Force Feedback: ", string(Weapon.WeaponFireWaveForm));
    DrawLine("Steam Reload Notify: ", string(Weapon.SteamReloadNotifySound));
    DrawLine("Need Reload Notify: ", string(Weapon.NeedReloadNotifySound));
    DrawLine("Fire No Ammo: ", string(Weapon.FireNoAmmoSound));
    DrawLine(" ");
    SetProfileColumn(++CurrentColumn);
    DrawLine("WEAPON MODS");
    DrawLine("---");
    ModManager = Weapon.GetModule(Class'SFXModule_WeaponModManager');
    if (ModManager != None)
    {
        foreach ModManager.WeaponMods(Mod, )
        {
            DrawLine("Mod Name: ", Mod.Class.static.GetModName(Mod.Level));
            DrawLine("Mod Class: ", string(Mod.Class.Name));
            DrawLine("Level: ", string(Mod.Level));
            DrawLine("Socket Name: ", string(Mod.SocketName));
            DrawLine(" ");
        }
    }
    DrawLine("GAME EFFECTS");
    DrawLine("---");
    GEManager = Weapon.GetModule(Class'SFXModule_GameEffectManager');
    if (GEManager != None)
    {
        foreach GEManager.GameEffects(Effect, )
        {
            DrawLine("Effect Name: ", string(Effect.Name));
            DrawLine("Effect Value: ", string(Effect.EffectValue));
            DrawLine(" ");
        }
    }
}
public exec function ReadAccomplishments()
{
    local int Index;
    local int Index2;
    local SFXAccomplishmentManager AccomplishmentManager;
    local Accomplishment Acc;
    local SFXProfileSettings Profile;
    local array<GrinderAccomplishment> GrinderAccList;
    local bool IsGrinder;
    
    Profile = Outer.ProfileSettings;
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager != None && Profile != None)
    {
        for (Index = 0; Index < AccomplishmentManager.AccomplishmentData.Length; Index++)
        {
            Acc = AccomplishmentManager.AccomplishmentData[Index];
            GrinderAccList.Length = 0;
            IsGrinder = AccomplishmentManager.GetGrinderAccomplishment(Acc.Name, GrinderAccList);
            if (Acc.LinkedAchievementID != EAchievementID.ACHIEVEMENT_NONE)
            {
            }
            if (Acc.XboxAchievementID > -1)
            {
            }
            if (Acc.PS3TrophyID > -1)
            {
            }
            if (IsGrinder)
            {
                for (Index2 = 0; Index2 < GrinderAccList.Length; ++Index2)
                {
                }
            }
        }
    }
}
public final exec function RemoveAIFilter(Name nmFilter)
{
    local BioAiController oController;
    local int nIndex;
    
    foreach Outer.AllActors(Class'BioAiController', oController, )
    {
        if (oController != None)
        {
            for (nIndex = 0; nIndex < oController.AILogFilter.Length; nIndex++)
            {
                if (oController.AILogFilter[nIndex] == nmFilter)
                {
                    oController.AILogFilter.Remove(nIndex, 1);
                    break;
                }
            }
        }
    }
}
public exec function RemoveAllPowers(string nmPawn)
{
    local BioPawn oPawn;
    local int nIndex;
    
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None || oPawn.PowerManager == None)
    {
        Outer.ClientMessage("Unable to remove powers - " $ nmPawn $ " is not a valid pawn name");
        return;
    }
    for (nIndex = oPawn.PowerManager.Powers.Length; nIndex >= 0; nIndex--)
    {
        if (oPawn.PowerManager.Powers[nIndex].DisplayInHUD || oPawn.PowerManager.Powers[nIndex].DisplayInCharacterRecord)
        {
            oPawn.PowerManager.RemovePower(oPawn.PowerManager.Powers[nIndex].Class);
        }
    }
    Outer.ClientMessage("All powers removed from the pawn");
}
public exec function RemoveEffect(string nmPawn, string EffectClassName)
{
    local BioPawn oPawn;
    local Class<SFXGameEffect> EffectClass;
    local SFXModule_GameEffectManager Manager;
    
    EffectClass = FindSFXGameEffectClass(EffectClassName);
    if (EffectClass == None)
    {
        EffectClass = FindSFXGameEffectClass("SFXGame." $ EffectClassName);
        if (EffectClass == None)
        {
            EffectClass = FindSFXGameEffectClass("SFXGameContent." $ EffectClassName);
            if (EffectClass == None)
            {
                Outer.ClientMessage("Unable to find effect - Failed to load effect " $ EffectClassName);
                return;
            }
        }
    }
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None || oPawn.PowerManager == None)
    {
        Outer.ClientMessage("Unable to get effect - " $ nmPawn $ " is not a valid pawn name");
        return;
    }
    Manager = oPawn.GetModule(Class'SFXModule_GameEffectManager');
    if (Manager == None)
    {
        Outer.ClientMessage("Unable to get effect - " $ nmPawn $ " does not have an SFXModule_GameEffectManager");
        return;
    }
    Manager.RemoveEffectsByType(EffectClass);
    Outer.ClientMessage("All effects of type " $ EffectClassName $ " have been removed");
}
public final exec function RemoveHeavyWeapons()
{
    local SFXInventoryManager InvManager;
    local SFXPawn_Player PlayerPawn;
    
    PlayerPawn = SFXPawn_Player(Outer.Pawn);
    if (PlayerPawn == None)
    {
        return;
    }
    InvManager = SFXInventoryManager(PlayerPawn.InvManager);
    if (InvManager == None)
    {
        return;
    }
    InvManager.RemoveHeavyWeapons();
}
public exec function RemovePower(string nmPawn, string PowerClassName)
{
    local BioPawn oPawn;
    local Class<SFXPowerCustomActionBase> PowerClass;
    
    PowerClass = FindPowerClass(PowerClassName);
    if (PowerClass == None)
    {
        PowerClass = FindPowerClass("SFXGameContent." $ PowerClassName);
    }
    if (PowerClass == None)
    {
        PowerClass = FindPowerClass("SFXGameContent.SFXPowerCustomAction_" $ PowerClassName);
    }
    if (PowerClass == None)
    {
        Outer.ClientMessage("Unable to remove power - Power class not found: " $ PowerClassName);
        return;
    }
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None || oPawn.PowerManager == None)
    {
        Outer.ClientMessage("Unable to remove power - " $ nmPawn $ " is not a valid pawn name");
        return;
    }
    if (oPawn.PowerManager.RemovePower(PowerClass))
    {
        Outer.ClientMessage("The power has been removed from the pawn");
    }
    else
    {
        Outer.ClientMessage("Unable to remove the power from the pawn");
    }
}
public exec function RemoveText(Name N)
{
    local BioHUD HUD;
    
    HUD = BioHUD(Outer.myHUD);
    HUD.RemoveDesignerText(N);
}
public final exec function RemoveTrace(int nTrace)
{
    BioHUD(Outer.myHUD).RemoveTraceAtIndex(nTrace);
}
public final exec function ResetAllGAWAssets()
{
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.ResetAllGAWAssets();
}
public function ResetAlwaysPlay()
{
    SFXGRI(Outer.WorldInfo.GRI).VocManager.bAlwaysPlay = FALSE;
}
public final exec function ResetGAWAsset(int Id)
{
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.ResetGAWAsset(Id);
}
public final exec function ResetGAWAssetByName(string AssetName)
{
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.ResetGAWAssetByName(AssetName);
}
public exec function ResetGrinder(int AccomplishmentProgressIndex)
{
    local SFXAccomplishmentManager AccomplishmentManager;
    
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager != None)
    {
        AccomplishmentManager.GrinderAccomplishmentReset(AccomplishmentManager.AccomplishmentProgressIndexToName(AccomplishmentProgressIndex), Outer);
        AccomplishmentManager.Save();
    }
}
public final exec function ResetReaperAlertLevels()
{
    Class'SFXSystem'.static.ResetGlobalReaperAlertLevels();
}
public exec function ResetTalents(string nmPawn)
{
    local BioPawn oPawn;
    
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None)
    {
        Outer.ClientMessage("Unable to get pawn - " $ nmPawn $ " is not a valid pawn name");
        return;
    }
    if (oPawn.PowerManager == None)
    {
        Outer.ClientMessage("Unable to get the pawn's power manager - " $ nmPawn);
        return;
    }
    oPawn.PowerManager.RefundAllTalentPoints();
    Outer.ClientMessage("All talent points reset for pawn - " $ nmPawn);
}
public exec function ResetWeapons(string sTarget)
{
    local SFXPawn TargetPawn;
    
    TargetPawn = SFXPawn(GetActorFromString(sTarget));
    if (TargetPawn == None)
    {
        return;
    }
    TargetPawn.CreateWeapons(TargetPawn.Loadout);
}
public exec function Revive()
{
    local SFXPlayerController PC;
    
    foreach Outer.WorldInfo.AllControllers(Class'SFXPlayerController', PC)
    {
        if (PC != None && BioPawn(PC.Pawn) != None)
        {
            BioPawn(PC.Pawn).Resurrect(1.0, FALSE);
        }
    }
}
public exec function RevivePawn(string PawnName)
{
    local BioPawn oPawn;
    
    oPawn = BioPawn(GetActorFromString(PawnName));
    if (oPawn != None)
    {
        Outer.Revive(oPawn);
    }
}
public exec function RunConditional(int Id, optional int Param = 0)
{
    local BioWorldInfo Info;
    
    Info = BioWorldInfo(Outer.WorldInfo);
    Info.CheckConditional(Id, Param);
}
private final function SaveCommandCallback_LoadGame(SFXSaveGameCommandEventArgs Args)
{
    local SFXCareerDescriptor CareerDescriptor;
    local SFXSavePair SavePair;
    
    foreach Args.Careers(CareerDescriptor, )
    {
        foreach CareerDescriptor.Saves(SavePair, )
        {
            if (SavePair.Save != None && SavePair.Save.DebugName == PendingLoadGameDebugName)
            {
                SFXEngine(Outer.Player.Outer).LoadSaveGame(SavePair.Save);
                return;
            }
        }
    }
}
public final function SaveGame_Callback(SFXSaveGameCommandEventArgs Args)
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Outer.Player.Outer);
    Engine.CurrentSaveGame.DebugName = "";
}
public final function SendMiniNotification()
{
    local BioHintSystem oHintSystem;
    local BioPlayerController oController;
    
    oController = Outer;
    oHintSystem = BioHintSystem(oController.HintSystem);
    if (oHintSystem != None)
    {
        oHintSystem.AddNotification_Custom(1.5, "Test " $ m_nMiniNotificationTest, "Test " $ m_nMiniNotificationTest, "", "", 'None', 'None', 'None', 0, 0, m_nMiniNotificationTest, 'None', TRUE);
        m_nMiniNotificationTest++;
    }
}
public exec function SendTelemetryTest(int Number, optional bool bAnonymous = FALSE)
{
    Class'SFXTelemetry'.static.SendInt(bAnonymous ? 'TelemetryHook_Test_Anon' : 'TelemetryHook_Test_Auth', Number);
}
public final exec function SetAimAssistValues(Vector2D Adhesion, float AimCorrection, Vector2D Friction)
{
    Outer.ConsoleCommand("set sfxweapon AdhesionRot (X=" $ Adhesion.X $ ", Y=" $ Adhesion.Y $ ")");
    Outer.ConsoleCommand("set sfxweapon AimCorrectionAmount " $ AimCorrection);
    Outer.ConsoleCommand("set sfxweapon FrictionMultiplierRange (X=" $ Friction.X $ ", Y=" $ Friction.Y $ ")");
}
public exec function SetAllMoods(EAICombatMood NewMood)
{
    local SFXAI_Core oController;
    
    foreach Outer.AllActors(Class'SFXAI_Core', oController, )
    {
        if (oController != None)
        {
            oController.SetCombatMood(NewMood);
        }
    }
}
public exec function SetAllWeaponModLevels(int nLevel)
{
    local int idx;
    local int Idx2;
    local Class<SFXWeaponMod> ModClass;
    local array<Class<SFXWeapon>> WeaponClasses;
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    WeaponClasses.AddItem(Class'SFXWeapon_AssaultRifle_Base');
    WeaponClasses.AddItem(Class'SFXWeapon_Pistol_Base');
    WeaponClasses.AddItem(Class'SFXWeapon_SMG_Base');
    WeaponClasses.AddItem(Class'SFXWeapon_Shotgun_Base');
    WeaponClasses.AddItem(Class'SFXWeapon_SniperRifle_Base');
    for (idx = 0; idx < WeaponClasses.Length; idx++)
    {
        for (Idx2 = 0; Idx2 < WeaponClasses[idx].default.AllowableWeaponMods.Length; Idx2++)
        {
            ModClass = Class'SFXWeaponMod'.static.LoadModClass(WeaponClasses[idx].default.AllowableWeaponMods[Idx2]);
            if (ModClass != None)
            {
                Outer.ClientMessage("Level " $ nLevel $ ": " $ ModClass.Name);
                Engine.SetPlayerVariable(Name(PathName(ModClass)), nLevel);
            }
        }
    }
}
public exec function SetAutoRightUpForceAndTorque(float fUpLiftForce, float fUprightTorque)
{
    local SVehicle oVeh;
    
    oVeh = SVehicle(Outer.Pawn);
    if (oVeh != None)
    {
        oVeh.UprightLiftStrength = fUpLiftForce;
        oVeh.UprightTorqueStrength = fUprightTorque;
    }
}
public exec function SetBoolByID(int PlotId, bool nValue)
{
    local BioGlobalVariableTable oGV;
    
    oGV = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    if (oGV != None)
    {
        oGV.SetBool(PlotId, nValue);
    }
}
public exec function SetFireTeam(string Henchman)
{
    local int HenchmanIndex;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanIndex = GetHenchIndex(Henchman);
    if (HenchmanIndex == -1)
    {
        GVars.SetIntByName('FireTeamLeader', 0);
        Outer.ClientMessage("Fire team leader has been cleared");
    }
    else
    {
        GVars.SetIntByName('FireTeamLeader', HenchmanIndex + 1);
        Outer.ClientMessage("Fire team leader has been set to" @ GetHenchName(HenchmanIndex));
    }
}
public exec function SetHelmetVisible(string PawnName, bool bVisible)
{
    local SFXPawn_PlayerParty Target;
    
    Target = SFXPawn_PlayerParty(GetActorFromString(PawnName));
    if (Target != None)
    {
        Target.SetHeadGearVisibility(bVisible);
    }
}
public exec function SetHenchmanAppearance(string Henchman, int Value)
{
    local string HenchmanCodename;
    local Name nmLabel;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanCodename = GetHenchCodename(Henchman);
    if (HenchmanCodename != "")
    {
        nmLabel = Name("Appearance" $ HenchmanCodename);
        GVars.SetIntByName(nmLabel, Value);
        Outer.ClientMessage(Henchman @ "appearance has been set to" @ Value);
    }
    else
    {
        Outer.ClientMessage(Henchman @ "is not a Henchman name!");
    }
}
public exec function SetHenchmanAvailable(string Henchman, bool Value)
{
    local string HenchmanCodename;
    local Name nmLabel;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanCodename = GetHenchCodename(Henchman);
    if (HenchmanCodename != "")
    {
        nmLabel = Name("IsSelectable" $ HenchmanCodename);
        GVars.SetBoolByName(nmLabel, Value);
        Outer.ClientMessage(Henchman @ "has been set" @ (Value ? "" : "not") @ "available");
    }
    else
    {
        Outer.ClientMessage(Henchman @ "is not a Henchman name!");
    }
}
public exec function SetHenchmanDead(string Henchman, bool Value)
{
    local int GVarIndex;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    GVarIndex = GetHenchIsDeadGVarIndex(Henchman);
    if (GVarIndex != -1)
    {
        GVars.SetBool(GVarIndex, Value);
        Outer.ClientMessage(Henchman @ "has been set" @ (Value ? "" : "not") @ "dead");
    }
    else
    {
        Outer.ClientMessage(Henchman @ "is not a Henchman name!");
    }
}
public exec function SetHenchmanKnown(string Henchman, bool Value)
{
    local string HenchmanCodename;
    local Name nmLabel;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanCodename = GetHenchCodename(Henchman);
    if (HenchmanCodename != "")
    {
        nmLabel = Name("KnowExist" $ HenchmanCodename);
        GVars.SetBoolByName(nmLabel, Value);
        Outer.ClientMessage(Henchman @ "has been set" @ (Value ? "" : "not") @ "known");
    }
    else
    {
        Outer.ClientMessage(Henchman @ "is not a Henchman name!");
    }
}
public exec function SetHenchmanLoyalty(string Henchman, bool Value)
{
    local string HenchmanCodename;
    local Name nmLabel;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanCodename = GetHenchCodename(Henchman);
    if (HenchmanCodename != "")
    {
        nmLabel = Name("IsLoyal" $ HenchmanCodename);
        GVars.SetBoolByName(nmLabel, Value);
        Outer.ClientMessage(Henchman @ "has been set" @ (Value ? "" : "not") @ "loyal");
    }
    else
    {
        Outer.ClientMessage(Henchman @ "is not a Henchman name!");
    }
}
public exec function SetHenchmanSpecialization(string Henchman, bool Value)
{
    local string HenchmanCodename;
    local Name nmLabel;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanCodename = GetHenchCodename(Henchman);
    if (HenchmanCodename != "")
    {
        nmLabel = Name("IsSpecialized" $ HenchmanCodename);
        GVars.SetBoolByName(nmLabel, Value);
        Outer.ClientMessage(Henchman @ "has been set" @ (Value ? "" : "not") @ "specialized");
    }
    else
    {
        Outer.ClientMessage(Henchman @ "is not a Henchman name!");
    }
}
public exec function SetModLevels(int nLevel)
{
    SetAllWeaponModLevels(nLevel);
}
public exec function SetMood(Name nmPawn, EAICombatMood NewMood)
{
    local Pawn oPawn;
    local SFXAI_Core oController;
    
    if (nmPawn == 'All')
    {
        SetAllMoods(NewMood);
        return;
    }
    foreach Outer.AllActors(Class'Pawn', oPawn, )
    {
        if (nmPawn == oPawn.Name)
        {
            break;
        }
    }
    if (oPawn == None)
    {
        return;
    }
    oController = SFXAI_Core(oPawn.Controller);
    if (oController == None)
    {
        return;
    }
    if (oController.SetCombatMood(NewMood))
    {
    }
}
public exec function SetMorinth(bool Value)
{
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    GVars.SetBoolByName('Morinth_not_Samara', Value);
    Outer.ClientMessage(Value ? "Morinth" : "Samara");
}
public exec function SetParagon(int nPoints)
{
    local SFXGame Game;
    
    Game = Outer.WorldInfo != None ? SFXGame(Outer.WorldInfo.Game) : None;
    if (Game != None)
    {
        Game.SetParagonPoints(nPoints);
        Outer.ClientMessage("The player's paragon points have been set to " $ nPoints);
    }
}
public exec function SetParam(string Target, Name Param, float Value)
{
    local Actor TargetActor;
    local MaterialInstance Mat;
    local MeshComponent Comp;
    local int i;
    
    TargetActor = GetActorFromString(Target);
    if (TargetActor != None)
    {
        foreach TargetActor.AllOwnedComponents(Class'MeshComponent', Comp)
        {
            for (i = 0; i < Comp.GetNumElements(); i++)
            {
                Mat = MaterialInstance(Comp.GetMaterial(i));
                if (Mat != None)
                {
                    Mat.SetScalarParameterValue(Param, Value);
                }
            }
        }
    }
}
public final exec function SetPowerPercent(Name nmPawn, float fPercent)
{
    local BioPawn oPawn;
    
    foreach Outer.AllActors(Class'BioPawn', oPawn, )
    {
        if (nmPawn == oPawn.Name)
        {
            break;
        }
    }
    if (oPawn == None)
    {
        return;
    }
    if (fPercent < 0.0 || fPercent > 1.0)
    {
        return;
    }
    oPawn.m_fPowerUsePercent = fPercent;
}
public exec function SetProfileChoseMorinth(bool ChoseMorinth)
{
    local SFXProfileSettings Profile;
    
    Profile = Outer.ProfileSettings;
    if (Profile != None)
    {
        Profile.SetChoseMorinthNotSamara(ChoseMorinth);
    }
}
public exec function SetRank(string nmPawn, Class<Object> PowerClass, float fRank)
{
    local BioPawn oPawn;
    local SFXPowerCustomActionBase oPower;
    
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None || oPawn.PowerManager == None)
    {
        Outer.ClientMessage("Unable to set the rank - " $ nmPawn $ " is not a valid pawn name");
        return;
    }
    oPower = oPawn.PowerManager.GetPowerByClass(PowerClass);
    if (oPower != None)
    {
        if (fRank == float(oPawn.PowerManager.EvolveRank))
        {
            Outer.ClientMessage("Unable to set the rank - it would cause the power to evolve");
            return;
        }
        oPower.Rank = fRank;
        Outer.ClientMessage("The rank has been set");
    }
    else
    {
        Outer.ClientMessage("Unable to set the rank - the pawn does not have the " $ PowerClass $ " power");
    }
}
public exec function SetRenegade(int nPoints)
{
    local SFXGame Game;
    
    Game = Outer.WorldInfo != None ? SFXGame(Outer.WorldInfo.Game) : None;
    if (Game != None)
    {
        Game.SetRenegadePoints(nPoints);
        Outer.ClientMessage("The player's renegade points have been set to " $ nPoints);
    }
}
public exec function SetSpecialist(string Henchman)
{
    local int HenchmanIndex;
    local BioGlobalVariableTable GVars;
    
    GVars = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    HenchmanIndex = GetHenchIndex(Henchman);
    if (HenchmanIndex == -1)
    {
        GVars.SetIntByName('Specialist', 0);
        Outer.ClientMessage("Specialist has been cleared");
    }
    else
    {
        GVars.SetIntByName('Specialist', HenchmanIndex + 1);
        Outer.ClientMessage("Specialist has been set to" @ GetHenchName(HenchmanIndex));
    }
}
public exec function SetUgly(int Ugliness)
{
    local SFXPawn_Player UglyPlayer;
    
    if (Ugliness < 0 || Ugliness > 4)
    {
        Outer.ClientMessage("Valid range is from [0,4]");
        return;
    }
    UglyPlayer = SFXPawn_Player(Outer.Pawn);
    if (UglyPlayer != None)
    {
        switch (Ugliness)
        {
            case 0:
                Outer.ConsoleCommand("SetRenegade 0");
                Outer.ConsoleCommand("SetParagon 2000");
                break;
            case 1:
                Outer.ConsoleCommand("SetRenegade 0");
                Outer.ConsoleCommand("SetParagon 350");
                break;
            case 2:
                Outer.ConsoleCommand("SetRenegade 0");
                Outer.ConsoleCommand("SetParagon 0");
                break;
            case 3:
                Outer.ConsoleCommand("SetRenegade 350");
                Outer.ConsoleCommand("SetParagon 0");
                break;
            case 4:
                Outer.ConsoleCommand("SetRenegade 2000");
                Outer.ConsoleCommand("SetParagon 0");
                break;
            default:
        }
        UglyPlayer.UpdateAppearance();
    }
}
public exec function SetVecParam(string Target, Name Param, float R, float G, float B, float A)
{
    local Actor TargetActor;
    local MaterialInstance Mat;
    local MeshComponent Comp;
    local LinearColor Value;
    local int i;
    
    TargetActor = GetActorFromString(Target);
    if (TargetActor != None)
    {
        Value.R = R;
        Value.G = G;
        Value.B = B;
        Value.A = A;
        foreach TargetActor.AllOwnedComponents(Class'MeshComponent', Comp)
        {
            for (i = 0; i < Comp.GetNumElements(); i++)
            {
                Mat = MaterialInstance(Comp.GetMaterial(i));
                if (Mat != None)
                {
                    Mat.SetVectorParameterValue(Param, Value);
                }
            }
        }
    }
}
public exec function SetVehicleCOMOffsetZ(float fOffsetZ)
{
    local SVehicle oVeh;
    
    oVeh = SVehicle(Outer.Pawn);
    if (oVeh != None)
    {
        oVeh.COMOffset.Z = fOffsetZ;
    }
}
public exec function ShowAudioEmitter(string nmAudioEmitter)
{
    local Actor AudioActor;
    local WwiseAmbientSound AudioEmitter;
    
    AudioActor = GetActorFromString(nmAudioEmitter);
    AudioEmitter = WwiseAmbientSound(AudioActor);
    if (AudioEmitter != None)
    {
        AudioEmitter.DrawEmitter();
    }
}
public exec function ShowAudioVolume(string nmAudioVolume)
{
    local Actor AudioActor;
    local WwiseAudioVolume AudioVolume;
    
    AudioActor = GetActorFromString(nmAudioVolume);
    AudioVolume = WwiseAudioVolume(AudioActor);
    if (AudioVolume != None)
    {
        AudioVolume.DrawVolume();
    }
}
public exec function ShowDebugText()
{
    if (Outer.WorldInfo != None)
    {
        Outer.WorldInfo.bShowDebugText = !Outer.WorldInfo.bShowDebugText;
    }
}
public exec function ShowInterruptUI()
{
    local SFXGUIInteraction pSFManager;
    local BioSFHandler_Conversation pConv;
    
    pSFManager = Class'SFXGUIInteraction'.static.GetInstance();
    pConv = pSFManager.CastGetMovie(Class'BioSFHandler_Conversation', Outer, pSFManager.MovieTag_Conversation);
    if (pConv != None)
    {
        pConv.AS_SetRenegadeInterrupt(TRUE);
        pConv.AS_SetParagonInterrupt(TRUE);
    }
    Outer.SetTimer(5.0, FALSE, 'HideInterruptUI', Self);
}
public exec function ShowMicrophone()
{
    Class'WwiseAudioComponent'.static.SetDrawMic(TRUE);
}
public final exec function ShowNumPlayers()
{
    if (Outer.Role == ENetRole.ROLE_Authority)
    {
        TestString("NumPlayers = " $ Outer.WorldInfo.Game.GetNumPlayers());
    }
    else
    {
        TestString("ShowNumPlayers not available to clients");
    }
}
public final exec function ShowSafeFrame()
{
    BioHUD(Outer.myHUD).ToggleDebugDraw(DrawSafeFrame);
}
public exec function ShowVocInfo(string PawnTag, string eventStr, optional int Type)
{
    local BioPawn TaggedPawn;
    local ESFXVocalizationEventID EventId;
    local int RoleIdx;
    local int VariationIdx;
    local string outputstring;
    
    EventId = byte(GetEnumIndex(Enum'SFXVocalizationManager.ESFXVocalizationEventID', Name(eventStr)));
    TaggedPawn = BioPawn(GetActorFromString(PawnTag));
    if (Type == 0)
    {
        for (RoleIdx = 0; RoleIdx < TaggedPawn.CombatVoc.Vocalizations[int(EventId)].Roles.Length; RoleIdx++)
        {
            appScreenDebugMessage("Event: " $ GetEnum(Enum'SFXVocalizationTypes.ESFXVocalizationRole', RoleIdx));
            for (VariationIdx = 0; VariationIdx < TaggedPawn.CombatVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations.Length; VariationIdx++)
            {
                if (TaggedPawn.CombatVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations[VariationIdx].SpecificType.Length > 0)
                {
                    outputstring = "" $ TaggedPawn.CombatVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations[VariationIdx].SpecificType[0];
                    outputstring $= ":::" $ TaggedPawn.CombatVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations[VariationIdx].SpecificValue[0];
                }
                else
                {
                    outputstring = "default";
                }
                appScreenDebugMessage(outputstring $ " ---> " $ TaggedPawn.CombatVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations[VariationIdx].Sound);
            }
        }
    }
    else if (Type == 1)
    {
        for (RoleIdx = 0; RoleIdx < TaggedPawn.ExplorationVoc.Vocalizations[int(EventId)].Roles.Length; RoleIdx++)
        {
            appScreenDebugMessage("Event: " $ GetEnum(Enum'SFXVocalizationTypes.ESFXVocalizationRole', RoleIdx));
            for (VariationIdx = 0; VariationIdx < TaggedPawn.ExplorationVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations.Length; VariationIdx++)
            {
                if (TaggedPawn.ExplorationVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations[VariationIdx].SpecificType.Length > 0)
                {
                    outputstring = "" $ TaggedPawn.ExplorationVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations[VariationIdx].SpecificType[0];
                    outputstring $= ":::" $ TaggedPawn.ExplorationVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations[VariationIdx].SpecificValue[0];
                }
                else
                {
                    outputstring = "default";
                }
                appScreenDebugMessage(outputstring $ " ---> " $ TaggedPawn.ExplorationVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations[VariationIdx].Sound);
            }
        }
    }
    else
    {
        for (RoleIdx = 0; RoleIdx < TaggedPawn.StealthVoc.Vocalizations[int(EventId)].Roles.Length; RoleIdx++)
        {
            appScreenDebugMessage("Event: " $ GetEnum(Enum'SFXVocalizationTypes.ESFXVocalizationRole', RoleIdx));
            for (VariationIdx = 0; VariationIdx < TaggedPawn.StealthVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations.Length; VariationIdx++)
            {
                if (TaggedPawn.StealthVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations[VariationIdx].SpecificType.Length > 0)
                {
                    outputstring = "" $ TaggedPawn.StealthVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations[VariationIdx].SpecificType[0];
                    outputstring $= ":::" $ TaggedPawn.StealthVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations[VariationIdx].SpecificValue[0];
                }
                else
                {
                    outputstring = "default";
                }
                appScreenDebugMessage(outputstring $ " ---> " $ TaggedPawn.StealthVoc.Vocalizations[int(EventId)].Roles[RoleIdx].Variations[VariationIdx].Sound);
            }
        }
    }
}
public final exec function ShowWeaponSelection(optional bool bAll = FALSE)
{
    local SFXGUIInteraction oGUI;
    local SFXGUI_WeaponSelection oWeapGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    oWeapGUI = oGUI.CastOpenMovie(Class'SFXGUI_WeaponSelection', Outer, oGUI.MovieTag_WeaponSelect, FALSE);
    if (oWeapGUI != None)
    {
        oWeapGUI.ShowAllWeapons = bAll;
        oWeapGUI.Start();
    }
}
public exec function ShowWwiseVolumeLocations(string nmVolume)
{
    local WwiseAudioVolume AudioVolume;
    
    AudioVolume = WwiseAudioVolume(GetActorFromString(nmVolume));
    if (AudioVolume != None)
    {
        AudioVolume.DrawSoundLocations = TRUE;
        AudioVolume.m_oTrackTimer.SetTimer(0.00999999978, TRUE, , );
        Outer.ClientMessage("Drawing sound locations for" @ nmVolume);
    }
}
public exec function Speak(byte EventId, string sInstigator, optional string sRecipient)
{
    local BioPawn TheInstigator;
    local BioPawn TheRecipient;
    
    TheInstigator = BioPawn(GetActorFromString(sInstigator));
    if (TheInstigator == None)
    {
        return;
    }
    if (Len(sRecipient) > 0)
    {
        TheRecipient = BioPawn(GetActorFromString(sRecipient));
        if (TheRecipient == None)
        {
            return;
        }
    }
    SFXGRI(Outer.WorldInfo.GRI).VocManager.bAlwaysPlay = TRUE;
    SFXGRI(Outer.WorldInfo.GRI).TriggerVocalizationEvent(EventId, TheInstigator, TheRecipient, 0.0, 100.0);
    Outer.SetTimer(0.100000001, FALSE, 'ResetAlwaysPlay', Self);
}
public exec function StartCoverGUI()
{
    local SFXPlayerController PC;
    local SFXPawn_Player oPlayer;
    local RvrClientEffectTarget Target;
    
    if (bCoverGuidShowing)
    {
        return;
    }
    PC = SFXPlayerController(Outer);
    oPlayer = SFXPawn_Player(PC.Pawn);
    Target.Instigator = oPlayer;
    Target.HitNormal = Vector(PC.Rotation);
    CoverGuid = Class'RvrClientEffectManager'.static.GetClientEffectManager().StartOnTarget(Class'BioPlayerController'.default.CE_Mantle, Target, oPlayer);
    bCoverGuidShowing = TRUE;
}
public final exec function StatusGrinder(int AccomplishmentProgressIndex)
{
    local SFXAccomplishmentManager AccomplishmentManager;
    local int CurProgress;
    local Name AccomplishmentProgressName;
    
    AccomplishmentManager = SFXEngine(Class'Engine'.static.GetEngine()).AccomplishmentManager;
    if (AccomplishmentManager != None)
    {
        AccomplishmentProgressName = AccomplishmentManager.AccomplishmentProgressIndexToName(AccomplishmentProgressIndex);
        CurProgress = AccomplishmentManager.GetGrinderAccomplishmentProgress(AccomplishmentProgressName, Outer);
        Outer.ClientMessage("Current Grinder Amount For Grinder" @ AccomplishmentProgressName);
        Outer.ClientMessage("Is:" @ CurProgress);
    }
    else
    {
        Outer.ClientMessage("No Accomplishment Manager Present");
    }
}
public exec function StopCoverGUI()
{
    if (bCoverGuidShowing)
    {
        bCoverGuidShowing = FALSE;
        Class'RvrClientEffectManager'.static.GetClientEffectManager().Stop(Class'BioPlayerController'.default.CE_Mantle, CoverGuid, TRUE);
    }
}
public exec function TeleportHenchman(string nmPawn)
{
    local BioPawn oPawn;
    local SFXAI_Henchman oController;
    local Pawn oPlayer;
    
    oPawn = BioPawn(GetActorFromString(nmPawn));
    if (oPawn == None || oPawn.Squad == None)
    {
        return;
    }
    oController = SFXAI_Henchman(oPawn.Controller);
    if (oController == None)
    {
        return;
    }
    oPlayer = oPawn.Squad.Members[0];
    if (oPlayer != None)
    {
        return;
    }
    oController.TeleportToActor(oPlayer);
}
public exec function Test_MiniNotifications(bool bStart)
{
    if (bStart)
    {
        Outer.SetTimer(1.0, TRUE, 'SendMiniNotification', Self);
    }
    else
    {
        Outer.ClearTimer('SendMiniNotification', Self);
    }
}
public exec function Test_Notifications()
{
    local BioHintSystem oHintSystem;
    local BioPlayerController oController;
    
    oController = Outer;
    oHintSystem = BioHintSystem(oController.HintSystem);
    if (oHintSystem != None)
    {
        oHintSystem.AddNotification_LevelUp(2);
        oHintSystem.AddNotification_JournalChange();
        oHintSystem.AddNotification_CodexChange();
        oHintSystem.AddNotification_CreditRecovery(99);
        oHintSystem.AddNotification_MedigelRecovery(98);
        oHintSystem.AddNotification_ParagonChange(97);
        oHintSystem.AddNotification_RenegadeChange(96);
        oHintSystem.AddNotification_IridiumRecovery(95);
        oHintSystem.AddNotification_PalladiumRecovery(94);
        oHintSystem.AddNotification_PlatinumRecovery(93);
        oHintSystem.AddNotification_ElementZeroRecovery(92);
        oHintSystem.AddNotification_HeavyWeaponAmmoRecovery(91);
        oHintSystem.AddNotification_AmmoRecovery(90);
        oHintSystem.AddNotification_AccomplishmentChange("Ach Title", "Ach SubTitle", "Ach Body", 5, 10, "GUI_Achievement_Images.01_driven");
        oHintSystem.AddNotification_HeavyAmmoFull();
        oHintSystem.AddNotification_MediGelFull();
        oHintSystem.AddNotification_SalvageRecovery(89);
        oHintSystem.AddNotification_LevelUp(87);
        oHintSystem.AddNotification_XP(86);
        oHintSystem.AddNotification_TechUnlocked("TechUnlocked Title", "TechUnlocked Name", "TechUnlocked Message");
        oHintSystem.AddNotification_Tech("Tech Title", "Tech Name", "Tech Message");
        Class'SFXGUIInteraction'.static.GetInstance().ShowHint($342115, 6.0, 0, 2);
    }
}
public exec function TestActionIndicator(ESFXHUDActionIcon eIcon)
{
    local SFXSFHandler_HUD HUD;
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    HUD = oGUI.CastGetMovie(Class'SFXSFHandler_HUD', Outer, oGUI.MovieTag_HUD);
    HUD.SetActionIndicator(eIcon);
    Outer.SetTimer(5.0, FALSE, 'HideActionIndicator', Self);
}
public exec function TestAutoGrant()
{
    Outer.ClientMessage("TestAutoGrant started");
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().ProcessAutoGrants(OnAutoGrantComplete);
}
public exec function TestBinaryHTTPSystem()
{
    local SFXOnlineJobImageRequest Job;
    
    Job = Class'SFXOnlineJobImageRequest'.static.CreateImageRequestJob();
    Job.mRequest.mImageName = "pic.dds";
    Job.__OnJobComplete__Delegate = BinaryHttpResult;
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentJobQueue().AddJob(Job);
}
public final exec function TestCancelCountdown()
{
    SFXPlayerController(Outer).CancelCountdownTimer();
}
public final exec function TestChoiceBox()
{
    local BioSFHandler_MessageBox mb;
    
    mb = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(None);
    if (mb != None)
    {
        mb.SetChoiceResultCallback(ChoiceDialogResult);
        mb.ShowChoiceDialogEx("Pick Your Poison", "Cancel", "Option 1", 1, TRUE, "Option 2", 2, TRUE, "Option 3", 3, TRUE);
    }
}
public exec function TestConditionals()
{
    local BioGlobalVariableTable gv;
    local int i;
    local float fTime;
    
    gv = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    gv.SetBool(0, TRUE);
    gv.SetBool(1, FALSE);
    gv.SetBool(2, TRUE);
    gv.SetBool(3, TRUE);
    gv.SetInt(0, 4);
    gv.SetInt(1, 8);
    Outer.Clock(fTime);
    BioWorldInfo(Outer.WorldInfo).CheckConditional(0);
    Outer.UnClock(fTime);
    Outer.Clock(fTime);
    BioWorldInfo(Outer.WorldInfo).CheckConditional(7);
    Outer.UnClock(fTime);
    Outer.Clock(fTime);
    for (i = 0; i < 100; i++)
    {
        BioWorldInfo(Outer.WorldInfo).CheckConditional(6);
    }
    Outer.UnClock(fTime);
    Outer.Clock(fTime);
    for (i = 0; i < 300; i++)
    {
        BioWorldInfo(Outer.WorldInfo).CheckConditional(0);
        BioWorldInfo(Outer.WorldInfo).CheckConditional(7);
        BioWorldInfo(Outer.WorldInfo).CheckConditional(6);
    }
    Outer.UnClock(fTime);
    Outer.Clock(fTime);
    BioWorldInfo(Outer.WorldInfo).CheckConditional(5);
    Outer.UnClock(fTime);
    Outer.Clock(fTime);
    for (i = 0; i < 1000; i++)
    {
        BioWorldInfo(Outer.WorldInfo).CheckConditional(5);
    }
    Outer.UnClock(fTime);
}
public exec function TestConsumeId(int nID)
{
    local BWConsumableId eID;
    
    eID.nID = nID;
    if (Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().ConsumeId(eID, 1, OnConsumeResult))
    {
        Outer.ClientMessage("TestConsumeId (" $ nID $ ") returned true");
    }
    else
    {
        Outer.ClientMessage("TestConsumeId (" $ nID $ ") returned false");
    }
}
public final exec function TestCountdown(float fSeconds, float fWarningSeconds)
{
    SFXPlayerController(Outer).BeginCountdownTimer(fSeconds, fWarningSeconds);
}
public exec function TestDisplay1stPartyStore()
{
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().Display1stPartyStore();
}
public exec function TestDumpDime()
{
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().DumpTestData();
}
public exec function TestEchoDigitalRights()
{
    TestGetOffersList();
    TestGetEntitlementsList();
    TestGetConsumablesList();
}
public exec function TestEchoWallet()
{
    Outer.ClientMessage("Wallet Balance - " $ Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().GetWalletBalance());
}
public exec function TestFalling(Name nmTarget)
{
    local BioPlayerController oController;
    local BioPawn oPawn;
    local Vector NewLocation;
    
    oController = Outer;
    oPawn = BioPawn(oController.Pawn);
    if (nmTarget == 'Target')
    {
        oPawn = BioPawn(oController.m_oPlayerSelection.m_oCurrentSelectionTarget);
        if (oPawn == None)
        {
            oPawn = BioPawn(oController.Pawn);
        }
    }
    NewLocation = oPawn.location;
    NewLocation.Z += float(500);
    oPawn.SetLocation(NewLocation, );
    oPawn.SetPhysics(2);
    oPawn.Falling();
}
public exec function TestGaWHTTPSystem()
{
    local SFXOnlineComponentGalaxyAtWar galaxyAtWar;
    
    galaxyAtWar = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentGalaxyAtWar();
    galaxyAtWar.GetRatings(TRUE, FALSE, GaWHTTPResult);
}
public exec function TestGetConsumablesList()
{
    local array<BWConsumableInfo> aConsumables;
    local BWConsumableInfo eConsumable;
    
    if (Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().GetConsumablesList(aConsumables))
    {
        foreach aConsumables(eConsumable, )
        {
            Outer.ClientMessage("Consumable - (" $ eConsumable.Id.nID $ "-" $ eConsumable.nCopies $ ")");
        }
    }
    else
    {
        Outer.ClientMessage("No consumables");
    }
}
public exec function TestGetEntitlementsList()
{
    local array<BWEntitlementInfo> aEntitlements;
    local BWEntitlementInfo eEntitlement;
    
    if (Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().GetEntitlementsList(aEntitlements))
    {
        foreach aEntitlements(eEntitlement, )
        {
            Outer.ClientMessage("Entitlement - (" $ eEntitlement.Id.nID $ ")");
        }
    }
    else
    {
        Outer.ClientMessage("No entitlements");
    }
}
public exec function TestGetOffersList()
{
    local array<BWOfferInfo> aOffers;
    local array<BWOfferId> aOfferFilters;
    local BWOfferInfo eOffer;
    
    aOfferFilters.Length = 0;
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().GetOffersList(aOffers, aOfferFilters);
    if (aOffers.Length == 0)
    {
        Outer.ClientMessage("No Offers");
    }
    else
    {
        foreach aOffers(eOffer, )
        {
            Outer.ClientMessage("Offer - (" $ eOffer.Id.nID $ "-" $ eOffer.sTitle $ "-" $ eOffer.sPrice $ "|" $ eOffer.sShortDescription $ "|" $ eOffer.sLongDescription $ ")");
        }
    }
}
public exec function TestGrantEntitlementId(int nID)
{
    local BWEntitlementId eID;
    
    eID.nID = nID;
    if (Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().GrantEntitlementId(eID, OnGrantEntitlementResult))
    {
        Outer.ClientMessage("TestGrantEntitlementId (" $ nID $ ") returned true");
    }
    else
    {
        Outer.ClientMessage("TestGrantEntitlementId (" $ nID $ ") returned false");
    }
}
public exec function TestHTTPSystem()
{
    local SFXOnlineJobHTTPRequest Job;
    
    Job = Class'SFXOnlineJobHTTPRequest'.static.CreateHTTPRequestJob();
    Job.mRequest.SetBaseURL("http://www.google.com/");
    Job.__OnJobComplete__Delegate = HTTPResult;
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentJobQueue().AddJob(Job);
}
public exec function TestKeyboardInput(string sDefaultText)
{
    m_TestKeyboard = new (Self) Class'SFXGUIHelper_ConsoleKeyboard';
    m_TestKeyboard.__OnKeyboardEntryComplete__Delegate = KeyboardTestEntryComplete;
    m_TestKeyboard.DisplayKeyboard(stringref(27515), stringref(321060), 0, 128, sDefaultText);
}
public exec function TestLoadingMessage(float fTime)
{
    local SFXSaveLoadWidgetProxy oProxy;
    
    oProxy = Class'SFXGUIInteraction'.static.GetInstance().m_oSavingLoadingDisplayProxy;
    oProxy.ShowLoadingMessage(TRUE);
    Outer.SetTimer(fTime, FALSE, 'HideLoadingMessage', Self);
}
public final exec function TestMessageBox(bool bDesign, string S)
{
    local BioSFHandler_MessageBox mb;
    local BioMessageBoxOptionalParams mbp;
    
    mbp.srAText = $152938;
    mbp.srBText = $168246;
    mbp.m_SkinType = bDesign ? SFX_MB_Skin.SFX_MB_Skin_Shepard : SFX_MB_Skin.SFX_MB_Skin_User;
    mb = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(None);
    if (mb != None)
    {
        mb.DisplayMessageBoxEx(S, mbp);
    }
}
public final exec function TestMPObjective(stringref sr, float fPct, bool bBoost)
{
    SFXPlayerController(Outer).SetScoreHudObjectiveText(sr);
    SFXPlayerController(Outer).SetScoreHudObjectiveProgress(fPct, bBoost);
}
public final exec function TestMPTicker(int nCount)
{
    local int N;
    
    for (N = 0; N < nCount; ++N)
    {
        SFXGRI(Outer.WorldInfo.GRI).GetEventTicker().AddTickerEntry("<font color=\"#FF0000\">MP HUD</font> Ticker Entry #" $ N + 1 $ "<font color=\"#00FF99\">(" $ BioWorldInfo(Outer.WorldInfo).TimeSeconds $ ")</font>");
    }
}
public exec function TestPOIIndicator()
{
    local SFXSFHandler_HUD HUD;
    local SFXGUIInteraction oGUI;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    HUD = oGUI.CastGetMovie(Class'SFXSFHandler_HUD', Outer, oGUI.MovieTag_HUD);
    HUD.SetPOIState(1);
    Outer.SetTimer(5.0, FALSE, 'HidePOIIndicator', Self);
}
public exec function TestPrefab(int nTestNum)
{
    DebugSpawnPrefab(nTestNum);
}
public exec function TestPulseFullAmmo(bool bGrenade)
{
    local SFXGUIInteraction oGUI;
    local SFXSFHandler_HUD oHud;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    oHud = oGUI.CastGetMovie(Class'SFXSFHandler_HUD', Outer, oGUI.MovieTag_HUD);
    oHud.PulseFullAmmoMessage(bGrenade);
}
public exec function TestPurchaseOfferId(int nID)
{
    local BWOfferId eID;
    
    eID.nID = nID;
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().PurchaseOfferId(eID, OnPurchaseOfferIdResult);
}
public exec function TestRefreshDigitalRights()
{
    Outer.ClientMessage("Refreshing Digital Rights");
    Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentCommerce().RefreshDigitalRights(OnRefreshDigitalRightsResult);
}
public exec function TestSavingMessage(float fSaveTime)
{
    local SFXSaveLoadWidgetProxy oProxy;
    
    oProxy = Class'SFXGUIInteraction'.static.GetInstance().GetSaveLoadWidget();
    oProxy.ShowSavingMessage(TRUE);
    Outer.SetTimer(fSaveTime, FALSE, 'HideSavingMessage', Self);
}
public final exec function TestString(string S)
{
    local BioSubtitles subs;
    
    subs = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).m_pSubtitles;
    if (subs != None)
    {
        if (S != "none")
        {
            S = "TEST: " $ S;
            subs.AddSubtitle(S, Self, None, MakeColor(255, 116, 109, 255), FALSE, 3, TRUE);
        }
        else
        {
            subs.RemoveSubtitle(Self);
        }
    }
}
public exec function TestTreasure()
{
    local BioWorldInfo oWorldInfo;
    local SFXPlotTreasure oTreasure;
    
    oWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    oTreasure = oWorldInfo.m_oTreasure;
    Validate(oTreasure);
    Outer.ClientMessage("Treasure Tested (check your log file)");
}
public final exec function TestTutorialHint(int nPosition)
{
    Class'SFXGUIInteraction'.static.GetInstance().ShowHint($552680, 5.0, 0, byte(nPosition));
}
public final exec function TestWeaponChoice()
{
    local BioSFHandler_MessageBox mb;
    
    mb = Class'SFXGUIInteraction'.static.GetInstance().CreateMessageBox(None);
    if (mb != None)
    {
        mb.SetWeaponChoiceResultCallback(WeaponChoiceDialogResult);
        mb.ShowWeaponChoiceDialogEx("New Weapon!", "This weapon is full of awesome sauce", PathName(Class'SFXWeapon'.default.IconResource), 45, "OK", 1, "Open Weapon Inventory", 2, "Equip Now", 3);
    }
}
public exec function TestWound(int WoundIdx, string TargetName)
{
    local Actor WoundTarget;
    local SFXModule_Wound WoundMod;
    
    WoundTarget = GetActorFromString(TargetName);
    if (WoundTarget != None)
    {
        WoundMod = WoundTarget.GetModule(Class'SFXModule_Wound');
        if (WoundMod != None)
        {
            WoundMod.CreateWound(WoundIdx);
            Outer.ClientMessage("Creating wound:" @ WoundIdx);
            return;
        }
    }
    Outer.ClientMessage("TestWound - Invalid target");
}
public exec function TestXMLParser()
{
    local SFXOnlineComponentXMLParser parser;
    local string stringResult;
    local string attribStringResult;
    local int IntResult;
    local int attribIntResult;
    
    stringResult = "";
    IntResult = -1;
    attribStringResult = "";
    attribIntResult = -1;
    parser = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentXMLParser();
    parser.StartParsing("<?xml version=\"1.0\" encoding=\"UTF-8\"?><xmlTester> <attribTest intAttrib=1337 stringAttrib=\"pretty string attrib\">0</attribTest> <aBigNumber>1073872896</aBigNumber> <whoMadeIt>Bob</whoMadeIt> <whoMadeIt>Joe<</whoMadeIt></xmlTester>");
    if (parser.GetXMLString("xmlTester.whoMadeIt", stringResult, 1))
    {
        Outer.ClientMessage("XML String: " $ stringResult);
    }
    else
    {
        Outer.ClientMessage("Failed to parse XML string");
    }
    if (parser.GetXMLInteger("xmlTester.aBigNumber", IntResult))
    {
        Outer.ClientMessage("XML Integer: " $ IntResult);
    }
    else
    {
        Outer.ClientMessage("Failed to parse XML Integer");
    }
    if (parser.GetXMLAttribString("xmlTester.attribTest", "stringAttrib", attribStringResult))
    {
        Outer.ClientMessage("XML String Attrib: " $ attribStringResult);
    }
    else
    {
        Outer.ClientMessage("Failed to parse XML string attrib");
    }
    if (parser.GetXMLAttribInteger("xmlTester.attribTest", "intAttrib", attribIntResult))
    {
        Outer.ClientMessage("XML Integer Attrib: " $ attribIntResult);
    }
    else
    {
        Outer.ClientMessage("Failed to parse XML Integer Attrib");
    }
}
public exec function ToggleAI(optional bool IncludeHenchmen = TRUE)
{
    local AIController AI;
    
    foreach Outer.WorldInfo.AllControllers(Class'AIController', AI)
    {
        if (IncludeHenchmen || SFXAI_Henchman(AI) == None)
        {
            AI.bNoTick = !AI.bNoTick;
            if (AI.Pawn != None)
            {
                AI.Pawn.bNoTick = !AI.Pawn.bNoTick;
            }
        }
    }
}
public exec function ToggleAngstIcons()
{
    if (SFXGRI(Outer.WorldInfo.GRI) != None && SFXGRI(Outer.WorldInfo.GRI).bMultiplayer == FALSE)
    {
        BioHUD(Outer.myHUD).ToggleDebugDraw(DebugDraw_AngstIcons);
    }
}
public exec function TogglePowerAiming()
{
    m_bShowPowerAiming = !m_bShowPowerAiming;
}
public exec function ToggleScoreIndicators()
{
    local bool bShowIndicators;
    local BioPlayerController Controller;
    
    Controller = Outer;
    bShowIndicators = Controller.ProfileSettings.GetShowScoreIndicators();
    bShowIndicators = !bShowIndicators;
    Controller.ProfileSettings.SetShowScoreIndicators(bShowIndicators);
    if (bShowIndicators)
    {
        Outer.ClientMessage("Scoring Indicators Enabled");
    }
    else
    {
        Outer.ClientMessage("Scoring Indicators Disabled");
    }
}
public exec function ToggleSFHUD()
{
    Class'SFXGUIInteraction'.static.GetInstance().ClearAll();
}
public exec function ToggleThreatRadius(optional string PawnName)
{
    local BioPawn oPawn;
    local SFXAI_Core oController;
    
    if (Len(PawnName) != 0)
    {
        oPawn = BioPawn(GetActorFromString(PawnName));
        if (oPawn == None)
        {
            return;
        }
        oController = SFXAI_Core(oPawn.Controller);
        if (oController == None)
        {
            return;
        }
        oController.bDebug_ThreatRadius = !oController.bDebug_ThreatRadius;
    }
    else
    {
        foreach Outer.AllActors(Class'BioPawn', oPawn, )
        {
            if (oPawn != None)
            {
                oController = SFXAI_Core(oPawn.Controller);
                if (oController != None)
                {
                    oController.bDebug_ThreatRadius = !oController.bDebug_ThreatRadius;
                }
            }
        }
    }
    DebugAIVals();
}
public exec function ToggleWeaponMod(string WeaponName, string modName)
{
    local SFXInventoryManager InvManager;
    local SFXWeapon Weapon;
    local int idx;
    local SFXModule_WeaponModManager Manager;
    local Class<SFXWeaponMod> ModClass;
    local Name ModClassName;
    local BioPawn oPawn;
    local BioPlayerController PC;
    local SFXEngine Engine;
    local int ModID;
    local int ModLevel;
    local Name ModClassPath;
    local Name WeaponClassPath;
    local bool bWeaponExists;
    local WeaponModSaveRecord ModSaveRecord;
    
    PC = Outer;
    if (PC == None)
    {
        Outer.ClientMessage("Couldn't get Player Controller");
        return;
    }
    oPawn = BioPawn(PC.Pawn);
    if (oPawn == None)
    {
        Outer.ClientMessage("Couldn't get Pawn");
        return;
    }
    Engine = SFXEngine(PC.Player.Outer);
    if (Engine == None)
    {
        Outer.ClientMessage("Couldn't get Engine");
        return;
    }
    InvManager = SFXInventoryManager(oPawn.InvManager);
    if (InvManager == None)
    {
        Outer.ClientMessage("Couldn't get Inventory Manager");
        return;
    }
    if (WeaponName ~= "current")
    {
        WeaponClassPath = InvManager.CurrentWeaponSelection.Name;
    }
    else
    {
        WeaponClassPath = Name(WeaponName);
    }
    ModClassPath = Name(modName);
    for (idx = 0; idx < Engine.PlayerWeaponMods.Length; idx++)
    {
        if (Engine.PlayerWeaponMods[idx].WeaponClassName == WeaponClassPath)
        {
            bWeaponExists = TRUE;
            ModID = Engine.PlayerWeaponMods[idx].WeaponModClassNames.Find(ModClassPath);
            if (ModID != -1)
            {
                Engine.PlayerWeaponMods[idx].WeaponModClassNames.Remove(ModID, 1);
            }
            else
            {
                Engine.PlayerWeaponMods[idx].WeaponModClassNames.AddItem(ModClassPath);
            }
            break;
        }
    }
    if (!bWeaponExists)
    {
        ModSaveRecord.WeaponClassName = WeaponClassPath;
        ModSaveRecord.WeaponModClassNames.AddItem(ModClassPath);
        Engine.PlayerWeaponMods.AddItem(ModSaveRecord);
    }
    foreach InvManager.InventoryActors(Class'SFXWeapon', Weapon)
    {
        for (idx = 0; idx < Engine.PlayerWeaponMods.Length; idx++)
        {
            if (PathName(Weapon.Class) == string(Engine.PlayerWeaponMods[idx].WeaponClassName))
            {
                Manager = Weapon.GetModule(Class'SFXModule_WeaponModManager');
                if (Manager != None)
                {
                    Manager.RemoveAllMods();
                    foreach Engine.PlayerWeaponMods[idx].WeaponModClassNames(ModClassName, )
                    {
                        ModClass = Class'SFXWeaponMod'.static.LoadModClass(string(ModClassName));
                        if (ModClass != None && ModClass.static.IsUnlocked(ModLevel))
                        {
                            Manager.AddMod(ModClass, ModLevel);
                        }
                    }
                }
            }
        }
    }
}
public final exec function TraceActorAnimNode(string sTargetActor, Name nmNode)
{
    local Actor TargetActor;
    local LinearColor DrawColor;
    
    TargetActor = GetActorFromString(sTargetActor);
    if (TargetActor == None)
    {
        TargetActor = Outer.Pawn;
    }
    DrawColor.R = 0.0;
    DrawColor.G = 0.25;
    DrawColor.B = 1.0;
    DrawColor.A = 1.0;
    BioHUD(Outer.myHUD).AddAnimNodeTraceStrip(TargetActor, nmNode, DrawColor);
}
public final exec function TraceActorProperty(string sTargetActor, Name nmProp)
{
    local Actor TargetActor;
    local LinearColor DrawColor;
    
    TargetActor = GetActorFromString(sTargetActor);
    if (TargetActor == None)
    {
        TargetActor = Outer.Pawn;
    }
    DrawColor.R = 1.0;
    DrawColor.G = 0.0;
    DrawColor.B = 0.25;
    DrawColor.A = 1.0;
    BioHUD(Outer.myHUD).AddPropertyTraceStrip(TargetActor, nmProp, DrawColor);
}
public final exec function TraceAxis(Name nmAxis)
{
    local LinearColor DrawColor;
    
    DrawColor.R = 1.0;
    DrawColor.G = 0.5;
    DrawColor.A = 1.0;
    BioHUD(Outer.myHUD).AddAxisTraceStrip(nmAxis, DrawColor);
}
public final exec function TraceButton(Name nmButton)
{
    local LinearColor DrawColor;
    
    DrawColor.R = 1.0;
    DrawColor.G = 1.0;
    DrawColor.A = 1.0;
    BioHUD(Outer.myHUD).AddButtonTraceStrip(nmButton, DrawColor);
}
public exec function UnlockAllAccomplishments();

public exec function UnlockAllGamerpics()
{
    Outer.OnlineSub.PlayerInterfaceEx.UnlockGamerPicture(0, 1);
    Outer.OnlineSub.PlayerInterfaceEx.UnlockGamerPicture(0, 2);
}
public exec function UnlockAllResearch(bool B)
{
    local BioWorldInfo oWorldInfo;
    local SFXPlotTreasure oTreasure;
    local int i;
    local int nTreasureId;
    local Name nmRequiredTech;
    local Name nmTech;
    
    oWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    oTreasure = oWorldInfo.m_oTreasure;
    for (i = 0; i != oTreasure.oPlotTreasureTreasure2DA.GetNumRows(); ++i)
    {
        nTreasureId = oTreasure.oPlotTreasureTreasure2DA.GetRowNumber(i);
        oTreasure.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmRequiredTech', nmRequiredTech);
        oTreasure.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmTech', nmTech);
        if (nmRequiredTech != 'None')
        {
            oWorldInfo.GetGlobalVariables().SetBool(nTreasureId, B);
            oWorldInfo.GetGlobalVariables().SetIntByName(nmTech, B ? 1 : 0);
        }
    }
}
public exec function UnlockAllTech(int i)
{
    local BioWorldInfo oWorldInfo;
    local SFXPlotTreasure oTreasure;
    local int N;
    local Name nmTech;
    
    oWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    oTreasure = oWorldInfo.m_oTreasure;
    for (N = 0; N != oTreasure.oPlotTreasureTech2DA.GetNumRows(); ++N)
    {
        oTreasure.oPlotTreasureTech2DA.GetNameEntryIN(N, 'nmTech', nmTech);
        oWorldInfo.GetGlobalVariables().SetIntByName(nmTech, i);
    }
    oWorldInfo.GetGlobalVariables().SetIntByName('Dep_Tec_GruntShotgun', i);
    oWorldInfo.GetGlobalVariables().SetIntByName('Dep_Tec_JackUpgrade', i);
    oWorldInfo.GetGlobalVariables().SetIntByName('Dep_Tec_LegionSniper', i);
    oWorldInfo.GetGlobalVariables().SetIntByName('Dep_Tec_MordinUpgrade', i);
    oWorldInfo.GetGlobalVariables().SetIntByName('Dep_Tec_ShipArmor', i);
    oWorldInfo.GetGlobalVariables().SetIntByName('Dep_Tec_ShipFuel', i);
    oWorldInfo.GetGlobalVariables().SetIntByName('Dep_Tec_ShipGun', i);
    oWorldInfo.GetGlobalVariables().SetIntByName('Dep_Tec_ShipProbes', i);
    oWorldInfo.GetGlobalVariables().SetIntByName('Dep_Tec_ShipScanner', i);
    oWorldInfo.GetGlobalVariables().SetIntByName('Dep_Tec_ShipShield', i);
    oWorldInfo.GetGlobalVariables().SetIntByName('Tech_CounterForRetrain', i);
    oWorldInfo.GetGlobalVariables().SetIntByName('Tech_CounterForLoyaltyPower', i);
}
public exec function UnlockAllTreasure(bool B)
{
    local BioWorldInfo oWorldInfo;
    local SFXPlotTreasure oTreasure;
    local int i;
    local int nTreasureId;
    
    oWorldInfo = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    oTreasure = oWorldInfo.m_oTreasure;
    for (i = 0; i != oTreasure.oPlotTreasureTreasure2DA.GetNumRows(); ++i)
    {
        nTreasureId = oTreasure.oPlotTreasureTreasure2DA.GetRowNumber(i);
        oWorldInfo.GetGlobalVariables().SetBool(nTreasureId, B);
    }
}
public exec function UnlockBonusPower(int BonusPowerID)
{
    local SFXProfileSettings Profile;
    local int idx;
    local array<BonusPowerUnlockData> BonusPowers;
    local BioGlobalVariableTable VarTable;
    local BioWorldInfo WI;
    
    WI = BioWorldInfo(Outer.WorldInfo);
    if (WI == None)
    {
        return;
    }
    VarTable = WI.GetGlobalVariables();
    if (VarTable == None)
    {
        return;
    }
    Profile = Outer.ProfileSettings;
    if (Profile == None)
    {
        return;
    }
    Profile.GetBonusPowerArray(BonusPowers);
    if (BonusPowers.Length <= 0)
    {
        return;
    }
    idx = BonusPowers.Find('BonusPowerID', BonusPowerID);
    if (idx == -1)
    {
        return;
    }
    if (VarTable.GetBool(BonusPowers[idx].PlotStateID) == FALSE)
    {
        VarTable.SetBool(BonusPowers[idx].PlotStateID, TRUE);
        Outer.ClientMessage("Updating Story Manager");
    }
    else
    {
        Outer.ClientMessage("Power Already Unlocked");
        return;
    }
    if (Profile != None)
    {
        Outer.ClientMessage("Updating Profile");
        Profile.UnlockBonusPower(BonusPowerID);
    }
}
public final exec function UpdateGAWAsset(int Id, int NewStrength)
{
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.UpdateGAWAsset(Id, NewStrength);
}
public final exec function UpdateGAWAssetByName(string AssetName, int NewStrength)
{
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.UpdateGAWAssetByName(AssetName, NewStrength);
}
public exec function UploadNewFaceCode(string CharacterName, optional string faceCode)
{
    SFXEngine(Class'Engine'.static.GetEngine()).MPSaveManager.AddNewFaceCode(CharacterName, faceCode);
    SFXEngine(Class'Engine'.static.GetEngine()).MPSaveManager.SaveRecords();
}
public static function Validate(SFXPlotTreasure oTreasure)
{
    ValidateResourcesSheet(oTreasure);
    ValidateTreasureSheet(oTreasure);
    ValidateTechSheet(oTreasure);
}
public static function ValidateResourcesSheet(SFXPlotTreasure oTreasure)
{
    local SResourceBudget stResource;
    local Name nmLevel;
    local int i;
    local int nCredits;
    local int Eezo;
    local int Palladium;
    local int Platinum;
    local int Iridium;
    local int Id;
    
    if (oTreasure.oPlotTreasureResources2DA.GetNumRows() < 2)
    {
    }
    for (i = 0; i != oTreasure.oPlotTreasureResources2DA.GetNumRows(); ++i)
    {
        nmLevel = oTreasure.oPlotTreasureResources2DA.GetRowName(i);
        oTreasure.oPlotTreasureResources2DA.GetIntEntryIN(i, 'Credits', nCredits);
        oTreasure.oPlotTreasureResources2DA.GetIntEntryIN(i, 'Eezo', Eezo);
        oTreasure.oPlotTreasureResources2DA.GetIntEntryIN(i, 'Palladium', Palladium);
        oTreasure.oPlotTreasureResources2DA.GetIntEntryIN(i, 'Platinum', Platinum);
        oTreasure.oPlotTreasureResources2DA.GetIntEntryIN(i, 'Iridium', Iridium);
        oTreasure.oPlotTreasureResources2DA.GetIntEntryIN(i, 'Id', Id);
        if (nmLevel == 'None')
        {
        }
        if (nCredits < 100 && Eezo < 100 && Palladium < 100 && Iridium < 100)
        {
        }
        stResource = oTreasure.Budget(nmLevel);
        if (stResource.nCredits != nCredits)
        {
        }
        if (stResource.nEezo != Eezo)
        {
        }
        if (stResource.nPalladium != Palladium)
        {
        }
        if (stResource.nPlatinum != Platinum)
        {
        }
        if (stResource.nIridium != Iridium)
        {
        }
        if (stResource.nID != Id)
        {
        }
    }
}
public static function ValidateTechSheet(SFXPlotTreasure oTreasure)
{
    local Name nmTech;
    local STech stTech;
    local int i;
    local int nSrTitle;
    local int nSrName;
    local int nSrMessage;
    local int nSrDescription;
    local int nLevels;
    
    if (oTreasure.oPlotTreasureTech2DA.GetNumRows() < 2)
    {
    }
    for (i = 0; i != oTreasure.oPlotTreasureTech2DA.GetNumRows(); ++i)
    {
        oTreasure.oPlotTreasureTech2DA.GetNameEntryIN(i, 'nmTech', nmTech);
        oTreasure.GetPlotTreasureTechInt(nmTech, 'nmTech', 'srTitle', nSrTitle);
        oTreasure.GetPlotTreasureTechInt(nmTech, 'nmTech', 'srName', nSrName);
        oTreasure.GetPlotTreasureTechInt(nmTech, 'nmTech', 'srMessage', nSrMessage);
        oTreasure.GetPlotTreasureTechInt(nmTech, 'nmTech', 'srDescription', nSrDescription);
        oTreasure.GetPlotTreasureTechInt(nmTech, 'nmTech', 'nLevels', nLevels);
        if (nmTech == 'None')
        {
        }
        stTech = oTreasure.Tech(nmTech);
        if (stTech.nmTech == 'None')
        {
        }
        if (stTech.nmTech != nmTech)
        {
        }
        if (stTech.srName != nSrName)
        {
        }
        if (stTech.srTitle != nSrTitle)
        {
        }
        if (stTech.srMessage != nSrMessage)
        {
        }
        if (stTech.srDescription != nSrDescription)
        {
        }
        if (stTech.nLevels != nLevels)
        {
        }
    }
}
public static function ValidateTreasureSheet(SFXPlotTreasure oTreasure)
{
    local int i;
    local STreasure stTreasure;
    local STech stTech;
    local Name nmLevel;
    local Name nmTreasure;
    local Name nmTech;
    local Name nmResource;
    local Name nmRequiredTech;
    local int nTreasureId;
    local int nPrice;
    local int nRequiredTechLevel;
    
    if (oTreasure.oPlotTreasureTreasure2DA.GetNumRows() < 2)
    {
    }
    for (i = 0; i != oTreasure.oPlotTreasureTreasure2DA.GetNumRows(); ++i)
    {
        nTreasureId = oTreasure.oPlotTreasureTreasure2DA.GetRowNumber(i);
        oTreasure.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmLevel', nmLevel);
        oTreasure.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmTreasure', nmTreasure);
        oTreasure.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmTech', nmTech);
        oTreasure.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmResource', nmResource);
        oTreasure.oPlotTreasureTreasure2DA.GetIntEntryIN(i, 'nPrice', nPrice);
        oTreasure.oPlotTreasureTreasure2DA.GetNameEntryIN(i, 'nmRequiredTech', nmRequiredTech);
        oTreasure.oPlotTreasureTreasure2DA.GetIntEntryIN(i, 'nRequiredTechLevel', nRequiredTechLevel);
        if (nmLevel == 'None')
        {
        }
        if (nmTreasure == 'None')
        {
        }
        if (nmTech == 'None')
        {
        }
        stTech = oTreasure.Tech(nmTech);
        if (stTech.nmTech == 'None')
        {
        }
        switch (nmResource)
        {
            case 'None':
            case 'Credits':
            case 'Eezo':
            case 'Iridium':
            case 'Palladium':
            case 'Platinum':
            case 'Probes':
                break;
            default:
        }
        if (nmResource == 'None' && nPrice != 0)
        {
        }
        if (nmResource != 'None' && nPrice == 0)
        {
        }
        stTech = oTreasure.Tech(nmRequiredTech);
        if (nmRequiredTech != 'None' && stTech.nmTech != nmRequiredTech)
        {
        }
        if (nmRequiredTech != 'None' && nRequiredTechLevel <= 0)
        {
        }
        if (nmRequiredTech == 'None' && nRequiredTechLevel != 0)
        {
        }
        stTreasure = oTreasure.TREASURE(nTreasureId);
        if (stTreasure.nmLevel != nmLevel)
        {
        }
        if (stTreasure.nmRequiredTech != nmRequiredTech)
        {
        }
        if (stTreasure.nmTech != nmTech)
        {
        }
        if (stTreasure.nmTreasure != nmTreasure)
        {
        }
        if (stTreasure.nTreasureId != nTreasureId)
        {
        }
        if (stTreasure.RequiredTechLevel != nRequiredTechLevel)
        {
        }
        if (stTreasure.ResourcePrice != nPrice)
        {
        }
    }
}
public exec function VoiceEnumerateInputs()
{
    local SFXOnlineComponentVoiceInterface oVoiceInterface;
    local int Index;
    local array<string> InputDevices;
    
    oVoiceInterface = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentVoiceInterface();
    if (oVoiceInterface != None)
    {
        if (oVoiceInterface.EnumerateInputDevices(InputDevices))
        {
            Outer.ClientMessage("-------------------------------------------");
            Outer.ClientMessage(InputDevices.Length $ " input devices found");
            Outer.ClientMessage("-------------------------------------------");
            for (Index = 0; Index < InputDevices.Length; Index++)
            {
                Outer.ClientMessage(Index $ " - " $ InputDevices[Index]);
            }
        }
        else
        {
            Outer.ClientMessage("-------------------------------------------");
            Outer.ClientMessage("No input devices found");
            Outer.ClientMessage("-------------------------------------------");
        }
    }
}
public exec function VoiceEnumerateOutputs()
{
    local SFXOnlineComponentVoiceInterface oVoiceInterface;
    local int Index;
    local array<string> OutputDevices;
    
    oVoiceInterface = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentVoiceInterface();
    if (oVoiceInterface != None)
    {
        if (oVoiceInterface.EnumerateOutputDevices(OutputDevices))
        {
            Outer.ClientMessage("-------------------------------------------");
            Outer.ClientMessage(OutputDevices.Length $ " output devices found");
            Outer.ClientMessage("-------------------------------------------");
            for (Index = 0; Index < OutputDevices.Length; Index++)
            {
                Outer.ClientMessage(Index $ " - " $ OutputDevices[Index]);
            }
        }
        else
        {
            Outer.ClientMessage("-------------------------------------------");
            Outer.ClientMessage("No output devices found");
            Outer.ClientMessage("-------------------------------------------");
        }
    }
}
public exec function VoiceGetDefaultInput()
{
    local SFXOnlineComponentVoiceInterface oVoiceInterface;
    local int inputDevice;
    
    inputDevice = -1;
    oVoiceInterface = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentVoiceInterface();
    if (oVoiceInterface != None)
    {
        inputDevice = oVoiceInterface.GetDefaultInputDevice();
    }
    if (inputDevice != -1)
    {
        Outer.ClientMessage("Default input device: " $ inputDevice);
    }
    else
    {
        Outer.ClientMessage("No default input found");
    }
}
public exec function VoiceGetDefaultOutput()
{
    local SFXOnlineComponentVoiceInterface oVoiceInterface;
    local int outputDevice;
    
    outputDevice = -1;
    oVoiceInterface = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentVoiceInterface();
    if (oVoiceInterface != None)
    {
        outputDevice = oVoiceInterface.GetDefaultOutputDevice();
    }
    if (outputDevice != -1)
    {
        Outer.ClientMessage("Default output device: " $ outputDevice);
    }
    else
    {
        Outer.ClientMessage("No default output found");
    }
}
public exec function VoiceSetInput(int inputDevice)
{
    local SFXOnlineComponentVoiceInterface oVoiceInterface;
    
    oVoiceInterface = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentVoiceInterface();
    if (oVoiceInterface != None)
    {
        if (oVoiceInterface.SetInputDevice(inputDevice))
        {
            Outer.ClientMessage("Input set to: " $ inputDevice);
        }
        else
        {
            Outer.ClientMessage("Failed to set input");
        }
    }
}
public exec function VoiceSetOutput(int outputDevice)
{
    local SFXOnlineComponentVoiceInterface oVoiceInterface;
    
    oVoiceInterface = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem().GetComponentVoiceInterface();
    if (oVoiceInterface != None)
    {
        if (oVoiceInterface.SetOutputDevice(outputDevice))
        {
            Outer.ClientMessage("Output set to: " $ outputDevice);
        }
        else
        {
            Outer.ClientMessage("Failed to set output");
        }
    }
}
public final function WeaponChoiceDialogResult(BioSFHandler_MessageBox oMsgBox, int nChoiceID)
{
    TestString("Weapon Choice Results: Option=" $ nChoiceID);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AllProfiles = ({
                    Header = "", 
                    Description = "Clears the current profile", 
                    Func = None, 
                    Utility = None, 
                    Keyword = 'None', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "", 
                    Description = "", 
                    Func = None, 
                    Utility = None, 
                    Keyword = 'None', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Camera Profile of", 
                    Description = "Displays camera info", 
                    Func = ProfileCamera, 
                    Utility = None, 
                    Keyword = 'Camera', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Combat Profile of", 
                    Description = "Displays all of the target's combat stats including equipment, damage stats, perception lists and inventory", 
                    Func = ProfileCombat, 
                    Utility = DrawAIUtility, 
                    Keyword = 'Combat', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Multiplayer Game Profile", 
                    Description = "Displays stats on objectives and enemy waves", 
                    Func = ProfileMPGame, 
                    Utility = DrawAIUtility, 
                    Keyword = 'mpgame', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Weapon Profile of", 
                    Description = "Displays all of the target's weapon stats", 
                    Func = ProfileWeapon, 
                    Utility = DrawAIUtility, 
                    Keyword = 'Weapon', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Combat Stats Profile of", 
                    Description = "Tracks combat accuracy and effectiveness", 
                    Func = ProfileCombatStats, 
                    Utility = DrawAIUtility, 
                    Keyword = 'combatstats', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Difficulty Profile of", 
                    Description = "Displays details of the current difficult setting", 
                    Func = ProfileDifficulty, 
                    Utility = None, 
                    Keyword = 'Difficulty', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Angst Profile", 
                    Description = "Displays Angst Icon over creatures that do not have their target within equipped weapon range.", 
                    Func = ProfileAngst, 
                    Utility = None, 
                    Keyword = 'angst', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Power Cooldown Profile of", 
                    Description = "Displays the cooldown bar for the player.", 
                    Func = ProfileCooldown, 
                    Utility = None, 
                    Keyword = 'Cooldown', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "", 
                    Description = "", 
                    Func = None, 
                    Utility = None, 
                    Keyword = 'None', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Pawn Profile of", 
                    Description = "Displays all non-combat information about a pawn including movement information, faction data, LOD and Talent information", 
                    Func = ProfilePawn, 
                    Utility = DrawTargetLineUtility, 
                    Keyword = 'Pawn', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Power Profile of", 
                    Description = "Displays all power information for a given pawn, can also display information for one power use 'profile power <self/target/camera> <powername>'", 
                    Func = ProfilePower, 
                    Utility = DrawTargetLineUtility, 
                    Keyword = 'Power', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Technology Profile of", 
                    Description = "All player tech. Use profile treasure for treasure. Use 'setintbyname <name> <value>' to modify", 
                    Func = ProfileTech, 
                    Utility = None, 
                    Keyword = 'Tech', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Treasure Profile of", 
                    Description = "Try 'debugtreasure local' or 'debugtreasure all' to switch modes", 
                    Func = ProfileTreasure, 
                    Utility = None, 
                    Keyword = 'TREASURE', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Locomotion Profile of", 
                    Description = "Displays locomotion data for the given pawn.", 
                    Func = ProfileLocomotion, 
                    Utility = DrawTargetLineUtility, 
                    Keyword = 'Locomotion', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "AnimTree Profile of", 
                    Description = "Displays animtree for the given pawn.", 
                    Func = ProfileAnimTree, 
                    Utility = DrawTargetLineUtility, 
                    Keyword = 'AnimTree', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Ticket Profile of", 
                    Description = "Displays the max and current target and attack tickets for the pawn's squad", 
                    Func = ProfileTicket, 
                    Utility = None, 
                    Keyword = 'ticket', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Vehicle Profile of", 
                    Description = "Displays all vehicle information, including movement, damage, and current thrust power.", 
                    Func = ProfileVehicle, 
                    Utility = None, 
                    Keyword = 'Vehicle', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Henchmen Profile of", 
                    Description = "Displays information about the henchmen", 
                    Func = ProfileHenchmen, 
                    Utility = None, 
                    Keyword = 'henchmen', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Settings Profile of", 
                    Description = "Displays all the profile settings, including trigger configuration, y axis inversion, etc.", 
                    Func = ProfileGameSettings, 
                    Utility = None, 
                    Keyword = 'Settings', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "GameEffect Profile of", 
                    Description = "Displays all GameEffect information for a given actor.", 
                    Func = ProfileEffects, 
                    Utility = None, 
                    Keyword = 'Effect', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Scaleform Profile", 
                    Description = "Displays general scaleform processor times for all active scaleform panels.", 
                    Func = ProfileScaleform, 
                    Utility = None, 
                    Keyword = 'Scaleform', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Save game profile", 
                    Description = "Displays information about the current save game", 
                    Func = ProfileSaveGame, 
                    Utility = None, 
                    Keyword = 'SaveGame', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "GAWAsset Profile of", 
                    Description = "Displays the totals of each of the categories of GAWAssets", 
                    Func = ProfileGAWAssets, 
                    Utility = None, 
                    Keyword = 'GAWAssets', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Military GAWAsset Profile of", 
                    Description = "Displays all of the available military GAWAssets along with their strength and unlock status", 
                    Func = ProfileMilitaryGAWAssets, 
                    Utility = None, 
                    Keyword = 'MilitaryGAWAssets', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Device GAWAsset Profile of", 
                    Description = "Displays all of the available device GAWAssets along with their strength and unlock status", 
                    Func = ProfileDeviceGAWAssets, 
                    Utility = None, 
                    Keyword = 'DeviceGAWAssets', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Intel GAWAsset Profile of", 
                    Description = "Displays all of the available intel GAWAssets along with their strength and unlock status", 
                    Func = ProfileIntelGAWAssets, 
                    Utility = None, 
                    Keyword = 'IntelGAWAssets', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Salvage GAWAsset Profile of", 
                    Description = "Displays all of the salvage military GAWAssets along with their strength and unlock status", 
                    Func = ProfileSalvageGAWAssets, 
                    Utility = None, 
                    Keyword = 'SalvageGAWAssets', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Artifact GAWAsset Profile of", 
                    Description = "Displays all of the artifact military GAWAssets along with their strength and unlock status", 
                    Func = ProfileArtifactGAWAssets, 
                    Utility = None, 
                    Keyword = 'ArtifactGAWAssets', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Focus/Movement Profile of", 
                    Description = "Focus and rotation", 
                    Func = ProfileFocus, 
                    Utility = DrawAIUtility, 
                    Keyword = 'Focus', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "LoadSeekFreeAsync Profile", 
                    Description = "Display all LoadSeekFreeAsync Objects currently loaded", 
                    Func = ProfileLoadSeekFreeAsync, 
                    Utility = None, 
                    Keyword = 'loadseekfreeasync', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Placeable Profile of", 
                    Description = "Displays info on the targeted SFXPlaceable", 
                    Func = ProfilePlaceable, 
                    Utility = None, 
                    Keyword = 'Placeable', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "", 
                    Description = "", 
                    Func = None, 
                    Utility = None, 
                    Keyword = 'None', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Animation Profile of", 
                    Description = "Displays animation information", 
                    Func = ProfileAnim, 
                    Utility = DrawTargetLineUtility, 
                    Keyword = 'Anim', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Cover Profile of", 
                    Description = "Displays cover information for the specified pawn, including information about their current movement targets and the cover they're currently using", 
                    Func = ProfileCover, 
                    Utility = DrawTargetLineUtility, 
                    Keyword = 'Cover', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Cover Profile of", 
                    Description = "Displays details of specified door", 
                    Func = ProfileDoor, 
                    Utility = None, 
                    Keyword = 'door', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Conversation Profile of", 
                    Description = "Simple conversation profile", 
                    Func = ProfileConversation, 
                    Utility = None, 
                    Keyword = 'Conversation', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Conversation Bug Profile of", 
                    Description = "Simple conversation profile", 
                    Func = ProfileConversationBug, 
                    Utility = None, 
                    Keyword = 'conversationbug', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Gestures Profile of", 
                    Description = "Displays gestures information for the specified actor", 
                    Func = ProfileGestures, 
                    Utility = DrawTargetLineUtility, 
                    Keyword = 'Gestures', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "", 
                    Description = "", 
                    Func = None, 
                    Utility = None, 
                    Keyword = 'None', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "", 
                    Description = "", 
                    Func = None, 
                    Utility = None, 
                    Keyword = 'None', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Look-At Profile of", 
                    Description = "Displays look-at information for the specified pawn", 
                    Func = ProfileLookAt, 
                    Utility = DrawTargetLineUtility, 
                    Keyword = 'LookAt', 
                    bNoTarget = FALSE
                   }, 
                   {
                    Header = "Wwise Profile of", 
                    Description = "Wwise audio profile", 
                    Func = ProfileWwise, 
                    Utility = None, 
                    Keyword = 'Wwise', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Kinect Profile of", 
                    Description = "Kinect Speech profile", 
                    Func = ProfileKinect, 
                    Utility = None, 
                    Keyword = 'Kinect', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Anim Preload Profile of", 
                    Description = "Displays animation preload information currently", 
                    Func = ProfileAnimPreload, 
                    Utility = DrawTargetLineUtility, 
                    Keyword = 'animpreload', 
                    bNoTarget = TRUE
                   }, 
                   {
                    Header = "Profile Galaxy Map", 
                    Description = "Galaxymap Info", 
                    Func = ProfileGalaxy, 
                    Utility = None, 
                    Keyword = 'galaxy', 
                    bNoTarget = TRUE
                   }
                  )
    CE_Destructible_Name = "BioVFX_Test_Indicators.Destructible"
    ColumnWidth = 350.0
    ProfileTitleColor = {B = 51, G = 153, R = 255, A = 255}
    ProfileHeaderColor = {B = 205, G = 204, R = 204, A = 255}
    ProfileTextColor = {B = 255, G = 255, R = 255, A = 255}
    ProfileHighlightColor = {B = 255, G = 255, R = 0, A = 255}
    GAWTextColor = {B = 0, G = 255, R = 0, A = 200}
    GAWHighlightColor = {B = 0, G = 255, R = 255, A = 255}
    GAWHighlightColor2 = {B = 255, G = 255, R = 0, A = 255}
    m_bEnablePowerCooldown = TRUE
}