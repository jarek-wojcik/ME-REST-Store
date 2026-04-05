Class Texture2D extends Texture
    native
    config(Engine);

struct native Texture2DMipMap 
{
    var native UntypedBulkData_Mirror Data;
    var native int SizeX;
    var native int SizeY;
};

var const native IndirectArray_Mirror Mips;
var array<byte> SystemMemoryData;
var const transient native Pointer ResourceMem;
var const native Guid TextureFileCacheGuid;
var Guid TFCFileGuid;
var Name TextureFileCacheName;
var const int SizeX;
var const int SizeY;
var const int OriginalSizeX;
var const int OriginalSizeY;
var transient int ForceMiplevelsToBeResident;
var transient float ForceMipLevelsToBeResidentTimestamp;
var const transient int RequestedMips;
var const transient int ResidentMips;
var const transient native ThreadSafeCounter PendingMipChangeRequestStatus;
var const int MipTailBaseIdx;
var const transient native int FirstResourceMemMip;
var native int BioMipMapCompressionSetting;
var transient native float CurrentScreenSize;
var transient native float CurrentDistanceFromCameraSq;
var transient native float CurrentScreenSizeOld;
var transient native float CurrentDistanceFromCameraSqOld;
var transient native int StreamingLinkIndex;
var const transient native float Timer;
var const transient bool bIsStreamable;
var const transient bool bHasCancelationPending;
var const transient bool bHasBeenLoadedFromPersistentArchive;
var(Texture2D) const bool bGlobalForceMipLevelsToBeResident;
var config bool bConfigForceMiplevelsToBeResident;
var const EPixelFormat Format;
var(Texture2D) TextureAddress AddressX;
var(Texture2D) TextureAddress AddressY;

public static final native function Texture2D Create(int InSizeX, int InSizeY, optional EPixelFormat InFormat = 2);

public final native function SetForceMipLevelsToBeResident(float Seconds, optional int CinematicTextureGroups = 0);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}