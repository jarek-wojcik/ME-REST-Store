Class BioAnimNodeBlendByWeaponEquip extends AnimNodeBlendList
    native;

enum EBioAnimNodeBlendByWeaponEquip
{
    eBioAnimNodeBlendByWeaponEquip_Idle,
    eBioAnimNodeBlendByWeaponEquip_Draw,
    eBioAnimNodeBlendByWeaponEquip_Holster,
};

var(BioAnimNodeBlendByWeaponEquip) float IdleToDrawBlendDuration;
var(BioAnimNodeBlendByWeaponEquip) float IdleToHolsterBlendDuration;
var(BioAnimNodeBlendByWeaponEquip) float HolsterToDrawBlendDuration;
var(BioAnimNodeBlendByWeaponEquip) float HolsterToIdleBlendDuration;
var transient bool bDisabledIK;

public event function DrawAnimEnd()
{
    local Pawn P;
    local SFXWeapon Weapon;
    
    P = Pawn(SkelComponent.Owner);
    if (P != None && P.Weapon != None)
    {
        Weapon = SFXWeapon(P.Weapon);
        if (Weapon != None)
        {
            Weapon.EquipFinished();
        }
    }
}
public event function HolsterAnimEnd()
{
    local BioPawn P;
    local SFXWeapon Weapon;
    
    P = BioPawn(SkelComponent.Owner);
    if (P != None && P.Weapon != None)
    {
        Weapon = SFXWeapon(P.Weapon);
        if (Weapon != None)
        {
            Weapon.UnEquipFinished();
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    IdleToDrawBlendDuration = 0.100000001
    IdleToHolsterBlendDuration = 0.100000001
    HolsterToDrawBlendDuration = 0.300000012
    HolsterToIdleBlendDuration = 0.699999988
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Idle', 
                 Weight = 1.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Draw', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }, 
                {
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Holster', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
}