Class BioCheatManagerNonNative extends BioCheatManager within BioPlayerController
    transient
    config(Game);

struct SetupModifierData 
{
    var array<int> PlotIDSet;
    var array<int> PlotIDClear;
    var array<SetMissionPlotIntPair> PlotInts;
    var array<SetMissionCondSetPair> PlotCond;
    var Name Modifier;
};
struct SetupMissionData 
{
    var array<int> PlotIDSet;
    var array<int> PlotIDClear;
    var array<SetMissionPlotIntPair> PlotInts;
    var array<SetMissionCondSetPair> PlotCond;
    var Name Mission;
    var Name LoadMapName;
};
struct SetMissionCondSetPair 
{
    var int C;
    var int CA;
    var int T;
    var int TA;
};
struct SetMissionPlotIntPair 
{
    var int Id;
    var int V;
};
const AT_ENTRYMENU = "EntryMenu";
const SETMISSION_MODIFIER_USED = 18122;
const SETMISSION_GALAXY_STATE_DEFAULT = 3;
const SETMISSION_GALAXY_Y_DEFAULT = 16978.0;
const SETMISSION_GALAXY_X_DEFAULT = -5224.0;
const SETMISSION_INDEX_GALAXY_Y = 10042;
const SETMISSION_INDEX_GALAXY_X = 10041;
const SETMISSION_INDEX_GALAXY_STATE = 10164;
const SETMISSION_INDEX_PREVIOUS_ACTIVE = 10163;
const SETMISSION_INDEX_CURRENT_VIEWING = 10162;
const SETMISSION_INDEX_ACTIVE_WORLD = 10161;
const SETMISSION_INDEX_MISSION_COUNT = 10165;

var string sTreasureLevelOverride;
var config array<SetupMissionData> SetupMissionArray;
var config array<SetupModifierData> SetupModifierArray;
var const array<Name> ReplicationTestNames;
var const array<string> ReplicationTestNameStrings;
var biodynamicload string AutoBotAIControllerName;
var transient SFXScoreManager LastScoreManager;
var transient Actor MPBotsUsedLast;
var transient BioPawn MPBotsUsedLastPawn;
var transient bool bDebugScore;
var transient bool MPBotsIgnoreHostInternal;
var bool bDebugHeadLOD;

public exec function AutoLevelUp(Name Command)
{
    local SFXPawn_Player P;
    
    if (Command == 'Reset')
    {
        P = SFXPawn_Player(Outer.Pawn);
        ResetTalents(string(P.Name));
        P.TotalXP = 0.0;
        P.CharacterLevel = 1;
        P.TalentPoints = 2;
        return;
    }
    SetMission(Command, TRUE);
    Class'SFXSeqAct_AutoLevelPlayer'.static.AutoLevelUpPlot();
}
public exec function CreateCareer(string firstName)
{
    local SFXEngine Engine;
    local int Year;
    local int Month;
    local int DayOfWeek;
    local int Day;
    local int Hour;
    local int Min;
    local int Sec;
    local int MSec;
    
    GetSystemTime(Year, Month, DayOfWeek, Day, Hour, Min, Sec, MSec);
    Engine = SFXEngine(Outer.Player.Outer);
    Engine.CreateCareerInternal(firstName, "Invalid", 1, 1, Year, Month, Day, ((Hour * 60 + Min) * 60 + Sec) * 1000 + MSec);
}
public static exec function DebugText(string S, optional int Duration = 10, optional int Index = -1)
{
    local int idx;
    local int N;
    local BioPlayerController PC;
    
    PC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    if (Index == -1)
    {
        Index = 0;
        for (idx = 0; idx < BioHUD(PC.myHUD).DesignerHudText.Length; idx++)
        {
            if (InStr(string(BioHUD(PC.myHUD).DesignerHudText[idx].Id), "BioCheatManagerNonNativeDebugText", , , ) != -1)
            {
                N = int(Right(string(BioHUD(PC.myHUD).DesignerHudText[idx].Id), Len(string(BioHUD(PC.myHUD).DesignerHudText[idx].Id)) - 33));
                if (Index < N + 1)
                {
                    Index = N + 1;
                }
            }
        }
    }
    if (Index > 25)
    {
        for (idx = 0; idx < BioHUD(PC.myHUD).DesignerHudText.Length; idx++)
        {
            if (InStr(string(BioHUD(PC.myHUD).DesignerHudText[idx].Id), "BioCheatManagerNonNativeDebugText", , , ) != -1)
            {
                N = int(Right(string(BioHUD(PC.myHUD).DesignerHudText[idx].Id), Len(string(BioHUD(PC.myHUD).DesignerHudText[idx].Id)) - 33));
                N = N + 25 - Index;
                if (N < 0)
                {
                    BioHUD(PC.myHUD).DesignerHudText[idx].Duration = 0.00999999978;
                    continue;
                }
                BioHUD(PC.myHUD).DesignerHudText[idx].Id = Name("BioCheatManagerNonNativeDebugText" $ N);
                BioHUD(PC.myHUD).DesignerHudText[idx].Y = 10.0 + 3.25 * float(N);
            }
        }
        Index = 25;
    }
    BioHUD(PC.myHUD).AddDesignerText(Name("BioCheatManagerNonNativeDebugText" $ Index), S, 5.0, 10.0 + 3.25 * float(Index), float(Duration), 1.0, FALSE);
}
public exec function FastResumeGame()
{
    local BioPlayerController PC;
    local SFXEngine oEngine;
    
    oEngine = SFXEngine(Class'SFXEngine'.static.GetEngine());
    PC = BioWorldInfo(oEngine.GetCurrentWorldInfo()).GetLocalPlayerController();
    if (oEngine != None)
    {
        if (PC != None)
        {
            Class'SFXGUIInteraction'.static.GetInstance().HideGameOverGui(PC);
        }
        oEngine.FastResumeGame(None);
    }
}
public final exec function ForceLOD(string Target, int LOD)
{
    local Actor ActorTarget;
    local SkeletalMeshComponent Mesh;
    
    ActorTarget = GetActorFromString(Target);
    if (ActorTarget != None)
    {
        foreach ActorTarget.ComponentList(Class'SkeletalMeshComponent', Mesh)
        {
            if (LOD >= 0)
            {
                Mesh.ForcedLodModel = LOD + 1;
            }
            else
            {
                Mesh.ForcedLodModel = 0;
            }
        }
    }
    else
    {
        Outer.ClientMessage("ForceLOD: Failed to find target" @ Target);
    }
}
public final exec function SetLanguageForSpeech(string Language, optional bool UpdateProfile = TRUE)
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Outer.Player.Outer);
    Engine.SetLanguageForSpeech(Language, UpdateProfile);
}
public final exec function SetLanguageForText(string Language, optional bool UpdateProfile = TRUE)
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Outer.Player.Outer);
    Engine.SetLanguageForText(Language, UpdateProfile);
}
public final exec function SetLanguageForVO(string Language, optional bool UpdateProfile = TRUE)
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Outer.Player.Outer);
    Engine.SetLanguageForVO(Language, UpdateProfile);
}
public exec function SetPlayerVariable(string PlayerVariable, int Value)
{
    local SFXEngine Engine;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    Engine.SetPlayerVariable(Name(PlayerVariable), Value);
    Outer.ClientMessage("Player Variable <" $ PlayerVariable $ "> Set to " $ Value);
}
public exec function Weapon GiveWeapon(string WeaponClassStr)
{
    if (Outer.Role != ENetRole.ROLE_Authority)
    {
        Outer.DispatchCommand("GiveWeapon" @ WeaponClassStr);
    }
    return Super(CheatManager).GiveWeapon(WeaponClassStr);
}
public exec function AT(Name newArea, optional Name StartPoint)
{
    local string MapEntryMenu;
    local BioWorldInfo BWI;
    
    MapEntryMenu = Caps("EntryMenu");
    BWI = BioWorldInfo(Outer.WorldInfo);
    if (BWI != None)
    {
        if (Caps(string(newArea)) != MapEntryMenu && Caps(BWI.GetURLMap()) != MapEntryMenu)
        {
            BWI.MoveToArea(newArea, StartPoint);
        }
        else
        {
            Outer.ConsoleCommand("defer open" @ newArea);
        }
    }
}
public final exec function AuthenticateGAWServer()
{
    local SFXOnlineSubsystem OSS;
    local SFXOnlineComponentGalaxyAtWar OnlineGAW;
    local SFXEngine Engine;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    OSS = SFXOnlineSubsystem(Engine.OnlineSubsystem);
    if (OSS == None)
    {
        return;
    }
    OnlineGAW = OSS.GetComponentGalaxyAtWar();
    if (OnlineGAW == None)
    {
        return;
    }
    OnlineGAW.GetRatings(TRUE, FALSE, GAWAuthenticateCompleted);
}
public exec function BlazeDisconnect()
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        if (oOnlineSubsystem.GetComponentLogin() != None)
        {
            oOnlineSubsystem.GetComponentLogin().Disconnect();
        }
    }
}
public exec function BotsSuperGun()
{
    local BioPawn PlayerPawn;
    local BioPawn AIPawn;
    local PlayerController PC;
    local SFXWeapon oWeapon;
    local BioRemoteLogger GLogger;
    
    if (Outer.Role != ENetRole.ROLE_Authority)
    {
        return;
    }
    foreach Outer.WorldInfo.AllControllers(Class'PlayerController', PC)
    {
        PlayerPawn = BioPawn(PC.Pawn);
        AIPawn = BioPawn(PC.GetViewTarget());
        if (AIPawn != PlayerPawn)
        {
            oWeapon = SFXWeapon(AIPawn.Weapon);
            oWeapon.bSuperDamage = TRUE;
            oWeapon.MagSize.Value = 9999.0;
        }
    }
    GLogger = Class'BioRemoteLogger'.static.GetLogger();
    if (GLogger != None)
    {
        GLogger.SendInvalidPlaythrough("SuperGun");
    }
}
public function CallRemoteTestNameReplication(Name InName, string InConfirmString);

public exec function DebugAllLevels()
{
    bDebugAllLevels = TRUE;
}
public exec function DebugBlockingSeekFree(bool DoDebug)
{
    Class'SFXEngine'.static.GetSFXEngine().DebugTraceBlockingSeekFreeLoad = DoDebug;
}
public final exec function DebugDistance()
{
    local BioHUD HUD;
    
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None)
    {
        HUD.ToggleDebugDraw(DebugDraw_Distance);
        Outer.ClientMessage("DebugDistance" @ HUD.IsDrawing(DebugDraw_Distance));
    }
}
private final function DebugDraw_Distance(BioHUD HUD)
{
    local Vector CamLoc;
    local Vector RenderLoc;
    local Rotator CamRot;
    local Actor ChkActor;
    local Pawn ChkPawn;
    local SkeletalMeshComponent Mesh;
    local float X;
    local float Y;
    local float YL;
    local Vector ScreenCoords;
    
    HUD.Canvas.SetDrawColor(255, 255, 255);
    Outer.GetPlayerViewPoint(CamLoc, CamRot);
    foreach Outer.DynamicActors(Class'Actor', ChkActor, )
    {
        Mesh = None;
        ChkPawn = Pawn(ChkActor);
        if (ChkPawn != None && (ChkPawn.location - CamLoc) Dot Vector(CamRot) > 0.0 && ChkPawn.WorldInfo.TimeSeconds - ChkPawn.LastRenderTime < 1.0)
        {
            if (BioPawn(ChkPawn) == None || BioPawn(ChkPawn).bActive)
            {
                RenderLoc = ChkPawn.location;
                Mesh = ChkPawn.Mesh;
            }
        }
        if (Mesh != None)
        {
            X = HUD.Canvas.CurX;
            Y = HUD.Canvas.CurY;
            YL = HUD.Canvas.CurYL;
            ScreenCoords = HUD.Canvas.Project(RenderLoc);
            HUD.Canvas.CurX = ScreenCoords.X;
            HUD.Canvas.CurY = ScreenCoords.Y;
            HUD.Canvas.DrawText("Actor:" @ ChkActor, TRUE);
            HUD.Canvas.DrawText("Distance:" @ PrettyFloat(VSize(ChkActor.location - Outer.Pawn.location) / 100.0, 2) @ "m");
            HUD.Canvas.CurX = X;
            HUD.Canvas.CurY = Y;
            HUD.Canvas.CurYL = YL;
        }
    }
}
private final function DebugDraw_LOD(BioHUD HUD)
{
    local Vector CamLoc;
    local Vector RenderLoc;
    local Rotator CamRot;
    local Actor ChkActor;
    local SkeletalMeshComponent Mesh;
    local SkeletalMeshComponent HeadMesh;
    local float X;
    local float Y;
    local float YL;
    local Vector ScreenCoords;
    local Vector2D Bounds;
    local Vector2D MinBounds;
    local Vector2D MaxBounds;
    local FontRenderInfo RenderInfo;
    
    HUD.Canvas.SetDrawColor(255, 255, 255);
    HUD.Canvas.TextSize("Actor: Pawn_1", Bounds.X, Bounds.Y);
    MinBounds.X = HUD.Canvas.OrgX - Bounds.X / float(3);
    MinBounds.Y = HUD.Canvas.OrgY;
    MaxBounds.X = HUD.Canvas.ClipX - Bounds.X;
    MaxBounds.Y = HUD.Canvas.ClipY - Bounds.Y * float(2);
    RenderInfo = HUD.Canvas.CreateFontRenderInfo(TRUE);
    Outer.GetPlayerViewPoint(CamLoc, CamRot);
    X = HUD.Canvas.CurX;
    Y = HUD.Canvas.CurY;
    YL = HUD.Canvas.CurYL;
    foreach Outer.DynamicActors(Class'Actor', ChkActor, )
    {
        if (ChkActor.bHidden == FALSE)
        {
            if ((ChkActor.location - CamLoc) Dot Vector(CamRot) > 0.0 && ChkActor.WorldInfo.TimeSeconds - ChkActor.LastRenderTime < 1.0)
            {
                Mesh = ChkActor.GetPrimarySkelMeshComponent();
                HeadMesh = ChkActor.GetHeadSkelMeshComponent();
                if (Mesh != None)
                {
                    RenderLoc = Mesh.Bounds.Origin;
                    RenderLoc.Z += Mesh.Bounds.BoxExtent.Z * 0.5;
                    ScreenCoords = HUD.Canvas.Project(RenderLoc);
                    ScreenCoords.X = FClamp(ScreenCoords.X, MinBounds.X, MaxBounds.X);
                    ScreenCoords.Y = FClamp(ScreenCoords.Y, MinBounds.Y, MaxBounds.Y);
                    HUD.Canvas.CurX = ScreenCoords.X;
                    HUD.Canvas.CurY = ScreenCoords.Y;
                    HUD.Canvas.DrawText("Actor:" @ ChkActor, TRUE, , , RenderInfo);
                    HUD.Canvas.DrawText("CurLOD:" @ Mesh.PredictedLODLevel, TRUE, , , RenderInfo);
                    if (Mesh.ForcedLodModel > 0)
                    {
                        HUD.Canvas.DrawText("FoLod:" @ Mesh.ForcedLodModel - 1, TRUE, , , RenderInfo);
                    }
                    else if (Mesh.MinAutoLODLevel > 0)
                    {
                        HUD.Canvas.DrawText("MinLOD:" @ Mesh.MinAutoLODLevel, TRUE, , , RenderInfo);
                    }
                    else
                    {
                        HUD.Canvas.DrawText("DF:" @ Mesh.MaxDistanceFactor, TRUE, , , RenderInfo);
                    }
                    if (bDebugHeadLOD && HeadMesh != None)
                    {
                        HUD.Canvas.DrawText("H: FoLod:" @ HeadMesh.ForcedLodModel, TRUE, , , RenderInfo);
                        HUD.Canvas.DrawText("H: MinLOD:" @ HeadMesh.MinAutoLODLevel, TRUE, , , RenderInfo);
                        HUD.Canvas.DrawText("H: CurLOD:" @ HeadMesh.PredictedLODLevel, TRUE, , , RenderInfo);
                    }
                }
            }
        }
    }
    HUD.Canvas.CurX = X;
    HUD.Canvas.CurY = Y;
    HUD.Canvas.CurYL = YL;
}
public final function DebugDraw_Projectile(BioHUD HUD)
{
    local SFXProjectile oProjectile;
    local Color DrawColor;
    
    foreach Outer.AllActors(Class'SFXProjectile', oProjectile, )
    {
        if (oProjectile != None)
        {
            if (oProjectile.Role == ENetRole.ROLE_Authority)
            {
                if (oProjectile.bActive)
                {
                    DrawColor.R = 255;
                    DrawColor.G = 255;
                    DrawColor.B = 255;
                }
                else
                {
                    DrawColor.R = 255;
                    DrawColor.G = 255;
                    DrawColor.B = 0;
                }
            }
            else if (oProjectile.Role == ENetRole.ROLE_SimulatedProxy)
            {
                if (oProjectile.bActive)
                {
                    DrawColor.R = 0;
                    DrawColor.G = 0;
                    DrawColor.B = 255;
                }
                else
                {
                    DrawColor.R = 160;
                    DrawColor.G = 32;
                    DrawColor.B = 240;
                }
            }
            else
            {
                DrawColor.R = 255;
                DrawColor.G = 0;
                DrawColor.B = 0;
            }
            oProjectile.DrawDebugBox(oProjectile.location, vect(34.0, 34.0, 34.0), DrawColor.R, DrawColor.G, DrawColor.B, FALSE);
        }
    }
}
public final exec function DebugLOD(optional bool bShowHeadLOD)
{
    local BioHUD HUD;
    
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None)
    {
        bDebugHeadLOD = bShowHeadLOD;
        if (HUD.IsDrawing(DebugDraw_LOD))
        {
            bDebugHeadLOD = FALSE;
        }
        HUD.ToggleDebugDraw(DebugDraw_LOD);
    }
}
public exec function DebugProjectile()
{
    local BioHUD HUD;
    
    HUD = BioHUD(Outer.myHUD);
    if (HUD != None)
    {
        HUD.ToggleDebugDraw(DebugDraw_Projectile);
        if (HUD.IsDrawing(DebugDraw_Projectile))
        {
            Outer.ClientMessage("DebugProjectile ON");
        }
        else
        {
            Outer.ClientMessage("DebugProjectile OFF");
        }
    }
}
public exec simulated function DebugScore()
{
    if (!bDebugScore)
    {
        bDebugScore = TRUE;
        Outer.SetTimer(0.100000001, TRUE, 'DisplayDebugScore', );
    }
    else
    {
        bDebugScore = FALSE;
        Outer.ClearTimer('DisplayDebugScore');
    }
}
public exec function DebugTreasure(string LevelName)
{
    local SFXEngine oEngine;
    local LevelTreasureSaveRecord TR;
    
    bDebugAllLevels = Locs(LevelName) == "all";
    if (Locs(Left(LevelName, 5)) != "biop_")
    {
        LevelName = "BioP_" $ LevelName;
    }
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    sTreasureLevelOverride = "disabled";
    foreach oEngine.SavedTreasure(TR, )
    {
        if (Locs(string(TR.LevelName)) == Locs(LevelName))
        {
            sTreasureLevelOverride = LevelName;
        }
    }
    Profile('TREASURE', "self");
}
public final exec function DeleteModSaveData()
{
    local SFXEngine Engine;
    
    Engine = SFXEngine(Outer.Player.Outer);
    if (Engine == None)
    {
        return;
    }
    Engine.PlayerWeaponMods.Length = 0;
}
public final function EndGameChoices(optional array<EEndGameOption> Options)
{
    local int idx;
    local array<string> OptionsStrings;
    
    OptionsStrings.AddItem("EGO_ReapersDestroyedEarthDestroyed");
    OptionsStrings.AddItem("EGO_ReapersDestroyedEarthDevastated");
    OptionsStrings.AddItem("EGO_ReapersDestroyedEarthOk");
    OptionsStrings.AddItem("EGO_ReapersDestroyedEarthOkShepardAlive");
    OptionsStrings.AddItem("EGO_BecomeAReaperAndEarthDestroyedAndReapersLeave");
    OptionsStrings.AddItem("EGO_BecomeAReaperAndEarthOkAndReapersLeave");
    OptionsStrings.AddItem("EGO_HarmonyOfManAndMachine");
    if (Options.Length <= 0)
    {
        Outer.ClientMessage("Error: No Options Found");
    }
    for (idx = 0; idx < Options.Length; idx++)
    {
        Outer.ClientMessage("End Game Option: " $ OptionsStrings[int(Options[idx])]);
    }
}
public final function GAWAuthenticateCompleted(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode)
{
}
public exec function GetMultiplayerAssetStrength()
{
    local SFXOnlineSubsystem OSS;
    local SFXOnlineComponentGalaxyAtWar OnlineGAW;
    local SFXEngine Engine;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    OSS = SFXOnlineSubsystem(Engine.OnlineSubsystem);
    if (OSS == None)
    {
        return;
    }
    OnlineGAW = OSS.GetComponentGalaxyAtWar();
    if (OnlineGAW == None)
    {
        return;
    }
    OnlineGAW.GetRatings(TRUE, FALSE, OutputMultiplayerAssetStrength);
}
public exec function GetPlotState(string DataType, int Id)
{
    local BioGlobalVariableTable oGlobalVariableTable;
    
    oGlobalVariableTable = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    if (oGlobalVariableTable == None)
    {
        return;
    }
    switch (DataType)
    {
        case "bool":
            Outer.ClientMessage(string(oGlobalVariableTable.GetBool(Id)));
            break;
        case "float":
            Outer.ClientMessage(string(oGlobalVariableTable.GetFloat(Id)));
            break;
        case "int":
            Outer.ClientMessage(string(oGlobalVariableTable.GetInt(Id)));
            break;
        default:
            Outer.ClientMessage("Unrecognized datatype. Please use \"bool\", \"float\", or \"int\".");
            break;
    }
}
public exec function GiveBonusPower(string BonusPowerClassName)
{
    local BioWorldInfo WI;
    local BioPlayerController PC;
    local SFXProfileSettings Profile;
    local int idx;
    local array<BonusPowerUnlockData> BonusPowers;
    local bool bFound;
    local string ConstructedBonusPowerClassName;
    local string PowerCompareName;
    
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (WI == None)
    {
        return;
    }
    PC = BioPlayerController(WI.GetALocalPlayerController());
    if (PC == None)
    {
        return;
    }
    Profile = PC.ProfileSettings;
    if (Profile == None)
    {
        return;
    }
    Profile.GetBonusPowerArray(BonusPowers);
    if (BonusPowers.Length <= 0)
    {
        return;
    }
    BonusPowerClassName = Locs(BonusPowerClassName);
    for (idx = 0; idx < BonusPowers.Length; idx++)
    {
        PowerCompareName = Locs(BonusPowers[idx].PowerClassName);
        if (PowerCompareName != BonusPowerClassName)
        {
            ConstructedBonusPowerClassName = "sfxpowercustomaction" $ BonusPowerClassName;
            if (PowerCompareName != ConstructedBonusPowerClassName)
            {
                ConstructedBonusPowerClassName = "sfxgamecontent.sfxpowercustomaction_" $ BonusPowerClassName;
                if (PowerCompareName == ConstructedBonusPowerClassName)
                {
                    bFound = TRUE;
                    break;
                    continue;
                }
                continue;
            }
        }
    }
    if (!bFound)
    {
        return;
    }
    Outer.ClientMessage("Power Unlocked: " $ BonusPowerClassName);
    if (Profile.IsBonusPowerUnlocked(BonusPowers[idx].BonusPowerID) == FALSE)
    {
        Profile.UnlockBonusPower(BonusPowers[idx].BonusPowerID);
    }
}
public exec function GrantMPCredits(int nCredits)
{
    local SFXSaveManagerMP MPSaveManager;
    
    MPSaveManager = SFXEngine(Class'Engine'.static.GetEngine()).MPSaveManager;
    MPSaveManager.AddCredits(nCredits, "cheat");
    MPSaveManager.SaveRecords();
}
public exec function GrantMPExperience(string className, float fXP)
{
    local SFXSaveManagerMP MPSaveManager;
    
    MPSaveManager = SFXEngine(Class'Engine'.static.GetEngine()).MPSaveManager;
    MPSaveManager.LevelUpClass(Name(className), fXP);
    MPSaveManager.SaveRecords();
}
public exec function IncreaseGalaxyAtWarRating(int defaultRatingIncrease, optional int ZoneID, optional int zoneRating, optional int zoneAsset);

public exec function ListPlayerVariables(optional string sSearchString)
{
    local array<Name> PlayerVariables;
    local Name PlayerVariable;
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    Engine.QueryPlayerVariables(PlayerVariables, sSearchString);
    foreach PlayerVariables(PlayerVariable, )
    {
        DebugText(PlayerVariable $ " = " $ Engine.GetPlayerVariable(PlayerVariable), 15);
    }
}
public exec function MPBots(bool bEnable, optional bool bIgnoreHost = FALSE)
{
    MPBotsIgnoreHostInternal = bIgnoreHost;
    MPBotsInternal(bEnable);
}
public final function MPBotsClearUsedLast()
{
    Outer.ClearTimer('MPBotsClearUsed');
    MPBotsUsedLast = None;
    if (MPBotsUsedLastPawn != None)
    {
        MPBotsUsedLastPawn.SetTickIsDisabled(TRUE);
        MPBotsUsedLastPawn.SetActive(FALSE);
        MPBotsUsedLastPawn = None;
    }
}
public final function MPBotsDisableTick(BioPawn P)
{
    local BioPawn AIPawn;
    local PlayerController PC;
    
    if (Outer.Role != ENetRole.ROLE_Authority || P == None)
    {
        return;
    }
    foreach Outer.WorldInfo.AllControllers(Class'PlayerController', PC)
    {
        AIPawn = BioPawn(PC.GetViewTarget());
        if (AIPawn == P && PC.Pawn != None)
        {
            PC.Pawn.SetTickIsDisabled(TRUE);
            PC.Pawn.SetActive(FALSE);
        }
    }
}
public final function BioPawn MPBotsGetUsedLastPawn()
{
    return MPBotsUsedLastPawn;
}
public function MPBotsInternal(bool bEnable)
{
    local SFXPawn PlayerPawn;
    local SFXPawn AIPawn;
    local Class<AIController> AIControllerClass;
    local SFXAI_Core AI;
    local PlayerController PC;
    local BioBaseSquad PlayerSquad;
    local SFXGRI GRI;
    local BioWorldInfo BWI;
    local int BotLevel;
    
    if (Outer.Role != ENetRole.ROLE_Authority)
    {
        return;
    }
    BWI = BioWorldInfo(Outer.WorldInfo);
    if (BWI == None)
    {
        return;
    }
    if (bEnable)
    {
        foreach Outer.WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            PlayerPawn = SFXPawn(PC.Pawn);
            if (PlayerPawn == None)
            {
                continue;
            }
            if (PC.GetViewTarget() == PlayerPawn && (!PC.IsLocalPlayerController() || !MPBotsIgnoreHostInternal))
            {
                AIPawn = SFXPawn(Class'Engine'.static.GetCurrentWorldInfo().Game.SpawnDefaultPawnFor(PC, None, TRUE));
                if (AIPawn == None)
                {
                    return;
                }
                PlayerPawn.SetHidden(TRUE);
                PlayerPawn.bBlockActors = FALSE;
                PlayerPawn.SetTickIsDisabled(TRUE);
                PlayerPawn.SetActive(FALSE);
                AIControllerClass = Class<AIController>(Class'SFXEngine'.static.GetSeekFreeObject(AutoBotAIControllerName, Class'Class'));
                if (AIControllerClass == None)
                {
                    return;
                }
                AI = SFXAI_Core(Outer.Spawn(AIControllerClass, , , PC.location, PC.Rotation));
                if (AI == None)
                {
                    return;
                }
                AI.Possess(AIPawn, FALSE);
                AIPawn.SetLocation(PlayerPawn.location, );
                AIPawn.SetRotation(PC.Rotation);
                AI.SetTeam(0);
                AIPawn.m_bMin1Health = BWI.m_bAutoBotUseMin1Health;
                PlayerPawn.m_bMin1Health = BWI.m_bAutoBotUseMin1Health;
                PC.bGodMode = TRUE;
                PC.SetViewTarget(AIPawn);
                PlayerSquad = PlayerPawn.Squad;
                PlayerSquad.AddMember(AIPawn, FALSE);
                AIPawn.m_fPowerUsePercent = BWI.m_fAutoBotAttackPowerPercent;
                SFXPawn_Player(AIPawn).AutoLevelUpInfo = SFXPawn_Player(AIPawn).PlayerClass.default.AutoLevelUpInfo;
                SFXPawn_Player(PlayerPawn).AutoLevelUpInfo = SFXPawn_Player(PlayerPawn).PlayerClass.default.AutoLevelUpInfo;
                if (BWI.m_nAutoBotLevel >= 1 && BWI.m_nAutoBotLevel <= 20)
                {
                    BotLevel = BWI.m_nAutoBotLevel;
                }
                else
                {
                    BotLevel = Rand(20) + 1;
                }
                MPBotsLevelUp(PlayerPawn, BotLevel);
                MPBotsLevelUp(AIPawn, BotLevel);
                GRI = SFXGRI(Outer.WorldInfo.GRI);
                if (GRI != None && GRI.DifficultyHandler != None)
                {
                    GRI.DifficultyHandler.CurrentDifficulty = byte(BWI.m_nAutoBotEnemyDifficulty);
                }
                BWI.SetAutoBotsEnabled(TRUE);
            }
        }
    }
    else
    {
        foreach Outer.WorldInfo.AllControllers(Class'PlayerController', PC)
        {
            PlayerPawn = SFXPawn(PC.Pawn);
            if (PlayerPawn == None)
            {
                continue;
            }
            AIPawn = SFXPawn(PC.GetViewTarget());
            if (AIPawn != PlayerPawn)
            {
                PlayerSquad = AIPawn.Squad;
                PlayerSquad.RemoveMember(AIPawn);
                PC.SetLocation(AIPawn.location, );
                PC.SetRotation(AIPawn.Rotation);
                PlayerPawn.SetLocation(AIPawn.location, );
                PlayerPawn.SetRotation(AIPawn.Rotation);
                AIPawn.Controller.Destroy();
                AIPawn.Destroy();
                PlayerPawn.m_bMin1Health = FALSE;
                PC.bGodMode = FALSE;
                PC.SetViewTarget(PlayerPawn);
                PlayerPawn.SetHidden(FALSE);
                PlayerPawn.bBlockActors = TRUE;
                PlayerPawn.SetTickIsDisabled(FALSE);
                PlayerPawn.SetActive(TRUE);
                BWI.SetAutoBotsEnabled(FALSE);
            }
        }
    }
}
public final function MPBotsLevelUp(SFXPawn inPawn, int Level)
{
    local int XPNeededForCurrentLevel;
    local SFXPawn_Player PlayerPawn;
    local int NewPlayerLevel;
    local int PlayerLevel;
    local int XPForNextLevel;
    local float CurrentXP;
    local SFXGRI GRI;
    
    PlayerPawn = SFXPawn_Player(inPawn);
    if (PlayerPawn == None)
    {
        return;
    }
    if (!Class'BioLevelUpSystem'.static.GetXPNeededForLevel(Level, XPNeededForCurrentLevel))
    {
        return;
    }
    if (PlayerPawn != None)
    {
        PlayerPawn.TotalXP = float(XPNeededForCurrentLevel);
        CurrentXP = PlayerPawn.TotalXP;
        PlayerLevel = PlayerPawn.CharacterLevel;
        GRI = SFXGRI(PlayerPawn.WorldInfo.GRI);
        NewPlayerLevel = PlayerLevel;
        if (PlayerLevel >= 1 && Class'BioLevelUpSystem'.static.GetXPNeededForLevel(PlayerLevel + 1, XPForNextLevel))
        {
            while (CurrentXP >= float(XPForNextLevel))
            {
                ++NewPlayerLevel;
                if (Class'BioLevelUpSystem'.static.GetXPNeededForLevel(NewPlayerLevel + 1, XPForNextLevel) == FALSE)
                {
                    break;
                }
            }
            if (Class'BioLevelUpSystem'.static.LevelUpBioPawn(PlayerPawn, NewPlayerLevel))
            {
                PlayerPawn.CharacterLevel = NewPlayerLevel;
            }
            if (GRI != None && GRI.DifficultyHandler != None)
            {
                GRI.DifficultyHandler.bNeedsUpdate = TRUE;
                GRI.DifficultyHandler.Update();
            }
        }
        Class'BioLevelUpSystem'.static.AutoLevelUpPowers(PlayerPawn);
    }
}
public final function MPBotsUse(BioPawn P, Actor Objective)
{
    local BioPawn AIPawn;
    local PlayerController PC;
    local bool Result;
    
    if (Outer.Role != ENetRole.ROLE_Authority || P == None || Objective == None)
    {
        return;
    }
    if (Objective == MPBotsUsedLast)
    {
        return;
    }
    foreach Outer.WorldInfo.AllControllers(Class'PlayerController', PC)
    {
        AIPawn = BioPawn(PC.GetViewTarget());
        if (AIPawn == P)
        {
            PC.SetLocation(P.location, );
            PC.SetRotation(P.Rotation);
            if (PC.Pawn != None)
            {
                Result = FALSE;
                PC.Pawn.SetLocation(P.location, );
                PC.Pawn.SetRotation(P.Rotation);
                PC.Pawn.SetTickIsDisabled(FALSE);
                PC.Pawn.SetActive(TRUE);
                if (BioPlayerController(PC) != None)
                {
                    Result = BioPlayerController(PC).TryUse(Objective);
                }
                if (Result)
                {
                    MPBotsUsedLast = Objective;
                    MPBotsUsedLastPawn = BioPawn(PC.Pawn);
                    Outer.SetTimer(20.0, FALSE, 'MPBotsClearUsed', );
                }
                else
                {
                    PC.Pawn.SetTickIsDisabled(TRUE);
                    PC.Pawn.SetActive(FALSE);
                }
                break;
            }
        }
    }
}
public function OutputMultiplayerAssetStrength(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode)
{
    local SFXGAWAssetsHandler GAWHandler;
    local int MultiplayerAssetStrength;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.GetExternalAssetInfo(0, updatedWarAssets[0], MultiplayerAssetStrength);
    Outer.ClientMessage("Multiplayer Asset Strength = " $ MultiplayerAssetStrength);
}
public function ProfileTreasure()
{
    local SFXEngine oEngine;
    local string LevelName;
    local LevelTreasureSaveRecord TR;
    local LevelTreasureSaveRecord TREASURE;
    local string TreasureString;
    local string S;
    local Name N;
    local TD T;
    local TD TreasureData;
    local bool bFound;
    local Canvas Canvas;
    local SFXGAWAssetsHandler GAWHandler;
    
    oEngine = SFXEngine(Class'Engine'.static.GetEngine());
    if (oEngine == None)
    {
        return;
    }
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    Canvas = Outer.myHUD.Canvas;
    DrawProfileHeaderText(" ");
    DrawProfileText(" ");
    DrawProfileHeaderText(" ");
    DrawProfileText(" ");
    DrawProfileHeaderText(" ");
    DrawProfileText(" ");
    DrawProfileHeaderText(" ");
    DrawProfileText(" ");
    DrawProfileHeaderText(" ");
    DrawProfileText(" ");
    DrawProfileHeaderText(" ");
    DrawProfileText(" ");
    LevelName = oEngine.GetCurrentWorldInfo().GetMapName();
    if (!bDebugAllLevels)
    {
        TREASURE.nCredits = 0;
        TREASURE.nXP = 0;
        foreach oEngine.SavedTreasure(TR, )
        {
            if (Locs(string(TR.LevelName)) == Locs(sTreasureLevelOverride))
            {
                LevelName = sTreasureLevelOverride;
            }
            if (Locs(string(TR.LevelName)) == Locs(LevelName))
            {
                TREASURE = TR;
            }
        }
        TreasureData.Credits = 0;
        TreasureData.XP = 0;
        SFXGame(Outer.WorldInfo.Game).TREASURE.GetLevelData(TreasureData, LevelName);
        DrawProfileHeaderText("Debugging Treasure: ");
        DrawProfileText(LevelName $ " ");
        DrawProfileHeaderText("    Credits: ");
        if (TreasureData.Credits > 0)
        {
            DrawProfileText(TREASURE.nCredits $ " / " $ TreasureData.Credits $ " (" $ PrettyFloat(100.0 * float(TREASURE.nCredits) / float(TreasureData.Credits), 1) $ "%)");
        }
        else
        {
            DrawProfileText(TREASURE.nCredits $ " / " $ TreasureData.Credits);
        }
        DrawProfileHeaderText("    XP: ");
        if (TreasureData.XP > 0)
        {
            DrawProfileText(TREASURE.nXP $ " / " $ TreasureData.XP $ " (" $ PrettyFloat(100.0 * float(TREASURE.nXP) / float(TreasureData.XP), 1) $ "%)");
        }
        else
        {
            DrawProfileText(TREASURE.nCredits $ " / " $ TreasureData.Credits);
        }
        foreach TreasureData.TREASURE(S, )
        {
            bFound = FALSE;
            foreach TREASURE.Items(N, )
            {
                bFound = bFound || S == string(N);
            }
            if (GAWHandler.IsGAWAssetUnlockedByName(S) == TRUE)
            {
                bFound = TRUE;
            }
            DrawProfileHeaderText("    " $ S $ ": ");
            if (bFound)
            {
                Canvas.DrawColor = Class'HUD'.default.GreenColor;
                Canvas.DrawText("Found!");
                Canvas.CurX = GetProfileColumnCoord();
            }
            else
            {
                DrawProfileText("- not found -");
            }
        }
        foreach TreasureData.UndetectableGAWAssets(S, )
        {
            bFound = FALSE;
            if (GAWHandler.IsGAWAssetUnlockedByName(S) == TRUE)
            {
                bFound = TRUE;
            }
            DrawProfileHeaderText("    " $ S $ ": ");
            if (bFound)
            {
                Canvas.DrawColor = Class'HUD'.default.GreenColor;
                Canvas.DrawText("Found!");
                Canvas.CurX = GetProfileColumnCoord();
            }
            else
            {
                DrawProfileText("- not found -");
            }
        }
        foreach TreasureData.ConditionalGAWAssets(S, )
        {
            bFound = FALSE;
            if (GAWHandler.IsGAWAssetUnlockedByName(S) == TRUE)
            {
                bFound = TRUE;
            }
            DrawProfileHeaderText("    " $ S $ ": ");
            if (bFound)
            {
                Canvas.DrawColor = Class'HUD'.default.GreenColor;
                Canvas.DrawText("Found!");
                Canvas.CurX = GetProfileColumnCoord();
            }
            else
            {
                DrawProfileText("- not found -");
            }
        }
    }
    else
    {
        DrawProfileHeaderText("Debugging All Treasure: ");
        DrawProfileText(" ");
        foreach oEngine.SavedTreasure(TREASURE, )
        {
            if (!bDebugAllLevels)
            {
                if (string(TREASURE.LevelName) != LevelName)
                {
                    continue;
                }
            }
            TreasureData.Credits = 0;
            TreasureData.XP = 0;
            foreach SFXGame(Outer.WorldInfo.Game).TREASURE.LevelTreasure(T, )
            {
                if (T.Level == string(TREASURE.LevelName))
                {
                    TreasureData = T;
                }
            }
            TreasureString = "Credits=" $ TREASURE.nCredits $ "/" $ TreasureData.Credits $ ", ";
            TreasureString = TreasureString $ "XP=" $ TREASURE.nXP $ "/" $ TreasureData.XP $ ", ";
            foreach TreasureData.TREASURE(S, )
            {
                bFound = FALSE;
                foreach TREASURE.Items(N, )
                {
                    bFound = bFound || S == string(N);
                }
                if (bFound)
                {
                    TreasureString = TreasureString $ S $ "=1, ";
                }
                else
                {
                    TreasureString = TreasureString $ S $ "=0, ";
                }
            }
            TreasureString = Repl(TreasureString, "SFXWeaponMod_", "Mod", );
            DrawProfileHeaderText(" Level=" $ TREASURE.LevelName $ ": ");
            DrawProfileText(TreasureString);
        }
    }
}
public exec function ResetMPCharacter(string KitName)
{
    local SFXSaveManagerMP MPSaveManager;
    
    MPSaveManager = SFXEngine(Class'Engine'.static.GetEngine()).MPSaveManager;
    MPSaveManager.ResetCharacter(Name(KitName));
}
public exec function ResetMPClass(string className)
{
    local SFXSaveManagerMP MPSaveManager;
    
    MPSaveManager = SFXEngine(Class'Engine'.static.GetEngine()).MPSaveManager;
    MPSaveManager.ResetClass(Name(className));
    MPSaveManager.SaveRecords();
}
public exec function ResetMPData()
{
    Class'SFXEngine'.static.GetSFXEngine().MPSaveManager.ResetMPData();
    Class'SFXEngine'.static.GetSFXEngine().MPSaveManager.SaveRecords();
}
public exec function ResetMPTutorialMessage()
{
    local SFXSaveManagerMP MPSaveManager;
    
    MPSaveManager = Class'SFXEngine'.static.GetSFXEngine().MPSaveManager;
    if (MPSaveManager != None)
    {
        MPSaveManager.SetPlayerVariable('LastPromoIDShown', 0);
        Outer.ClientMessage("MP Tutorial message reset");
    }
    else
    {
        Outer.ClientMessage("MP Save Manager doesn't exist");
    }
}
public final exec function SetEndGameOptions(optional bool bBrain)
{
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.SetEndGameOptions(bBrain);
}
public exec function SetMission(Name Command, optional bool NoTP = FALSE)
{
    local SetupMissionData Mission;
    local SetupModifierData Modifier;
    local bool IsMission;
    local bool IsModifier;
    local BioGlobalVariableTable gv;
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    if (Engine != None)
    {
        Engine.bUsedSetMission = TRUE;
    }
    gv = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetGlobalVariables();
    if (gv == None)
    {
        return;
    }
    IsMission = FALSE;
    IsModifier = FALSE;
    foreach SetupMissionArray(Mission, )
    {
        if (Command == Mission.Mission)
        {
            IsMission = TRUE;
            break;
        }
    }
    if (!IsMission)
    {
        foreach SetupModifierArray(Modifier, )
        {
            if (Command == Modifier.Modifier)
            {
                IsModifier = TRUE;
                break;
            }
        }
    }
    if (IsMission)
    {
        SetupMission(gv, Command, NoTP);
    }
    else if (IsModifier)
    {
        SetupModifier(gv, Command);
    }
}
public event exec function SetMMBotOptions(bool withDisconnections, bool fastForward)
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        if (oOnlineSubsystem.GetComponentMatchMakingBot() != None)
        {
            oOnlineSubsystem.GetComponentMatchMakingBot().SetOptions(withDisconnections, fastForward);
        }
    }
}
public exec function SetModLevel(string ModClassName, int nLevel)
{
    local Class<SFXWeaponMod> ModClass;
    local SFXEngine Engine;
    
    Engine = SFXEngine(Class'Engine'.static.GetEngine());
    ModClass = Class'SFXWeaponMod'.static.LoadModClass(ModClassName);
    if (ModClass == None)
    {
        ModClass = Class'SFXWeaponMod'.static.LoadModClass("SFXWeaponMod_" $ ModClassName);
        if (ModClass == None)
        {
            ModClass = Class'SFXWeaponMod'.static.LoadModClass("SFXGameContent.SFXWeaponMod_" $ ModClassName);
            if (ModClass == None)
            {
                return;
            }
        }
    }
    Outer.ClientMessage("Level " $ nLevel $ ": " $ ModClass.Name);
    Engine.SetPlayerVariable(Name(PathName(ModClass)), nLevel);
}
public exec function SetPlotState(string DataType, int Id, string Value)
{
    local BioGlobalVariableTable oGlobalVariableTable;
    
    oGlobalVariableTable = BioWorldInfo(Outer.WorldInfo).GetGlobalVariables();
    if (oGlobalVariableTable == None)
    {
        return;
    }
    switch (DataType)
    {
        case "bool":
            oGlobalVariableTable.SetBool(Id, bool(Value));
            break;
        case "float":
            oGlobalVariableTable.SetFloat(Id, float(Value));
            break;
        case "int":
            oGlobalVariableTable.SetInt(Id, int(Value));
            break;
        default:
            Outer.ClientMessage("Unrecognized datatype. Please use \"bool\", \"float\", or \"int\".");
            break;
    }
}
private final function SetupMission(BioGlobalVariableTable gv, Name Command, optional bool NoTP = FALSE)
{
    local BioWorldInfo BWI;
    local SetupMissionData Mission;
    local int MissionCount;
    local int PlotId;
    local SetMissionPlotIntPair PlotInts;
    local SetMissionCondSetPair PlotCond;
    local int ActiveWorld;
    
    BWI = BioWorldInfo(Outer.WorldInfo);
    if (BWI != None)
    {
        MissionCount = -1;
        SetupPlayer();
        if (!gv.GetBool(18122))
        {
            SetupModifier(gv, 'ME2Success');
        }
        foreach SetupMissionArray(Mission, )
        {
            foreach Mission.PlotIDSet(PlotId, )
            {
                gv.SetBool(PlotId, TRUE);
            }
            foreach Mission.PlotIDClear(PlotId, )
            {
                gv.SetBool(PlotId, FALSE);
            }
            foreach Mission.PlotInts(PlotInts, )
            {
                gv.SetInt(PlotInts.Id, PlotInts.V);
            }
            foreach Mission.PlotCond(PlotCond, )
            {
                if (BWI.CheckConditional(PlotCond.C, PlotCond.CA))
                {
                    BWI.ExecuteStateTransition(PlotCond.T, PlotCond.TA);
                }
            }
            if (InStr(string(Mission.Mission), string('_'), , , ) == -1)
            {
                MissionCount++;
            }
            if (Command == Mission.Mission)
            {
                break;
            }
        }
        gv.SetInt(10165, MissionCount);
        if (Mission.LoadMapName != 'None')
        {
            gv.SetInt(10164, 3);
            gv.SetFloat(10041, -5224.0);
            gv.SetFloat(10042, 16978.0);
            ActiveWorld = gv.GetInt(10161);
            gv.SetInt(10162, ActiveWorld);
            gv.SetInt(10163, ActiveWorld);
            if (!NoTP)
            {
                BWI.MoveToArea(Mission.LoadMapName, 'None', "?SetMission");
            }
        }
    }
}
private final function SetupModifier(BioGlobalVariableTable gv, Name Command)
{
    local SetupModifierData Modifier;
    local int PlotId;
    local SetMissionPlotIntPair PlotInts;
    local SetMissionCondSetPair PlotCond;
    
    gv.SetBool(18122, TRUE);
    foreach SetupModifierArray(Modifier, )
    {
        if (Command == Modifier.Modifier)
        {
            break;
        }
    }
    foreach Modifier.PlotIDSet(PlotId, )
    {
        gv.SetBool(PlotId, TRUE);
    }
    foreach Modifier.PlotIDClear(PlotId, )
    {
        gv.SetBool(PlotId, FALSE);
    }
    foreach Modifier.PlotInts(PlotInts, )
    {
        gv.SetInt(PlotInts.Id, PlotInts.V);
    }
    foreach Modifier.PlotCond(PlotCond, )
    {
        if (BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).CheckConditional(PlotCond.C, PlotCond.CA))
        {
            BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).ExecuteStateTransition(PlotCond.T, PlotCond.TA);
        }
    }
}
private final function SetupPlayer()
{
    local SFXEngine E;
    
    E = SFXEngine(Class'Engine'.static.GetEngine());
    if (E != None && E.CurrentSaveGame != None && E.CurrentSaveGame.PlayerRecord.PlayerClass == None)
    {
        BioWorldInfo(E.GetCurrentWorldInfo()).ClearCurrentGame();
    }
}
public exec function SetWeaponLevels(int Level)
{
    local PlayerController PC;
    local SFXPawn_Player pPawn;
    local SFXEngine Engine;
    local LoadoutWeaponInfo WeaponInfo;
    
    if (Outer.WorldInfo == None)
    {
        return;
    }
    PC = Outer.WorldInfo.GetALocalPlayerController();
    if (PC == None)
    {
        return;
    }
    pPawn = SFXPawn_Player(PC.Pawn);
    if (pPawn == None)
    {
        return;
    }
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    foreach Class'SFXPlayerSquadLoadoutData'.default.AssaultRifles(WeaponInfo, )
    {
        Engine.SetPlayerVariable(WeaponInfo.className, Level);
    }
    foreach Class'SFXPlayerSquadLoadoutData'.default.SniperRifles(WeaponInfo, )
    {
        Engine.SetPlayerVariable(WeaponInfo.className, Level);
    }
    foreach Class'SFXPlayerSquadLoadoutData'.default.Shotguns(WeaponInfo, )
    {
        Engine.SetPlayerVariable(WeaponInfo.className, Level);
    }
    foreach Class'SFXPlayerSquadLoadoutData'.default.HeavyPistols(WeaponInfo, )
    {
        Engine.SetPlayerVariable(WeaponInfo.className, Level);
    }
    foreach Class'SFXPlayerSquadLoadoutData'.default.AutoPistols(WeaponInfo, )
    {
        Engine.SetPlayerVariable(WeaponInfo.className, Level);
    }
    Outer.ClientMessage("All Weapons changed to level " $ Level);
}
public exec function ShowNavSightLines(Name NavName)
{
    local NavigationPoint Nav;
    local int NavLOS;
    local int Mask;
    local int Dist;
    local int i;
    local Rotator SectorRot;
    local Rotator SectorBoundaryRot;
    local Vector XVector;
    local Vector Line;
    
    foreach Outer.WorldInfo.AllNavigationPoints(Class'NavigationPoint', Nav)
    {
        if (NavName == Nav.Name)
        {
            break;
        }
    }
    if (Nav == None)
    {
        return;
    }
    NavLOS = Nav.ApproximateLineOfFire;
    XVector.X = 1.0;
    SectorRot.Yaw = 6554;
    for (i = 0; i < 10; i++)
    {
        SectorBoundaryRot = SectorRot * float(i);
        SectorBoundaryRot.Yaw += 3277;
        Line = XVector >> SectorBoundaryRot;
        Outer.DrawDebugLine(Nav.location + Line * 600.0, Nav.location, 0, 255, 0, TRUE);
    }
    for (i = 0; i < 10; i++)
    {
        Mask = 7 << i * 3;
        Dist = NavLOS & Mask;
        Dist = Dist >> i * 3;
        Line = XVector >> SectorRot * float(i);
        switch (Dist)
        {
            case 7:
                Outer.DrawDebugLine(Nav.location + Line * 4000.0, Nav.location, 255, 0, 0, TRUE);
                break;
            case 6:
                Outer.DrawDebugLine(Nav.location + Line * 3000.0, Nav.location, 255, 0, 0, TRUE);
                break;
            case 5:
                Outer.DrawDebugLine(Nav.location + Line * 2400.0, Nav.location, 255, 0, 0, TRUE);
                break;
            case 4:
                Outer.DrawDebugLine(Nav.location + Line * 1800.0, Nav.location, 255, 0, 0, TRUE);
                break;
            case 3:
                Outer.DrawDebugLine(Nav.location + Line * 1250.0, Nav.location, 255, 0, 0, TRUE);
                break;
            case 2:
                Outer.DrawDebugLine(Nav.location + Line * 800.0, Nav.location, 255, 0, 0, TRUE);
                break;
            case 1:
                Outer.DrawDebugLine(Nav.location + Line * 400.0, Nav.location, 255, 0, 0, TRUE);
                break;
            default:
        }
    }
}
public exec function SimulateHostDisconnect()
{
    SFXEngine(Class'Engine'.static.GetEngine()).bSimulatedNetworkError = TRUE;
}
public exec function TestNameReplication();

public function TestNameReplicationResponse(Name InName, string InConfirmString);

public exec function TickMultiplayerAsset()
{
    local SFXGAWAssetsHandler GAWHandler;
    
    GAWHandler = Class'SFXGAWAssetsHandler'.static.GetGAWHandler();
    if (GAWHandler == None)
    {
        return;
    }
    GAWHandler.IncrementMultiplayerAsset();
    Outer.ClientMessage("Incrementing MP GAW Asset");
}
public exec function ToggleDebugMPPlayerVariables()
{
    local SFXSaveManagerMP MPSaveManager;
    
    MPSaveManager = Class'SFXEngine'.static.GetSFXEngine().MPSaveManager;
    if (MPSaveManager != None)
    {
        MPSaveManager.m_bDebugPlayerVariables = !MPSaveManager.m_bDebugPlayerVariables;
        Outer.ClientMessage("Toggling Debug MP Player Variables " $ MPSaveManager.m_bDebugPlayerVariables);
    }
    else
    {
        Outer.ClientMessage("MP Save Manager doesn't exist");
    }
}
public exec function ToggleFullGuiSoundLogging()
{
    local SFXGUIInteraction GUIInteraction;
    
    GUIInteraction = Class'SFXGUIInteraction'.static.GetInstance();
    GUIInteraction.bFullGuiSoundLogging = !GUIInteraction.bFullGuiSoundLogging;
}
public exec function ToggleQASaveLibrary()
{
    local SFXEngine oEngine;
    
    oEngine = SFXEngine(Class'SFXEngine'.static.GetEngine());
    if (oEngine != None)
    {
        if (oEngine.GenerateQASaveLibrary)
        {
            Outer.ClientMessage("Disabling QA Savegame Library generation");
            oEngine.GenerateQASaveLibrary = FALSE;
        }
        else
        {
            Outer.ClientMessage("Enabling QA Savegame Library generation");
            oEngine.GenerateQASaveLibrary = TRUE;
        }
    }
}
public exec function ToggleSkynetSaves()
{
    local SFXEngine oEngine;
    
    oEngine = SFXEngine(Class'SFXEngine'.static.GetEngine());
    if (oEngine != None)
    {
        if (oEngine.CopySaveToSkynet)
        {
            Outer.ClientMessage("Disabling automatic upload of savegames to Skynet");
            oEngine.CopySaveToSkynet = FALSE;
        }
        else
        {
            Outer.ClientMessage("Enabling automatic upload of savegames to Skynet");
            oEngine.CopySaveToSkynet = TRUE;
        }
    }
}
public exec function UnlockAllBonusPowers()
{
    local BioWorldInfo WI;
    local BioPlayerController PC;
    local SFXProfileSettings Profile;
    local int idx;
    local array<BonusPowerUnlockData> BonusPowers;
    
    WI = BioWorldInfo(Class'WorldInfo'.static.GetWorldInfo());
    if (WI == None)
    {
        return;
    }
    PC = BioPlayerController(WI.GetALocalPlayerController());
    if (PC == None)
    {
        return;
    }
    Profile = PC.ProfileSettings;
    if (Profile == None)
    {
        return;
    }
    Profile.GetBonusPowerArray(BonusPowers);
    if (BonusPowers.Length <= 0)
    {
        return;
    }
    for (idx = 0; idx < BonusPowers.Length; idx++)
    {
        if (Profile.IsBonusPowerUnlocked(BonusPowers[idx].BonusPowerID) == FALSE)
        {
            Profile.UnlockBonusPower(BonusPowers[idx].BonusPowerID);
        }
    }
}
public exec function UnlockAllMPKits()
{
    Class'SFXEngine'.static.GetSFXEngine().MPSaveManager.UnlockAllMPKits();
}
public exec function UnlockArmorPiece(EArmorTreasurePiece ArmorPiece)
{
    local int idx;
    local BioWorldInfo WI;
    local BioGlobalVariableTable VarTable;
    local BioPlayerController PC;
    local BioHintSystem HintSystem;
    local SFXGame Game;
    
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
    PC = BioPlayerController(WI.GetALocalPlayerController());
    if (PC == None)
    {
        return;
    }
    HintSystem = BioHintSystem(PC.HintSystem);
    if (HintSystem == None)
    {
        return;
    }
    Game = SFXGame(WI.Game);
    if (Game == None || Game.TREASURE == None)
    {
        return;
    }
    idx = Game.TREASURE.ArmorTreasure.Find('ArmorPiece', ArmorPiece);
    if (idx == -1)
    {
        return;
    }
    VarTable.SetBool(Game.TREASURE.ArmorTreasure[idx].ArmorPlotState, TRUE);
    HintSystem.AddNotification_ArmorTreasureUnlocked(string(Game.TREASURE.ArmorTreasure[idx].srDisplayName));
}
public final exec function UpgradeExternalAsset(int AssetID)
{
    local SFXOnlineSubsystem OSS;
    local SFXOnlineComponentGalaxyAtWar OnlineGAW;
    local SFXEngine Engine;
    local array<MapEntry> ExternalAssets;
    local array<MapEntry> MapEntries;
    local MapEntry ExternalAsset;
    local GAWExternalAssetID ExternalAssetID;
    
    Engine = Class'SFXEngine'.static.GetSFXEngine();
    if (Engine == None)
    {
        return;
    }
    OSS = SFXOnlineSubsystem(Engine.OnlineSubsystem);
    if (OSS == None)
    {
        return;
    }
    OnlineGAW = OSS.GetComponentGalaxyAtWar();
    if (OnlineGAW == None)
    {
        return;
    }
    ExternalAssetID = byte(AssetID);
    MapEntries.Length = 0;
    ExternalAsset.EntryId = AssetID;
    ExternalAsset.IncreaseValue = 1;
    ExternalAssets.AddItem(ExternalAsset);
    Outer.ClientMessage("Trying to Update External Asset: " $ ExternalAssetID);
    OnlineGAW.IncreaseRatings(0, MapEntries, ExternalAssets, UpgradeExternalAssetCallback);
}
public final function UpgradeExternalAssetCallback(array<int> updatedSecurityRatings, array<int> updatedWarAssets, int Level, int errorCode)
{
    local int idx;
    
    for (idx = 0; idx < updatedWarAssets.Length; idx++)
    {
        Outer.ClientMessage("War Asset: " $ byte(idx) $ ", Strength = " $ updatedWarAssets[idx]);
    }
}
public final exec function UpgradeWeapon(string WeaponClassStr, optional int Count)
{
    local Class<SFXWeapon> WeaponClass;
    local SFXPawn_Player pPawn;
    local BioPlayerController PC;
    local SFXGRI GRI;
    local int idx;
    
    if (Outer.WorldInfo == None)
    {
        return;
    }
    PC = BioPlayerController(Outer.WorldInfo.GetALocalPlayerController());
    if (PC == None)
    {
        return;
    }
    pPawn = SFXPawn_Player(PC.Pawn);
    if (pPawn == None)
    {
        return;
    }
    GRI = SFXGRI(Outer.WorldInfo.GRI);
    if (GRI == None)
    {
        return;
    }
    WeaponClass = Class'SFXWeapon'.static.LoadWeaponClass(WeaponClassStr);
    if (WeaponClass == None)
    {
        WeaponClass = Class'SFXWeapon'.static.LoadWeaponClass("SFXGameContent." $ WeaponClassStr);
    }
    if (WeaponClass == None)
    {
        WeaponClass = Class'SFXWeapon'.static.LoadWeaponClass("SFXGameContent.SFXWeapon_" $ WeaponClassStr);
    }
    if (WeaponClass == None)
    {
        WeaponClass = Class'SFXWeapon'.static.LoadWeaponClass("SFXGameContent.SFXWeapon_Heavy_" $ WeaponClassStr);
    }
    if (WeaponClass == None)
    {
        WeaponClass = Class'SFXWeapon'.static.LoadWeaponClass("SFXGameContent.SFXWeapon_AssaultRifle_" $ WeaponClassStr);
    }
    if (WeaponClass == None)
    {
        WeaponClass = Class'SFXWeapon'.static.LoadWeaponClass("SFXGameContent.SFXWeapon_Shotgun_" $ WeaponClassStr);
    }
    if (WeaponClass == None)
    {
        WeaponClass = Class'SFXWeapon'.static.LoadWeaponClass("SFXGameContent.SFXWeapon_SniperRifle_" $ WeaponClassStr);
    }
    if (WeaponClass == None)
    {
        WeaponClass = Class'SFXWeapon'.static.LoadWeaponClass("SFXGameContent.SFXWeapon_Pistol_" $ WeaponClassStr);
    }
    if (WeaponClass == None)
    {
        WeaponClass = Class'SFXWeapon'.static.LoadWeaponClass("SFXGameContent.SFXWeapon_SMG_" $ WeaponClassStr);
    }
    if (WeaponClass == None)
    {
        return;
    }
    if (Count == 0)
    {
        Count = 1;
    }
    for (idx = 0; idx < Count; idx++)
    {
        WeaponClass.static.Upgrade(pPawn, WeaponClass, FALSE, GRI.bIsMultiplayerCharacter);
    }
}
public exec function ValidateMatchMakingStates(bool writeToFile)
{
    local SFXOnlineSubsystem oOnlineSubsystem;
    
    oOnlineSubsystem = Class'SFXOnlineSubsystem'.static.GetOnlineSubsystem();
    if (oOnlineSubsystem != None)
    {
        if (oOnlineSubsystem.GetComponentGameFlow() != None)
        {
            oOnlineSubsystem.GetComponentGameFlow().DebugValidateStates(writeToFile);
        }
    }
}
public final exec function WeaponSelection()
{
    local SFXGUIInteraction oGUI;
    local SFXGUI_WeaponSelection oWeapGUI;
    local BioPlayerController oPC;
    
    oGUI = Class'SFXGUIInteraction'.static.GetInstance();
    oPC = BioWorldInfo(Outer.WorldInfo).GetLocalPlayerController();
    oWeapGUI = oGUI.CastOpenMovie(Class'SFXGUI_WeaponSelection', oPC, oGUI.MovieTag_WeaponSelect, FALSE);
    if (oWeapGUI != None)
    {
        oWeapGUI.Start();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SetupMissionArray = ({
                          PlotIDSet = (17677), 
                          PlotIDClear = (17678, 
                                         17679, 
                                         17680, 
                                         17681, 
                                         17682, 
                                         17694, 
                                         17838, 
                                         17684, 
                                         17685, 
                                         17686, 
                                         17687, 
                                         17688, 
                                         17695, 
                                         17839
                                        ), 
                          PlotInts = ({Id = 10169, V = 0}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'PROEAR', 
                          LoadMapName = 'Biop_ProEar'
                         }, 
                         {
                          PlotIDSet = (0), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10166, V = 1}, 
                                      {Id = 10161, V = 10100}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'PROMAR', 
                          LoadMapName = 'Biop_ProMar'
                         }, 
                         {
                          PlotIDSet = (17694, 17695, 17678, 17684), 
                          PlotIDClear = (17680, 17686, 17679, 17685), 
                          PlotInts = ({Id = 10167, V = 2}, 
                                      {Id = 10161, V = 10100}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'ProCit', 
                          LoadMapName = 'BioP_CitHub'
                         }, 
                         {
                          PlotIDSet = (19211, 19212, 19213, 19214, 19206), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10168, V = 3}, 
                                      {Id = 10161, V = 70000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'KROGAR', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (0), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 10100}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CitHub_p1', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (0), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 0, V = 0}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CitHub_p1_nosummit', 
                          LoadMapName = 'BioP_CitHub'
                         }, 
                         {
                          PlotIDSet = (17682, 18765, 18764, 17688, 18723, 19940), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10213, V = 4}, 
                                      {Id = 10161, V = 310000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'OMGJCK', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (0), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 10100}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CitHub_p2', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (0), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 0, V = 0}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CitHub_p2_nosummit', 
                          LoadMapName = 'BioP_CitHub'
                         }, 
                         {
                          PlotIDSet = (18694, 19275), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10200, V = 5}, 
                                      {Id = 10161, V = 80000}
                                     ), 
                          PlotCond = ({C = 176, CA = 0, T = 33, TA = 0}
                                     ), 
                          Mission = 'KRO001', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (17742), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 40100}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'Kro001_nosummit', 
                          LoadMapName = 'Biop_Kro001'
                         }, 
                         {
                          PlotIDSet = (17743), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10178, V = 6}, 
                                      {Id = 10161, V = 40100}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'KroN7A', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18946), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10180, V = 7}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'KroN7B', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18739), 
                          PlotIDClear = (17743), 
                          PlotInts = ({Id = 10181, V = 8}, 
                                      {Id = 10161, V = 330000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'KROGRU', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (17743), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10182, V = 9}, 
                                      {Id = 10161, V = 40100}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'KRO002', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18745, 18948, 18947), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 40100}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'Kro002_nosummit', 
                          LoadMapName = 'Biop_Kro002'
                         }, 
                         {
                          PlotIDSet = (0), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10179, V = 10}, 
                                      {Id = 10161, V = 10100}
                                     ), 
                          PlotCond = ({C = 1016, CA = 0, T = 1283, TA = 0}
                                     ), 
                          Mission = 'CAT003', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18388), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 10100}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'Cat003_nosummit', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (0), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10184, V = 11}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'Cat003_debrief', 
                          LoadMapName = 'BioP_CitHub'
                         }, 
                         {
                          PlotIDSet = (18751), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 10100}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CitHub_p3', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (0), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 0, V = 0}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CitHub_p3_nosummit', 
                          LoadMapName = 'BioP_CitHub'
                         }, 
                         {
                          PlotIDSet = (18751, 18766, 18466, 19704), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 340000}
                                     ), 
                          PlotCond = ({C = 191, CA = 0, T = 31, TA = 0}, 
                                      {C = 190, CA = 0, T = 32, TA = 0}
                                     ), 
                          Mission = 'CITSAM', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (19274, 19480), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 340000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CitSam_nosummit', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18850), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10195, V = 12}, 
                                      {Id = 10161, V = 270400}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CERJCB', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (19273, 18767), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10189, V = 13}, 
                                      {Id = 10161, V = 100000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'GTH001', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (17740), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 90000}
                                     ), 
                          PlotCond = ({C = 178, CA = 0, T = 250, TA = 0}
                                     ), 
                          Mission = 'Gth001_nosummit', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (0), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10172, V = 14}, 
                                      {Id = 10161, V = 90000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'GthN7A', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (0), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10172, V = 15}, 
                                      {Id = 10161, V = 90000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'GTHLEG', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (17805, 17803, 18854), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10172, V = 14}, 
                                      {Id = 10174, V = 15}, 
                                      {Id = 10176, V = 16}, 
                                      {Id = 10161, V = 90000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'GthLeg_N7A', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (17741, 17806, 17804), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 90000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'GTH002', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18853, 18856), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 90000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'Gth002_nosummit', 
                          LoadMapName = 'Biop_Gth002'
                         }, 
                         {
                          PlotIDSet = (19262), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10173, V = 17}, 
                                      {Id = 10161, V = 90000}
                                     ), 
                          PlotCond = ({C = 1052, CA = 0, T = 191, TA = 0}
                                     ), 
                          Mission = 'Nor_GthEnd', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18481), 
                          PlotIDClear = (18694, 19275), 
                          PlotInts = ({Id = 10200, V = 0}, 
                                      {Id = 10161, V = 310000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'OmgJck_fullparty', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18694, 19275), 
                          PlotIDClear = (18946), 
                          PlotInts = ({Id = 10180, V = 0}, 
                                      {Id = 10181, V = 0}, 
                                      {Id = 10200, V = 5}, 
                                      {Id = 10161, V = 40100}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'KroN7A_fullparty', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18946), 
                          PlotIDClear = (18739), 
                          PlotInts = ({Id = 10180, V = 7}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'KroN7B_fullparty', 
                          LoadMapName = 'Biop_KroN7b'
                         }, 
                         {
                          PlotIDSet = (18739), 
                          PlotIDClear = (18947), 
                          PlotInts = ({Id = 10182, V = 0}, 
                                      {Id = 10181, V = 8}, 
                                      {Id = 10161, V = 330000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'KroGru_fullparty', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18947), 
                          PlotIDClear = (18850, 19274), 
                          PlotInts = ({Id = 10195, V = 0}, 
                                      {Id = 10182, V = 9}, 
                                      {Id = 10161, V = 340000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CitSam_fullparty', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18850, 19274), 
                          PlotIDClear = (19273, 18767), 
                          PlotInts = ({Id = 10189, V = 0}, 
                                      {Id = 10195, V = 12}, 
                                      {Id = 10161, V = 270400}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CerJcb_fullparty', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (19273, 18767), 
                          PlotIDClear = (18481), 
                          PlotInts = ({Id = 10189, V = 13}, 
                                      {Id = 10161, V = 10100}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CAT002', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (19301), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 50000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'Cat002_nosummit', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18481, 18482), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10183, V = 18}, 
                                      {Id = 10161, V = 130000}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CERMIR', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (18482, 18767, 17821, 19273), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10188, V = 19}, 
                                      {Id = 10161, V = 120300}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'CAT004', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (19535), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 20800}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'SPCer', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (20892), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 40100}, 
                                      {Id = 10302, V = 20}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'SPTowr', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (20893), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 430000}, 
                                      {Id = 10307, V = 21}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'SPSlum', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (20891), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 120200}, 
                                      {Id = 10306, V = 22}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'SPNov', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (20890), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 390000}, 
                                      {Id = 10304, V = 23}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'SPRctr', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (20889), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10161, V = 400000}, 
                                      {Id = 10305, V = 24}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'SPDish', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (20894, 19290, 19286), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10185, V = 26}, 
                                      {Id = 10303, V = 25}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'END001', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (0), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10202, V = 21}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'END002', 
                          LoadMapName = 'BioP_Nor'
                         }, 
                         {
                          PlotIDSet = (0), 
                          PlotIDClear = (0), 
                          PlotInts = ({Id = 10203, V = 22}
                                     ), 
                          PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                     ), 
                          Mission = 'End003', 
                          LoadMapName = 'BioP_Nor'
                         }
                        )
    SetupModifierArray = ({
                           PlotIDSet = (1456, 
                                        33, 
                                        34, 
                                        35, 
                                        36, 
                                        37, 
                                        38, 
                                        39, 
                                        40, 
                                        2935, 
                                        41, 
                                        42, 
                                        43, 
                                        44, 
                                        13942, 
                                        13024, 
                                        2676, 
                                        757, 
                                        1247, 
                                        6815, 
                                        13001, 
                                        1831, 
                                        1496, 
                                        1497, 
                                        1498, 
                                        1499, 
                                        1500, 
                                        1501, 
                                        1502, 
                                        1503, 
                                        1504, 
                                        1505, 
                                        1506, 
                                        1507, 
                                        6561, 
                                        14464, 
                                        14459, 
                                        12587, 
                                        361, 
                                        1497, 
                                        3817, 
                                        3322, 
                                        3323, 
                                        3324, 
                                        3321, 
                                        3326, 
                                        3327, 
                                        3328, 
                                        3329, 
                                        3330, 
                                        3331, 
                                        3332, 
                                        3333, 
                                        3334, 
                                        3335, 
                                        3336, 
                                        3337, 
                                        3338, 
                                        6157, 
                                        3881, 
                                        13941, 
                                        13942, 
                                        189
                                       ), 
                           PlotIDClear = (195, 
                                          196, 
                                          197, 
                                          198, 
                                          199, 
                                          200, 
                                          201, 
                                          202, 
                                          203, 
                                          204, 
                                          205, 
                                          206, 
                                          1664, 
                                          13028, 
                                          13029, 
                                          15543, 
                                          2677, 
                                          759, 
                                          13002, 
                                          1832, 
                                          6562, 
                                          12588, 
                                          3630, 
                                          3629, 
                                          3631, 
                                          3632, 
                                          3349, 
                                          3350, 
                                          360, 
                                          362
                                         ), 
                           PlotInts = ({Id = 166, V = 0}, 
                                       {Id = 197, V = 2}
                                      ), 
                           PlotCond = ({C = 11, CA = 0, T = 527, TA = 0}, 
                                       {C = 12, CA = 0, T = 528, TA = 0}
                                      ), 
                           Modifier = 'ME2Success'
                          }, 
                          {
                           PlotIDSet = (1456, 
                                        37, 
                                        43, 
                                        195, 
                                        196, 
                                        197, 
                                        198, 
                                        199, 
                                        200, 
                                        201, 
                                        202, 
                                        203, 
                                        204, 
                                        205, 
                                        206, 
                                        1664, 
                                        13028, 
                                        2677, 
                                        759, 
                                        1247, 
                                        13002, 
                                        1832, 
                                        1500, 
                                        1506, 
                                        6562, 
                                        12588, 
                                        3630, 
                                        3629, 
                                        3631, 
                                        3632, 
                                        3349, 
                                        360, 
                                        1497
                                       ), 
                           PlotIDClear = (33, 
                                          34, 
                                          35, 
                                          36, 
                                          38, 
                                          39, 
                                          40, 
                                          2935, 
                                          41, 
                                          42, 
                                          44, 
                                          13942, 
                                          13024, 
                                          13025, 
                                          13026, 
                                          13684, 
                                          2676, 
                                          757, 
                                          6815, 
                                          13001, 
                                          1831, 
                                          1496, 
                                          1497, 
                                          1498, 
                                          1499, 
                                          1501, 
                                          1502, 
                                          1503, 
                                          1504, 
                                          1505, 
                                          1507, 
                                          6561, 
                                          14464, 
                                          14459, 
                                          12587, 
                                          3350, 
                                          361, 
                                          362, 
                                          189
                                         ), 
                           PlotInts = ({Id = 166, V = 4}
                                      ), 
                           PlotCond = ({C = 11, CA = 0, T = 528, TA = 0}, 
                                       {C = 12, CA = 0, T = 527, TA = 0}
                                      ), 
                           Modifier = 'ME2Failure'
                          }, 
                          {
                           PlotIDSet = (16530, 15943), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'PlayedME1'
                          }, 
                          {
                           PlotIDSet = (13942, 13024, 13015), 
                           PlotIDClear = (13028, 13029, 15543, 13021), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'WrexAlive'
                          }, 
                          {
                           PlotIDSet = (13028, 13021), 
                           PlotIDClear = (13942, 13024, 13025, 13026, 13684, 13015), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'WrexDead'
                          }, 
                          {
                           PlotIDSet = (13827), 
                           PlotIDClear = (13828), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'AshleyAlive'
                          }, 
                          {
                           PlotIDSet = (13828), 
                           PlotIDClear = (13827), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'AshleyDead'
                          }, 
                          {
                           PlotIDSet = (13828), 
                           PlotIDClear = (13827), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'KaidanAlive'
                          }, 
                          {
                           PlotIDSet = (13827), 
                           PlotIDClear = (13828), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'KaidanDead'
                          }, 
                          {
                           PlotIDSet = (14464, 14459), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'KirraheAlive'
                          }, 
                          {
                           PlotIDSet = (0), 
                           PlotIDClear = (14464, 14459), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'KirraheDead'
                          }, 
                          {
                           PlotIDSet = (2676), 
                           PlotIDClear = (2677), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'MaelonDataSaved'
                          }, 
                          {
                           PlotIDSet = (2677), 
                           PlotIDClear = (2676), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'MaelonDataDestroyed'
                          }, 
                          {
                           PlotIDSet = (33), 
                           PlotIDClear = (195), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'MirandaAlive'
                          }, 
                          {
                           PlotIDSet = (195), 
                           PlotIDClear = (33), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'MirandaDead'
                          }, 
                          {
                           PlotIDSet = (34), 
                           PlotIDClear = (196), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'JacobAlive'
                          }, 
                          {
                           PlotIDSet = (196), 
                           PlotIDClear = (34), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'JacobDead'
                          }, 
                          {
                           PlotIDSet = (35), 
                           PlotIDClear = (197), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'JackAlive'
                          }, 
                          {
                           PlotIDSet = (197), 
                           PlotIDClear = (35), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'JackDead'
                          }, 
                          {
                           PlotIDSet = (36, 1247), 
                           PlotIDClear = (198), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'LegionAlive'
                          }, 
                          {
                           PlotIDSet = (198, 1247), 
                           PlotIDClear = (36), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'LegionDead'
                          }, 
                          {
                           PlotIDSet = (1247), 
                           PlotIDClear = (36, 198), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'LegionNew'
                          }, 
                          {
                           PlotIDSet = (37), 
                           PlotIDClear = (199), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'KasumiAlive'
                          }, 
                          {
                           PlotIDSet = (199), 
                           PlotIDClear = (37), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'KasumiDead'
                          }, 
                          {
                           PlotIDSet = (38), 
                           PlotIDClear = (200), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'GarrusAlive'
                          }, 
                          {
                           PlotIDSet = (200), 
                           PlotIDClear = (38), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'GarrusDead'
                          }, 
                          {
                           PlotIDSet = (39), 
                           PlotIDClear = (201), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'ThaneAlive'
                          }, 
                          {
                           PlotIDSet = (201), 
                           PlotIDClear = (39), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'ThaneDead'
                          }, 
                          {
                           PlotIDSet = (40), 
                           PlotIDClear = (202), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'TaliAlive'
                          }, 
                          {
                           PlotIDSet = (40, 2935), 
                           PlotIDClear = (202), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'TaliAliveAdmiral'
                          }, 
                          {
                           PlotIDSet = (202), 
                           PlotIDClear = (40), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'TaliDead'
                          }, 
                          {
                           PlotIDSet = (41), 
                           PlotIDClear = (203), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'MordinAlive'
                          }, 
                          {
                           PlotIDSet = (203), 
                           PlotIDClear = (41), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'MordinDead'
                          }, 
                          {
                           PlotIDSet = (42), 
                           PlotIDClear = (204), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'GruntAlive'
                          }, 
                          {
                           PlotIDSet = (204), 
                           PlotIDClear = (42), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'GruntDead'
                          }, 
                          {
                           PlotIDSet = (43), 
                           PlotIDClear = (205, 1664), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'SamaraAlive'
                          }, 
                          {
                           PlotIDSet = (205), 
                           PlotIDClear = (43, 1664), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'SamaraDead'
                          }, 
                          {
                           PlotIDSet = (43, 1664), 
                           PlotIDClear = (205), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'MorinthAlive'
                          }, 
                          {
                           PlotIDSet = (205, 1664), 
                           PlotIDClear = (43), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'MorinthDead'
                          }, 
                          {
                           PlotIDSet = (44), 
                           PlotIDClear = (206), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'ZaeedAlive'
                          }, 
                          {
                           PlotIDSet = (206), 
                           PlotIDClear = (44), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'ZaeedDead'
                          }, 
                          {
                           PlotIDSet = (12587), 
                           PlotIDClear = (12588), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'RachniQueenAlive'
                          }, 
                          {
                           PlotIDSet = (12588), 
                           PlotIDClear = (12587), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'RachniQueenDead'
                          }, 
                          {
                           PlotIDSet = (757), 
                           PlotIDClear = (759), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'HereticsDead'
                          }, 
                          {
                           PlotIDSet = (759), 
                           PlotIDClear = (757), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'HereticsRewritten'
                          }, 
                          {
                           PlotIDSet = (13001), 
                           PlotIDClear = (13002), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'CouncilAlive'
                          }, 
                          {
                           PlotIDSet = (13002), 
                           PlotIDClear = (13001), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'CouncilDead'
                          }, 
                          {
                           PlotIDSet = (14281, 13827), 
                           PlotIDClear = (14169, 6931, 6941, 13828), 
                           PlotInts = ({Id = 10017, V = 4}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'AshleyRomanced'
                          }, 
                          {
                           PlotIDSet = (14281, 13827), 
                           PlotIDClear = (14169, 6931, 6941, 13828), 
                           PlotInts = ({Id = 10017, V = 4}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'AshRomanced'
                          }, 
                          {
                           PlotIDSet = (13960, 13828), 
                           PlotIDClear = (14169, 6931, 6941, 13827), 
                           PlotInts = ({Id = 10015, V = 4}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'KaidanRomanced'
                          }, 
                          {
                           PlotIDSet = (14169), 
                           PlotIDClear = (14281, 13960), 
                           PlotInts = ({Id = 10016, V = 4}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'LiaraRomanced'
                          }, 
                          {
                           PlotIDSet = (14169, 6927, 6931, 6815, 7051, 7035, 7151), 
                           PlotIDClear = (14281, 13960), 
                           PlotInts = ({Id = 10016, V = 4}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'LiaraRomancedLotSB'
                          }, 
                          {
                           PlotIDSet = (5209), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 266, V = 5}
                                      ), 
                           PlotCond = ({C = 235, CA = 0, T = 777, TA = 0}, 
                                       {C = 236, CA = 0, T = 778, TA = 0}
                                      ), 
                           Modifier = 'MirandaRomanced'
                          }, 
                          {
                           PlotIDSet = (5208), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 213, V = 5}
                                      ), 
                           PlotCond = ({C = 236, CA = 0, T = 778, TA = 0}, 
                                       {C = 232, CA = 0, T = 776, TA = 0}
                                      ), 
                           Modifier = 'JackRomanced'
                          }, 
                          {
                           PlotIDSet = (3926), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 272, V = 5}
                                      ), 
                           PlotCond = ({C = 235, CA = 0, T = 777, TA = 0}, 
                                       {C = 232, CA = 0, T = 776, TA = 0}
                                      ), 
                           Modifier = 'TaliRomanced'
                          }, 
                          {
                           PlotIDSet = (3892), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 267, V = 5}
                                      ), 
                           PlotCond = ({C = 234, CA = 0, T = 781, TA = 0}, 
                                       {C = 233, CA = 0, T = 780, TA = 0}
                                      ), 
                           Modifier = 'JacobRomanced'
                          }, 
                          {
                           PlotIDSet = (5206), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 271, V = 5}
                                      ), 
                           PlotCond = ({C = 234, CA = 0, T = 781, TA = 0}, 
                                       {C = 231, CA = 0, T = 779, TA = 0}
                                      ), 
                           Modifier = 'ThaneRomanced'
                          }, 
                          {
                           PlotIDSet = (5207), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 270, V = 5}
                                      ), 
                           PlotCond = ({C = 233, CA = 0, T = 780, TA = 0}, 
                                       {C = 231, CA = 0, T = 779, TA = 0}
                                      ), 
                           Modifier = 'GarrusRomanced'
                          }, 
                          {
                           PlotIDSet = (3304), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 266, V = 6}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'MirandaBreakup'
                          }, 
                          {
                           PlotIDSet = (3270), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 213, V = 6}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'JackBreakup'
                          }, 
                          {
                           PlotIDSet = (3307), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 272, V = 6}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'TaliBreakup'
                          }, 
                          {
                           PlotIDSet = (3472), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 267, V = 6}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'JacobBreakup'
                          }, 
                          {
                           PlotIDSet = (3310), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 271, V = 6}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'ThaneBreakup'
                          }, 
                          {
                           PlotIDSet = (3660), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 270, V = 6}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'GarrusBreakup'
                          }, 
                          {
                           PlotIDSet = (19722), 
                           PlotIDClear = (19727, 19724, 19723, 19726, 19725, 19835, 19838), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'LiaraTrueLove'
                          }, 
                          {
                           PlotIDSet = (19724), 
                           PlotIDClear = (19729, 19722, 19723, 19726, 19725, 19835, 19838), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'AshleyTrueLove'
                          }, 
                          {
                           PlotIDSet = (19723), 
                           PlotIDClear = (19728, 19722, 19724, 19726, 19725, 19835, 19838), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'KaidanTrueLove'
                          }, 
                          {
                           PlotIDSet = (19726), 
                           PlotIDClear = (19731, 19722, 19724, 19723, 19725, 19835, 19838), 
                           PlotInts = ({Id = 272, V = 5}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'TaliTrueLove'
                          }, 
                          {
                           PlotIDSet = (19725), 
                           PlotIDClear = (19730, 19722, 19724, 19723, 19726, 19835, 19838), 
                           PlotInts = ({Id = 270, V = 5}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'GarrusTrueLove'
                          }, 
                          {
                           PlotIDSet = (19835), 
                           PlotIDClear = (19836, 19722, 19724, 19723, 19726, 19725, 19838), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'AllersTrueLove'
                          }, 
                          {
                           PlotIDSet = (19838), 
                           PlotIDClear = (19839, 19722, 19724, 19723, 19726, 19725, 19835), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'CortezTrueLove'
                          }, 
                          {
                           PlotIDSet = (17787), 
                           PlotIDClear = (17788, 17789), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'GethDead'
                          }, 
                          {
                           PlotIDSet = (17789), 
                           PlotIDClear = (17787, 17788), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'GethPeace'
                          }, 
                          {
                           PlotIDSet = (17788), 
                           PlotIDClear = (17787, 17789, 17838, 17839), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'QuariansDead'
                          }, 
                          {
                           PlotIDSet = (1831), 
                           PlotIDClear = (1832), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'BaseDestroyed'
                          }, 
                          {
                           PlotIDSet = (1832), 
                           PlotIDClear = (1831), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'BaseSaved'
                          }, 
                          {
                           PlotIDSet = (6561), 
                           PlotIDClear = (6562), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'DavidSaved'
                          }, 
                          {
                           PlotIDSet = (6562), 
                           PlotIDClear = (6561), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'DavidHandedOVer'
                          }, 
                          {
                           PlotIDSet = (0), 
                           PlotIDClear = (6561, 6562), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'OverlordNotPlayed'
                          }, 
                          {
                           PlotIDSet = (6815, 7051, 7035, 7151, 7200), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'LotSBPlayed'
                          }, 
                          {
                           PlotIDSet = (0), 
                           PlotIDClear = (6815, 7051, 7035, 7151, 7200), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'LotSBNotPlayed'
                          }, 
                          {
                           PlotIDSet = (7451), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'ArrivalPlayed'
                          }, 
                          {
                           PlotIDSet = (0), 
                           PlotIDClear = (7451), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'ArrivalNotPlayed'
                          }, 
                          {
                           PlotIDSet = (3351), 
                           PlotIDClear = (3629, 3630, 3631, 3632, 3349, 3350), 
                           PlotInts = ({Id = 166, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'CrewAlive'
                          }, 
                          {
                           PlotIDSet = (3629, 3630, 3631, 3632, 3349), 
                           PlotIDClear = (3351, 3350), 
                           PlotInts = ({Id = 166, V = 4}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'CrewDead'
                          }, 
                          {
                           PlotIDSet = (3629, 3632, 3351), 
                           PlotIDClear = (3630, 3631, 3349, 3350), 
                           PlotInts = ({Id = 166, V = 1}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'CrewHalfDead'
                          }, 
                          {
                           PlotIDSet = (1456), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'PlayedME2'
                          }, 
                          {
                           PlotIDSet = (0), 
                           PlotIDClear = (1456), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'DidNotPlayME2'
                          }, 
                          {
                           PlotIDSet = (17683, 17689), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'AddProthean'
                          }, 
                          {
                           PlotIDSet = (360, 1497), 
                           PlotIDClear = (361, 362), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'JacobDadMarooned'
                          }, 
                          {
                           PlotIDSet = (361, 1497), 
                           PlotIDClear = (360, 362), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'JacobDadArrested'
                          }, 
                          {
                           PlotIDSet = (362, 1497), 
                           PlotIDClear = (360, 361), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'JacobDadKilled'
                          }, 
                          {
                           PlotIDSet = (6815), 
                           PlotIDClear = (0), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'PlayedLotSB'
                          }, 
                          {
                           PlotIDSet = (19704, 18893), 
                           PlotIDClear = (17680, 
                                          17686, 
                                          17679, 
                                          17685, 
                                          18199, 
                                          18445, 
                                          19523, 
                                          19524, 
                                          19525, 
                                          19526, 
                                          19521, 
                                          19522, 
                                          19519, 
                                          19520, 
                                          19527, 
                                          19528, 
                                          19649, 
                                          19648
                                         ), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 190, CA = 0, T = 839, TA = 0}, 
                                       {C = 191, CA = 0, T = 820, TA = 0}
                                      ), 
                           Modifier = 'PlayerShotAK'
                          }, 
                          {
                           PlotIDSet = (19704), 
                           PlotIDClear = (17680, 
                                          17686, 
                                          17679, 
                                          17685, 
                                          18199, 
                                          18445, 
                                          19523, 
                                          19524, 
                                          19525, 
                                          19526, 
                                          19521, 
                                          19522, 
                                          19519, 
                                          19520, 
                                          19527, 
                                          19528, 
                                          19649, 
                                          19648
                                         ), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 190, CA = 0, T = 839, TA = 0}, 
                                       {C = 191, CA = 0, T = 820, TA = 0}, 
                                       {C = 190, CA = 0, T = 1867, TA = 0}, 
                                       {C = 191, CA = 0, T = 1868, TA = 0}
                                      ), 
                           Modifier = 'LiaraShotAK'
                          }, 
                          {
                           PlotIDSet = (19704), 
                           PlotIDClear = (17680, 
                                          17686, 
                                          17679, 
                                          17685, 
                                          18199, 
                                          18445, 
                                          19523, 
                                          19524, 
                                          19525, 
                                          19526, 
                                          19521, 
                                          19522, 
                                          19519, 
                                          19520, 
                                          19527, 
                                          19528, 
                                          19649, 
                                          19648
                                         ), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 190, CA = 0, T = 839, TA = 0}, 
                                       {C = 191, CA = 0, T = 820, TA = 0}, 
                                       {C = 190, CA = 0, T = 1869, TA = 0}, 
                                       {C = 191, CA = 0, T = 1870, TA = 0}
                                      ), 
                           Modifier = 'EDIShotAK'
                          }, 
                          {
                           PlotIDSet = (19704), 
                           PlotIDClear = (17680, 
                                          17686, 
                                          17679, 
                                          17685, 
                                          18199, 
                                          18445, 
                                          19523, 
                                          19524, 
                                          19525, 
                                          19526, 
                                          19521, 
                                          19522, 
                                          19519, 
                                          19520, 
                                          19527, 
                                          19528, 
                                          19649, 
                                          19648
                                         ), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 190, CA = 0, T = 839, TA = 0}, 
                                       {C = 191, CA = 0, T = 820, TA = 0}, 
                                       {C = 190, CA = 0, T = 1865, TA = 0}, 
                                       {C = 191, CA = 0, T = 1866, TA = 0}
                                      ), 
                           Modifier = 'JamesShotAK'
                          }, 
                          {
                           PlotIDSet = (19704), 
                           PlotIDClear = (17680, 
                                          17686, 
                                          17679, 
                                          17685, 
                                          18199, 
                                          18445, 
                                          19523, 
                                          19524, 
                                          19525, 
                                          19526, 
                                          19521, 
                                          19522, 
                                          19519, 
                                          19520, 
                                          19527, 
                                          19528, 
                                          19649, 
                                          19648
                                         ), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 190, CA = 0, T = 839, TA = 0}, 
                                       {C = 191, CA = 0, T = 820, TA = 0}, 
                                       {C = 190, CA = 0, T = 1863, TA = 0}, 
                                       {C = 191, CA = 0, T = 1864, TA = 0}
                                      ), 
                           Modifier = 'GarrusShotAK'
                          }, 
                          {
                           PlotIDSet = (19704), 
                           PlotIDClear = (17680, 
                                          17686, 
                                          17679, 
                                          17685, 
                                          18199, 
                                          18445, 
                                          19523, 
                                          19524, 
                                          19525, 
                                          19526, 
                                          19521, 
                                          19522, 
                                          19519, 
                                          19520, 
                                          19527, 
                                          19528, 
                                          19649, 
                                          19648
                                         ), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 190, CA = 0, T = 839, TA = 0}, 
                                       {C = 191, CA = 0, T = 820, TA = 0}, 
                                       {C = 190, CA = 0, T = 1871, TA = 0}, 
                                       {C = 191, CA = 0, T = 1872, TA = 0}
                                      ), 
                           Modifier = 'ProtheanShotAK'
                          }, 
                          {
                           PlotIDSet = (19182), 
                           PlotIDClear = (19181), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'RecruitMichel'
                          }, 
                          {
                           PlotIDSet = (19181), 
                           PlotIDClear = (19182, 3630), 
                           PlotInts = ({Id = 0, V = 0}
                                      ), 
                           PlotCond = ({C = 0, CA = 0, T = 0, TA = 0}
                                      ), 
                           Modifier = 'RecruitChakwas'
                          }
                         )
    ReplicationTestNames = ('Active', 
                            'BioticsStrength', 
                            'Wrinkle', 
                            'None', 
                            'AddSubscriber', 
                            'ATTENUATION_Inverse', 
                            'bQueueAndSuppressNotifications', 
                            'ChkCover', 
                            'Default__BioDebugMenu', 
                            'EChallengeType', 
                            'm_nCodexLastSelectedPrimary', 
                            'NotifyEnemyVisible', 
                            'StormRegen', 
                            'OverlayTexture', 
                            'ScaleMax', 
                            'GetElementMemberBool', 
                            'XPLevel'
                           )
    ReplicationTestNameStrings = ("StringName123456789", "____TestStringName___", "")
    AutoBotAIControllerName = "SFXGameContent.SFXAI_AutoBot"
}