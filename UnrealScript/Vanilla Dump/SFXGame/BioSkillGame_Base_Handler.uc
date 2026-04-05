Class BioSkillGame_Base_Handler extends SFXGUIMovieLegacyAdapter
    native
    abstract
    config(UI);

var string m_sBackgroundMusic;
var delegate<OnSuccessCallback> __OnSuccessCallback__Delegate;
var delegate<OnFailureCallback> __OnFailureCallback__Delegate;
var delegate<OnCancelCallback> __OnCancelCallback__Delegate;
var Name m_sTecPlotStateName;
var float m_fTecTimeMultiplier;
var int m_nStartingResource;
var int m_nPhase2Resource;
var int m_nPhase2Time;
var Object m_oDependent;
var BioPawn m_oUsingPawn;
var bool m_bRewardOnTimeFail;
var bool m_bSuccessfulEndGame;
var bool m_bCanceled;

public native function Cancel();

public native function ExIntCancelGame();

public native function ExIntGameOver(bool bGameWon, int nRemainingResource);

public native function ExIntInitGame();

public native function ExIntInterruptGame();

public native function ExIntStartGame();

public native function ExIntStartLoopingSound();

public native function ExIntStopLoopingSound();

public delegate function OnCancelCallback(int n_TimeTaken);

public delegate function OnFailureCallback(int n_TimeTaken);

public delegate function OnSuccessCallback(int n_TimeTaken);


//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_fTecTimeMultiplier = 1.0
    m_nStartingResource = 10000
    m_nPhase2Time = 20000
}