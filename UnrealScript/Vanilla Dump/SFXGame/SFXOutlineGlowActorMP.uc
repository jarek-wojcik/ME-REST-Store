Class SFXOutlineGlowActorMP extends SFXOutlineGlowActorBase
    native;

var const LinearColor AliveColour;
var const LinearColor DyingColour;
var const LinearColor EnemyColour;
var const float RenderDelay;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AliveColour = {R = 1.5, G = 1.5, B = 50.0, A = 1.0}
    DyingColour = {R = 50.0, G = 1.0, B = 1.0, A = 1.0}
    EnemyColour = {R = 1.0, G = 0.0, B = 2.0, A = 1.0}
    RenderDelay = 0.5
    GlowMaterial = Material'BioVFX_MP_SquadOutline.Materials.OutlineGlow'
}