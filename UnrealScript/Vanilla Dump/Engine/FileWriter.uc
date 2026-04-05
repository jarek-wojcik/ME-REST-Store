Class FileWriter extends Info
    native;

enum FWFileType
{
    FWFT_Log,
    FWFT_Stats,
    FWFT_HTML,
    FWFT_User,
    FWFT_Debug,
};

var const string Filename;
var const native Pointer ArchivePtr;
var bool bFlushEachWrite;
var bool bWantsAsyncWrites;
var const FWFileType FileType;

public final native function CloseFile();

public event function Destroyed()
{
    CloseFile();
}
public final native function Logf(coerce string logString);

public final native function bool OpenFile(coerce string InFilename, optional FWFileType InFileType, optional string InExtension, optional bool bUnique, optional bool bIncludeTimeStamp);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bFlushEachWrite = TRUE
    bTickIsDisabled = TRUE
}