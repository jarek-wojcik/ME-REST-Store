Class SFXGameModeMultiLand extends SFXGameModeGalaxy within BioPlayerController
    native
    config(Input);

var editinline transient export array<ParticleSystemComponent> TemporaryComponents;
var transient Rotator ReticleRot;
var config Rotator ReticleRotStart;
var config Rotator ReticleRotTopLeftClamp;
var config Rotator ReticleRotBottomRightClamp;
var transient Vector ScanReticleInputMovement;
var config float ReticleDegreesPerSecond;
var config float InputAttenuation;
var editinline transient export ParticleSystemComponent ReticleEffect;
var transient float ReticleScale;
var config float ReticleMoveSpeed;
var config float SelectDistance;
var transient SFXPlanetFeature LandingSiteFeature;
var transient float fRescaleTime;
var transient float fInitialScale;
var transient float fNewScale;
var transient float fMaxRescaleTime;
var transient bool bMouseLock;
var transient bool bCanLand;
var transient bool bInitialized;
var transient bool bRescaling;

public function Activated()
{
    local InterpActor oPlanet;
    
    Super(SFXGameModeBase).Activated();
    ReticleRot = ReticleRotStart;
    oPlanet = GetGameData().Planet;
    if (oPlanet.DrawScale3D.X != Class'BioPlanet'.default.m_fPlanetScale)
    {
        fInitialScale = oPlanet.DrawScale3D.X;
        fNewScale = Class'BioPlanet'.default.m_fPlanetScale;
    }
    if (ReticleEffect != None)
    {
        ReticleEffect.ActivateSystem();
    }
    LandingSiteFeature = None;
    UpdateReticle(0.0);
    ToggleMouseLock(TRUE);
}
public event function bool CanExit()
{
    return Super.CanExit() && !bRescaling;
}
public function Deactivated()
{
    local int i;
    local BioSeqAct_MultiLand GameData;
    local BioSFHandler_GalaxyMap oGUI;
    
    GameData = GetGameData();
    if (ReticleEffect != None)
    {
        ReticleEffect.DeactivateSystem();
    }
    for (i = 0; i < TemporaryComponents.Length; i++)
    {
        TemporaryComponents[i].DeactivateSystem();
        GameData.Planet.DetachComponent(TemporaryComponents[i]);
    }
    GameData.EndAction();
    ToggleMouseLock(FALSE);
    LandingSiteFeature = None;
    oGUI = Class'SFXGUIInteraction'.static.GetInstance().GetGalaxyMap(Outer);
    if (oGUI != None)
    {
        oGUI.AS_SetRTriggerLabelVisible(FALSE, "");
    }
    bInitialized = FALSE;
    Super(SFXGameModeBase).Deactivated();
}
public function Update(float DeltaTime)
{
    local BioSeqAct_MultiLand GameData;
    
    GameData = GetGameData();
    if (bRescaling)
    {
        UpdatePlanetScale(DeltaTime);
        return;
    }
    if (ReticleEffect == None)
    {
        ReticleEffect = new Class'ParticleSystemComponent';
        ReticleEffect.SetTemplate(GameData.Reticle);
        ReticleEffect.SetAbsolute(FALSE, TRUE, FALSE);
        ReticleEffect.SetScale(ReticleScale);
        GameData.Planet.AttachComponent(ReticleEffect);
        ReticleEffect.ActivateSystem();
    }
    if (!bInitialized)
    {
        GameData = GetGameData();
        GameData.CurrentPlanet.LoadMultiLandPlanetData(GameData.Planet, TemporaryComponents);
        DrawLabels();
        bInitialized = TRUE;
    }
    UpdateReticle(DeltaTime);
    UpdateLabelPositions();
}
public final function AttemptLand()
{
    local Name MapName;
    local BioSeqAct_MultiLand GameData;
    
    GameData = GetGameData();
    if (GameData == None)
    {
        return;
    }
    if (LandingSiteFeature != None && LandingSiteFeature.FeatureType == EFeatureType.FEATURE_LANDINGSITE)
    {
        LandingSiteFeature.PerformTransition();
        MapName = Name(LandingSiteFeature.LandingSiteMapName);
        if (MapName == 'None')
        {
            MapName = Name(GameData.CurrentPlanet.MapName);
        }
        GameData.GetGalaxyCamera().TriggerEvent('PlanetLanding', MapName);
    }
}
public function BeginExitGalaxyMap(bool resize)
{
    ReticleEffect.DeactivateSystem();
    if (fInitialScale > 0.0 && resize)
    {
        fNewScale = fInitialScale;
        fInitialScale = 5.5;
        bRescaling = TRUE;
    }
}
public function DrawLabels()
{
    local BioSFHandler_GalaxyMap oPanel;
    local SFXGalaxyMapObject o;
    local SFXPlanetFeature F;
    local int numDisplayed;
    local stringref srLabel;
    local string sText;
    local BioSeqAct_MultiLand GameData;
    local Rotator rotPlanet;
    
    GameData = GetGameData();
    oPanel = Class'SFXGUIInteraction'.static.GetInstance().GetGalaxyMap(Outer);
    rotPlanet = GameData.Planet.Rotation;
    rotPlanet.Yaw = 0;
    GameData.Planet.SetRotation(rotPlanet);
    numDisplayed = 0;
    if (oPanel != None)
    {
        oPanel.InitializePlanetTags(GameData.CurrentPlanet.Children.Length);
        foreach GameData.CurrentPlanet.Children(o, )
        {
            F = SFXPlanetFeature(o);
            if (F == None || F.FeatureType != EFeatureType.FEATURE_LANDINGSITE)
            {
                continue;
            }
            if (F.IsUsable() && F.IsVisible())
            {
                srLabel = F.DisplayName;
                if (srLabel == 0)
                {
                    srLabel = Class'BioSFHandler_GalaxyMap'.default.TextUnknownObj;
                }
                sText = oPanel.UIStrRef(F.LandingSiteText);
                oPanel.SetSelectorState(numDisplayed, TRUE, 1, 1, 100, srLabel, sText);
                numDisplayed++;
            }
        }
        UpdateLabelPositions();
    }
}
public function SFXCameraMode GetCameraMode(SFXCameraMode OldCameraMode, out int PreserveTarget, out float TransitionTime, out SFXCameraMode_Interpolate Transition)
{
    return Outer.GameModeManager2.GameModes[11].GetCameraMode(OldCameraMode, PreserveTarget, TransitionTime, Transition);
}
public function BioSeqAct_MultiLand GetGameData()
{
    local SeqAct_Latent SeqAct;
    
    foreach Outer.Pawn.LatentActions(SeqAct, )
    {
        if (BioSeqAct_MultiLand(SeqAct) != None)
        {
            return BioSeqAct_MultiLand(SeqAct);
        }
    }
    return None;
}
public function RingReticleLeftRight(float Axis)
{
    ScanReticleInputMovement.X += Axis * InputAttenuation;
}
public function RingReticleUpDown(float Axis)
{
    ScanReticleInputMovement.Y += Axis * InputAttenuation;
}
public final function bool TestLandingCondition()
{
    local BioSeqAct_MultiLand GameData;
    local Vector ReticlePos;
    local SFXGalaxyMapObject o;
    local SFXPlanetFeature F;
    
    GameData = GetGameData();
    ReticlePos = 100.0 * Vector(ReticleRot);
    bCanLand = FALSE;
    foreach GameData.CurrentPlanet.Children(o, )
    {
        F = SFXPlanetFeature(o);
        if (F == None || F.FeatureType != EFeatureType.FEATURE_LANDINGSITE)
        {
            continue;
        }
        if (F.IsUsable() && F.IsVisible())
        {
            if (VSize(ReticlePos - F.Position) < SelectDistance)
            {
                bCanLand = TRUE;
                LandingSiteFeature = F;
            }
        }
    }
    LandingSiteFeature = bCanLand ? LandingSiteFeature : None;
    return bCanLand;
}
public exec function ToggleMouseLock(bool bNewMouseLock)
{
    local BioSFHandler_GalaxyMap oHandler;
    
    bMouseLock = bNewMouseLock;
    oHandler = Class'SFXGUIInteraction'.static.GetInstance().GetGalaxyMap(Outer);
    if (oHandler != None)
    {
        if (bMouseLock)
        {
            oHandler.SetMouseShown(FALSE);
        }
        else
        {
            oHandler.SetMouseShown(TRUE);
        }
    }
}
public final function UpdateLabelPositions()
{
    local BioSFHandler_GalaxyMap oPanel;
    local SFXGalaxyMapObject o;
    local SFXPlanetFeature F;
    local array<Vector2D> aLocations;
    local Vector vWorldLoc;
    local Vector2D V;
    local Vector4 vOffScreen;
    local SFXGUISceneView SceneView;
    local BioSeqAct_MultiLand GameData;
    
    GameData = GetGameData();
    oPanel = Class'SFXGUIInteraction'.static.GetInstance().GetGalaxyMap(Outer);
    if (oPanel != None)
    {
        SceneView = oPanel.GetGUISceneView();
        foreach GameData.CurrentPlanet.Children(o, )
        {
            F = SFXPlanetFeature(o);
            if (F == None || F.FeatureType != EFeatureType.FEATURE_LANDINGSITE)
            {
                continue;
            }
            if (F.IsUsable() && F.IsVisible())
            {
                vWorldLoc = GameData.Planet.LocalToWorld(F.Position);
                oPanel.WorldToScreenFast(SceneView, vWorldLoc, V, vOffScreen, FALSE);
                aLocations.AddItem(V);
            }
        }
        oPanel.AS_UpdateSystemSelectors(0, aLocations);
    }
}
public function UpdatePlanetScale(float DeltaTime)
{
    if (fRescaleTime >= fMaxRescaleTime)
    {
        bRescaling = FALSE;
        fRescaleTime = 0.0;
    }
}
public final function UpdateReticle(float fDeltaT)
{
    local Rotator Rot;
    local Vector ReticlePos;
    local bool bCanLandOld;
    
    UpdateReticleRotationFromInput(fDeltaT);
    bCanLandOld = bCanLand;
    TestLandingCondition();
    if (bCanLand != bCanLandOld && bCanLand)
    {
        Class'SFXGUIInteraction'.static.GetInstance().PlayGuiSound('GalaxyMap-HighlightPlanetLandingSite');
    }
    Rot = ReticleRot;
    ReticlePos = 100.0 * Vector(ReticleRot);
    ReticleEffect.SetTranslation(ReticlePos);
    Rot.Pitch -= int(float(90) * 182.044449);
    ReticleEffect.SetRotation(Rot);
}
public final function UpdateReticleRotationFromInput(float fDeltaT)
{
    ScanReticleInputMovement.Z = 0.0;
    if (VSize2D(ScanReticleInputMovement) > 1.0)
    {
        ScanReticleInputMovement = Normal(ScanReticleInputMovement);
    }
    ReticleRot.Yaw -= int(182.044449 * (ScanReticleInputMovement.X * ReticleDegreesPerSecond * fDeltaT));
    ReticleRot.Pitch += int(182.044449 * (ScanReticleInputMovement.Y * ReticleDegreesPerSecond * fDeltaT));
    ReticleRot.Yaw = Clamp(ReticleRot.Yaw, ReticleRotBottomRightClamp.Yaw, ReticleRotTopLeftClamp.Yaw);
    ReticleRot.Pitch = Clamp(ReticleRot.Pitch, ReticleRotBottomRightClamp.Pitch, ReticleRotTopLeftClamp.Pitch);
    ScanReticleInputMovement.X = 0.0;
    ScanReticleInputMovement.Y = 0.0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BioCameraBehaviorGalaxy Name=GalaxyCam0
    End Template
    Begin Template Class=SFXCameraTransition_GalaxyMap Name=InstantTransition0
    End Template
    ReticleRotStart = {Pitch = 639, Yaw = 59569, Roll = 0}
    ReticleRotTopLeftClamp = {Pitch = 9100, Yaw = 68000, Roll = 0}
    ReticleRotBottomRightClamp = {Pitch = -9100, Yaw = 50500, Roll = 0}
    ReticleDegreesPerSecond = 90.0
    InputAttenuation = 0.0500000007
    ReticleScale = 0.150000006
    SelectDistance = 20.0
    GalaxyCam = GalaxyCam0
    InstantTransition = InstantTransition0
}