Class SpriteComponent extends PrimitiveComponent
    native
    editinlinenew
    collapsecategories;

var(SpriteComponent) Texture2D Sprite;
var(SpriteComponent) float ScreenSize;
var(SpriteComponent) float U;
var(SpriteComponent) float UL;
var(SpriteComponent) float V;
var(SpriteComponent) float VL;
var(SpriteComponent) bool bIsScreenSizeScaled;

public simulated native function SetSprite(Texture2D NewSprite);

public simulated native function SetSpriteAndUV(Texture2D NewSprite, int NewU, int NewUL, int NewV, int NewVL);

public simulated native function SetUV(int NewU, int NewUL, int NewV, int NewVL);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ScreenSize = 0.100000001
    ReplacementPrimitive = None
}