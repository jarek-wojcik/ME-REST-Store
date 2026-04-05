Class AnimNodeBlendByBase extends AnimNodeBlendList
    native;

enum EBaseBlendType
{
    BBT_ByActorTag,
    BBT_ByActorClass,
};

var(AnimNodeBlendByBase) Class<Actor> ActorClass;
var(AnimNodeBlendByBase) Name ActorTag;
var(AnimNodeBlendByBase) float BlendTime;
var transient Actor CachedBase;
var(AnimNodeBlendByBase) EBaseBlendType Type;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    BlendTime = 0.200000003
    Children = ({
                 RootMotion = {
                               Rotation = {X = 0.0, Y = 0.0, Z = 0.0, W = 0.0}, 
                               Translation = {X = 0.0, Y = 0.0, Z = 0.0}, 
                               Scale = 0.0
                              }, 
                 Name = 'Normal', 
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
                 Name = 'Based', 
                 Weight = 0.0, 
                 BlendWeight = 0.0, 
                 bHasRootMotion = 0, 
                 Anim = None, 
                 bMirrorSkeleton = FALSE, 
                 bIsAdditive = FALSE
                }
               )
    bFixNumChildren = TRUE
    bSkipTickWhenZeroWeight = TRUE
}