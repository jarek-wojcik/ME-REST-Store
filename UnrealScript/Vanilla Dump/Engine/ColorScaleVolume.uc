Class ColorScaleVolume extends Volume
    placeable;

var(ColorScaleVolume) Vector ColorScale;
var(ColorScaleVolume) float InterpTime;

public event function Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local Pawn P;
    local PlayerController PC;
    
    Super(Actor).Touch(Other, OtherComp, HitLocation, HitNormal);
    P = Pawn(Other);
    if (P != None)
    {
        PC = PlayerController(P.Controller);
        if (PC != None && PC.PlayerCamera != None)
        {
            PC.PlayerCamera.SetDesiredColorScale(ColorScale, InterpTime);
        }
    }
}
public event function UnTouch(Actor Other)
{
    local Pawn P;
    local PlayerController PC;
    local Vector DesiredColorScale;
    local float DesiredInterpTime;
    local ColorScaleVolume CSV;
    
    Super(Actor).UnTouch(Other);
    P = Pawn(Other);
    if (P != None)
    {
        PC = PlayerController(P.Controller);
        if (PC != None && PC.PlayerCamera != None)
        {
            DesiredColorScale = WorldInfo.DefaultColorScale;
            DesiredInterpTime = 1.0;
            foreach P.TouchingActors(Class'ColorScaleVolume', CSV, TRUE)
            {
                if (CSV != None && CSV != Self)
                {
                    DesiredColorScale = CSV.ColorScale;
                    DesiredInterpTime = CSV.InterpTime;
                    break;
                }
            }
            PC.PlayerCamera.SetDesiredColorScale(DesiredColorScale, DesiredInterpTime);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BrushComponent Name=BrushComponent0
        ReplacementPrimitive = None
    End Template
    ColorScale = {X = 1.0, Y = 1.0, Z = 1.0}
    InterpTime = 1.0
    BrushComponent = BrushComponent0
    Components = (BrushComponent0)
    CollisionComponent = BrushComponent0
}