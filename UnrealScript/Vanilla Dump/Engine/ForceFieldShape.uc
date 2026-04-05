Class ForceFieldShape
    native
    editinlinenew
    abstract;

public event function FillByBox(Vector Dimension);

public event function FillByCapsule(float Height, float Radius);

public event function FillByCylinder(float BottomRadius, float TopRadius, float Height, float HeightOffset);

public event function FillBySphere(float Radius);

public event function PrimitiveComponent GetDrawComponent();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}