Class BioAnimNodeBlendByFireSequence extends AnimNodeBlendList
    native;

enum EBioAnimNodeBlendByFireSequenceChild
{
    BIO_ANIM_NODE_BLEND_BY_FIRE_SEQUENCE_CHILD_IDLE,
    BIO_ANIM_NODE_BLEND_BY_FIRE_SEQUENCE_CHILD_START,
    BIO_ANIM_NODE_BLEND_BY_FIRE_SEQUENCE_CHILD_LOOP,
    BIO_ANIM_NODE_BLEND_BY_FIRE_SEQUENCE_CHILD,
    BIO_ANIM_NODE_BLEND_BY_FIRE_SEQUENCE_CHILD_END,
};
const SHOTS_PER_LOOP_CYCLE = 5.0f;

var transient array<AnimNodeSequence> CachedAnimSeqLoop;
var transient array<AnimNodeSequence> CachedAnimSeqEnd;
var transient Vector FlashLocation;
var(BioAnimNodeBlendByFireSequence) float BlendDuration;
var transient int QueuedTransition;
var transient int FlashCount;
var transient bool CacheUpdated;

public final event function float GetPlayRate(AnimNodeSequence Seq)
{
    local float SeqLength;
    local float TimeForOneShot;
    local float TimeForAllShots;
    local float FireRate;
    local Pawn Pawn;
    local SFXWeapon Weapon;
    
    Pawn = Pawn(SkelComponent.Owner);
    if (Pawn != None && Pawn.Weapon != None)
    {
        Weapon = SFXWeapon(Pawn.Weapon);
        if (Weapon != None)
        {
            if (Weapon.bScaleAnimDurationByFireRate)
            {
                FireRate = Weapon.GetRateOfFire() / 60.0;
                SeqLength = Seq.GetAnimPlaybackLength();
                TimeForOneShot = SeqLength / 5.0;
                TimeForAllShots = TimeForOneShot * FireRate;
                if (SeqLength == float(0))
                {
                    return 1.0;
                }
                return TimeForAllShots / SeqLength;
            }
        }
    }
    return 1.0;
}
public final event function NotifyWeaponAnimationPlaying(bool Playing)
{
    local Pawn Pawn;
    local SFXWeapon Weapon;
    
    Pawn = Pawn(SkelComponent.Owner);
    if (Pawn != None && Pawn.Weapon != None)
    {
        Weapon = SFXWeapon(Pawn.Weapon);
        if (Weapon != None)
        {
            Weapon.bFiringAnimationPlaying = Playing;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlendDuration = 0.5
    QueuedTransition = -1
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
                 Name = 'StartFire', 
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
                 Name = 'LoopFire', 
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
                 Name = 'Deprecated', 
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
                 Name = 'EndFire', 
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