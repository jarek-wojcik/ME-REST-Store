Class UISkin extends UIDataStore
    native;

struct native UISoundCue 
{
    var Name SoundName;
    var SoundCue SoundToPlay;
};

var const export array<UIStyle> Styles;
var const array<string> StyleGroups;
var const array<UISoundCue> SoundCues;
var const transient array<string> StyleGroupMap;
var const transient native Object StyleLookupTable;
var const transient native Object StyleNameMap;
var const native duplicatetransient Object CursorMap;
var const transient native Object SoundCueMap;

public final native function bool AddStyleGroupName(string StyleGroupName);

public final native function bool AddUISoundCue(Name SoundCueName, SoundCue SoundToPlay);

public final native function int FindStyleGroupIndex(string StyleGroupName);

public final native function GetAvailableStyles(out array<UIStyle> out_Styles, optional bool bIncludeInheritedStyles = TRUE);

public final native function UITexture GetCursorResource(Name CursorName);

public final native function GetSkinSoundCues(out array<UISoundCue> out_SoundCues);

public final native function GetStyleGroups(out array<string> StyleGroupArray, optional bool bIncludeInheritedGroups = TRUE);

public final native function bool GetUISoundCue(Name SoundCueName, out SoundCue out_UISoundCue);

public final native function bool IsInheritedGroupName(string StyleGroupName);

public final native function bool RemoveStyleGroupName(string StyleGroupName);

public final native function bool RemoveUISoundCue(Name SoundCueName);

public final native function bool RenameStyleGroup(string OldStyleGroupName, string NewStyleGroupName);

public event function SubscriberAttached(UIDataStoreSubscriber Subscriber);

public event function SubscriberDetached(UIDataStoreSubscriber Subscriber);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Tag = 'Styles'
}