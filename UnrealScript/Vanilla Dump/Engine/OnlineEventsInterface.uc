Class OnlineEventsInterface extends Interface
    abstract;

public function bool UploadGameplayEventsData(OnlineGameplayEvents Events);

public function bool UploadProfileData(UniqueNetId UniqueId, string PlayerNick, OnlineProfileSettings ProfileSettings);

public function bool UploadHardwareData(UniqueNetId UniqueId, string PlayerNick);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}