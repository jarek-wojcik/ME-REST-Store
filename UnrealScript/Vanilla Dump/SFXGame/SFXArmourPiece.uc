Class SFXArmourPiece
    native
    editinlinenew;

var(SFXArmourPiece) array<Name> HideBones;
var(SFXArmourPiece) Vector RelativeBoneLocation;
var(SFXArmourPiece) Rotator RelativeBoneRotation;
var(SFXArmourPiece) Vector RelativeBoneScale;
var(SFXArmourPiece) Rotator Rotation;
var(SFXArmourPiece) Name AttachSocket;
var(SFXArmourPiece) Name BoneName;
var(SFXArmourPiece) Name ArmourName;
var(SFXArmourPiece) Object Mesh;
var(SFXArmourPiece) Object DestroyedMesh;
var(SFXArmourPiece) PhysicalMaterial PhysMaterialOverride;
var(SFXArmourPiece) PhysicsAsset PhysicsAsset;
var editinline transient export PrimitiveComponent AttachInstance;
var(SFXArmourPiece) ParticleSystem PS_Destruction;
var(SFXArmourPiece) WwiseEvent DestructionSound;
var(SFXArmourPiece) float MaxHealth;
var transient float CurrentHealth;
var(SFXArmourPiece) bool bMeshStartsHidden;
var(SFXArmourPiece) bool bStartsDetached;
var(SFXArmourPiece) bool bCanBeDamaged;
var(SFXArmourPiece) bool bNotifyOnHit;
var(SFXArmourPiece) bool bPassThroughDamage;

public final event function ActivateEffects(Actor oTarget)
{
    local Vector ArmourLoc;
    local Rotator ArmourRot;
    
    if (oTarget != None)
    {
        ArmourLoc = AttachInstance.Bounds.Origin;
        ArmourRot = AttachInstance.GetRotation();
        SFXGRI(oTarget.WorldInfo.GRI).DuringAsyncWorker.SpawnEffectAtLocation(oTarget, PS_Destruction, ArmourLoc, ArmourRot);
        if (DestructionSound != None)
        {
            if (AttachInstance.Owner != None)
            {
                AttachInstance.Owner.PlaySound(DestructionSound, TRUE, FALSE, FALSE, ArmourLoc);
            }
        }
    }
}
public native function bool AttachToActor(Actor oTarget);

public native function DetachFromActor(Actor oTarget, bool bDestroyed, out TraceHitInfo HitInfo);

public function UpdateAppearance()
{
    if (SkeletalMeshComponent(AttachInstance) != None)
    {
        UpdateMorphWeights(SkeletalMeshComponent(AttachInstance), CurrentHealth / MaxHealth);
    }
}
public native function UpdateMorphWeights(SkeletalMeshComponent SkelMeshComp, float NewWeight);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    RelativeBoneScale = {X = 1.0, Y = 1.0, Z = 1.0}
    bCanBeDamaged = TRUE
}