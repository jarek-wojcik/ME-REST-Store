Class TextureMovie extends Texture
    native;

enum EMovieStreamSource
{
    MovieStream_File,
    MovieStream_Memory,
};

var const native UntypedBulkData_Mirror Data;
var const Class<CodecMovie> DecoderClass;
var const transient native Pointer ReleaseCodecFence;
var const native Guid TextureFileCacheGuid;
var Guid TFCFileGuid;
var Name TextureFileCacheName;
var const int SizeX;
var const int SizeY;
var const transient CodecMovie Decoder;
var const transient bool Paused;
var const transient bool Stopped;
var(TextureMovie) bool Looping;
var(TextureMovie) bool AutoPlay;
var(TextureMovie) bool m_bIsDroppingFrames;
var const EPixelFormat Format;
var(TextureMovie) TextureAddress AddressX;
var(TextureMovie) TextureAddress AddressY;
var(TextureMovie) EMovieStreamSource MovieStreamSource;

public native function Pause();

public native function Play();

public native function Stop();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    DecoderClass = Class'CodecMovieFallback'
    Looping = TRUE
    AutoPlay = TRUE
    MovieStreamSource = EMovieStreamSource.MovieStream_Memory
    NeverStream = TRUE
}