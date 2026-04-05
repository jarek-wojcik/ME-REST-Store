Class SFXCustomizationInstance
    abstract;

public final function ApplyMaterialTinting(Actor InTarget)
{
    local SkeletalMeshComponent MeshCmpt;
    local MaterialInstanceConstant MIC;
    local int MeshElementID;
    local MaterialInterface CurrentMaterial;
    
    foreach InTarget.ComponentList(Class'SkeletalMeshComponent', MeshCmpt)
    {
        for (MeshElementID = 0; MeshElementID < MeshCmpt.GetNumElements(); ++MeshElementID)
        {
            MIC = None;
            CurrentMaterial = MeshCmpt.GetBaseMaterial(MeshElementID);
            if (CurrentMaterial == None)
            {
            }
            else if (CurrentMaterial.Outer == InTarget)
            {
                MIC = MaterialInstanceConstant(CurrentMaterial);
            }
            if (MIC == None)
            {
                MIC = new (InTarget) Class'MaterialInstanceConstant';
                MIC.SetParent(CurrentMaterial);
                MeshCmpt.SetMaterial(MeshElementID, MIC);
            }
            CustomizeMaterialInstance(MIC);
        }
    }
}
public function CustomizeMaterialInstance(MaterialInstanceConstant MIC);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}