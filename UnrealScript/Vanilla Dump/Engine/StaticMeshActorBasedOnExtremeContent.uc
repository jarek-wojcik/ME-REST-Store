Class StaticMeshActorBasedOnExtremeContent extends Actor
    native
    placeable;

struct native SMMaterialSetterDatum 
{
    var(SMMaterialSetterDatum) int MaterialIndex;
    var(SMMaterialSetterDatum) MaterialInterface TheMaterial;
};

var(StaticMeshActorBasedOnExtremeContent) array<SMMaterialSetterDatum> ExtremeContent;
var(StaticMeshActorBasedOnExtremeContent) array<SMMaterialSetterDatum> NonExtremeContent;
var(StaticMeshActorBasedOnExtremeContent) const editinline editconst export StaticMeshComponent StaticMeshComponent;

public event simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetMaterialBasedOnExtremeContent();
}
public simulated function SetMaterialBasedOnExtremeContent()
{
    local int idx;
    
    if (WorldInfo.GRI.ShouldShowGore())
    {
        for (idx = 0; idx < ExtremeContent.Length; ++idx)
        {
            StaticMeshComponent.SetMaterial(ExtremeContent[idx].MaterialIndex, ExtremeContent[idx].TheMaterial);
        }
    }
    else
    {
        for (idx = 0; idx < NonExtremeContent.Length; ++idx)
        {
            StaticMeshComponent.SetMaterial(NonExtremeContent[idx].MaterialIndex, NonExtremeContent[idx].TheMaterial);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
        bAllowApproximateOcclusion = TRUE
        bForceDirectLightMap = TRUE
        bUsePrecomputedShadows = TRUE
    End Object
    StaticMeshComponent = StaticMeshComponent0
    Components = (StaticMeshComponent0)
    CollisionComponent = StaticMeshComponent0
    bStatic = TRUE
    bWorldGeometry = TRUE
    bGameRelevant = TRUE
    bMovable = FALSE
    bCollideActors = TRUE
    bBlockActors = TRUE
    bEdShouldSnap = TRUE
}