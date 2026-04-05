Class BioAnimNodeBlendByReload extends AnimNodeBlendList
    native;

enum EBioReloadAnimNode
{
    RELOAD_ANIM_NODE_IDLE,
    RELOAD_ANIM_NODE_RELOADING,
};

public final event function float GetReloadDuration()
{
    local Pawn ChkPawn;
    local SFXWeapon Weapon;
    
    ChkPawn = Pawn(SkelComponent.Owner);
    if (ChkPawn != None && ChkPawn.Weapon != None)
    {
        Weapon = SFXWeapon(ChkPawn.Weapon);
        if (Weapon != None)
        {
            return Weapon.GetReloadDuration();
        }
    }
    return 0.0;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
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
                 Name = 'RELOAD', 
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