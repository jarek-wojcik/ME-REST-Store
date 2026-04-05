Class SFXGRISP extends SFXGRI
    config(Game);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=RvrClientEffectManager Name=CEManager
    End Template
    Begin Template Class=RvrClientEffectPool Name=CEPool
    End Template
    Begin Template Class=SFXGameConfig Name=GameConfigBase
    End Template
    VocManagerClass = Class'SFXVocalizationManagerSP'
    gameconfig = GameConfigBase
    m_pClientEffectManager = CEManager
    m_pClientEffectPool = CEPool
}