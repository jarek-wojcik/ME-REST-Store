Class SFXOnlineComponentXMLParser extends SFXOnlineComponent
    implements(ISFXOnlineComponent)
    native;

var const native noexport Pointer VfTable_IISFXOnlineComponent;
var native Pointer mXmlSource;

public native function Name GetAPIName();

public native function bool GetXMLAttribInteger(string Element, string attrib, out int intOut, optional int skipcount = 0);

public native function bool GetXMLAttribString(string Element, string attrib, out string stringOut, optional int skipcount = 0);

public native function bool GetXMLInteger(string Element, out int intOut, optional int skipcount = 0);

public native function bool GetXMLString(string Element, out string stringOut, optional int skipcount = 0);

public native function OnInitialize(SFXOnlineSubsystem oOnlineSubsystem);

public native function OnRelease();

public native function StartParsing(string xmlInput);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}