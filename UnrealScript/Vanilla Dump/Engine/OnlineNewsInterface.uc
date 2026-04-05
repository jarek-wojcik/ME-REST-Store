Class OnlineNewsInterface extends Interface
    abstract;

var delegate<OnReadNewsCompleted> __OnReadNewsCompleted__Delegate;

public delegate function OnReadNewsCompleted(bool bWasSuccessful, EOnlineNewsType NewsType);

public function bool ReadNews(byte LocalUserNum, EOnlineNewsType NewsType);

public function AddReadNewsCompletedDelegate(delegate<OnReadNewsCompleted> ReadNewsDelegate);

public function ClearReadNewsCompletedDelegate(delegate<OnReadNewsCompleted> ReadNewsDelegate);

public function string GetNews(byte LocalUserNum, EOnlineNewsType NewsType);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}