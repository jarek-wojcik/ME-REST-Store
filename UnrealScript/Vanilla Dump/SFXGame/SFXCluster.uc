Class SFXCluster extends SFXGalaxyMapObject
    native
    config(Game);

var array<SFXSystem> Systems;
var array<SFXCluster> RelayConnections;
var(Appearance) LinearColor StarColor;
var(Appearance) LinearColor StarColor2;
var(Appearance) Texture2D ClusterTexture;
var(Appearance) float NebularDensity;
var(Appearance) float CloudTile;
var(Appearance) float SphereIntensity;
var(Appearance) float SphereSize;
var(Label) bool ExploredCluster;

public event function AddChild(SFXGalaxyMapObject oChild)
{
    Super.AddChild(oChild);
    if (SFXSystem(oChild) != None && Systems.Find(oChild) == -1)
    {
        Systems.AddItem(oChild);
    }
}
public final event function bool IsReaperControlled()
{
    local SFXGalaxyMapObject o;
    local SFXSystem S;
    
    foreach Children(o, )
    {
        S = SFXSystem(o);
        if (S != None)
        {
            if (S.IsReaperControlled())
            {
                return TRUE;
            }
        }
    }
    return FALSE;
}
public event function RemoveChild(SFXGalaxyMapObject Child)
{
    local int i;
    
    i = Systems.Find(Child);
    if (i != -1)
    {
        Systems[i] = None;
    }
    Super.RemoveChild(Child);
}
public function CountObjectsForExploration(out int nObjectCount, out int nExploredCount, EBioGalaxyMapState eMapLevel)
{
    local SFXGalaxyMapObject o;
    local SFXSystem oSystem;
    local bool bShouldCount;
    
    foreach Children(o, )
    {
        oSystem = SFXSystem(o);
        if (oSystem != None && oSystem.ShouldCountSystemObjectsForExploration())
        {
            bShouldCount = TRUE;
            break;
        }
    }
    if (bShouldCount)
    {
        Super.CountObjectsForExploration(nObjectCount, nExploredCount, eMapLevel);
    }
}
public final function EnumerateSystems()
{
    local SFXSystem S;
    local int i;
    
    foreach Systems(S, i)
    {
        if (S != None)
        {
            S.TableID = i;
            S.Tag $= Right("0" $ i, 2);
            S.EnumeratePlanets(Self);
        }
    }
}
public function float GetLevelSize()
{
    return 630.0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StarColor = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    StarColor2 = {R = 0.0, G = 0.0, B = 0.0, A = 1.0}
    Tag = "Cluster"
    MapObjectLevel = ESFXGalaxyMapObjectLevel.GalaxyMapObjType_GalaxyLevel
}