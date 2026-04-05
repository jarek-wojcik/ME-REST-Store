Class BioSimpleDialog
    native;

struct native SimpleVOEvent 
{
    var array<stringref> Lines;
    var Name EventName;
    var stringref ReplyLine;
};
struct native SimpleDialogLine 
{
    var stringref srText;
    var WwiseBaseSoundObject pCue;
};

var privatewrite array<SimpleDialogLine> DialogLinesMale;
var privatewrite array<SimpleDialogLine> DialogLinesFemale;
var privatewrite transient array<SimpleDialogLine> DialogLines;
var array<SimpleVOEvent> SimpleVOEvents;
var const Color SubtitleColor;
var transient float LastEventDuration;

public final native function PlayDialogLine(stringref DialogLineSr, optional BioPlayerController ControllerToPlayOn);

public final native function PlayDialogLineIndex(int DialogLineIndex, optional BioPlayerController ControllerToPlayOn);

public simulated function PlayVOEventLine(Name EventName, int LineIndex, optional SFXPlayerController ControllerToPlayOn = None)
{
    local int idx;
    
    if (LineIndex >= 0)
    {
        for (idx = 0; idx < SimpleVOEvents.Length; idx++)
        {
            if (SimpleVOEvents[idx].EventName == EventName && SimpleVOEvents[idx].Lines.Length > LineIndex)
            {
                PlayDialogLine(SimpleVOEvents[idx].Lines[LineIndex], ControllerToPlayOn);
                break;
            }
        }
    }
}
public simulated function PlayVOEventRandomLine(Name EventName, optional SFXPlayerController ControllerToPlayOn = None)
{
    local int idx;
    local int RandomIndex;
    
    for (idx = 0; idx < SimpleVOEvents.Length; idx++)
    {
        if (SimpleVOEvents[idx].EventName == EventName && SimpleVOEvents[idx].Lines.Length > 0)
        {
            RandomIndex = Rand(SimpleVOEvents[idx].Lines.Length);
            PlayDialogLine(SimpleVOEvents[idx].Lines[RandomIndex], ControllerToPlayOn);
            break;
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    SubtitleColor = {B = 255, G = 255, R = 203, A = 255}
}