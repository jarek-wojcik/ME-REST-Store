Class FontImportOptions
    native
    transient;

struct native FontImportOptionsData 
{
    var(FontImportOptionsData) string FontName;
    var(FontImportOptionsData) string Chars;
    var(FontImportOptionsData) string UnicodeRange;
    var(FontImportOptionsData) string CharsFilePath;
    var(FontImportOptionsData) string CharsFileWildcard;
    var(FontImportOptionsData) LinearColor ForegroundColor;
    var(FontImportOptionsData) float Height;
    var(FontImportOptionsData) int TexturePageWidth;
    var(FontImportOptionsData) int TexturePageMaxHeight;
    var(FontImportOptionsData) int XPadding;
    var(FontImportOptionsData) int YPadding;
    var(FontImportOptionsData) int ExtendBoxTop;
    var(FontImportOptionsData) int ExtendBoxBottom;
    var(FontImportOptionsData) int ExtendBoxRight;
    var(FontImportOptionsData) int ExtendBoxLeft;
    var(FontImportOptionsData) int Kerning;
    var(FontImportOptionsData) int DistanceFieldScaleFactor;
    var(FontImportOptionsData) bool bEnableAntialiasing;
    var(FontImportOptionsData) bool bEnableBold;
    var(FontImportOptionsData) bool bEnableItalic;
    var(FontImportOptionsData) bool bEnableUnderline;
    var(FontImportOptionsData) bool bAlphaOnly;
    var(FontImportOptionsData) bool bCreatePrintableOnly;
    var(FontImportOptionsData) bool bIncludeASCIIRange;
    var(FontImportOptionsData) bool bEnableDropShadow;
    var(FontImportOptionsData) bool bEnableLegacyMode;
    var(FontImportOptionsData) bool bUseDistanceFieldAlpha;
    var(FontImportOptionsData) EFontImportCharacterSet CharacterSet;
    
    structdefaultproperties
    {
        FontName = "Arial"
        ForegroundColor = {R = 1.0, G = 1.0, B = 1.0, A = 1.0}
        Height = 16.0
        TexturePageWidth = 256
        TexturePageMaxHeight = 256
        XPadding = 1
        YPadding = 1
        DistanceFieldScaleFactor = 16
        bEnableAntialiasing = TRUE
        bIncludeASCIIRange = TRUE
    }
};
enum EFontImportCharacterSet
{
    FontICS_Default,
    FontICS_Ansi,
    FontICS_Symbol,
};

var(FontImportOptions) FontImportOptionsData Data;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Data = {
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