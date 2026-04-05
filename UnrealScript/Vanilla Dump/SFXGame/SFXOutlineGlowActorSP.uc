Class SFXOutlineGlowActorSP extends SFXOutlineGlowActorBase
    native;

var const LinearColor EnemyColour;
var const LinearColor HenchmenColour;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    EnemyColour = {R = 1.0, G = 0.0, B = 2.0, A = 1.0}
    HenchmenColour = {R = 1.5, G = 1.5, B = 50.0, A = 1.0}
    GlowMaterial = Material'BioVFX_MP_SquadOutline.Materials.OutlineGlow'
    PostDeathGlowDuration = 2.5
}