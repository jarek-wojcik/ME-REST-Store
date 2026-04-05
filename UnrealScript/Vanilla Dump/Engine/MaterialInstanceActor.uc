Class MaterialInstanceActor extends Actor
    native
    placeable;

var(MaterialInstanceActor) MaterialInstanceConstant MatInst;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Components = (None)
    bNoDelete = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}