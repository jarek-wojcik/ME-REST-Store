Class Font
    native;

struct native immutable FontCharacter 
{
    var(FontCharacter) int StartU;
    var(FontCharacter) int StartV;
    var(FontCharacter) int USize;
    var(FontCharacter) int VSize;
    var(FontCharacter) byte TextureIndex;
    var(FontCharacter) int VerticalOffset;
};
const NULLCHARACTER = 127;

var(Font) FontImportOptionsData ImportOptions;
var(Font) array<FontCharacter> Characters;
var array<Texture2D> Textures;
var transient array<int> MaxCharHeight;
var const native Object CharRemap;
var int IsRemapped;
var(Font) int Kerning;
var transient int NumCharacters;

public final native function float GetAuthoredViewportHeight(float ViewportHeight);

public native function float GetMaxCharHeight();

public native function int GetResolutionPageIndex(float HeightTest);

public native function float GetScalingFactor(float HeightTest);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ImportOptions = {
                     FontName = "Arial", 
                     Chars = "", 
                     UnicodeRange = "", 
                     CharsFilePath = "", 
                     CharsFileWildcard = "", 
                     ForegroundColor = {R = 1.0, G = 1.0, B = 1.0, A = 1.0}, 
                     Height = 16.0, 
                     TexturePageWidth = 256, 
                     TexturePageMaxHeight = 256, 
                     XPadding = 1, 
                     YPadding = 1, 
                     ExtendBoxTop = 0, 
                     ExtendBoxBottom = 0, 
                     ExtendBoxRight = 0, 
                     ExtendBoxLeft = 0, 
                     Kerning = 0, 
                     DistanceFieldScaleFactor = 16, 
                     bEnableAntialiasing = TRUE, 
                     bEnableBold = FALSE, 
                     bEnableItalic = FALSE, 
                     bEnableUnderline = FALSE, 
                     bAlphaOnly = FALSE, 
                     bCreatePrintableOnly = FALSE, 
                     bIncludeASCIIRange = TRUE, 
                     bEnableDropShadow = FALSE, 
                     bEnableLegacyMode = FALSE, 
                     bUseDistanceFieldAlpha = FALSE, 
                     CharacterSet = EFontImportCharacterSet.FontICS_Default
                    }
}