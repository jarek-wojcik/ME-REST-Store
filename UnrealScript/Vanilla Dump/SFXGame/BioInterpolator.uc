Class BioInterpolator
    native
    abstract;

enum EBioInterpolationMethod
{
    BIO_INTERPOLATION_METHOD_LINEAR,
    BIO_INTERPOLATION_METHOD_LOG_E,
    BIO_INTERPOLATION_METHOD_QUARTER_SIN,
};

public static final native function InterpolateFloat(out float Output, EBioInterpolationMethod InterpolationMethod, float Source, float Target, float normalizedDisplacement);

public static final native function InterpolateFloatCurve(out float Output, const out InterpCurveFloat Curve, float Source, float Target, float normalizedDisplacement);

public static final native function InterpolateRotator(out Rotator Output, EBioInterpolationMethod InterpolationMethod, Rotator Source, Rotator Target, float normalizedDisplacement);

public static final native function InterpolateVector(out Vector Output, EBioInterpolationMethod InterpolationMethod, Vector Source, Vector Target, float normalizedDisplacement);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}