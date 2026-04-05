Class BioTierManager
    native
    transient
    config(Engine);

struct native TierDetails_t 
{
    var Name TierName;
    var Color Color;
    var int Priority;
    var bool IsEnabled;
    var bool IsFloor;
    var bool IsGlobal;
    var bool IsDynamic;
};

var config array<TierDetails_t> TierDetails;
var transient array<BioTierInfo> TierInfo;
var config Name DefaultTier;
var transient bool bReevaluateStreaming;
var transient byte FloorTierIndex;

public static native function BackgroundStreamingDone(const out array<Sequence> Sequences, Pawn PlayerPawn);

public static native function ConvertPlotStreaming(Name fnVirtualChunk, out array<PlotStreamingElement> aRealChunks);

public static native function ForegroundStreamingDone(const out array<Sequence> Sequences, Pawn PlayerPawn);

public native function BioTierInfo GetFloorTier();

public static native function byte GetNumTiers();

public native function BioTierInfo GetTier(byte Index);

public static native function Name GetTierName(byte Index);

public static native function RegisterPlotStreaming(const out array<PlotStreamingSet> PlotStreaming);

public static native function UnregisterPlotStreaming(const out array<PlotStreamingSet> PlotStreaming);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    TierDetails = ({
                    TierName = 'TIER_Art', 
                    Color = {B = 0, G = 255, R = 0, A = 0}, 
                    Priority = 1, 
                    IsEnabled = TRUE, 
                    IsFloor = TRUE, 
                    IsGlobal = FALSE, 
                    IsDynamic = FALSE
                   }, 
                   {
                    TierName = 'TIER_Art2', 
                    Color = {B = 0, G = 196, R = 0, A = 0}, 
                    Priority = 2, 
                    IsEnabled = TRUE, 
                    IsFloor = FALSE, 
                    IsGlobal = FALSE, 
                    IsDynamic = FALSE
                   }, 
                   {
                    TierName = 'TIER_Design', 
                    Color = {B = 255, G = 0, R = 0, A = 0}, 
                    Priority = 3, 
                    IsEnabled = TRUE, 
                    IsFloor = FALSE, 
                    IsGlobal = FALSE, 
                    IsDynamic = TRUE
                   }, 
                   {
                    TierName = 'TIER_Design2', 
                    Color = {B = 196, G = 0, R = 0, A = 0}, 
                    Priority = 4, 
                    IsEnabled = TRUE, 
                    IsFloor = FALSE, 
                    IsGlobal = FALSE, 
                    IsDynamic = TRUE
                   }, 
                   {
                    TierName = 'TIER_Design3', 
                    Color = {B = 128, G = 0, R = 0, A = 0}, 
                    Priority = 5, 
                    IsEnabled = TRUE, 
                    IsFloor = FALSE, 
                    IsGlobal = FALSE, 
                    IsDynamic = TRUE
                   }, 
                   {
                    TierName = 'TIER_Audio', 
                    Color = {B = 0, G = 255, R = 255, A = 0}, 
                    Priority = 6, 
                    IsEnabled = TRUE, 
                    IsFloor = FALSE, 
                    IsGlobal = FALSE, 
                    IsDynamic = FALSE
                   }, 
                   {
                    TierName = 'TIER_Global', 
                    Color = {B = 255, G = 0, R = 255, A = 0}, 
                    Priority = 7, 
                    IsEnabled = TRUE, 
                    IsFloor = FALSE, 
                    IsGlobal = TRUE, 
                    IsDynamic = FALSE
                   }, 
                   {
                    TierName = 'TIER_QA', 
                    Color = {B = 64, G = 64, R = 0, A = 0}, 
                    Priority = 8, 
                    IsEnabled = FALSE, 
                    IsFloor = FALSE, 
                    IsGlobal = TRUE, 
                    IsDynamic = FALSE
                   }, 
                   {
                    TierName = 'TIER_Disabled', 
                    Color = {B = 128, G = 128, R = 128, A = 0}, 
                    Priority = 0, 
                    IsEnabled = FALSE, 
                    IsFloor = FALSE, 
                    IsGlobal = FALSE, 
                    IsDynamic = FALSE
                   }
                  )
    DefaultTier = 'TIER_Art'
}