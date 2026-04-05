Class Note extends Actor
    native
    placeable;

var(Note) string Text;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Components = (None, None)
    bStatic = TRUE
    bHidden = TRUE
    bNoDelete = TRUE
    bMovable = FALSE
}