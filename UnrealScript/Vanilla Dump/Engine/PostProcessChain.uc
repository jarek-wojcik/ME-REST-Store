Class PostProcessChain
    native;

struct native RequestedPostProcessEffect 
{
    var native Pointer pOwner;
    var PostProcessEffect pEffect;
    var EAddPostProcessEffectCombineType CombineType;
};
enum EAddPostProcessEffectCombineType
{
    EAPPE_Override,
    EAPPE_Combine,
};

var array<PostProcessEffect> Effects;

public final function PostProcessEffect FindPostProcessEffect(Name EffectName)
{
    local int idx;
    
    for (idx = 0; idx < Effects.Length; idx++)
    {
        if (Effects[idx] != None && Effects[idx].EffectName == EffectName)
        {
            return Effects[idx];
        }
    }
    return None;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}