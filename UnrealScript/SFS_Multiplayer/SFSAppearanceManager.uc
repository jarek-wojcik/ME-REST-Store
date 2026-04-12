Class SFSAppearanceManager extends SFSManager within SFXPawn;

var AnimTree crouchAnimTree;
var array<int> idsWithHelmet;

public function CopyAppearanceSelf(SFXPawn src, string Id, bool b_useHeadgear)
{
    CopyAppearance(src, Outer, Id, b_useHeadgear);
}
public function CopyAppearance(SFXPawn src, SFXPawn trg, string Id, bool b_useHeadgear)
{
    local SkeletalMeshComponent srcSkel;
    local SkeletalMeshComponent dstSkel;
    local SFXSkelControlLimb IKControl;
    local int i;
    local bool b_crouchMod;
    
    //DEPRECATED
    if (src == None || trg == None)
    {
        return;
    }
    else
    {
        b_crouchMod = Class'SFSDependencyCheckerUtility'.static.CheckForCrouchModPresence(BioPlayerController(Outer.Controller));
        log(Self.Name, "crouch mod is present: " $ b_crouchMod, Outer);
    }
    // Try copy primary skeletal mesh and common mesh-level fields
    srcSkel = src.Mesh;
    dstSkel = trg.Mesh;
    if (srcSkel != None && dstSkel != None)
    {
        // For copying looks from SP henchmen
        removeOldHead(SFXPawn_PlayerMP(trg));
        removeOldHair(SFXPawn_PlayerMP(trg));
        removeOldHeadgear(SFXPawn_PlayerMP(trg));
        if (SFXPawn_Henchman(src) != None && SFXPawn_PlayerMP(trg) != None)
        {
            logHenchmanAndTargetStuff(SFXPawn_Henchman(src), SFXPawn_PlayerMP(trg));
            copyAppearanceBasic(srcSkel, dstSkel);
            copyOtherProperties(SFXPawn_Henchman(src), SFXPawn_PlayerMP(trg));
            if (b_useHeadgear && HasHeadgearMesh(src) && headgearIsHelmet(int(Id)))
            {
                createHeadgearMeshFromSource(SFXPawn_PlayerMP(trg), SFXPawn_Henchman(src));
            }
            else if (b_useHeadgear && HasHeadgearMesh(src))
            {
                createHeadMeshFromSource(SFXPawn_PlayerMP(trg), SFXPawn_Henchman(src));
                createHairMeshFromSource(SFXPawn_PlayerMP(trg), SFXPawn_Henchman(src));
                createHeadgearMeshFromSource(SFXPawn_PlayerMP(trg), SFXPawn_Henchman(src));
            }
            else
            {
                createHeadMeshFromSource(SFXPawn_PlayerMP(trg), SFXPawn_Henchman(src));
                createHairMeshFromSource(SFXPawn_PlayerMP(trg), SFXPawn_Henchman(src));
            }
            trg.Mesh.SetAnimTreeTemplate(default.crouchAnimTree);
            //setupAnimations(SFXPawn_Henchman(src), SFXPawn_PlayerMP(trg)); // This breaks the crab.
        }
        else
        {
            // For copying looks from MP Kits or pawns that have a full head+body mesh.
            copyAppearanceBasic(srcSkel, dstSkel);
        }
        dstSkel.bForceRefpose = srcSkel.bForceRefpose;
        ApplyTinting(trg);
    }
}
public function CopyAppearanceWithVisuals(SFXPawn src, SFXPawn trg, bool b_useHeadgear, bool b_useHelmet)
{
    local SkeletalMeshComponent srcSkel;
    local SkeletalMeshComponent dstSkel;
    local bool b_crouchMod;
    
    if (src == None || trg == None)
    {
        return;
    }
    else
    {
        b_crouchMod = Class'SFSDependencyCheckerUtility'.static.CheckForCrouchModPresence(BioPlayerController(Outer.Controller));
        log(Self.Name, "crouch mod is present: " $ b_crouchMod, Outer);
    }
    srcSkel = src.Mesh;
    dstSkel = trg.Mesh;
    if (srcSkel != None && dstSkel != None)
    {
        removeOldHead(SFXPawn_PlayerMP(trg));
        removeOldHair(SFXPawn_PlayerMP(trg));
        removeOldHeadgear(SFXPawn_PlayerMP(trg));
        if (SFXPawn_Henchman(src) != None && SFXPawn_PlayerMP(trg) != None)
        {
            logHenchmanAndTargetStuff(SFXPawn_Henchman(src), SFXPawn_PlayerMP(trg));
            copyAppearanceBasic(srcSkel, dstSkel);
            copyOtherProperties(SFXPawn_Henchman(src), SFXPawn_PlayerMP(trg));
            // If both are true, helmet takes priority.
            if ((b_useHelmet || b_useHeadgear) && HasHeadgearMesh(src))
            {
                if (b_useHelmet)
                {
                    // Helmet: skip head/hair, only attach headgear mesh.
                    createHeadgearMeshFromSource(SFXPawn_PlayerMP(trg), SFXPawn_Henchman(src));
                }
                else
                {
                    // Headgear over visible face: copy head, hair, and headgear.
                    createHeadMeshFromSource(SFXPawn_PlayerMP(trg), SFXPawn_Henchman(src));
                    createHairMeshFromSource(SFXPawn_PlayerMP(trg), SFXPawn_Henchman(src));
                    createHeadgearMeshFromSource(SFXPawn_PlayerMP(trg), SFXPawn_Henchman(src));
                }
            }
            else
            {
                createHeadMeshFromSource(SFXPawn_PlayerMP(trg), SFXPawn_Henchman(src));
                createHairMeshFromSource(SFXPawn_PlayerMP(trg), SFXPawn_Henchman(src));
            }
            trg.Mesh.SetAnimTreeTemplate(default.crouchAnimTree);
        }
        else
        {
            copyAppearanceBasic(srcSkel, dstSkel);
        }
        dstSkel.bForceRefpose = srcSkel.bForceRefpose;
        ApplyTinting(trg);
    }
}
function bool headgearIsHelmet(int Id)
{
    local int iterator;
    
    foreach idsWithHelmet(iterator, )
    {
        if (iterator == Id)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public function bool HasHeadgearMesh(SFXPawn SourcePawn)
{
    return SourcePawn != None && SourcePawn.m_oHeadGearMesh != None && SourcePawn.m_oHeadGearMesh.SkeletalMesh != None;
}
public function copyAppearanceBasic(SkeletalMeshComponent srcSkel, SkeletalMeshComponent dstSkel)
{
    local int i;
    
    // Standard copy for other pawn types
    dstSkel.SkeletalMesh = srcSkel.SkeletalMesh;
    // Copy common material array or material slots if available
    for (i = 0; i < 8; i++)
    {
        // Guarded calls: many projects expose SetMaterial/GetMaterial
        if (srcSkel.GetMaterial != None && dstSkel.SetMaterial != None)
        {
            dstSkel.SetMaterial(i, srcSkel.GetMaterial(i));
        }
    }
}
public function copyOtherProperties(SFXPawn_Henchman src, SFXPawn_PlayerMP trg)
{
    trg.bHeadGearVisible = src.bHeadGearVisible;
    trg.m_oHairMesh = src.m_oHairMesh;
    trg.m_oHeadGearMesh = src.m_oHeadGearMesh;
    trg.m_oVisorMesh = src.m_oVisorMesh;
    trg.m_oFacePlateMesh = src.m_oFacePlateMesh;
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
    return;
    if (src.WeaponAnimSpecs.Length > 0)
    {
        targetWeapon = SFXWeapon(trg.Weapon);
        trg.WeaponAnimSpecs = src.WeaponAnimSpecs;
        log(Self.Name, "Setting up weapon animations for  " $ targetWeapon, Outer);
        trg.SetupWeaponAnimations(targetWeapon, None);
    }
}
public function createHeadMeshFromSource(SFXPawn_PlayerMP TargetMP, SFXPawn_Henchman SourcePawn)
{
    local SkeletalMeshComponent NewHeadMesh;
    local int i;
    
    log(Self.Name, "createHeadMeshFromSource: start", Outer);
    // Create a NEW HeadMesh component owned by target
    if (SourcePawn.HeadMesh != None && SourcePawn.HeadMesh.SkeletalMesh != None)
    {
        NewHeadMesh = new (TargetMP) Class'SkeletalMeshComponent';
        NewHeadMesh.SetSkeletalMesh(SourcePawn.HeadMesh.SkeletalMesh);
        // Copy materials
        for (i = 0; i < SourcePawn.HeadMesh.GetNumElements(); i++)
        {
            if (SourcePawn.HeadMesh.GetMaterial(i) != None)
            {
                NewHeadMesh.SetMaterial(i, SourcePawn.HeadMesh.GetMaterial(i));
            }
        }
        // Set HeadMesh on Target
        TargetMP.HeadMesh = NewHeadMesh;
        // Set up component properties
        TargetMP.HeadMesh.bOverrideParentSkeleton = TRUE;
        TargetMP.HeadMesh.nmOverrideStartBoneName = 'headBase';
        TargetMP.HeadMesh.SetParentAnimComponent(TargetMP.Mesh);
        TargetMP.HeadMesh.SetShadowParent(TargetMP.Mesh);
        TargetMP.HeadMesh.SetLightEnvironment(TargetMP.LightEnvironment);
        // Attach to target
        TargetMP.AttachComponent(TargetMP.HeadMesh);
        TargetMP.HeadMesh.UpdateParentBoneMap();
        log(Self.Name, "AttachHeadMeshToBody: After attach - bAttached=" $ TargetMP.HeadMesh.bAttached $ " Owner=" $ TargetMP.HeadMesh.Owner, Outer);
    }
}
public function removeOldHead(SFXPawn SourcePawn)
{
    SourcePawn.DetachComponent(SourcePawn.HeadMesh);
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
public function createHairMeshFromSource(SFXPawn_PlayerMP TargetMP, SFXPawn_Henchman SourcePawn)
{
    local SkeletalMeshComponent NewHairMesh;
    local int i;
    
    log(Self.Name, "createHairMeshFromSource: start", Outer);
    // Create a NEW HairMesh component owned by target
    if (SourcePawn.m_oHairMesh != None && SourcePawn.m_oHairMesh.SkeletalMesh != None)
    {
        NewHairMesh = new (TargetMP) Class'SkeletalMeshComponent';
        NewHairMesh.SetSkeletalMesh(SourcePawn.m_oHairMesh.SkeletalMesh);
        // Copy materials
        for (i = 0; i < SourcePawn.m_oHairMesh.GetNumElements(); i++)
        {
            if (SourcePawn.m_oHairMesh.GetMaterial(i) != None)
            {
                NewHairMesh.SetMaterial(i, SourcePawn.m_oHairMesh.GetMaterial(i));
            }
        }
        // Set HairMesh on Target
        TargetMP.m_oHairMesh = NewHairMesh;
        // Set up component properties
        TargetMP.m_oHairMesh.bOverrideParentSkeleton = TRUE;
        TargetMP.m_oHairMesh.nmOverrideStartBoneName = 'headBase';
        TargetMP.m_oHairMesh.SetParentAnimComponent(TargetMP.Mesh);
        TargetMP.m_oHairMesh.SetShadowParent(TargetMP.Mesh);
        TargetMP.m_oHairMesh.SetLightEnvironment(TargetMP.LightEnvironment);
        // Attach to target
        TargetMP.AttachComponent(TargetMP.m_oHairMesh);
        TargetMP.m_oHairMesh.UpdateParentBoneMap();
        log(Self.Name, "createHairMeshFromSource: After attach - bAttached=" $ TargetMP.m_oHairMesh.bAttached $ " Owner=" $ TargetMP.m_oHairMesh.Owner, Outer);
    }
}
public function removeOldHair(SFXPawn SourcePawn)
{
    SourcePawn.DetachComponent(SourcePawn.m_oHairMesh);
}
public function CopyHairMaterials(SFXPawn SourcePawn, SFXPawn_PlayerMP TargetMP)
{
    local int i;
    
    log(Self.Name, "CopyHairMaterials: start", Outer);
    for (i = 0; i < SourcePawn.m_oHairMesh.GetNumElements(); i++)
    {
        if (SourcePawn.m_oHairMesh.GetMaterial(i) != None)
        {
            TargetMP.m_oHairMesh.SetMaterial(i, SourcePawn.m_oHairMesh.GetMaterial(i));
        }
    }
    log(Self.Name, "CopyHairMaterials: Copied materials from source hair", Outer);
}
public function createHeadgearMeshFromSource(SFXPawn_PlayerMP TargetMP, SFXPawn_Henchman SourcePawn)
{
    local SkeletalMeshComponent NewHeadgearMesh;
    local int i;
    
    log(Self.Name, "createHeadgearMeshFromSource: start", Outer);
    // Create a NEW HeadgearMesh component owned by target
    if (SourcePawn.m_oHeadGearMesh != None && SourcePawn.m_oHeadGearMesh.SkeletalMesh != None)
    {
        NewHeadgearMesh = new (TargetMP) Class'SkeletalMeshComponent';
        NewHeadgearMesh.SetSkeletalMesh(SourcePawn.m_oHeadGearMesh.SkeletalMesh);
        // Copy materials
        for (i = 0; i < SourcePawn.m_oHeadGearMesh.GetNumElements(); i++)
        {
            if (SourcePawn.m_oHeadGearMesh.GetMaterial(i) != None)
            {
                NewHeadgearMesh.SetMaterial(i, SourcePawn.m_oHeadGearMesh.GetMaterial(i));
            }
        }
        // Set HeadgearMesh on Target
        TargetMP.m_oHeadGearMesh = NewHeadgearMesh;
        // Set up component properties
        TargetMP.m_oHeadGearMesh.bOverrideParentSkeleton = TRUE;
        TargetMP.m_oHeadGearMesh.nmOverrideStartBoneName = 'headBase';
        TargetMP.m_oHeadGearMesh.SetParentAnimComponent(TargetMP.Mesh);
        TargetMP.m_oHeadGearMesh.SetShadowParent(TargetMP.Mesh);
        TargetMP.m_oHeadGearMesh.SetLightEnvironment(TargetMP.LightEnvironment);
        // Attach to target
        TargetMP.AttachComponent(TargetMP.m_oHeadGearMesh);
        TargetMP.m_oHeadGearMesh.UpdateParentBoneMap();
        log(Self.Name, "createHeadgearMeshFromSource: After attach - bAttached=" $ TargetMP.m_oHeadGearMesh.bAttached $ " Owner=" $ TargetMP.m_oHeadGearMesh.Owner, Outer);
    }
}
public function removeOldHeadgear(SFXPawn SourcePawn)
{
    SourcePawn.DetachComponent(SourcePawn.m_oHeadGearMesh);
}
public function CopyHeadgearMaterials(SFXPawn SourcePawn, SFXPawn_PlayerMP TargetMP)
{
    local int i;
    
    log(Self.Name, "CopyHeadgearMaterials: start", Outer);
    for (i = 0; i < SourcePawn.m_oHeadGearMesh.GetNumElements(); i++)
    {
        if (SourcePawn.m_oHeadGearMesh.GetMaterial(i) != None)
        {
            TargetMP.m_oHeadGearMesh.SetMaterial(i, SourcePawn.m_oHeadGearMesh.GetMaterial(i));
        }
    }
    log(Self.Name, "CopyHeadgearMaterials: Copied materials from source headgear", Outer);
}
private final function ApplyTinting(SFXPawn trg)
{
    local SFXPawn_PlayerMP trgMP;
    
    trgMP = SFXPawn_PlayerMP(trg);
    if (trgMP != None && trgMP.CustomizationMP != None)
    {
        trgMP.CustomizationMP.ApplyMaterialTinting(trg);
    }
}
public function logHenchmanAndTargetStuff(SFXPawn_Henchman src, SFXPawn_PlayerMP trg)
{
    local SkeletalMeshComponent srcSkel;
    local SkeletalMeshComponent dstSkel;
    
    if (!bDebug)
    {
        return;
    }
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
    log(Self.Name, "srcSkel.ParentAnimComponent " $ srcSkel.ParentAnimComponent, Outer);
    log(Self.Name, "trgSkel.ParentAnimComponent " $ dstSkel.ParentAnimComponent, Outer);
    //Mesh Attachments
    printAttachments(Self.Name, Outer, src.Mesh.Attachments, "src.Mesh.Attachments");
    printAttachments(Self.Name, Outer, trg.Mesh.Attachments, "trg.mesh.Attachments");
    //Components
    printArrayContents(Self.Name, Outer, src.AllComponents, "src.Components");
    printArrayContents(Self.Name, Outer, trg.AllComponents, "trg.Components");
    //Modules
    printArrayContents(Self.Name, Outer, src.Modules, "src.Modules");
    printArrayContents(Self.Name, Outer, trg.Modules, "trg.Modules");
    //Translation Offset
    log(Self.Name, "src.MeshTranslationOffset " $ src.MeshTranslationOffset, Outer);
    log(Self.Name, "trg.MeshTranslationOffset " $ trg.MeshTranslationOffset, Outer);
    //Animsets
    printArrayContents(Self.Name, Outer, dstSkel.AnimSets, "dstSkel.AnimSets");
    printArrayContents(Self.Name, Outer, srcSkel.AnimSets, "srcSkel.AnimSets");
    //WeaponAnimSpecs
    printWeaponAnimSpecs(Self.Name, Outer, src.WeaponAnimSpecs, "src.WeaponAnimSpecs");
    printWeaponAnimSpecs(Self.Name, Outer, trg.WeaponAnimSpecs, "trg.WeaponAnimSpecs");
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
    crouchAnimTree = AnimTree'BioTemp_Cit004.AnimTree.BIOG_Combat_Player_Crouching'
    idsWithHelmet = (99)
    bDebug = FALSE
}