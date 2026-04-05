Class BioSFHandler_PCConversation extends BioSFHandler_Conversation
    native
    config(UI);

var Vector vMouseInput;
var config float AccumulationDivisor;

public event function bool HandleInputEvent(BioGuiEvents Event, optional float fValue = 1.0)
{
    switch (Event)
    {
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_X:
        case BioGuiEvents.BIOGUI_EVENT_AXIS_LSTICK_Y:
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_MOUSE_X:
            vInput.X = fValue;
            break;
        case BioGuiEvents.BIOGUI_EVENT_AXIS_MOUSE_Y:
            vInput.Y = fValue;
            break;
        default:
            return Super.HandleInputEvent(Event, fValue);
    }
    return TRUE;
}
public function OnPanelAdded()
{
    Super.OnPanelAdded();
    SetMouseShown(FALSE);
    vMouseInput = vect(1.0, 0.0, 0.0);
    AS_SetArrowPosition(0, FALSE);
}
public function HighlightDefaultConvSegment()
{
    vMouseInput = vect(1.0, 0.0, 0.0);
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AccumulationDivisor = 100.0
    ScreenLayout = GUILayout.GUILayout_PC
}