Class BioInGamePropertyEditor
    native;

var string m_sFooterText;
var string m_sFileName;
var string m_sEditableRootName;
var string m_sCameraRootName;
var string m_sAnimNodeName;
var string m_sNewLoadSaveNodeName;
var string m_sStateNodeName;
var string m_sActionMappingName;
var BioPropertyEditorBaseNode m_oPropertyEditorNodes;
var float m_fHUDRelativePropertyEditorOriginX;
var float m_fHUDRelativePropertyEditorOriginY;
var float m_fPropertyEditorSizeX;
var float m_fPropertyEditorSizeY;
var float m_fPropertyEditorRelativeColumnOneX;
var float m_fPropertyEditorRelativeColumnTwoX;
var float m_fPropertyEditorRelativeColumnThreeX;
var float m_fPropertyEditorRelativeColumnY;
var float m_fColumnHeight;
var bool m_bIsActive;
var bool m_bDebugBones;
var bool m_bSortByType;
var bool m_bSortByName;

public native function bool ActivateMainMenu();

public native function bool ActivateSystem();

public event function CreateGameplayNodes(BioPropertyEditorBaseNode Parent);

public native function bool CreateNodeTestData();

public native function bool DeactivateSystem();

public native function DrawBones(BioHUD oHud);

public native function bool Initialize();

public native function bool PerformActivateAction();

public native function bool PerformDeactivateAction();

public native function bool PerformDownAction();

public native function bool PerformLeftAction();

public native function bool PerformLeftShoulderAction();

public native function bool PerformLeftTriggerAction();

public native function bool PerformRightAction();

public native function bool PerformRightShoulderAction();

public native function bool PerformRightTriggerAction();

public native function bool PerformUpAction();

public native function bool UpdateSystem(float fDeltaTime);

public native function bool WriteTreeDataToHUD(BioHUD oHud);

public function CreateCommand(BioPropertyEditorBaseNode Parent, string CmdName, string Command)
{
    local BioPropertyEditorLevelNode oControlNode;
    
    oControlNode = new (Self) Class'BioPropertyEditorLevelNode';
    oControlNode.m_sNodeDisplayName = CmdName;
    oControlNode.m_sCommand = Command;
    oControlNode.m_oTop = Self;
    Parent.m_aChildren.AddItem(oControlNode);
}
public function CreateObjectNode(BioPropertyEditorBaseNode Parent, Object o, string ObjName)
{
    local BioPropertyEditorPropertyNode oControlNode;
    
    oControlNode = new (Self) Class'BioPropertyEditorPropertyNode';
    oControlNode.m_sNodeDisplayName = ObjName;
    oControlNode.m_oParent = Parent;
    oControlNode.m_sDeliminator = "";
    oControlNode.SetObject(o);
    oControlNode.MakeNodes("");
    Parent.m_aChildren.AddItem(oControlNode);
}
public function DrawToHUD(BioHUD oHud)
{
    local Canvas oCanvas;
    local float fBorderSpacing;
    local int i;
    local int minimum;
    local int FootHeaderHeight;
    local BioPropertyEditorBaseNode oFocusedControlNode;
    local BioPropertyEditorBaseNode oSelectableSiblingsParent;
    local Color Col;
    
    if (m_bDebugBones)
    {
        DrawBones(oHud);
    }
    if (!m_bIsActive)
    {
        return;
    }
    oCanvas = oHud.Canvas;
    fBorderSpacing = 30.0;
    FootHeaderHeight = 28;
    oCanvas.SetDrawColor(255, 255, 255, 200);
    oCanvas.SetPos(m_fHUDRelativePropertyEditorOriginX, m_fHUDRelativePropertyEditorOriginY);
    oCanvas.DrawTile(Texture2D'EngineResources.Black', m_fPropertyEditorSizeX, m_fPropertyEditorSizeY, 0.0, 0.0, 32.0, 32.0);
    oCanvas.SetDrawColor(0, 0, 155, 100);
    oCanvas.SetPos(m_fHUDRelativePropertyEditorOriginX, m_fHUDRelativePropertyEditorOriginY);
    oCanvas.DrawTile(Texture2D'EngineResources.Black', m_fPropertyEditorSizeX, float(FootHeaderHeight), 0.0, 0.0, 32.0, 32.0);
    oCanvas.SetPos(m_fHUDRelativePropertyEditorOriginX, m_fHUDRelativePropertyEditorOriginY + m_fPropertyEditorSizeY - float(FootHeaderHeight));
    oCanvas.DrawTile(Texture2D'EngineResources.Black', m_fPropertyEditorSizeX, float(FootHeaderHeight), 0.0, 0.0, 32.0, 32.0);
    oCanvas.SetDrawColor(255, 255, 255, 150);
    oCanvas.Font = Class'Engine'.static.GetMediumFont();
    oCanvas.SetDrawColor(255, 255, 255, 200);
    oCanvas.SetPos(m_fHUDRelativePropertyEditorOriginX, m_fHUDRelativePropertyEditorOriginY);
    oCanvas.DrawText("Menu", TRUE);
    oCanvas.SetPos(m_fHUDRelativePropertyEditorOriginX + m_fPropertyEditorRelativeColumnTwoX, m_fHUDRelativePropertyEditorOriginY);
    oCanvas.DrawText("Hierarchy View", TRUE);
    oCanvas.SetPos(m_fHUDRelativePropertyEditorOriginX + m_fPropertyEditorRelativeColumnThreeX, m_fHUDRelativePropertyEditorOriginY);
    oCanvas.DrawText("Selectables", TRUE);
    oCanvas.Font = Class'Engine'.static.GetMediumFont();
    oCanvas.SetPos(m_fHUDRelativePropertyEditorOriginX, m_fHUDRelativePropertyEditorOriginY + fBorderSpacing);
    for (i = 0; i < m_oPropertyEditorNodes.m_aChildren.Length; i++)
    {
        if (m_oPropertyEditorNodes.m_aTraversedStack.Length == 0 && i == m_oPropertyEditorNodes.m_nCurrentlySelectedChild)
        {
            Col = m_oPropertyEditorNodes.m_aChildren[i].getColour();
            Col.R = byte(Clamp(255, 0, 255));
            Col.G = byte(Clamp(55, 0, 255));
            Col.B = byte(Clamp(5, 0, 255));
            oCanvas.SetDrawColor(Col.R, Col.G, Col.B);
        }
        else
        {
            Col = m_oPropertyEditorNodes.m_aChildren[i].getColour();
            oCanvas.SetDrawColor(Col.R, Col.G, Col.B);
        }
        oCanvas.DrawText(filterString(m_oPropertyEditorNodes.m_aChildren[i].getDisplayText(FALSE)), TRUE);
    }
    oCanvas.Font = Class'Engine'.static.GetSmallFont();
    oCanvas.SetDrawColor(128, 128, 128, 230);
    oCanvas.SetPos(m_fHUDRelativePropertyEditorOriginX + m_fPropertyEditorRelativeColumnTwoX, m_fHUDRelativePropertyEditorOriginY + fBorderSpacing);
    if (m_oPropertyEditorNodes.m_aTraversedStack.Length > 0)
    {
        oFocusedControlNode = m_oPropertyEditorNodes.m_aTraversedStack[m_oPropertyEditorNodes.m_aTraversedStack.Length - 1];
        for (i = 0; i < oFocusedControlNode.m_aTraversedStack.Length; i++)
        {
            Col = oFocusedControlNode.m_aTraversedStack[i].getColour();
            oCanvas.SetDrawColor(Col.R, Col.G, Col.B, 230);
            oCanvas.DrawText(filterString(oFocusedControlNode.m_aTraversedStack[i].getDisplayText(FALSE)), TRUE);
        }
    }
    oCanvas.Font = Class'Engine'.static.GetSmallFont();
    oCanvas.SetPos(m_fHUDRelativePropertyEditorOriginX + m_fPropertyEditorRelativeColumnThreeX, m_fHUDRelativePropertyEditorOriginY + fBorderSpacing);
    if (m_oPropertyEditorNodes.m_aTraversedStack.Length > 0)
    {
        oFocusedControlNode = m_oPropertyEditorNodes.GetSelectablesParent();
        oSelectableSiblingsParent = oFocusedControlNode.GetSelectablesParent();
        if (oSelectableSiblingsParent.m_aChildren.Length > 0)
        {
            minimum = oSelectableSiblingsParent.m_nScrollBoxSize;
            if (oSelectableSiblingsParent.m_aChildren.Length < minimum)
            {
                minimum = oSelectableSiblingsParent.m_aChildren.Length;
            }
            for (i = oSelectableSiblingsParent.m_nScrollBoxFirstIndex; i < oSelectableSiblingsParent.m_nScrollBoxFirstIndex + minimum; i++)
            {
                if (i == oSelectableSiblingsParent.m_nCurrentlySelectedChild)
                {
                    Col = oSelectableSiblingsParent.m_aChildren[i].getColour();
                    Col.R = byte(Clamp(int(Col.R) * 2, 0, 255));
                    Col.G = byte(Clamp(int(Col.G) * 2, 0, 255));
                    Col.B = byte(Clamp(int(Col.B) * 2, 0, 255));
                    oCanvas.SetDrawColor(Col.R, Col.G, Col.B, 230);
                }
                else
                {
                    Col = oSelectableSiblingsParent.m_aChildren[i].getColour();
                    oCanvas.SetDrawColor(Col.R, Col.G, Col.B, 230);
                }
                oCanvas.DrawText(filterString(oSelectableSiblingsParent.m_aChildren[i].getDisplayText(TRUE)), TRUE);
            }
        }
    }
    oCanvas.Font = Class'Engine'.static.GetMediumFont();
    oCanvas.SetDrawColor(255, 255, 255, 200);
    oCanvas.SetPos(m_fHUDRelativePropertyEditorOriginX + float(120), m_fHUDRelativePropertyEditorOriginY + m_fPropertyEditorSizeY - float(25));
    oCanvas.DrawText(m_sFooterText, TRUE);
    WriteTreeDataToHUD(oHud);
}
public function string filterString(string Input)
{
    local string Output;
    
    if (Len(Input) > 42)
    {
        Output = Left(Input, 42);
        Output = Output $ "...";
        return Output;
    }
    else
    {
        return Input;
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    m_sFooterText = "In Game Property Editor"
    m_sFileName = "EditedInGameProperties.txt"
    m_sEditableRootName = "Editable World Objects"
    m_sCameraRootName = "Cameras"
    m_sAnimNodeName = "Anim. / Character Edit"
    m_sNewLoadSaveNodeName = "NEW: Load / Save Game"
    m_sStateNodeName = "Load / Save State Only"
    m_sActionMappingName = "Action Mappings (controlled character)"
    m_bSortByType = TRUE
    m_bSortByName = TRUE
}