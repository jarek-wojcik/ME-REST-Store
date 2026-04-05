Class AnimationCompressionAlgorithm
    native
    abstract;

var string Description;
var bool bNeedsSkeleton;
var AnimationCompressionFormat TranslationCompressionFormat;
var(AnimationCompressionAlgorithm) AnimationCompressionFormat RotationCompressionFormat;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Description = "None"
    RotationCompressionFormat = AnimationCompressionFormat.ACF_Float96NoW
}