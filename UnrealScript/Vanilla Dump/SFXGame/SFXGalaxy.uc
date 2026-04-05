Class SFXGalaxy extends SFXGalaxyMapObject
    native
    config(Game);

var array<SFXCluster> Clusters;
var float m_fGalaxyRadius;

public event function AddChild(SFXGalaxyMapObject oChild)
{
    Super.AddChild(oChild);
    if (SFXCluster(oChild) != None && Clusters.Find(oChild) == -1)
    {
        Clusters.AddItem(oChild);
    }
}
public final event function EnumerateClusters()
{
    local SFXCluster C;
    local int i;
    
    foreach Clusters(C, i)
    {
        if (C != None)
        {
            C.TableID = i;
            C.Tag $= Right("0" $ i, 2);
            C.EnumerateSystems();
        }
    }
}
public event function RemoveChild(SFXGalaxyMapObject Child)
{
    local int i;
    
    i = Clusters.Find(Child);
    if (i != -1)
    {
        Clusters[i] = None;
    }
    Super.RemoveChild(Child);
}
public function float GetLevelSize()
{
    return 630.0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Tag = "Galaxy"
}