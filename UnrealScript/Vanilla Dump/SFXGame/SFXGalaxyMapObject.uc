Class SFXGalaxyMapObject
    native
    abstract
    config(Game);

enum EGalaxyObjectUsableAutoSet
{
    GalaxyObjectUsable_Unset,
};
enum EGalaxyObjectUsablePlotAutoSet
{
    GalaxyObjectUsablePlot_Unset,
};
enum EGalaxyObjectVisibleAutoSet
{
    GalaxyObjectVisible_Unset,
};
enum EGalaxyObjectVisiblePlotAutoSet
{
    GalaxyObjectVisiblePlot_Unset,
};
enum ESFXGalaxyMapObjectLevel
{
    GalaxyMapObjType_Undefined,
    GalaxyMapObjType_GalaxyLevel,
    GalaxyMapObjType_ClusterLevel,
    GalaxyMapObjType_SystemLevel,
    GalaxyMapObjType_PlanetLevel,
};

var transient string Tag;
var array<SFXGalaxyMapObject> Children;
var editinline transient export array<ActorComponent> TemporaryComponents;
var(Kismet) Name VisitedEvent;
var(Kismet) Name VisitedEventParam;
var int PosX;
var int PosY;
var transient int TableID;
var(Label) stringref DisplayName;
var(Appearance) float Scale;
var(Appearance) SFXGalaxyMapObjectAppearanceBase Appearance;
var transient int nPreviouslySelectedIndex;
var int VisibleConditional;
var(Conditions) int VisibleParameter;
var int UsableConditional;
var(Conditions) int UsableParameter;
var config float m_fScanDetectionRange;
var transient Actor ObjectActor;
var bool VirtualObject;
var transient bool ActorSpawned;
var(Conditions) EBioRegionAutoSet VisibleConditionalRegion;
var(Conditions) EGalaxyObjectVisiblePlotAutoSet VisibleConditionalPlot;
var(Conditions) EGalaxyObjectVisibleAutoSet VisibleConditionalName;
var(Conditions) EBioRegionAutoSet UsableConditionalRegion;
var(Conditions) EGalaxyObjectUsablePlotAutoSet UsableConditionalPlot;
var(Conditions) EGalaxyObjectUsableAutoSet UsableConditionalName;
var ESFXGalaxyMapObjectLevel MapObjectLevel;

public event function AddChild(SFXGalaxyMapObject oChild)
{
    if (oChild != None && Children.Find(oChild) == -1)
    {
        Children.AddItem(oChild);
    }
}
public event function AssociateActor(Name nmAssociation, Actor oActor);

public final event function AttachTemporaryComponent(ActorComponent oComponent)
{
    if (ObjectActor != None)
    {
        ObjectActor.AttachComponent(oComponent);
    }
    TemporaryComponents.AddItem(oComponent);
}
public event function bool BuildPlotLabelList(out array<stringref> aPlotNames, optional EBioGalaxyMapState eMapLevel = 0)
{
    local SFXGalaxyMapObject oChild;
    local bool bHasCritPath;
    local bool bChildCritPath;
    
    if (IsVisible() && IsUsable())
    {
        foreach Children(oChild, )
        {
            if (oChild != None)
            {
                bChildCritPath = oChild.BuildPlotLabelList(aPlotNames, eMapLevel);
                bHasCritPath = bHasCritPath || bChildCritPath;
            }
        }
    }
    return bHasCritPath;
}
public event function bool CanBeScanned()
{
    return FALSE;
}
public final native function CleanActor(Actor oActorToClean);

public event function CleanTransientData()
{
    local int i;
    local SFXGalaxyMapObject oChild;
    
    foreach Children(oChild, )
    {
        oChild.CleanTransientData();
    }
    for (i = 0; i < TemporaryComponents.Length; i++)
    {
        if (ParticleSystemComponent(TemporaryComponents[i]) != None)
        {
            ParticleSystemComponent(TemporaryComponents[i]).DeactivateSystem();
        }
        if (ObjectActor != None)
        {
            ObjectActor.DetachComponent(TemporaryComponents[i]);
        }
    }
    if (ActorSpawned)
    {
        CleanActor(ObjectActor);
        ActorSpawned = FALSE;
    }
    ObjectActor = None;
}
public final native function int CountChildren(Class<SFXGalaxyMapObject> childClassType);

public final native function SFXGalaxyMapObject CreateChild(Class<SFXGalaxyMapObject> childClass);

public static final native function DecodeWorldID(int nWorldID, out int nCluster, out int nSystem, out int nPlanet);

public final event function DetachTemporaryComponent(ActorComponent oComponent)
{
    if (ObjectActor != None)
    {
        ObjectActor.DetachComponent(oComponent);
    }
    TemporaryComponents.RemoveItem(oComponent);
}
public static final native function int EncodeWorldID(int nCluster, int nSystem, int nPlanet);

public final native function SFXGalaxyMapObject GetChildWithID(int nTableId);

public static final native function int GetClusterFromID(int nWorldID);

public event function string GetEditorLabel()
{
    local string sLabel;
    
    return sLabel;
}
public final event function float GetExploredPercent(EBioGalaxyMapState eMapLevel)
{
    local int nTotal;
    local int nExplored;
    
    CountObjectsForExploration(nTotal, nExplored, eMapLevel);
    if (nTotal <= 0)
    {
        return -1.0;
    }
    return float(nExplored) / float(nTotal);
}
public event function stringref GetMapTag()
{
    return DisplayName;
}
public static final native function int GetPlanetFromID(int nWorldID);

public event function Vector GetSpawnLocation(Vector vMapCenter)
{
    local Vector vLocation;
    local float fMapSize;
    
    if (SFXGalaxyMapObject(Outer) != None)
    {
        fMapSize = SFXGalaxyMapObject(Outer).GetLevelSize();
    }
    if (fMapSize <= 0.0)
    {
        return vMapCenter;
    }
    vLocation = vMapCenter;
    vLocation.X += float(PosX) / 1024.0 * fMapSize - fMapSize * 0.5;
    vLocation.Y += float(PosY) / 1024.0 * fMapSize - fMapSize * 0.5;
    return vLocation;
}
public static final native function int GetSystemFromID(int nWorldID);

public event function InitializeAppearance()
{
    local Class<Object> oClass;
    local Class<SFXGalaxyMapObjectAppearanceBase> oAppearanceClass;
    local SFXGalaxyMapObjectAppearanceBase oNewAppearance;
    
    return;
}
public final event function InitObjectActor(Actor pActor, BioCameraBehaviorGalaxy pGalaxy)
{
    ObjectActor = pActor;
    if (Appearance != None)
    {
        Appearance.OnObjectSpawned(pActor, pGalaxy);
    }
}
public event function bool IsSelectable()
{
    return FALSE;
}
public final event function bool IsUsable()
{
    local bool bUsable;
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    bUsable = FALSE;
    if (oBWI != None)
    {
        bUsable = oBWI.CheckConditional(UsableConditional, UsableParameter);
    }
    return bUsable;
}
public final event function bool IsVisible()
{
    local bool bVisible;
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    bVisible = FALSE;
    if (oBWI != None)
    {
        bVisible = oBWI.CheckConditional(VisibleConditional, VisibleParameter);
    }
    return bVisible;
}
public event function bool IsVisitedInMap()
{
    return FALSE;
}
public event function bool MapTagIsVisible()
{
    local array<stringref> aPlots;
    
    if (IsVisible() && IsUsable())
    {
        BuildPlotLabelList(aPlots);
        return aPlots.Length > 0;
    }
    return FALSE;
}
public event function ObjectLeft();

public event function ObjectVisited()
{
    if (VisitedEvent != 'None')
    {
        GetGalaxyBehavior().TriggerEvent(VisitedEvent, VisitedEventParam);
    }
}
public event function OnEditorCreate()
{
    InitializeAppearance();
}
public event function OnScanned(Object oScanInstigator, Vector vScanOrigin);

public event function RemoveChild(SFXGalaxyMapObject Child)
{
    Children.RemoveItem(Child);
}
public event function SetEditorPosition(int nX, int nY)
{
    PosX = nX;
    PosY = nY;
}
public event function Actor Spawn(BioCameraBehaviorGalaxy pGalaxy, Vector vLocation, optional Name nmTag = 'None')
{
    local Class<Actor> oActorClass;
    local Actor oNewActor;
    
    if (Appearance == None || Appearance.RequiresActor() == FALSE)
    {
        return None;
    }
    oActorClass = Class'DynamicSMActor_Spawnable';
    if (Appearance.SkeletalMeshResource != None)
    {
        oActorClass = Class'SkeletalMeshActorSpawnable';
    }
    oNewActor = SpawnGalaxyActor(oActorClass, vLocation, nmTag);
    if (oNewActor == None)
    {
        return None;
    }
    ActorSpawned = TRUE;
    InitObjectActor(oNewActor, pGalaxy);
    return oNewActor;
}
public function Tick(BioCameraBehaviorGalaxy oGalaxy, float fDeltaT)
{
    if (Appearance != None)
    {
        Appearance.Tick(oGalaxy, fDeltaT);
    }
}
public event function TickChildren(BioCameraBehaviorGalaxy oGalaxy, float fDeltaT)
{
    local SFXGalaxyMapObject oChild;
    
    foreach Children(oChild, )
    {
        if (oChild != None)
        {
            oChild.Tick(oGalaxy, fDeltaT);
        }
    }
}
public function CountObjectsForExploration(out int nObjectCount, out int nExploredCount, EBioGalaxyMapState eMapLevel)
{
    local SFXGalaxyMapObject oChild;
    
    foreach Children(oChild, )
    {
        if (oChild != None && oChild.IsVisible() && oChild.IsUsable())
        {
            oChild.CountObjectsForExploration(nObjectCount, nExploredCount, eMapLevel);
        }
    }
}
public final function BioCameraBehaviorGalaxy GetGalaxyBehavior()
{
    local BioWorldInfo oBWI;
    local BioPlayerController oPC;
    
    oBWI = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo());
    if (oBWI == None)
    {
        return None;
    }
    oPC = oBWI.GetLocalPlayerController();
    if (oPC == None)
    {
        return None;
    }
    return BioCameraBehaviorGalaxy(oPC.GameModeManager2.HACK_GetCameraMode(11));
}
public function float GetLevelSize()
{
    return -1.0;
}
public function bool HasFeaturesToCountForExploration()
{
    return FALSE;
}
public final function Actor SpawnGalaxyActor(Class<Actor> oActorClass, Vector vLocation, optional Name nmTag = 'None')
{
    local Actor oNewActor;
    local BioPlayerController oPC;
    local Rotator rotRotation;
    
    oPC = BioWorldInfo(Class'Engine'.static.GetCurrentWorldInfo()).GetLocalPlayerController();
    if (oPC == None)
    {
        return None;
    }
    oNewActor = oPC.Spawn(oActorClass, oPC, nmTag, vLocation);
    oNewActor.SetRotation(rotRotation);
    return oNewActor;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TableID = -1
    Scale = 1.0
    VisibleConditional = 13
    UsableConditional = 13
    m_fScanDetectionRange = -1.0
}