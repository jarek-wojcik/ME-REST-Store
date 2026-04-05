Class OnlineNewsInterfaceMcp extends MCPBase
    implements(OnlineNewsInterface)
    native
    config(Engine);

struct native NewsCacheEntry 
{
    var const string NewsUrl;
    var string NewsItem;
    var const native Pointer HttpDownloader;
    var const float TimeOut;
    var const bool bIsUnicode;
    var EOnlineEnumerationReadState ReadState;
    var const EOnlineNewsType NewsType;
};

var config array<NewsCacheEntry> NewsItems;
var array<delegate<OnReadNewsCompleted>> ReadNewsDelegates;
var delegate<OnReadNewsCompleted> __OnReadNewsCompleted__Delegate;
var transient bool bNeedsTicking;

public delegate function OnReadNewsCompleted(bool bWasSuccessful, EOnlineNewsType NewsType);

public native function bool ReadNews(byte LocalUserNum, EOnlineNewsType NewsType);

public function AddReadNewsCompletedDelegate(delegate<OnReadNewsCompleted> ReadNewsDelegate)
{
    if (ReadNewsDelegates.Find(ReadNewsDelegate) == -1)
    {
        ReadNewsDelegates[ReadNewsDelegates.Length] = ReadNewsDelegate;
    }
}
public function ClearReadNewsCompletedDelegate(delegate<OnReadNewsCompleted> ReadGameNewsDelegate)
{
    local int RemoveIndex;
    
    RemoveIndex = ReadNewsDelegates.Find(ReadGameNewsDelegate);
    if (RemoveIndex != -1)
    {
        ReadNewsDelegates.Remove(RemoveIndex, 1);
    }
}
public function string GetNews(byte LocalUserNum, EOnlineNewsType NewsType)
{
    local int NewsIndex;
    
    for (NewsIndex = 0; NewsIndex < NewsItems.Length; NewsIndex++)
    {
        if (int(NewsItems[NewsIndex].NewsType) == int(NewsType))
        {
            return NewsItems[NewsIndex].NewsItem;
        }
    }
    return "";
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}