Class SFSGenericStringQueue within SFSManager;

struct SFSQueueItem 
{
    var float timestamp;
    var string Value;
};

var array<SFSQueueItem> queue;
var string queueEmptyEventString;
var float evictionTimerSeconds;

public function addItem(string Item)
{
    local SFSQueueItem queueItem;
    
    queueItem.timestamp = Outer.Outer.WorldInfo.GameTimeSeconds;
    queueItem.Value = Item;
    Self.queue.AddItem(queueItem);
    Outer.Outer.SetTimer(1.0, TRUE, 'checkEviction', Self);
}
public function popItem(string Item)
{
    local SFSQueueItem queueItem;
    local int iterator;
    
    for (iterator = 0; iterator < queue.Length; iterator++)
    {
        if (queue[iterator].Value == Item)
        {
            queueItem.timestamp = queue[iterator].timestamp;
            queueItem.Value = queue[iterator].Value;
        }
    }
    Self.queue.RemoveItem(queueItem);
    checkEmpty();
}
public function checkEviction()
{
    local int iterator;
    local float GameTimeSeconds;
    
    GameTimeSeconds = Outer.Outer.WorldInfo.GameTimeSeconds;
    for (iterator = 0; iterator < queue.Length; iterator++)
    {
        if (GameTimeSeconds - queue[iterator].timestamp > evictionTimerSeconds)
        {
            popItem(queue[iterator].Value);
        }
    }
}
private final function checkEmpty()
{
    local SFSEvent queueEmptyEvent;
    
    if (queue.Length <= 0)
    {
        queueEmptyEvent = new (Outer) Class'SFSEvent';
        queueEmptyEvent.sValue = queueEmptyEventString;
        Outer.AddSFSEvent(queueEmptyEvent, Outer.Outer);
        Outer.Outer.ClearTimer('checkEviction', Self);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    evictionTimerSeconds = 3.0
}