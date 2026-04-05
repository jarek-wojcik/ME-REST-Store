Class SFXGameModeCheatMenu extends SFXGameModeBase within BioPlayerController
    config(Input);

public function Activated()
{
    local BioWorldInfo oBWI;
    
    Super.Activated();
    oBWI = BioWorldInfo(Outer.WorldInfo);
    if (oBWI == None)
    {
        return;
    }
    if (oBWI.m_oPropertyEditor == None)
    {
        oBWI.m_oPropertyEditor = new (Self) Class'BioInGamePropertyEditor';
        oBWI.m_oPropertyEditor.Initialize();
    }
    oBWI.m_oPropertyEditor.ActivateSystem();
    BioHUD(oBWI.GetLocalPlayerController().myHUD).AddDebugDraw(DebugDraw_PropertyEditor);
}
public function Deactivated()
{
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Outer.WorldInfo);
    if (oBWI != None)
    {
        if (oBWI.m_oPropertyEditor != None)
        {
            oBWI.m_oPropertyEditor.DeactivateSystem();
        }
    }
    BioHUD(oBWI.GetLocalPlayerController().myHUD).ClearDebugDraw(DebugDraw_PropertyEditor);
    Super.Deactivated();
}
private final function DebugDraw_PropertyEditor(BioHUD HUD)
{
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Outer.WorldInfo);
    if (oBWI == None)
    {
        return;
    }
    if (oBWI.m_oPropertyEditor == None)
    {
        return;
    }
    oBWI.m_oPropertyEditor.DrawToHUD(HUD);
}
public exec function EndIPE()
{
    Outer.GameModeManager2.DisableMode(14);
}
public exec function IPEBack()
{
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Outer.WorldInfo);
    if (oBWI == None)
    {
        return;
    }
    if (oBWI.m_oPropertyEditor != None)
    {
        oBWI.m_oPropertyEditor.PerformLeftAction();
    }
}
public exec function IPEDownAction()
{
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Outer.WorldInfo);
    if (oBWI == None)
    {
        return;
    }
    if (oBWI.m_oPropertyEditor != None)
    {
        oBWI.m_oPropertyEditor.PerformDownAction();
    }
}
public exec function IPEForward()
{
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Outer.WorldInfo);
    if (oBWI == None)
    {
        return;
    }
    if (oBWI.m_oPropertyEditor != None)
    {
        oBWI.m_oPropertyEditor.PerformRightAction();
    }
}
public exec function IPELeftShoulder()
{
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Outer.WorldInfo);
    if (oBWI == None)
    {
        return;
    }
    if (oBWI.m_oPropertyEditor != None)
    {
        oBWI.m_oPropertyEditor.PerformLeftShoulderAction();
    }
}
public exec function IPELeftTrigger()
{
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Outer.WorldInfo);
    if (oBWI == None)
    {
        return;
    }
    if (oBWI.m_oPropertyEditor != None)
    {
        oBWI.m_oPropertyEditor.PerformLeftTriggerAction();
    }
}
public exec function IPERightShoulder()
{
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Outer.WorldInfo);
    if (oBWI == None)
    {
        return;
    }
    if (oBWI.m_oPropertyEditor != None)
    {
        oBWI.m_oPropertyEditor.PerformRightShoulderAction();
    }
}
public exec function IPERightTrigger()
{
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Outer.WorldInfo);
    if (oBWI == None)
    {
        return;
    }
    if (oBWI.m_oPropertyEditor != None)
    {
        oBWI.m_oPropertyEditor.PerformRightTriggerAction();
    }
}
public exec function IPEUpAction()
{
    local BioWorldInfo oBWI;
    
    oBWI = BioWorldInfo(Outer.WorldInfo);
    if (oBWI == None)
    {
        return;
    }
    if (oBWI.m_oPropertyEditor != None)
    {
        oBWI.m_oPropertyEditor.PerformUpAction();
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    bMergeNotifications = TRUE
    Priority = EGameModePriority2.ModePriority_CheatMenu
}