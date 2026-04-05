Class TextureCube extends Texture
    native;

var const transient int SizeX;
var const transient int SizeY;
var const transient int NumMips;
var(TextureCube) const Texture2D FacePosX;
var(TextureCube) const Texture2D FaceNegX;
var(TextureCube) const Texture2D FacePosY;
var(TextureCube) const Texture2D FaceNegY;
var(TextureCube) const Texture2D FacePosZ;
var(TextureCube) const Texture2D FaceNegZ;
var const transient bool bIsCubemapValid;
var const transient EPixelFormat Format;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}