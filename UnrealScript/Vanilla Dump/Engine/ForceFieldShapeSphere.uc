Class ForceFieldShapeSphere extends ForceFieldShape
    native
    editinlinenew;

var editinline export DrawSphereComponent Shape;

public event function FillByBox(Vector Extent)
{
    Shape.SphereRadius = VSize(Extent);
}
public event function FillByCapsule(float Height, float Radius)
{
    Shape.SphereRadius = Height / float(2) + Radius;
}
public event function FillByCylinder(float BottomRadius, float TopRadius, float Height, float HeightOffset)
{
    local float topDistance;
    local float bottomDistance;
    local float centerBelowTop;
    local float centerAboveBottom;
    
    centerBelowTop = Height / float(2) + HeightOffset;
    centerAboveBottom = Height / float(2) - HeightOffset;
    topDistance = Sqrt(TopRadius * TopRadius + centerBelowTop * centerBelowTop);
    bottomDistance = Sqrt(BottomRadius * BottomRadius + centerAboveBottom * centerAboveBottom);
    Shape.SphereRadius = FMax(topDistance, bottomDistance);
}
public event function FillBySphere(float Radius)
{
    Shape.SphereRadius = Radius;
}
public event function PrimitiveComponent GetDrawComponent()
{
    return Shape;
}
public event function float GetRadius()
{
    return Shape.SphereRadius;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DrawSphereComponent Name=DrawSphere0
        SphereRadius = 200.0
        ReplacementPrimitive = None
    End Object
    Shape = DrawSphere0
}