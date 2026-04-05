Class ForceFieldShapeBox extends ForceFieldShape
    native
    editinlinenew;

var editinline export DrawBoxComponent Shape;

public event function FillByBox(Vector Extent)
{
    Shape.BoxExtent = Extent;
}
public event function FillByCapsule(float Height, float Radius)
{
    Shape.BoxExtent.X = Radius;
    Shape.BoxExtent.Y = Radius;
    Shape.BoxExtent.Z = Radius + Height / float(2);
}
public event function FillByCylinder(float BottomRadius, float TopRadius, float Height, float HeightOffset)
{
    Shape.BoxExtent.X = FMax(BottomRadius, TopRadius);
    Shape.BoxExtent.Y = Shape.BoxExtent.X;
    Shape.BoxExtent.Z = Height / float(2) + Abs(HeightOffset);
}
public event function FillBySphere(float Radius)
{
    Shape.BoxExtent.X = Radius;
    Shape.BoxExtent.Y = Radius;
    Shape.BoxExtent.Z = Radius;
}
public event function PrimitiveComponent GetDrawComponent()
{
    return Shape;
}
public event function Vector GetRadii()
{
    return Shape.BoxExtent;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DrawBoxComponent Name=DrawBox0
        ReplacementPrimitive = None
    End Object
    Shape = DrawBox0
}