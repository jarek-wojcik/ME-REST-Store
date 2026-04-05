Class SFXAIPerceptionManager extends Actor
    native
    transient;

struct native SFXAIPerceptionNoise 
{
    var Name NoiseType;
    var Actor NoiseMaker;
    var float Loudness;
};

var array<SFXAIPerceptionNoise> Noises;

public final native function AutoAcquireEnemies(BioAiController AI);

public final native function AutoNotifyEnemies(BioAiController AI);

public final native function DelayedNoticeEnemy(BioAiController AI, Pawn Enemy, EPerceptionType Notification, float Delay, Name EventName);

public final native function FillEnemyList(BioAiController AI);

public final native function NoticeEnemy(BioAiController AI, Pawn Enemy, EPerceptionType Notification, bool bPerceivedDirectly, Name EventName);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bOnlyRelevantToOwner = TRUE
    TickGroup = ETickingGroup.TG_DuringAsyncWork
}