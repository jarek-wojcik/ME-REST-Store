Class SoundNodeWaveStreaming extends SoundNodeWave
    native
    editinlinenew
    perobjectconfig;

var array<byte> QueuedAudio;

public event native function int AvailableAudioBytes();

public event native function GeneratePCMData(out array<byte> Buffer, int SamplesNeeded);

public event native function QueueAudio(array<byte> Data);

public event native function ResetAudio();


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bLoopingSound = FALSE
    bProcedural = TRUE
}