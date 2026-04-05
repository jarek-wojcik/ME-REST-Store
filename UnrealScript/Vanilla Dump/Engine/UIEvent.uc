Class UIEvent extends SequenceEvent
    native
    placeable
    abstract;

var const localized string Description;
var delegate<AllowEventActivation> __AllowEventActivation__Delegate;
var const int SubobjectVersionModifier;
var noimport UIScreenObject EventOwner;
var Object EventActivator;
var bool bShouldRegisterEvent;
var bool bPropagateEvent;

public final native function bool ActivateUIEvent(int ControllerIndex, UIScreenObject InEventOwner, optional Object InEventActivator, optional bool bActivateImmediately, optional const out array<int> IndicesToActivate);

public delegate function bool AllowEventActivation(int ControllerIndex, UIScreenObject InEventOwner, Object InEventActivator, bool bActivateImmediately, const out array<int> IndicesToActivate);

public final native function bool CanBeActivated(int ControllerIndex, UIScreenObject InEventOwner, optional Object InEventActivator, optional bool bActivateImmediately, optional const out array<int> IndicesToActivate);

public final native function bool ConditionalActivateUIEvent(int ControllerIndex, UIScreenObject InEventOwner, optional Object InEventActivator, optional bool bActivateImmediately, optional const out array<int> IndicesToActivate);

public static event function int GetObjClassVersion()
{
    return Super(SequenceObject).GetObjClassVersion() + default.SubobjectVersionModifier + 2;
}
public final native function UIScreenObject GetOwner();

public final native function UIScene GetOwnerScene();

public event function bool IsValidLevelSequenceObject()
{
    return FALSE;
}
public event function bool IsValidUISequenceObject(optional UIScreenObject TargetObject)
{
    return TRUE;
}
public event function bool ShouldAlwaysInstance()
{
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bShouldRegisterEvent = TRUE
    bPropagateEvent = TRUE
    bClientSideOnly = TRUE
    VariableLinks = ({
                      LinkedVariables = (), 
                      LinkDesc = "Activator", 
                      ExpectedType = Class'SeqVar_Object', 
                      LinkVar = 'None', 
                      PropertyName = 'None', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Player Index", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'PlayerIndex', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }, 
                     {
                      LinkedVariables = (), 
                      LinkDesc = "Gamepad Id", 
                      ExpectedType = Class'SeqVar_Int', 
                      LinkVar = 'None', 
                      PropertyName = 'GamepadID', 
                      MinVars = 1, 
                      MaxVars = 255, 
                      CachedProperty = None, 
                      bWriteable = TRUE, 
                      bModifiesLinkedObject = FALSE, 
                      bAllowAnyType = FALSE
                     }
                    )
}