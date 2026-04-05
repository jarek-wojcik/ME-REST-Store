Class WwiseProcFoleyComponent extends ActorComponent
    native;

struct native ProcFoleyInfo 
{
    var Vector vLoc;
    var Name nmBoneName;
};
const MAX_PROC_FOLEY_BONES = 4;

var ProcFoleyInfo Info[4];
var editinline export WwiseAudioComponent m_AudioComp;
var WwiseEventPairObject m_FoleySound;
var float m_fLastMaxVel;
var float m_fSmoothFactor;
var float m_fMaxThreshold;
var int m_nProcFoleyRTPCId;
var bool m_bIsPlaying;

public event function int GetMAX_PROC_FOLEY_BONES()
{
    return 4;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Info[0] = {
               vLoc = {X = 0.0, Y = 0.0, Z = 0.0}, 
               nmBoneName = 'LeftWrist'
              }
    Info[1] = {
               vLoc = {X = 0.0, Y = 0.0, Z = 0.0}, 
               nmBoneName = 'RightWrist'
              }
    Info[2] = {
               vLoc = {X = 0.0, Y = 0.0, Z = 0.0}, 
               nmBoneName = 'LeftAnkle'
              }
    Info[3] = {
               vLoc = {X = 0.0, Y = 0.0, Z = 0.0}, 
               nmBoneName = 'RightAnkle'
              }
    m_FoleySound = WwiseEventPairObject'Wwise_Generic_Foley_Procedural.Foley_Procedural_Blend_Container'
}