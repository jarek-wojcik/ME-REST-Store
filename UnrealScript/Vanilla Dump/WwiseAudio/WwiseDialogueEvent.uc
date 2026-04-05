Class WwiseDialogueEvent extends WwiseEvent
    native;

struct native WwiseDialogueArgument 
{
    var(WwiseDialogueArgument) array<WwiseDialogueArgumentValue> Values;
    var(WwiseDialogueArgument) Name Name;
    var(WwiseDialogueArgument) int Id;
};
struct native WwiseDialogueArgumentValue 
{
    var(WwiseDialogueArgumentValue) Name Name;
    var(WwiseDialogueArgumentValue) int Id;
};

var(DialogueArguments) const editconst array<WwiseDialogueArgument> Arguments;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}