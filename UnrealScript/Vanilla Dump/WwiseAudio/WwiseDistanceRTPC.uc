Class WwiseDistanceRTPC extends Actor;

const AUDIO_DISTANCE_FACTOR = 0.01;

var(WwiseDistanceRTPC) string RTPCName;
var(WwiseDistanceRTPC) float TickDelay;
var float m_fTimeSinceLastUpdate;

public function Tick(float DeltaTime)
{
    local float DistanceFromListener;
    local Vector Distance;
    local Vector MicPosition;
    
    Super.Tick(DeltaTime);
    m_fTimeSinceLastUpdate += DeltaTime;
    if (m_fTimeSinceLastUpdate > TickDelay)
    {
        m_fTimeSinceLastUpdate = 0.0;
        MicPosition = Class'WwiseAudioComponent'.static.GetMicPosition();
        Distance = MicPosition - Self.location;
        DistanceFromListener = VSize(Distance) * 0.00999999978;
        Class'WwiseAudioComponent'.static.SetGlobalRTPCFromScript(RTPCName, DistanceFromListener);
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TickDelay = 0.5
    Components = (None)
}