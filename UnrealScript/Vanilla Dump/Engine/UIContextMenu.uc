Class UIContextMenu extends UIList
    native
    config(UI);

struct native transient ContextMenuItem 
{
    var init string ItemText;
    var const transient native init Pointer ParentItem;
    var const transient init UIContextMenu OwnerMenu;
    var init int ItemId;
    var init EContextMenuItemType ItemType;
    
    structdefaultproperties
    {
        ItemId = -1
    }
};
enum EContextMenuItemType
{
    CMIT_Normal,
    CMIT_Submenu,
    CMIT_Separator,
    CMIT_Check,
    CMIT_Radio,
};

var const transient array<ContextMenuItem> MenuItems;
var const transient UIObject InvokingWidget;
var const transient bool bResolvePosition;

public event function bool ClearMenuItems(UIObject Widget)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local Name WidgetDSTag;
    
    if (Widget != None && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != None)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != None)
            {
                WidgetDSTag = Name(ConvertWidgetIDToString(Widget));
                if (SceneDS.ClearCollectionValueArray(WidgetDSTag))
                {
                    RefreshSubscriberValue();
                    bResult = TRUE;
                }
            }
        }
    }
    return bResult;
}
public final native function bool Close(optional int PlayerIndex = GetBestPlayerIndex());

public event function int FindMenuItemIndex(UIObject Widget, string ItemToFind)
{
    local int Result;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local Name WidgetDSTag;
    
    Result = -1;
    if (Widget != None && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != None)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != None)
            {
                WidgetDSTag = Name(ConvertWidgetIDToString(Widget));
                Result = SceneDS.FindCollectionValueIndex(WidgetDSTag, ItemToFind);
            }
        }
    }
    return Result;
}
public event function bool GetAllMenuItems(UIObject Widget, out array<string> out_MenuItems)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local Name WidgetDSTag;
    
    if (Widget != None && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != None)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != None)
            {
                WidgetDSTag = Name(ConvertWidgetIDToString(Widget));
                bResult = SceneDS.GetCollectionValueArray(WidgetDSTag, out_MenuItems);
            }
        }
    }
    return bResult;
}
public event function bool GetMenuItem(UIObject Widget, int IndexToGet, out string out_MenuItem)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local Name WidgetDSTag;
    
    if (Widget != None && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != None)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != None)
            {
                WidgetDSTag = Name(ConvertWidgetIDToString(Widget));
                bResult = SceneDS.GetCollectionValue(WidgetDSTag, IndexToGet, out_MenuItem);
            }
        }
    }
    return bResult;
}
public event function bool InsertMenuItem(UIObject Widget, string Item, optional int InsertIndex = -1, optional bool bAllowDuplicates)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local Name WidgetDSTag;
    
    if (Widget != None && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != None)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != None)
            {
                WidgetDSTag = Name(ConvertWidgetIDToString(Widget));
                if (SceneDS.InsertCollectionValue(WidgetDSTag, Item, InsertIndex, , bAllowDuplicates))
                {
                    RefreshSubscriberValue();
                    bResult = TRUE;
                }
            }
        }
    }
    return bResult;
}
public final native function bool IsActiveContextMenu();

public final native function bool Open(optional int PlayerIndex = GetBestPlayerIndex());

public event function bool RemoveMenuItem(UIObject Widget, string ItemToRemove)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local Name WidgetDSTag;
    
    if (Widget != None && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != None)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != None)
            {
                WidgetDSTag = Name(ConvertWidgetIDToString(Widget));
                if (SceneDS.RemoveCollectionValue(WidgetDSTag, ItemToRemove))
                {
                    RefreshSubscriberValue();
                    bResult = TRUE;
                }
            }
        }
    }
    return bResult;
}
public event function bool RemoveMenuItemAtIndex(UIObject Widget, int IndexToRemove)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local Name WidgetDSTag;
    
    if (Widget != None && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != None)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != None)
            {
                WidgetDSTag = Name(ConvertWidgetIDToString(Widget));
                if (SceneDS.RemoveCollectionValueByIndex(WidgetDSTag, IndexToRemove))
                {
                    RefreshSubscriberValue();
                    bResult = TRUE;
                }
            }
        }
    }
    return bResult;
}
public event function bool SetMenuItems(UIObject Widget, array<string> NewMenuItems, optional bool bClearExisting = TRUE, optional int InsertIndex = -1)
{
    local bool bResult;
    local UIScene SceneOwner;
    local SceneDataStore SceneDS;
    local Name WidgetDSTag;
    
    if (Widget != None && Widget.WidgetID.A != 0)
    {
        SceneOwner = GetScene();
        if (SceneOwner != None)
        {
            SceneDS = SceneOwner.GetSceneDataStore();
            if (SceneDS != None)
            {
                WidgetDSTag = Name(ConvertWidgetIDToString(Widget));
                if (SceneDS.SetCollectionValueArray(WidgetDSTag, NewMenuItems, bClearExisting, InsertIndex))
                {
                    RefreshSubscriberValue();
                    bResult = TRUE;
                }
            }
        }
    }
    return bResult;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    Begin Template Class=UIComp_ListPresenter Name=ListPresentationComponent
        Begin Template Class=UITexture Name=ActiveOverlayTemplate
        End Template
        Begin Template Class=UITexture Name=HoverOverlayTemplate
        End Template
        Begin Template Class=UITexture Name=NormalOverlayTemplate
        End Template
        Begin Template Class=UITexture Name=SelectionOverlayTemplate
        End Template
        ListItemOverlay[0] = NormalOverlayTemplate
        ListItemOverlay[1] = ActiveOverlayTemplate
        ListItemOverlay[2] = SelectionOverlayTemplate
        ListItemOverlay[3] = HoverOverlayTemplate
    End Template
    Begin Template Class=UIScrollbar Name=VertScrollbarTemplate
        Begin Template Class=UIComp_DrawImage Name=ScrollBarBackgroundImageTemplate
        End Template
        Begin Template Class=UIComp_Event Name=WidgetEventComponent
        End Template
        BackgroundImageComponent = ScrollBarBackgroundImageTemplate
        EventProvider = WidgetEventComponent
    End Template
    VerticalScrollbar = VertScrollbarTemplate
    CellDataComponent = ListPresentationComponent
    bEnableVerticalScrollbar = FALSE
    bInitializeScrollbars = FALSE
    bSingleClickSubmission = TRUE
    bUpdateItemUnderCursor = TRUE
    ColumnAutoSizeMode = ECellAutoSizeMode.CELLAUTOSIZE_AdjustList
    RowAutoSizeMode = ECellAutoSizeMode.CELLAUTOSIZE_AdjustList
    WrapType = EListWrapBehavior.LISTWRAP_Jump
    bEnableActiveCursorUpdates = TRUE
    Children = (VertScrollbarTemplate)
    Position = {
                Value[2] = 16.0, 
                Value[3] = 100.0, 
                ScaleType[0] = EPositionEvalType.EVALPOS_PixelViewport, 
                ScaleType[1] = EPositionEvalType.EVALPOS_PixelViewport, 
                ScaleType[2] = EPositionEvalType.EVALPOS_PixelOwner, 
                ScaleType[3] = EPositionEvalType.EVALPOS_PixelOwner
               }
    EventProvider = WidgetEventComponent
    bHidden = TRUE
}