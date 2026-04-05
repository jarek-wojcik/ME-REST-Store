Class TextureRenderTarget2D extends TextureRenderTarget
    native;

var(TextureRenderTarget2D) const LinearColor ClearColor;
var(TextureRenderTarget2D) const int SizeX;
var(TextureRenderTarget2D) const int SizeY;
var(TextureRenderTarget2D) const transient bool bForceLinearGamma;
var const EPixelFormat Format;
var(TextureRenderTarget2D) TextureAddress AddressX;
var(TextureRenderTarget2D) TextureAddress AddressY;

public static final native function TextureRenderTarget2D Create(int InSizeX, int InSizeY, optional EPixelFormat InFormat = 2, optional LinearColor InClearColor, optional bool bOnlyRenderOnce);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ClearColor = {R = 0.0, G = 1.0, B = 0.0, A = 1.0}
    Format = EPixelFormat.PF_A8R8G8B8
}