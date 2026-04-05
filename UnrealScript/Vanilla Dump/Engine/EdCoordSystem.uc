Class EdCoordSystem
    native
    editinlinenew;

var(EdCoordSystem) Matrix M;
var(EdCoordSystem) string Desc;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    M = {
         XPlane = {W = 0.0, X = 1.0, Y = 0.0, Z = 0.0}, 
         YPlane = {W = 0.0, X = 0.0, Y = 1.0, Z = 0.0}, 
         ZPlane = {W = 0.0, X = 0.0, Y = 0.0, Z = 1.0}, 
         WPlane = {W = 1.0, X = 0.0, Y = 0.0, Z = 0.0}
        }
    Desc = "Coord System"
}