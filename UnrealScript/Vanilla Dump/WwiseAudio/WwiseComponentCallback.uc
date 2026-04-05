Class WwiseComponentCallback extends Interface
    native
    abstract;

struct native WwiseComponentCallbackInfo 
{
    var WwiseComponentCallback TargetObject;
    var int CallbackFlags;
    var WwiseEvent TargetEvent;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}