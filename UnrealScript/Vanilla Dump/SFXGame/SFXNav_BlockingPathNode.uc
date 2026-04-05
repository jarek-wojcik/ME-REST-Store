Class SFXNav_BlockingPathNode extends PathNode
    native
    placeable
    abstract;

var(SFXNav_BlockingPathNode) BlockingVolume PathBlockingVolume;
var transient bool bRemovedFromInclusionaryList;

public simulated function EndPathMove(Actor Mover)
{
    if (PathBlockingVolume != None)
    {
        if (PathBlockingVolume.bInclusionaryList)
        {
            if (bRemovedFromInclusionaryList)
            {
                PathBlockingVolume.lstAffectedActors.AddItem(Mover.Tag);
            }
        }
        else
        {
            PathBlockingVolume.lstAffectedActors.RemoveItem(Mover.Tag);
        }
    }
}
public simulated function StartPathMove(Actor Mover)
{
    bRemovedFromInclusionaryList = FALSE;
    if (PathBlockingVolume != None)
    {
        if (PathBlockingVolume.lstAffectedActors.Length == 0)
        {
            PathBlockingVolume.bInclusionaryList = FALSE;
        }
        if (PathBlockingVolume.bInclusionaryList)
        {
            if (PathBlockingVolume.lstAffectedActors.Find(Mover.Tag) != -1)
            {
                bRemovedFromInclusionaryList = TRUE;
                PathBlockingVolume.lstAffectedActors.RemoveItem(Mover.Tag);
            }
        }
        else
        {
            PathBlockingVolume.lstAffectedActors.AddItem(Mover.Tag);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=CylinderComponent Name=CollisionCylinder
        ReplacementPrimitive = None
    End Template
    CylinderComponent = CollisionCylinder
    Components = (None, None, None, CollisionCylinder, None)
    CollisionComponent = CollisionCylinder
}