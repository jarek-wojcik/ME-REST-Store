Class OnlineContentInterface extends Interface
    abstract;

var delegate<OnReadContentComplete> __OnReadContentComplete__Delegate;
var delegate<OnQueryAvailableDownloadsComplete> __OnQueryAvailableDownloadsComplete__Delegate;
var delegate<OnContentChange> __OnContentChange__Delegate;

public function AddContentChangeDelegate(delegate<OnContentChange> ContentDelegate, optional byte LocalUserNum = 255);

public function AddQueryAvailableDownloadsComplete(byte LocalUserNum, delegate<OnQueryAvailableDownloadsComplete> QueryDownloadsDelegate);

public function AddReadContentComplete(byte LocalUserNum, delegate<OnReadContentComplete> ReadContentCompleteDelegate);

public function ClearContentChangeDelegate(delegate<OnContentChange> ContentDelegate, optional byte LocalUserNum = 255);

public function ClearQueryAvailableDownloadsComplete(byte LocalUserNum, delegate<OnQueryAvailableDownloadsComplete> QueryDownloadsDelegate);

public function ClearReadContentComplete(byte LocalUserNum, delegate<OnReadContentComplete> ReadContentCompleteDelegate);

public function GetAvailableDownloadCounts(byte LocalUserNum, out int NewDownloads, out int TotalDownloads);

public function EOnlineEnumerationReadState GetContentList(byte LocalUserNum, out array<OnlineContent> ContentList);

public delegate function OnContentChange();

public delegate function OnQueryAvailableDownloadsComplete(bool bWasSuccessful);

public delegate function OnReadContentComplete(bool bWasSuccessful);

public function bool QueryAvailableDownloads(byte LocalUserNum, optional int CategoryMask = -1);

public function bool ReadContentList(byte LocalUserNum);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}