Class UIList extends UIObject
    implements(UIDataStorePublisher)
    native
    placeable
    config(UI);

const ResizeBufferPixels = 5;
struct native transient CellHitDetectionInfo 
{
    var init int HitColumn;
    var init int HitRow;
    var init int ResizeColumn;
    var init int ResizeRow;
};
enum EListWrapBehavior
{
    LISTWRAP_None,
    LISTWRAP_Smooth,
    LISTWRAP_Jump,
};
enum ECellLinkType
{
    LINKED_None,
    LINKED_Rows,
    LINKED_Columns,
};
enum ECellAutoSizeMode
{
    CELLAUTOSIZE_None,
    CELLAUTOSIZE_Uniform,
    CELLAUTOSIZE_Constrain,
    CELLAUTOSIZE_AdjustList,
};

var const native noexport Pointer VfTable_IUIDataStorePublisher;
var UIStyleReference GlobalCellStyle[4];
var UIStyleReference ItemOverlayStyle[4];
var UIStyleReference ColumnHeaderBackgroundStyle[3];
var(Data) UIDataStoreBinding DataSource;
var UIStyleReference ColumnHeaderStyle;
var const transient array<int> Items;
var transient array<int> SelectedItems;
var delegate<OnSubmitSelection> __OnSubmitSelection__Delegate;
var delegate<OnListElementsSorted> __OnListElementsSorted__Delegate;
var delegate<ShouldDisableElement> __ShouldDisableElement__Delegate;
var delegate<OnOverrideListElementState> __OnOverrideListElementState__Delegate;
var(Appearance) UIScreenValue_Extent RowHeight;
var(Appearance) UIScreenValue_Extent MinColumnSize;
var(Appearance) UIScreenValue_Extent ColumnWidth;
var(Appearance) UIScreenValue_Extent HeaderCellPadding;
var(Appearance) UIScreenValue_Extent HeaderElementSpacing;
var(Appearance) UIScreenValue_Extent CellSpacing;
var(Appearance) UIScreenValue_Extent CellPadding;
var const transient UIListElementProvider DataProvider;
var(Sound) Name SubmitDataSuccessCue;
var(Sound) Name SubmitDataFailedCue;
var(Sound) Name DecrementIndexCue;
var(Sound) Name IncrementIndexCue;
var(Sound) Name SortAscendingCue;
var(Sound) Name SortDescendingCue;
var transient int Index;
var transient int TopIndex;
var(Appearance) editconst transient duplicatetransient int MaxVisibleItems;
var(Appearance) int ColumnCount;
var(Appearance) int RowCount;
var UIScrollbar VerticalScrollbar;
var const transient int ResizeColumn;
var transient int SetIndexMutex;
var transient int ValueChangeNotificationMutex;
var(Components) editinline export UIComp_DrawImage BackgroundImageComponent;
var(Components) editinline export UIComp_ListElementSorter SortComponent;
var(Components) editinline export UIComp_ListPresenterBase CellDataComponent;
var(Appearance) bool bEnableMultiSelect;
var(Controls) bool bEnableVerticalScrollbar;
var transient bool bInitializeScrollbars;
var(Interaction) bool bAllowDisabledItemSelection;
var(Interaction) bool bSingleClickSubmission;
var(Appearance) bool bUpdateItemUnderCursor;
var(Appearance) bool bHoverStateOverridesSelected;
var(Appearance) bool bForceFullPageDisplay;
var(Interaction) bool bAllowColumnResizing;
var(ZDebug) transient bool bDisplayDataBindings;
var const transient bool bSortingList;
var(Appearance) ECellAutoSizeMode ColumnAutoSizeMode;
var(Appearance) ECellAutoSizeMode RowAutoSizeMode;
var(Appearance) ECellLinkType CellLinkType;
var(Appearance) EListWrapBehavior WrapType;

public final event function bool AllMutexesDisabled()
{
    return IsSetIndexEnabled() && IsValueChangeNotificationEnabled();
}
public native function int CalculateIndexFromCursorLocation(optional bool bRequireValidIndex = TRUE);

public final native function bool CanSelectElement(int ElementIndex);

public final native function ClearBoundDataStores();

public final event function DecrementAllMutexes(optional bool bDispatchUpdates)
{
    EnableValueChangeNotification();
    EnableSetIndex();
    if (bDispatchUpdates)
    {
        SetIndex(Index, TRUE);
        if (AllMutexesDisabled())
        {
            RequestFormattingUpdate();
            RequestSceneUpdate(FALSE, TRUE);
        }
    }
}
public final event function DisableSetIndex()
{
    SetIndexMutex++;
}
public final event function DisableValueChangeNotification()
{
    ValueChangeNotificationMutex++;
}
public final function EnableColumnHeaderRendering(optional bool bShouldRenderColHeaders = TRUE)
{
    if (CellDataComponent != None)
    {
        CellDataComponent.EnableColumnHeaderRendering(bShouldRenderColHeaders);
    }
}
public final event function EnableSetIndex()
{
    if (--SetIndexMutex < 0)
    {
        ScriptTrace();
        SetIndexMutex = 0;
    }
}
public final event function EnableValueChangeNotification()
{
    if (--ValueChangeNotificationMutex < 0)
    {
        ScriptTrace();
        ValueChangeNotificationMutex = 0;
    }
}
public final native function int FindItemIndex(string ItemValue, optional int CellIndex = -1);

public final native function GetBoundDataStores(out array<UIDataStore> out_BoundDataStores);

public final native function Vector2D GetClientRegion();

public final native function float GetColumnWidth(optional int ColumnIndex = -1, optional bool bColHeader, optional bool bReturnUnformattedValue);

public final native function int GetCurrentItem();

public final native function string GetDataStoreBinding(optional int BindingIndex = -1);

public final native function EUIListElementState GetElementCellState(int ElementIndex);

public final native function string GetElementValue(int ElementIndex, optional int CellIndex = -1);

public native function int GetItemCount();

public final native function int GetMaxNumVisibleColumns();

public final native function int GetMaxNumVisibleRows();

public native function int GetMaxVisibleElementCount();

public native function int GetResizeColumn(optional out CellHitDetectionInfo ClickedCell);

public native function float GetRowHeight(optional int RowIndex = -1, optional bool bColHeader, optional bool bReturnUnformattedValue);

public final native function array<int> GetSelectedItems();

public final native function int GetTotalColumnCount();

public final native function int GetTotalRowCount();

public final event function IncrementAllMutexes()
{
    DisableValueChangeNotification();
    DisableSetIndex();
}
public event function Initialized()
{
    Super(UIScreenObject).Initialized();
    SetActiveCursorUpdate(bUpdateItemUnderCursor);
    if (VerticalScrollbar != None)
    {
        VerticalScrollbar.__OnScrollActivity__Delegate = ScrollVertical;
        VerticalScrollbar.__OnClickedScrollZone__Delegate = ClickedScrollZone;
    }
}
public final native function bool IsElementAutoSizingEnabled();

public final native function bool IsElementEnabled(int ElementIndex);

public final native function bool IsElementSelected(int ElementIndex);

public final native function bool IsHotTrackingEnabled();

public final event function bool IsSetIndexEnabled()
{
    return SetIndexMutex == 0;
}
public final event function bool IsValueChangeNotificationEnabled()
{
    return ValueChangeNotificationMutex == 0;
}
public final native function bool NavigateIndex(bool bIncrementIndex, bool bFullPage, bool bHorizontalNavigation);

public final native function NotifyDataStoreValueUpdated(UIDataStore SourceDataStore, bool bValuesInvalidated, Name PropertyTag, UIDataProvider SourceProvider, int ArrayIndex);

public delegate function OnListElementsSorted(UIList Sender);

public delegate function EUIListElementState OnOverrideListElementState(UIList Sender, int ElementIndex, EUIListElementState CurrentState, EUIListElementState NewElementState);

public delegate function OnSubmitSelection(UIList Sender, optional int PlayerIndex = GetBestPlayerIndex());

public event function PostInitialize()
{
    Super(UIScreenObject).PostInitialize();
    ConditionalPropagateEnabledState(GetBestPlayerIndex());
}
public final native function bool RefreshSubscriberValue(optional int BindingIndex = -1);

public native function int RemoveElement(int ElementToRemove);

public native function bool SaveSubscriberValue(out array<UIDataStore> out_BoundDataStores, optional int BindingIndex = -1);

public final native function bool ScrollVertical(UIScrollbar Sender, float PositionChange, optional bool bPositionMaxed = FALSE);

public final native function SetColumnCount(int NewColumnCount);

public final native function SetDataStoreBinding(string MarkupText, optional int BindingIndex = -1);

public final native function bool SetElementCellState(int ElementIndex, EUIListElementState NewElementState);

public final native function SetHotTracking(bool bShouldUpdateItemUnderCursor);

public final native function bool SetIndex(int NewIndex, optional bool bClampValue = TRUE, optional bool bSkipNotification = FALSE);

public final native function SetRowCount(int NewRowCount);

public final native function bool SetTopIndex(int NewTopIndex, optional bool bClampValue = TRUE);

public delegate function bool ShouldDisableElement(UIList Sender, int ElementIndex);

public final function bool ShouldRenderColumnHeaders()
{
    if (CellDataComponent != None)
    {
        return CellDataComponent.ShouldRenderColumnHeaders();
    }
    return FALSE;
}
public function ClickedScrollZone(UIScrollbar Sender, float PositionPerc, int PlayerIndex)
{
    local int MouseX;
    local int MouseY;
    local float MarkerPosition;
    local bool bDecrement;
    local int NewTopItem;
    
    if (GetCursorPosition(MouseX, MouseY))
    {
        MarkerPosition = Sender.GetMarkerButtonPosition();
        bDecrement = Sender.ScrollbarOrientation == EUIOrientation.UIORIENT_Vertical ? float(MouseY) < MarkerPosition : float(MouseX) < MarkerPosition;
        NewTopItem = bDecrement ? TopIndex - MaxVisibleItems : TopIndex + MaxVisibleItems;
        SetTopIndex(NewTopItem, TRUE);
    }
}
public final function OnStateChanged(UIScreenObject Sender, int PlayerIndex, UIState NewlyActiveState, optional UIState PreviouslyActiveState)
{
    if (Sender == Self)
    {
        if (UIState_Pressed(NewlyActiveState) != None)
        {
            SetMouseCaptureOverride(TRUE);
        }
        else if (UIState_Pressed(PreviouslyActiveState) != None)
        {
            SetMouseCaptureOverride(FALSE);
        }
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    Begin Template Class=UIComp_Event Name=WidgetEventComponent
    End Template
    Begin Object Class=UIComp_ListPresenter Name=ListPresentationComponent
        Begin Template Class=UITexture Name=NormalOverlayTemplate
        End Template
        Begin Template Class=UITexture Name=ActiveOverlayTemplate
        End Template
        Begin Template Class=UITexture Name=SelectionOverlayTemplate
        End Template
        Begin Template Class=UITexture Name=HoverOverlayTemplate
        End Template
        ListItemOverlay[0] = NormalOverlayTemplate
        ListItemOverlay[1] = ActiveOverlayTemplate
        ListItemOverlay[2] = SelectionOverlayTemplate
        ListItemOverlay[3] = HoverOverlayTemplate
    End Object
    Begin Object Class=UIScrollbar Name=VertScrollbarTemplate
        Begin Template Class=UIComp_DrawImage Name=ScrollBarBackgroundImageTemplate
        End Template
        Begin Template Class=UIComp_Event Name=WidgetEventComponent
        End Template
        BackgroundImageComponent = ScrollBarBackgroundImageTemplate
        EventProvider = WidgetEventComponent
    End Object
    GlobalCellStyle[0] = {
                          RequiredStyleClass = Class'UIStyle_Combo', 
                          AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                          DefaultStyleTag = 'DefaultCellStyleNormal', 
                          ResolvedStyle = None
                         }
    GlobalCellStyle[1] = {
                          RequiredStyleClass = Class'UIStyle_Combo', 
                          AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                          DefaultStyleTag = 'DefaultCellStyleActive', 
                          ResolvedStyle = None
                         }
    GlobalCellStyle[2] = {
                          RequiredStyleClass = Class'UIStyle_Combo', 
                          AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                          DefaultStyleTag = 'DefaultCellStyleSelected', 
                          ResolvedStyle = None
                         }
    GlobalCellStyle[3] = {
                          RequiredStyleClass = Class'UIStyle_Combo', 
                          AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                          DefaultStyleTag = 'DefaultCellStyleHover', 
                          ResolvedStyle = None
                         }
    ItemOverlayStyle[0] = {
                           RequiredStyleClass = Class'UIStyle_Image', 
                           AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                           DefaultStyleTag = 'ListItemBackgroundNormalStyle', 
                           ResolvedStyle = None
                          }
    ItemOverlayStyle[1] = {
                           RequiredStyleClass = Class'UIStyle_Image', 
                           AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                           DefaultStyleTag = 'ListItemBackgroundActiveStyle', 
                           ResolvedStyle = None
                          }
    ItemOverlayStyle[2] = {
                           RequiredStyleClass = Class'UIStyle_Image', 
                           AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                           DefaultStyleTag = 'ListItemBackgroundSelectedStyle', 
                           ResolvedStyle = None
                          }
    ItemOverlayStyle[3] = {
                           RequiredStyleClass = Class'UIStyle_Image', 
                           AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                           DefaultStyleTag = 'ListItemBackgroundHoverStyle', 
                           ResolvedStyle = None
                          }
    ColumnHeaderBackgroundStyle[0] = {
                                      RequiredStyleClass = Class'UIStyle_Image', 
                                      AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                                      DefaultStyleTag = 'None', 
                                      ResolvedStyle = None
                                     }
    ColumnHeaderBackgroundStyle[1] = {
                                      RequiredStyleClass = Class'UIStyle_Image', 
                                      AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                                      DefaultStyleTag = 'None', 
                                      ResolvedStyle = None
                                     }
    ColumnHeaderBackgroundStyle[2] = {
                                      RequiredStyleClass = Class'UIStyle_Image', 
                                      AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                                      DefaultStyleTag = 'None', 
                                      ResolvedStyle = None
                                     }
    DataSource = {
                  MarkupString = "", 
                  Subscriber = None, 
                  DataStoreName = 'None', 
                  DataStoreField = 'None', 
                  BindingIndex = -1, 
                  ResolvedDataStore = None, 
                  RequiredFieldType = EUIDataProviderFieldType.DATATYPE_Collection
                 }
    ColumnHeaderStyle = {
                         RequiredStyleClass = Class'UIStyle_Combo', 
                         AssignedStyleID = {A = 0, B = 0, C = 0, D = 0}, 
                         DefaultStyleTag = 'DefaultColumnHeaderStyle', 
                         ResolvedStyle = None
                        }
    RowHeight = {Value = 16.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}
    MinColumnSize = {Value = 0.5, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}
    ColumnWidth = {Value = 100.0, ScaleType = EUIExtentEvalType.UIEXTENTEVAL_Pixels, Orientation = EUIOrientation.UIORIENT_Horizontal}
    SubmitDataSuccessCue = 'ListSubmit'
    SubmitDataFailedCue = 'GenericError'
    DecrementIndexCue = 'ListUp'
    IncrementIndexCue = 'ListDown'
    SortAscendingCue = 'SortAscending'
    SortDescendingCue = 'SortDescending'
    Index = -1
    TopIndex = -1
    ColumnCount = 1
    RowCount = 4
    VerticalScrollbar = VertScrollbarTemplate
    ResizeColumn = -1
    CellDataComponent = ListPresentationComponent
    bEnableVerticalScrollbar = TRUE
    bInitializeScrollbars = TRUE
    bForceFullPageDisplay = TRUE
    bAllowColumnResizing = TRUE
    ColumnAutoSizeMode = ECellAutoSizeMode.CELLAUTOSIZE_Uniform
    RowAutoSizeMode = ECellAutoSizeMode.CELLAUTOSIZE_Constrain
    CellLinkType = ECellLinkType.LINKED_Columns
    PrimaryStyle = {RequiredStyleClass = Class'UIStyle_Combo', DefaultStyleTag = 'DefaultListStyle'}
    PrivateFlags = 1024
    DebugBoundsColor = {B = 255, G = 255, R = 255, A = 255}
    bSupportsPrimaryStyle = FALSE
    Children = (VertScrollbarTemplate)
    DefaultStates = (Class'UIState_Enabled', Class'UIState_Disabled', Class'UIState_Focused', Class'UIState_Active', Class'UIState_Pressed')
    __NotifyActiveStateChanged__Delegate = OnStateChanged
    EventProvider = WidgetEventComponent
    bSupportsFocusHint = TRUE
}