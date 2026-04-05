Class Texture2DComposite extends Texture
    native;

struct native SourceTexture2DRegion 
{
    var int OffsetX;
    var int OffsetY;
    var int SizeX;
    var int SizeY;
    var Texture2D Texture2D;
};

var array<SourceTexture2DRegion> SourceRegions;
var int MaxTextureSize;

public final native function ResetSourceRegions();

public final native function bool SourceTexturesFullyStreamedIn();

public final native function UpdateCompositeTexture(int NumMipsToGenerate);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    NeverStream = TRUE
}