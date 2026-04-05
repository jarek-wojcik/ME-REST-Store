Class TextureRenderTargetCube extends TextureRenderTarget
    native;

var(TextureRenderTargetCube) int SizeX;
var const EPixelFormat Format;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Format = EPixelFormat.PF_A8R8G8B8
}