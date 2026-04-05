Class UIInputConfiguration extends UIRoot
    native
    config(Input);

var const config array<UIInputAliasClassMap> WidgetInputAliases;
var const config array<UIAxisEmulationDefinition> AxisEmulationDefinitions;

public final native function LoadInputAliasClasses();

public native function NotifyGameSessionEnded();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    AxisEmulationDefinitions = ({InputKeyToEmulate[0] = 'None', InputKeyToEmulate[1] = 'None', AxisInputKey = 'MouseX', AdjacentAxisInputKey = 'MouseY', bEmulateButtonPress = FALSE}, 
                                {InputKeyToEmulate[0] = 'None', InputKeyToEmulate[1] = 'None', AxisInputKey = 'MouseY', AdjacentAxisInputKey = 'MouseX', bEmulateButtonPress = FALSE}, 
                                {InputKeyToEmulate[0] = 'Gamepad_LeftStick_Right', InputKeyToEmulate[1] = 'Gamepad_LeftStick_Left', AxisInputKey = 'XboxTypeS_LeftX', AdjacentAxisInputKey = 'XboxTypeS_LeftY', bEmulateButtonPress = TRUE}, 
                                {InputKeyToEmulate[0] = 'Gamepad_LeftStick_Up', InputKeyToEmulate[1] = 'Gamepad_LeftStick_Down', AxisInputKey = 'XboxTypeS_LeftY', AdjacentAxisInputKey = 'XboxTypeS_LeftX', bEmulateButtonPress = TRUE}, 
                                {InputKeyToEmulate[0] = 'Gamepad_RightStick_Right', InputKeyToEmulate[1] = 'Gamepad_RightStick_Left', AxisInputKey = 'XboxTypeS_RightX', AdjacentAxisInputKey = 'XboxTypeS_RightY', bEmulateButtonPress = TRUE}, 
                                {InputKeyToEmulate[0] = 'Gamepad_RightStick_Down', InputKeyToEmulate[1] = 'Gamepad_RightStick_Up', AxisInputKey = 'XboxTypeS_RightY', AdjacentAxisInputKey = 'XboxTypeS_RightX', bEmulateButtonPress = TRUE}
                               )
}