Class KActorSpawnable extends KActor
    native;

var bool bRecycleScaleToZero;
var bool bScalingToZero;

public simulated function Initialize()
{
    bScalingToZero = FALSE;
    SetDrawScale(default.DrawScale);
    ClearTimer('Recycle');
    SetHidden(FALSE);
    StaticMeshComponent.SetHidden(FALSE);
    SetTickIsDisabled(FALSE);
    SetPhysics(10);
    SetCollision(TRUE, FALSE, );
}
public simulated function Recycle()
{
    if (bRecycleScaleToZero)
    {
        bScalingToZero = TRUE;
    }
    else
    {
        RecycleInternal();
    }
}
public event simulated function RecycleInternal()
{
    SetHidden(TRUE);
    StaticMeshComponent.SetHidden(TRUE);
    SetPhysics(0);
    SetCollision(FALSE, FALSE, );
    ClearTimer('Recycle');
    SetTickIsDisabled(TRUE);
}
public final native function ResetComponents();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
    End Template
    Begin Template Class=StaticMeshComponent Name=StaticMeshComponent0
        ReplacementPrimitive = None
        LightEnvironment = MyLightEnvironment
    End Template
    StaticMeshComponent = StaticMeshComponent0
    LightEnvironment = MyLightEnvironment
    Components = (MyLightEnvironment, StaticMeshComponent0)
    CollisionComponent = StaticMeshComponent0
    bNoDelete = FALSE
}