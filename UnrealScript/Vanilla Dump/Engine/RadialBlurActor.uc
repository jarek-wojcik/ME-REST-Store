Class RadialBlurActor extends Actor
    placeable;

var(RadialBlurActor) editinline export RadialBlurComponent RadialBlur;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Object Class=RadialBlurComponent Name=RadialBlurComp
    End Object
    Begin Object Class=SpriteComponent Name=Sprite
        ReplacementPrimitive = None
    End Object
    RadialBlur = RadialBlurComp
    Components = (RadialBlurComp, Sprite)
}