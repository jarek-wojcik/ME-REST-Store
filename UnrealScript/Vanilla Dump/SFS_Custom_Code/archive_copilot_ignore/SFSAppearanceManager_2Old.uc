Class SFSAppearanceManager extends SFSManager within SFXPawn;

public function CopyAppearanceSelf(SFXPawn src)
{
    CopyAppearance(src, Outer);
}
public function CopyAppearance(SFXPawn src, SFXPawn trg)
{
    local SkeletalMeshComponent srcSkel;
    local SkeletalMeshComponent dstSkel;
    local int i;
    
    if (src == None || trg == None)
    {
        return;
    }
    // Try copy primary skeletal mesh and common mesh-level fields
    srcSkel = src.Mesh;
    dstSkel = trg.Mesh;
    if (srcSkel != None && dstSkel != None)
    {
        // Copy skeletal mesh reference (best-effort)
        dstSkel.SkeletalMesh = srcSkel.SkeletalMesh;
        // Copy common material array or material slots if available
        // Prefer direct array copy if the engine exposes it; otherwise attempt simple assignments
        // fallback: attempt to copy material slots by index (if supported)
        for (i = 0; i < 8; i++)
        {
            // Guarded calls: many projects expose SetMaterial/GetMaterial
            if (srcSkel.GetMaterial != None && dstSkel.SetMaterial != None)
            {
                dstSkel.SetMaterial(i, srcSkel.GetMaterial(i));
            }
        }
        // Copy animation related templates/sets where present
        if (SFXPawn_Henchman(src) != None && SFXPawn_PlayerMP(trg) != None)
        {
            logHenchmanAndTargetStuff(SFXPawn_Henchman(src), SFXPawn_PlayerMP(trg));
            copyOtherProperties(SFXPawn_Henchman(src), SFXPawn_PlayerMP(trg));
            AttachHeadMeshToBody(SFXPawn_PlayerMP(trg));
            CopyHeadMaterials(SFXPawn_Henchman(src), SFXPawn_PlayerMP(trg));
            //setupAnimations(SFXPawn_Henchman(src), SFXPawn_PlayerMP(trg));
        }
        dstSkel.bForceRefpose = srcSkel.bForceRefpose;
    }
}
public function copyOtherProperties(SFXPawn_Henchman src, SFXPawn_PlayerMP trg)
{
    trg.bHeadGearVisible = src.bHeadGearVisible;
    trg.HeadMesh = src.HeadMesh;
    trg.m_oHairMesh = src.m_oHairMesh;
    trg.m_oHeadGearMesh = src.m_oHeadGearMesh;
    trg.m_oVisorMesh = src.m_oVisorMesh;
    trg.m_oFacePlateMesh = src.m_oFacePlateMesh;
    trg.LightEnvironment = src.LightEnvironment;
    trg.CombatVocVariants = src.CombatVocVariants;
    trg.CombatVoc = src.CombatVoc;
    trg.PlayerCombatVoc = src.CombatVoc;
}
public function setupAnimations(SFXPawn_Henchman src, SFXPawn_PlayerMP trg)
{
    local SkeletalMeshComponent srcSkel;
    local SkeletalMeshComponent trgSkel;
    local AnimSet animIterator;
    local WeaponAnimSpec iterator;
    local SFXWeapon targetWeapon;
    
    srcSkel = src.Mesh;
    trgSkel = trg.Mesh;
    if (srcSkel.AnimTreeTemplate != None)
    {
        trgSkel.SetAnimTreeTemplate(srcSkel.AnimTreeTemplate);
    }
    if (srcSkel.AnimSets.Length > 0)
    {
        trgSkel.AnimSets = srcSkel.AnimSets;
    }
    if (src.WeaponAnimSpecs.Length > 0)
    {
        targetWeapon = SFXWeapon(trg.Weapon);
        trg.WeaponAnimSpecs = src.WeaponAnimSpecs;
        log(Self.Name, "Setting up weapon animations for  " $ targetWeapon, Outer);
        trg.SetupWeaponAnimations(targetWeapon, None);
    }
}
public function AttachHeadMeshToBody(SFXPawn_PlayerMP TargetMP)
{
    log(Self.Name, "AttachHeadMeshToBody: start", Outer);
    log(Self.Name, "AttachHeadMeshToBody: bAttached=" $ TargetMP.HeadMesh.bAttached $ " Owner=" $ TargetMP.HeadMesh.Owner, Outer);
    // Always set these properties
    TargetMP.HeadMesh.bOverrideParentSkeleton = TRUE;
    TargetMP.HeadMesh.nmOverrideStartBoneName = 'headBase';
    TargetMP.HeadMesh.SetParentAnimComponent(TargetMP.Mesh);
    TargetMP.HeadMesh.SetShadowParent(TargetMP.Mesh);
    TargetMP.HeadMesh.SetLightEnvironment(TargetMP.LightEnvironment);
    // Attach to target if not already attached to THIS pawn
    if (!TargetMP.HeadMesh.bAttached || TargetMP.HeadMesh.Owner != TargetMP)
    {
        TargetMP.AttachComponent(TargetMP.HeadMesh);
        log(Self.Name, "AttachHeadMeshToBody: Head mesh attached to target", Outer);
    }
    TargetMP.HeadMesh.UpdateParentBoneMap();
    log(Self.Name, "AttachHeadMeshToBody: After attach - bAttached=" $ TargetMP.HeadMesh.bAttached $ " Owner=" $ TargetMP.HeadMesh.Owner, Outer);
    // Start monitoring timer
    TargetMP.SetTimer(2.0, TRUE, 'CheckHeadMeshRef', Self);
    log(Self.Name, "AttachHeadMeshToBody: Started HeadMesh monitoring timer", Outer);
}
public function CheckHeadMeshRef()
{
    local SFXPawn_PlayerMP TargetMP;
    
    TargetMP = SFXPawn_PlayerMP(Outer);
    if (TargetMP != None)
    {
        log(Self.Name, "CheckHeadMeshRef: HeadMesh=" $ TargetMP.HeadMesh $ " bAttached=" $ TargetMP.HeadMesh.bAttached $ " Owner=" $ TargetMP.HeadMesh.Owner, Outer);
    }
    else
    {
        log(Self.Name, "CheckHeadMeshRef: Target pawn is None, clearing timer", Outer);
        Outer.ClearTimer('CheckHeadMeshRef', Self);
    }
    if (TargetMP.HeadMesh == None)
    {
        log(Self.Name, "CheckHeadMeshRef: HEAD IS GONE, clearing timer", Outer);
        Outer.ClearTimer('CheckHeadMeshRef', Self);
    }
}
public function CopyHeadMaterials(SFXPawn SourcePawn, SFXPawn_PlayerMP TargetMP)
{
    local int i;
    
    log(Self.Name, "CopyHeadMaterials: start", Outer);
    for (i = 0; i < SourcePawn.HeadMesh.GetNumElements(); i++)
    {
        if (SourcePawn.HeadMesh.GetMaterial(i) != None)
        {
            TargetMP.HeadMesh.SetMaterial(i, SourcePawn.HeadMesh.GetMaterial(i));
        }
    }
    log(Self.Name, "CopyHeadMaterials: Copied materials from source head", Outer);
}
public function logHenchmanAndTargetStuff(SFXPawn_Henchman src, SFXPawn_PlayerMP trg)
{
    local SkeletalMeshComponent srcSkel;
    local SkeletalMeshComponent dstSkel;
    
    srcSkel = src.Mesh;
    dstSkel = trg.Mesh;
    log(Self.Name, "logHenchmanAndTargetStuff", Outer);
    //General Variables
    log(Self.Name, "trg.bHelmetHidesHead " $ trg.bHelmetHidesHead, Outer);
    log(Self.Name, "trg.bHelmetHidesHead " $ trg.bHelmetHidesHead, Outer);
    log(Self.Name, "trg.bHeadGearVisible " $ trg.bHeadGearVisible, Outer);
    log(Self.Name, "trg.isHeadBoneHIdden " $ trg.Mesh.IsBoneHidden(trg.Mesh.MatchRefBone('Head')), Outer);
    log(Self.Name, "trg.headMesh.AttachedToSkelComponent " $ trg.HeadMesh.AttachedToSkelComponent, Outer);
    log(Self.Name, "trg.HeadMesh.ParentAnimComponent " $ trg.HeadMesh.ParentAnimComponent, Outer);
    log(Self.Name, "src.bHelmetHidesHead " $ src.bHelmetHidesHead, Outer);
    log(Self.Name, "src.bHelmetHidesHead " $ src.bHelmetHidesHead, Outer);
    log(Self.Name, "src.bHeadGearVisible " $ src.bHeadGearVisible, Outer);
    log(Self.Name, "src.isHeadBoneHIdden " $ src.Mesh.IsBoneHidden(trg.Mesh.MatchRefBone('Head')), Outer);
    log(Self.Name, "src.headMesh.AttachedToSkelComponent " $ src.HeadMesh.AttachedToSkelComponent, Outer);
    log(Self.Name, "src.HeadMesh.ParentAnimComponent " $ src.HeadMesh.ParentAnimComponent, Outer);
    //Parent Anim Component
    //log(Self.Name, "srcSkel.ParentAnimComponent " $ srcSkel.ParentAnimComponent, Outer);
    //log(Self.Name, "trgSkel.ParentAnimComponent " $ dstSkel.ParentAnimComponent, Outer);
    //Mesh Attachments
    //printAttachments(Self.Name, Outer, src.Mesh.Attachments, "src.Mesh.Attachments");
    //printAttachments(Self.Name, Outer, trg.Mesh.Attachments, "trg.mesh.Attachments");
    //Components
    //printArrayContents(Self.Name, Outer, src.AllComponents, "src.Components");
    //printArrayContents(Self.Name, Outer, trg.AllComponents, "trg.Components");
    //Modules
    //printArrayContents(Self.Name, Outer, src.Modules, "src.Modules");
    //printArrayContents(Self.Name, Outer, trg.Modules, "trg.Modules");
    //Translation Offset
    //log(Self.Name, "src.MeshTranslationOffset " $ src.MeshTranslationOffset, Outer);
    //log(Self.Name, "trg.MeshTranslationOffset " $ trg.MeshTranslationOffset, Outer);
    //Animsets
    //printArrayContents(Self.Name, Outer, dstSkel.AnimSets, "dstSkel.AnimSets");
    //printArrayContents(Self.Name, Outer, srcSkel.AnimSets, "srcSkel.AnimSets");
    //WeaponAnimSpecs
    //printWeaponAnimSpecs(Self.Name, Outer, src.WeaponAnimSpecs, "src.WeaponAnimSpecs");
    //printWeaponAnimSpecs(Self.Name, Outer, trg.WeaponAnimSpecs, "trg.WeaponAnimSpecs");
}
function printAttachments(Name callerName, Pawn Pawn, array<Attachment> Target, string arrayName)
{
    local Attachment iterator;
    
    log(callerName, "Printing contents of " $ arrayName, Pawn);
    foreach Target(iterator, )
    {
        log(callerName, " * " $ iterator.Component $ " , BoneName " $ iterator.BoneName $ ", RelativeLocation " $ iterator.RelativeLocation $ ", RelativeRotation " $ iterator.RelativeRotation $ ", RelativeScale " $ iterator.RelativeScale, Pawn);
    }
}
function printWeaponAnimSpecs(Name callerName, Pawn Pawn, array<WeaponAnimSpec> Target, string arrayName)
{
    local WeaponAnimSpec iterator;
    local int iteratorInt;
    
    log(callerName, "Printing contents of " $ arrayName, Pawn);
    foreach Target(iterator, iteratorInt)
    {
        printArrayContents(Self.Name, Outer, iterator.m_animSets, iteratorInt $ " : m_animSets");
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}