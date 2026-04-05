Class ForceFieldShapeCapsule extends ForceFieldShape
    native
    editinlinenew;

var editinline export DrawCapsuleComponent Shape;

public event function FillByBox(Vector Extent)
{
    Shape.CapsuleRadius = Sqrt(Extent.X * Extent.X + Extent.Y * Extent.Y);
    Shape.CapsuleHeight = Extent.Z * float(2);
}
public event function FillByCapsule(float Height, float Radius)
{
    Shape.CapsuleHeight = Height;
    Shape.CapsuleRadius = Radius;
}
public event function FillByCylinder(float BottomRadius, float TopRadius, float Height, float HeightOffset)
{
    Shape.CapsuleRadius = FMax(BottomRadius, TopRadius);
    Shape.CapsuleHeight = Height + Abs(HeightOffset) * float(2);
}
public event function FillBySphere(float Radius)
{
    Shape.CapsuleRadius = Radius;
    Shape.CapsuleHeight = 0.0;
}
public event function PrimitiveComponent GetDrawComponent()
{
    return Shape;
}
public event function float GetHeight()
{
    return Shape.CapsuleHeight;
}
public event function float GetRadius()
{
    return Shape.CapsuleRadius;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=DrawCapsuleComponent Name=DrawCapsule0
        ReplacementPrimitive = None
        Rotation = {Pitch = 0, Yaw = 0, Roll = 16384}
    End Object
    Shape = DrawCapsule0
}