Class ParticleModuleTypeDataMesh extends ParticleModuleTypeDataBase
    native
    editinlinenew;

enum EMeshCameraFacingOptions
{
    XAxisFacing_NoUp,
    XAxisFacing_ZUp,
    XAxisFacing_NegativeZUp,
    XAxisFacing_YUp,
    XAxisFacing_NegativeYUp,
    LockedAxis_ZAxisFacing,
    LockedAxis_NegativeZAxisFacing,
    LockedAxis_YAxisFacing,
    LockedAxis_NegativeYAxisFacing,
    VelocityAligned_ZAxisFacing,
    VelocityAligned_NegativeZAxisFacing,
    VelocityAligned_YAxisFacing,
    VelocityAligned_NegativeYAxisFacing,
};
enum EMeshCameraFacingUpAxis
{
    CameraFacing_NoneUP,
    CameraFacing_ZUp,
    CameraFacing_NegativeZUp,
    CameraFacing_YUp,
    CameraFacing_NegativeYUp,
};
enum EMeshScreenAlignment
{
    PSMA_MeshFaceCameraWithRoll,
    PSMA_MeshFaceCameraWithSpin,
    PSMA_MeshFaceCameraWithLockedAxis,
};

var(Mesh) StaticMesh Mesh;
var(Orientation) float Pitch;
var(Orientation) float Roll;
var(Orientation) float Yaw;
var bool CastShadows;
var bool DoCollisions;
var(Mesh) bool bAllowMotionBlur;
var(Mesh) bool bOverrideMaterial;
var(CameraFacing) bool bCameraFacing;
var(Mesh) EMeshScreenAlignment MeshAlignment;
var(Orientation) EParticleAxisLock AxisLockOption;
var(CameraFacing) EMeshCameraFacingOptions CameraFacingOption;

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}