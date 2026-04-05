Class OnlineTitleFileDownloadMcp extends MCPBase
    native
    config(Engine);

var array<delegate<OnReadTitleFileComplete>> ReadTitleFileCompleteDelegates;
var array<TitleFile> TitleFiles;
var config string BaseUrl;
var delegate<OnReadTitleFileComplete> __OnReadTitleFileComplete__Delegate;
var const native Pointer HttpDownloader;
var transient int CurrentIndex;
var config float TimeOut;

public native function bool GetTitleFileContents(string Filename, out array<byte> FileContents);

public delegate function OnReadTitleFileComplete(bool bWasSuccessful, string Filename);

public native function bool ReadTitleFile(string FileToRead);

public native function bool ClearDownloadedFiles();

public function AddReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
    if (ReadTitleFileCompleteDelegates.Find(ReadTitleFileCompleteDelegate) == -1)
    {
        ReadTitleFileCompleteDelegates[ReadTitleFileCompleteDelegates.Length] = ReadTitleFileCompleteDelegate;
    }
}
public function ClearReadTitleFileCompleteDelegate(delegate<OnReadTitleFileComplete> ReadTitleFileCompleteDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = ReadTitleFileCompleteDelegates.Find(ReadTitleFileCompleteDelegate);
    if (RemoveIndex != -1)
    {
        ReadTitleFileCompleteDelegates.Remove(RemoveIndex, 1);
    }
}
public function EOnlineEnumerationReadState GetTitleFileState(string Filename)
{
    local int FileIndex;
    
    FileIndex = TitleFiles.Find('Filename', Filename);
    if (FileIndex != -1)
    {
        return TitleFiles[FileIndex].AsyncState;
    }
    return 3;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}