Class SoundNodeWave extends SoundNode
    native
    editinlinenew
    perobjectconfig;

enum EDecompressionType
{
    DTYPE_Setup,
    DTYPE_Invalid,
    DTYPE_Preview,
    DTYPE_Native,
    DTYPE_RealTime,
    DTYPE_Procedural,
    DTYPE_Xenon,
};

var const native UntypedBulkData_Mirror RawData;
var const native UntypedBulkData_Mirror CompressedPCData;
var const native UntypedBulkData_Mirror CompressedXbox360Data;
var const native UntypedBulkData_Mirror CompressedPS3Data;
var(TTS) const localized string SpokenText;
var const array<int> ChannelOffsets;
var const array<int> ChannelSizes;
var(Subtitles) const localized array<SubtitleCue> Subtitles;
var array<LocalizedSubtitle> LocalizedSubtitles;
var const native Pointer VorbisDecompressor;
var const native Pointer RawPCMData;
var const native Pointer ResourceData;
var(Compression) int CompressionQuality;
var(Info) const editconst float Volume;
var(Info) const editconst float Pitch;
var(Info) const editconst float Duration;
var(Info) const editconst int NumChannels;
var(Info) const editconst int SampleRate;
var const int RawPCMDataSize;
var const transient int ResourceID;
var const transient int ResourceSize;
var(Compression) bool bForceRealTimeDecompression;
var(Compression) bool bLoopingSound;
var const transient bool bDynamicResource;
var(TTS) bool bUseTTS;
var transient bool bProcedural;
var(Subtitles) const localized bool bMature;
var(Subtitles) const localized bool bManualWordWrap;
var(TTS) ETTSSpeaker TTSSpeaker;
var const transient EDecompressionType DecompressionType;

public event function GeneratePCMData(out array<byte> Buffer, int SamplesNeeded);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    CompressionQuality = 40
    Volume = 0.75
    Pitch = 1.0
    bLoopingSound = TRUE
}