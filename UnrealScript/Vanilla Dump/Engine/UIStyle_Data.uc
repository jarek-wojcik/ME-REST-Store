Class UIStyle_Data extends UIRoot
    native
    abstract;

var delegate<MatchesStyleData> __MatchesStyleData__Delegate;
var LinearColor StyleColor;
var float StylePadding[2];
var bool bEnabled;
var transient bool bDirty;

public delegate function bool MatchesStyleData(const UIStyle_Data OtherStyle);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    StyleColor = {R = 1.0, G = 1.0, B = 1.0, A = 1.0}
}