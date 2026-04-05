Class Texture2DDynamic extends Texture
    native;

var transient native int SizeX;
var transient native int SizeY;
var transient native int NumMips;
var transient native bool bIsResolveTarget;
var transient native EPixelFormat Format;

public static final native function Texture2DDynamic Create(int InSizeX, int InSizeY, optional EPixelFormat InFormat = 2, optional bool InIsResolveTarget = FALSE);

public final native function Init(int InSizeX, int InSizeY, optional EPixelFormat InFormat = 2, optional bool InIsResolveTarget = FALSE);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NeverStream = TRUE
}