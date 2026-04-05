Class WwiseMicPosOrient extends Actor
    native
    placeable;

public native function Vector GetFrontVector();

public native function Vector GetUpVector();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Components = (None, None)
    Rotation = {Pitch = -16384, Yaw = 0, Roll = 0}
}