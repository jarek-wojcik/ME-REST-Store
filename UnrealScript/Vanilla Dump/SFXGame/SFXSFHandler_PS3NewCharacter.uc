Class SFXSFHandler_PS3NewCharacter extends BioSFHandler_NewCharacter
    config(UI);

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=BioMorphFaceFrontEnd Name=MorphEditor0
    End Template
    m_oBioMorphFrontEnd = MorphEditor0
    ScreenLayout = GUILayout.GUILayout_PS3
}