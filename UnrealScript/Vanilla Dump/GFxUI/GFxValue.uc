Class GFxValue within GFxMovie
    native;

struct native ASColorTransform 
{
    var(ASColorTransform) LinearColor Multiply;
    var(ASColorTransform) LinearColor Add;
    
    structdefaultproperties
    {
        Multiply = {R = 1.0, G = 1.0, B = 1.0, A = 1.0}
        Add = {R = 0.0, G = 0.0, B = 0.0, A = 0.0}
    }
};
struct native ASDisplayInfo 
{
    var(ASDisplayInfo) float X;
    var(ASDisplayInfo) float Y;
    var(ASDisplayInfo) float Z;
    var(ASDisplayInfo) float Rotation;
    var(ASDisplayInfo) float XRotation;
    var(ASDisplayInfo) float YRotation;
    var(ASDisplayInfo) float XScale;
    var(ASDisplayInfo) float YScale;
    var(ASDisplayInfo) float ZScale;
    var(ASDisplayInfo) float Alpha;
    var(ASDisplayInfo) bool visible;
    var(ASDisplayInfo) bool hasX;
    var(ASDisplayInfo) bool hasY;
    var(ASDisplayInfo) bool hasZ;
    var(ASDisplayInfo) bool hasRotation;
    var(ASDisplayInfo) bool hasXRotation;
    var(ASDisplayInfo) bool hasYRotation;
    var(ASDisplayInfo) bool hasXScale;
    var(ASDisplayInfo) bool hasYScale;
    var(ASDisplayInfo) bool hasZScale;
    var(ASDisplayInfo) bool hasAlpha;
    var(ASDisplayInfo) bool hasVisible;
};

var const native int Value[12];

public final native function bool GetBool(string member);

public final native function bool GetPosition(out float X, out float Y);

public final native function Set(string member, ASValue Arg);

public final native function SetBool(string member, bool B);

public final native function SetElementVisible(int Index, bool visible);

public final native function SetObject(string member, GFxValue val);

public final native function SetPosition(float X, float Y);

public final native function SetVisible(bool visible);

public final native function array<GFxValue> ActionScriptArray(string Path);

public final native function float ActionScriptFloat(string method);

public final native function int ActionScriptInt(string method);

public final native function GFxValue ActionScriptObject(string Path);

public final native function ActionScriptSetFunction(string member);

public final native function ActionScriptSetFunctionOn(GFxValue Target, string member);

public final native function string ActionScriptString(string method);

public final native function ActionScriptVoid(string method);

public final native function GFxValue AttachMovie(string symbolname, string InstanceName, optional int Depth = -1, optional Class<GFxValue> Type = Class'GFxValue');

public final native function coerce GFxValue CastTo(Class<GFxValue> Type);

public final native function GFxValue CreateEmptyMovieClip(string InstanceName, optional int Depth = -1, optional Class<GFxValue> Type = Class'GFxValue');

public final native function ASValue Get(string member);

public final native function ASColorTransform GetColorTransform();

public final native function ASDisplayInfo GetDisplayInfo();

public final native function Matrix GetDisplayMatrix();

public final native function ASValue GetElement(int Index);

public final native function bool GetElementBool(int Index);

public final native function ASDisplayInfo GetElementDisplayInfo(int Index);

public final native function Matrix GetElementDisplayMatrix(int Index);

public final native function ASValue GetElementMember(int Index, string member);

public final native function bool GetElementMemberBool(int Index, string member);

public final native function float GetElementMemberNumber(int Index, string member);

public final native function GFxValue GetElementMemberObject(int Index, string member, optional Class<GFxValue> Type = Class'GFxValue');

public final native function string GetElementMemberString(int Index, string member);

public final native function float GetElementNumber(int Index);

public final native function GFxValue GetElementObject(int Index, optional Class<GFxValue> Type = Class'GFxValue');

public final native function string GetElementString(int Index);

public final native function float GetNumber(string member);

public final native function GFxValue GetObject(string member, optional Class<GFxValue> Type = Class'GFxValue');

public final native function string GetString(string member);

public final native function string GetText();

public final native function GotoAndPlay(string frame);

public final native function GotoAndPlayI(int frame);

public final native function GotoAndStop(string frame);

public final native function GotoAndStopI(int frame);

public final native function ASValue Invoke(string member, array<ASValue> Args);

public final native function SetColorTransform(ASColorTransform cxform);

public final native function SetDisplayInfo(const out ASDisplayInfo D);

public final native function SetDisplayMatrix(Matrix M);

public final native function SetDisplayMatrix3D(Matrix M);

public final native function SetElement(int Index, ASValue Arg);

public final native function SetElementBool(int Index, bool B);

public final native function SetElementColorTransform(int Index, ASColorTransform cxform);

public final native function SetElementDisplayInfo(int Index, ASDisplayInfo D);

public final native function SetElementDisplayMatrix(int Index, Matrix M);

public final native function SetElementMember(int Index, string member, ASValue Arg);

public final native function SetElementMemberBool(int Index, string member, bool B);

public final native function SetElementMemberNumber(int Index, string member, float F);

public final native function SetElementMemberObject(int Index, string member, GFxValue val);

public final native function SetElementMemberString(int Index, string member, string S);

public final native function SetElementNumber(int Index, float F);

public final native function SetElementObject(int Index, GFxValue val);

public final native function SetElementPosition(int Index, float X, float Y);

public final native function SetElementString(int Index, string S);

public final native function SetFunction(string member, Object Context, Name fname);

public final native function SetMemberObjectText(string sMember, coerce string sText, optional bool bIsHTML = FALSE);

public final native function SetNumber(string member, float F);

public final native function SetString(string member, string S);

public final native function SetText(coerce string Text, optional bool bIsHTML = FALSE);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}