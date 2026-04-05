Class SFXModule_Armour extends SFXModule
    native;

const TOTAL_ARMOUR_PIECE_HEALTH_STEPS = 15;
const MAX_ARMOUR_PIECES = 12;

var(SFXModule_Armour) SFXArmourPiece ActiveArmour[12];
var repnotify int ReplicatedArmourStates[12];

public event simulated function HandlePostBeginPlay()
{
    local int i;
    local SFXArmourPiece piece;
    
    Super.HandlePostBeginPlay();
    for (i = 0; i < 12; i++)
    {
        piece = SFXModule_Armour(ObjectArchetype).ActiveArmour[i];
        if (piece != None)
        {
            ActiveArmour[i] = new Class'SFXArmourPiece' (SFXModule_Armour(ObjectArchetype).ActiveArmour[i]);
        }
    }
    PreviewArmour();
}
public event simulated function PreviewArmour()
{
    local int ArmourIndex;
    
    for (ArmourIndex = 0; ArmourIndex < 12; ArmourIndex++)
    {
        if (ActiveArmour[ArmourIndex] == None)
        {
            continue;
        }
        if (ActiveArmour[ArmourIndex].bStartsDetached)
        {
            continue;
        }
        if (ActiveArmour[ArmourIndex].AttachInstance == None)
        {
            ActiveArmour[ArmourIndex].AttachToActor(ModuleOwner);
        }
        ReplicateArmourPiece(ArmourIndex);
    }
}
public event simulated function ReplicatedEvent(Name VarName)
{
    if (VarName == 'ReplicatedArmourStates')
    {
        UpdateReplicatedArmour();
    }
    Super.ReplicatedEvent(VarName);
}
public function AddArmourEntry(SFXArmourPiece piece)
{
    local int ArmourIndex;
    
    for (ArmourIndex = 0; ArmourIndex < 12; ArmourIndex++)
    {
        if (ActiveArmour[ArmourIndex] == None)
        {
            ActiveArmour[ArmourIndex] = piece;
            return;
        }
    }
}
public simulated function ApplyDamage(out float Damage, out TraceHitInfo HitInfo, out Vector HitLocation, Vector Momentum, Class<SFXDamageType> DamageType, Controller instigatedBy, Actor DamageCauser)
{
    local int ArmourIndex;
    local SFXWeapon Weapon;
    local SFXArmourPiece ArmourPiece;
    local Pawn OwnerPawn;
    
    if (Damage <= float(0))
    {
        return;
    }
    OwnerPawn = Pawn(ModuleOwner);
    for (ArmourIndex = 0; ArmourIndex < 12; ArmourIndex++)
    {
        if (ActiveArmour[ArmourIndex] == None || ActiveArmour[ArmourIndex].AttachInstance == None)
        {
            continue;
        }
        if (HitInfo.HitComponent == ActiveArmour[ArmourIndex].AttachInstance)
        {
            ArmourPiece = ActiveArmour[ArmourIndex];
            if (int(GetActorRole()) == 3)
            {
                ApplyDamageToPiece(ArmourIndex, Damage, instigatedBy);
                if (ArmourPiece.bNotifyOnHit && OwnerPawn != None && SFXAI_Core(OwnerPawn.Controller) != None)
                {
                    SFXAI_Core(OwnerPawn.Controller).NotifyArmourHit(Damage, ArmourPiece.ArmourName, instigatedBy, HitLocation, Momentum, DamageType, DamageCauser);
                }
                if (!ArmourPiece.bPassThroughDamage)
                {
                    Damage = 0.0;
                }
            }
            Weapon = SFXWeapon(DamageCauser);
            if (Weapon != None)
            {
                PlayWeaponImpacts(Weapon, HitInfo, HitLocation);
            }
            break;
        }
    }
}
public function ApplyDamageToPiece(int ArmourIndex, float Damage, Controller instigatedBy)
{
    local SFXArmourPiece ArmourPiece;
    
    if (ModuleOwner == None || int(GetActorRole()) != 3)
    {
        return;
    }
    ArmourPiece = ActiveArmour[ArmourIndex];
    if (ArmourPiece.bCanBeDamaged)
    {
        ArmourPiece.CurrentHealth -= Damage;
        if (ArmourPiece.CurrentHealth <= float(0))
        {
            if (Pawn(ModuleOwner) != None && SFXAI_Core(Pawn(ModuleOwner).Controller) != None)
            {
                SFXAI_Core(Pawn(ModuleOwner).Controller).NotifyArmourDestroyed(ArmourPiece.ArmourName, instigatedBy);
            }
            if (ArmourPiece.DestroyedMesh != None)
            {
                SwapToDamagedArmourPiece(ArmourPiece);
            }
            else
            {
                DetachDamagedArmourPiece(ArmourPiece);
            }
        }
        else
        {
            ArmourPiece.UpdateAppearance();
        }
        if (BioPawn(ModuleOwner) != None)
        {
            BioPawn(ModuleOwner).NotifyArmourAppearanceUpdated(ArmourIndex);
        }
        ReplicateArmourPiece(ArmourIndex);
    }
}
public function AttachAllDynamicArmour()
{
    local int ArmourIndex;
    
    if (ModuleOwner == None || int(GetActorRole()) != 3)
    {
        return;
    }
    for (ArmourIndex = 0; ArmourIndex < 12; ArmourIndex++)
    {
        if (ActiveArmour[ArmourIndex] != None && ActiveArmour[ArmourIndex].bStartsDetached && ActiveArmour[ArmourIndex].AttachInstance == None)
        {
            ActiveArmour[ArmourIndex].AttachToActor(ModuleOwner);
        }
        ReplicateArmourPiece(ArmourIndex);
    }
}
public simulated function DestroyAllArmour()
{
    local int idx;
    local SFXArmourPiece Armour;
    local Pawn OwnerPawn;
    
    OwnerPawn = Pawn(ModuleOwner);
    for (idx = 0; idx < 12; idx++)
    {
        Armour = ActiveArmour[idx];
        if (Armour != None && Armour.AttachInstance != None && Armour.bCanBeDamaged)
        {
            Armour.CurrentHealth = 0.0;
            if (OwnerPawn != None && SFXAI_Core(OwnerPawn.Controller) != None)
            {
                SFXAI_Core(OwnerPawn.Controller).NotifyArmourDestroyed(Armour.ArmourName, SFXAI_Core(OwnerPawn.Controller));
            }
            if (Armour.DestroyedMesh != None)
            {
                SwapToDamagedArmourPiece(Armour);
            }
            else
            {
                DetachDamagedArmourPiece(Armour);
            }
            ReplicateArmourPiece(idx);
        }
    }
}
public function DetachAllDynamicArmour()
{
    local int ArmourIndex;
    local TraceHitInfo TraceHit;
    
    if (ModuleOwner == None || int(GetActorRole()) != 3)
    {
        return;
    }
    for (ArmourIndex = 0; ArmourIndex < 12; ArmourIndex++)
    {
        if (ActiveArmour[ArmourIndex] != None && ActiveArmour[ArmourIndex].AttachInstance != None)
        {
            ActiveArmour[ArmourIndex].DetachFromActor(ModuleOwner, TRUE, TraceHit);
        }
        ReplicateArmourPiece(ArmourIndex);
    }
}
public simulated function bool DetachArmourPiece(Name ArmourName, out SFXArmourPiece piece)
{
    local int ArmourIndex;
    local TraceHitInfo TraceHit;
    local SFXArmourPiece ArmourPiece;
    
    for (ArmourIndex = 0; ArmourIndex < 12; ArmourIndex++)
    {
        if (ActiveArmour[ArmourIndex] == None)
        {
            continue;
        }
        if (ArmourName == ActiveArmour[ArmourIndex].ArmourName)
        {
            ArmourPiece = ActiveArmour[ArmourIndex];
            ArmourPiece.DetachFromActor(ModuleOwner, FALSE, TraceHit);
            ActiveArmour[ArmourIndex] = None;
            piece = ArmourPiece;
            ReplicateArmourPiece(ArmourIndex);
            return TRUE;
        }
    }
    return FALSE;
}
public simulated function DetachDamagedArmourPiece(SFXArmourPiece ArmourPiece)
{
    local TraceHitInfo TraceHit;
    
    if (ArmourPiece != None && ArmourPiece.AttachInstance != None)
    {
        ArmourPiece.DetachFromActor(ModuleOwner, TRUE, TraceHit);
    }
}
public simulated function float GetArmourHealthPct(int ArmourIndex)
{
    local SFXArmourPiece piece;
    
    if (ArmourIndex >= 0 && ArmourIndex < 12)
    {
        piece = ActiveArmour[ArmourIndex];
        if (piece != None)
        {
            return piece.CurrentHealth / piece.MaxHealth;
        }
    }
    return 0.0;
}
public simulated function float GetArmourHealthPctByName(Name ArmourName)
{
    local SFXArmourPiece piece;
    
    piece = GetArmourPieceByName(ArmourName);
    if (piece != None)
    {
        return piece.CurrentHealth / piece.MaxHealth;
    }
    return 1.0;
}
public simulated function int GetArmourIndex(SFXArmourPiece ArmourPiece)
{
    local int idx;
    
    for (idx = 0; idx < 12; idx++)
    {
        if (ActiveArmour[idx] == ArmourPiece)
        {
            return idx;
        }
    }
    return -1;
}
public simulated function SFXArmourPiece GetArmourPieceByName(Name ArmourName)
{
    local int idx;
    
    for (idx = 0; idx < 12; idx++)
    {
        if (ActiveArmour[idx] != None && ActiveArmour[idx].ArmourName == ArmourName)
        {
            return ActiveArmour[idx];
        }
    }
    return None;
}
public simulated function bool HasDynamicArmourToAttach()
{
    local int ArmourIndex;
    
    for (ArmourIndex = 0; ArmourIndex < 12; ArmourIndex++)
    {
        if (ActiveArmour[ArmourIndex] != None && ActiveArmour[ArmourIndex].bStartsDetached && ActiveArmour[ArmourIndex].AttachInstance == None)
        {
            return TRUE;
        }
    }
    return FALSE;
}
public final simulated function PlayWeaponImpacts(SFXWeapon Weapon, out TraceHitInfo HitInfo, out Vector HitLocation)
{
    local ImpactInfo Impact;
    
    if (Weapon != None)
    {
        Impact.HitInfo = HitInfo;
        Impact.HitActor = ModuleOwner;
        Impact.HitLocation = HitLocation;
        Impact.HitNormal = Normal(Weapon.Instigator.location - HitLocation);
        Impact.RayDir = Impact.HitNormal * -1.0;
        Weapon.SpawnImpactEffects(Impact);
        Weapon.SpawnImpactSounds(Impact);
        if (StaticMeshComponent(HitInfo.HitComponent) != None)
        {
            Weapon.SpawnADecal(Impact);
        }
    }
}
public function ReplicateArmourPiece(int ArmourIndex)
{
    local SFXArmourPiece oArmourPiece;
    local int NewArmourPieceHealth;
    
    oArmourPiece = ActiveArmour[ArmourIndex];
    if (oArmourPiece == None || oArmourPiece.AttachInstance == None)
    {
        NewArmourPieceHealth = -1;
    }
    else
    {
        NewArmourPieceHealth = FCeil(oArmourPiece.CurrentHealth / oArmourPiece.MaxHealth * float(15));
        if (NewArmourPieceHealth < 0)
        {
            NewArmourPieceHealth = 0;
        }
    }
    if (ReplicatedArmourStates[ArmourIndex] != NewArmourPieceHealth)
    {
        if (NewArmourPieceHealth == -1)
        {
            ModuleOwner.bForceNetUpdate = TRUE;
        }
        ReplicatedArmourStates[ArmourIndex] = NewArmourPieceHealth;
    }
}
public simulated function SwapToDamagedArmourPiece(SFXArmourPiece ArmourPiece)
{
    local SkeletalMeshComponent SkelMeshCmpt;
    local StaticMeshComponent StaticMeshCmpt;
    
    if (ArmourPiece != None && ArmourPiece.AttachInstance != None && ArmourPiece.DestroyedMesh != None)
    {
        ArmourPiece.bCanBeDamaged = FALSE;
        ArmourPiece.ActivateEffects(ModuleOwner);
        SkelMeshCmpt = SkeletalMeshComponent(ArmourPiece.AttachInstance);
        if (SkelMeshCmpt != None && SkeletalMesh(ArmourPiece.DestroyedMesh) != None)
        {
            SkelMeshCmpt.SetSkeletalMesh(SkeletalMesh(ArmourPiece.DestroyedMesh));
            return;
        }
        StaticMeshCmpt = StaticMeshComponent(ArmourPiece.AttachInstance);
        if (StaticMeshCmpt != None && StaticMesh(ArmourPiece.DestroyedMesh) != None)
        {
            StaticMeshCmpt.SetStaticMesh(StaticMesh(ArmourPiece.DestroyedMesh));
            return;
        }
    }
}
public simulated function UpdateReplicatedArmour()
{
    local int ListIndex;
    local int NewReplicatedArmourState;
    local SFXArmourPiece ArmourPiece;
    local float NewArmourPieceHealth;
    
    for (ListIndex = 0; ListIndex < 12; ListIndex++)
    {
        ArmourPiece = ActiveArmour[ListIndex];
        NewReplicatedArmourState = ReplicatedArmourStates[ListIndex];
        if (ArmourPiece != None)
        {
            if (NewReplicatedArmourState == -1)
            {
                if (ArmourPiece.AttachInstance != None)
                {
                    DetachDamagedArmourPiece(ArmourPiece);
                }
            }
            else
            {
                NewArmourPieceHealth = float(NewReplicatedArmourState) / float(15) * ArmourPiece.MaxHealth;
                if (NewArmourPieceHealth != ArmourPiece.CurrentHealth)
                {
                    if (ArmourPiece.AttachInstance == None)
                    {
                        ArmourPiece.AttachToActor(ModuleOwner);
                    }
                    ArmourPiece.CurrentHealth = NewArmourPieceHealth;
                    if (ArmourPiece.CurrentHealth == float(0) && ArmourPiece.DestroyedMesh != None)
                    {
                        SwapToDamagedArmourPiece(ArmourPiece);
                    }
                    else
                    {
                        ArmourPiece.UpdateAppearance();
                    }
                    if (BioPawn(ModuleOwner) != None)
                    {
                        BioPawn(ModuleOwner).NotifyArmourAppearanceUpdated(ListIndex);
                    }
                }
            }
            continue;
        }
        if (NewReplicatedArmourState != -1)
        {
        }
    }
}

replication
{
    if (bNetDirty && int(GetActorRole()) == 3)
        ReplicatedArmourStates;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ReplicatedArmourStates[0] = -1
    ReplicatedArmourStates[1] = -1
    ReplicatedArmourStates[2] = -1
    ReplicatedArmourStates[3] = -1
    ReplicatedArmourStates[4] = -1
    ReplicatedArmourStates[5] = -1
    ReplicatedArmourStates[6] = -1
    ReplicatedArmourStates[7] = -1
    ReplicatedArmourStates[8] = -1
    ReplicatedArmourStates[9] = -1
    ReplicatedArmourStates[10] = -1
    ReplicatedArmourStates[11] = -1
    bNetVisible = TRUE
}