Class SFXGalaxyMapObjectAppearanceBase within SFXGalaxyMapObject
    native
    editinlinenew;

var(SFXGalaxyMapObjectAppearanceBase) array<MaterialInterface> MaterialOverrides;
var(SFXGalaxyMapObjectAppearanceBase) Rotator MeshRotation;
var(SFXGalaxyMapObjectAppearanceBase) Rotator MeshRotationSpeed;
var(SFXGalaxyMapObjectAppearanceBase) float MeshScale;
var(SFXGalaxyMapObjectAppearanceBase) StaticMesh MeshResource;
var(SFXGalaxyMapObjectAppearanceBase) SkeletalMesh SkeletalMeshResource;
var transient float m_fAccumulatedRotationTime;
var(SFXGalaxyMapObjectAppearanceBase) bool NoAppearance;

public function Tick(BioCameraBehaviorGalaxy pGalaxy, float fDeltaT)
{
    local Rotator rotDelta;
    
    m_fAccumulatedRotationTime += fDeltaT;
    if (RSize(MeshRotationSpeed) > float(0) && Outer.ObjectActor != None)
    {
        rotDelta = m_fAccumulatedRotationTime * MeshRotationSpeed;
        if (DynamicSMActor(Outer.ObjectActor) != None)
        {
            DynamicSMActor(Outer.ObjectActor).StaticMeshComponent.SetRotation(rotDelta);
        }
        else if (SkeletalMeshActor(Outer.ObjectActor) != None)
        {
            SkeletalMeshActor(Outer.ObjectActor).SkeletalMeshComponent.SetRotation(rotDelta);
        }
        Outer.ObjectActor.SetRotation(MeshRotation);
    }
}
public function OnObjectSpawned(Actor oObjectActor, BioCameraBehaviorGalaxy pGalaxy)
{
    local DynamicSMActor oStaticMeshActor;
    local SkeletalMeshActor oSkelMeshActor;
    local MeshComponent oMeshComp;
    local int nMaterial;
    
    if (MeshResource != None || SkeletalMeshResource != None)
    {
        oStaticMeshActor = DynamicSMActor(oObjectActor);
        if (oStaticMeshActor != None)
        {
            oStaticMeshActor.StaticMeshComponent.SetStaticMesh(MeshResource);
            oMeshComp = oStaticMeshActor.StaticMeshComponent;
        }
        else if (SkeletalMeshActor(oObjectActor) != None)
        {
            oSkelMeshActor = SkeletalMeshActor(oObjectActor);
            oSkelMeshActor.SkeletalMeshComponent.SetSkeletalMesh(SkeletalMeshResource);
            oMeshComp = oSkelMeshActor.SkeletalMeshComponent;
        }
        if (oMeshComp != None)
        {
            oMeshComp.SetRotation(MeshRotation);
            oMeshComp.SetScale(MeshScale);
            oObjectActor.SetCollision(FALSE, FALSE, TRUE);
            oObjectActor.SetCollisionType(1);
            for (nMaterial = 0; nMaterial < MaterialOverrides.Length; ++nMaterial)
            {
                if (MaterialOverrides[nMaterial] != None)
                {
                    oMeshComp.SetMaterial(nMaterial, MaterialOverrides[nMaterial]);
                }
            }
        }
    }
}
public function bool RequiresActor()
{
    return NoAppearance || MeshResource != None || SkeletalMeshResource != None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MeshScale = 1.0
}