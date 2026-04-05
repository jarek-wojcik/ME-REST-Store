class SFXAppearanceHelper extends Object;

/*
  Best-effort helper to copy appearance-related fields from one SFXPawn to another.
  This function attempts to copy skeletal mesh references, material arrays, animation
  templates/sets and obvious static-mesh materials. It uses guarded checks so it
  has minimal risk when some components/properties are missing on either pawn.

  Notes: UE3/UnrealScript APIs vary between projects; adjust field & method names
  for your build if needed (for example: `SkeletalMesh`, `Materials`, `AnimTreeTemplate`).
*/
static function CopyAppearance(class SFXPawn Source, class SFXPawn Target)
{
    if (Source == None || Target == None)
        return;

    local SkeletalMeshComponent srcSkel;
    local SkeletalMeshComponent dstSkel;
    local StaticMeshComponent srcStatic;
    local StaticMeshComponent dstStatic;
    local int i;
    local int j;
    local name compName;

    // Try copy primary skeletal mesh and common mesh-level fields
    srcSkel = SkeletalMeshComponent(Source.Mesh);
    dstSkel = SkeletalMeshComponent(Target.Mesh);

    if (srcSkel != None && dstSkel != None)
    {
        // Copy skeletal mesh reference (best-effort)
        dstSkel.SkeletalMesh = srcSkel.SkeletalMesh;

        // Copy common material array or material slots if available
        // Prefer direct array copy if the engine exposes it; otherwise attempt simple assignments
        if (srcSkel.Materials != None)
        {
            dstSkel.Materials = srcSkel.Materials;
        }
        else
        {
            // fallback: attempt to copy material slots by index (if supported)
            for (i = 0; i < 8; i++)
            {
                // Guarded calls: many projects expose SetMaterial/GetMaterial
                if (srcSkel.GetMaterial != None && dstSkel.SetMaterial != None)
                {
                    dstSkel.SetMaterial(i, srcSkel.GetMaterial(i));
                }
            }
        }

        // Copy animation related templates/sets where present
        if (srcSkel.AnimTreeTemplate != None)
            dstSkel.AnimTreeTemplate = srcSkel.AnimTreeTemplate;

        if (srcSkel.AnimSets != None)
            dstSkel.AnimSets = srcSkel.AnimSets;

        if (scriptIterator(srcSkel) != None) // harmless guard for projects without these props
            dstSkel.bForceRefPose = srcSkel.bForceRefPose;
    }

    // Try copy static-mesh components and their materials by matching component names
    // This loop is best-effort: component APIs differ between projects.
    if (Source.Components != None && Target.Components != None)
    {
        for (i = 0; i < Source.Components.Length; i++)
        {
            srcStatic = StaticMeshComponent(Source.Components[i]);
            if (srcStatic == None)
                continue;

            compName = Source.Components[i].GetName();
            dstStatic = StaticMeshComponent(Target.FindComponentByName(compName));
            if (dstStatic == None)
                continue;

            dstStatic.StaticMesh = srcStatic.StaticMesh;

            if (srcStatic.Materials != None)
            {
                dstStatic.Materials = srcStatic.Materials;
            }
            else
            {
                for (j = 0; j < 8; j++)
                {
                    if (srcStatic.GetMaterial != None && dstStatic.SetMaterial != None)
                        dstStatic.SetMaterial(j, srcStatic.GetMaterial(j));
                }
            }
        }
    }

    // Additional appearance fields can be copied here as needed (skins, decals, VFX attachments, etc.)
}

defaultproperties
{
}
