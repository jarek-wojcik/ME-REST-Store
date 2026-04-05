Class OnlineCommunityContentInterface extends Interface
    abstract;

var delegate<OnReadFriendsContentListComplete> __OnReadFriendsContentListComplete__Delegate;
var delegate<OnUploadContentComplete> __OnUploadContentComplete__Delegate;
var delegate<OnDownloadContentComplete> __OnDownloadContentComplete__Delegate;
var delegate<OnGetContentPayloadComplete> __OnGetContentPayloadComplete__Delegate;
var delegate<OnReadContentListComplete> __OnReadContentListComplete__Delegate;

public function bool DownloadContent(byte PlayerNum, const out CommunityContentFile FileToDownload);

public function Exit();

public function bool Init();

public function AddDownloadContentCompleteDelegate(delegate<OnDownloadContentComplete> DownloadContentCompleteDelegate);

public function AddGetContentPayloadCompleteDelegate(delegate<OnGetContentPayloadComplete> GetContentPayloadCompleteDelegate);

public function AddReadContentListCompleteDelegate(delegate<OnReadContentListComplete> ReadContentListCompleteDelegate);

public function AddReadFriendsContentListCompleteDelegate(delegate<OnReadFriendsContentListComplete> ReadFriendsContentListCompleteDelegate);

public function AddUploadContentCompleteDelegate(delegate<OnUploadContentComplete> UploadContentCompleteDelegate);

public function ClearDownloadContentCompleteDelegate(delegate<OnDownloadContentComplete> DownloadContentCompleteDelegate);

public function ClearGetContentPayloadCompleteDelegate(delegate<OnGetContentPayloadComplete> GetContentPayloadCompleteDelegate);

public function ClearReadContentListCompleteDelegate(delegate<OnReadContentListComplete> ReadContentListCompleteDelegate);

public function ClearReadFriendsContentListCompleteDelegate(delegate<OnReadFriendsContentListComplete> ReadFriendsContentListCompleteDelegate);

public function ClearUploadContentCompleteDelegate(delegate<OnUploadContentComplete> UploadContentCompleteDelegate);

public function bool GetContentList(byte PlayerNum, out array<CommunityContentFile> ContentFiles);

public function bool GetContentPayload(byte PlayerNum, const out CommunityContentFile FileDownloaded);

public function bool GetFriendsContentList(byte PlayerNum, const out OnlineFriend Friend, out array<CommunityContentFile> ContentFiles);

public delegate function OnDownloadContentComplete(bool bWasSuccessful, CommunityContentFile FileDownloaded);

public delegate function OnGetContentPayloadComplete(bool bWasSuccessful, CommunityContentFile FileDownloaded, const out array<byte> Payload);

public delegate function OnReadContentListComplete(bool bWasSuccessful);

public delegate function OnReadFriendsContentListComplete(bool bWasSuccessful);

public delegate function OnUploadContentComplete(bool bWasSuccessful, CommunityContentFile UploadedFile);

public function RateContent(byte PlayerNum, const out CommunityContentFile FileToRate, int NewRating);

public function bool ReadContentList(byte PlayerNum, optional int StartAt = 0, optional int NumToRead = -1);

public function bool ReadFriendsContentList(byte PlayerNum, const out array<OnlineFriend> Friends, optional int StartAt = 0, optional int NumToRead = -1);

public function bool UploadContent(byte PlayerNum, const out array<byte> Payload, const out CommunityContentMetadata MetaData);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}