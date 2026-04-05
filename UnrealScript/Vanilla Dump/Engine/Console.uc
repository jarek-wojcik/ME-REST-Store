Class Console extends Interaction within GameViewportClient
    native
    transient
    config(Input);

struct native AutoCompleteNode 
{
    var init array<int> AutoCompleteListIndices;
    var init array<Pointer> ChildNodes;
    var int IndexChar;
};
struct native AutoCompleteCommand 
{
    var string Command;
    var string Desc;
};
const MaxHistory = 16;

var config string History[16];
var transient native AutoCompleteNode AutoCompleteTree;
var array<string> Scrollback;
var string TypedStr;
var config array<AutoCompleteCommand> ManualAutoCompleteList;
var transient array<AutoCompleteCommand> AutoCompleteList;
var config array<string> MapPathsForAutoComplete;
var transient array<int> AutoCompleteIndices;
var globalconfig Name ConsoleKey;
var globalconfig Name TypeKey;
var LocalPlayer ConsoleTargetPlayer;
var Texture2D DefaultTexture_Black;
var Texture2D DefaultTexture_White;
var globalconfig int MaxScrollbackSize;
var int SBHead;
var int SBPos;
var config int HistoryTop;
var config int HistoryBot;
var config int HistoryCur;
var int TypedStrPos;
var transient int AutoCompleteIndex;
var transient bool bNavigatingHistory;
var transient bool bCaptureKeyInput;
var bool bCtrl;
var config bool bEnableUI;
var transient bool bAutoCompleteLocked;
var config bool bRequireCtrlToNavigateAutoComplete;
var transient bool bIsRuntimeAutoCompleteUpToDate;

public final native function BuildRuntimeAutoCompleteList(optional bool bForce);

public function ConsoleCommand(string Command)
{
    if (!(History[HistoryTop] ~= Command))
    {
        PurgeCommandFromHistory(Command);
        HistoryTop = (HistoryTop + 1) %  16;
        History[HistoryTop] = Command;
        if (HistoryBot == -1 || HistoryBot == HistoryTop)
        {
            HistoryBot = (HistoryBot + 1) %  16;
        }
    }
    HistoryCur = HistoryBot;
    SaveHistoryToFile();
    if (bEnableUI)
    {
        OutputText("\n\\>\\>\\>" @ Command @ "\\<\\<\\<");
    }
    else
    {
        OutputText("\n>>>" @ Command @ "<<<");
    }
    if (ConsoleTargetPlayer != None)
    {
        ConsoleTargetPlayer.Actor.ConsoleCommand(Command);
    }
    else if (Outer.Outer.GamePlayers.Length > 0 && Outer.Outer.GamePlayers[0].Actor != None)
    {
        Outer.Outer.GamePlayers[0].Actor.ConsoleCommand(Command);
    }
    else
    {
        Outer.ConsoleCommand(Command);
    }
}
public function Initialized()
{
    Super.Initialized();
    if (bEnableUI)
    {
    }
}
public event function OutputText(coerce string Text)
{
    local string RemainingText;
    local int StringLength;
    local int LineLength;
    
    RemainingText = Text;
    StringLength = Len(Text);
    while (StringLength > 0)
    {
        LineLength = InStr(RemainingText, "\n", , , );
        if (LineLength == -1)
        {
            LineLength = StringLength;
        }
        OutputTextLine(Left(RemainingText, LineLength));
        RemainingText = Mid(RemainingText, LineLength + 1, );
        StringLength -= LineLength + 1;
    }
}
public native function UpdateCompleteIndices();

public function bool InputChar(int ControllerId, string Unicode)
{
    return bCaptureKeyInput;
}
public function FlushPlayerInput()
{
    local PlayerController PC;
    
    if (ConsoleTargetPlayer != None)
    {
        PC = ConsoleTargetPlayer.Actor;
    }
    else if (Outer.Outer.GamePlayers.Length > 0 && Outer.Outer.GamePlayers[0].Actor != None)
    {
        PC = Outer.Outer.GamePlayers[0].Actor;
    }
    if (PC != None && PC.PlayerInput != None)
    {
        PC.PlayerInput.ResetInput();
    }
}
public function AppendInputText(string Text)
{
    local int Character;
    
    while (Len(Text) > 0)
    {
        Character = Asc(Left(Text, 1));
        Text = Mid(Text, 1, );
        if (Character >= 32 && Character < 256)
        {
            SetInputText(Left(TypedStr, TypedStrPos) $ Chr(Character) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
            SetCursorPos(TypedStrPos + 1);
        }
    }
    UpdateCompleteIndices();
}
public function ClearOutput()
{
    SBHead = 0;
    Scrollback.Remove(0, Scrollback.Length);
    if (bEnableUI)
    {
    }
}
public function bool InputKey(int ControllerId, Name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = FALSE)
{
    if (Event == EInputEvent.IE_Pressed)
    {
        bCaptureKeyInput = FALSE;
        if (Key == ConsoleKey)
        {
            GotoState('Open', , , );
            bCaptureKeyInput = TRUE;
            return TRUE;
        }
        else if (Key == TypeKey)
        {
            GotoState('Typing', , , );
            bCaptureKeyInput = TRUE;
            return TRUE;
        }
    }
    return bCaptureKeyInput;
}
public function bool IsUIConsoleOpen()
{
    return FALSE;
}
public function bool IsUIMiniConsoleOpen()
{
    return FALSE;
}
public function OutputTextLine(coerce string Text)
{
    if (Scrollback.Length > MaxScrollbackSize)
    {
        Scrollback.Remove(0, 1);
        SBHead = MaxScrollbackSize - 1;
    }
    else
    {
        SBHead++;
    }
    Scrollback.Length = Scrollback.Length + 1;
    Scrollback[SBHead] = Text;
}
public function PostRender_Console(Canvas Canvas);

public function bool ProcessControlKey(Name Key, EInputEvent Event)
{
    if (Key == 'LeftControl' || Key == 'RightControl')
    {
        if (Event == EInputEvent.IE_Released)
        {
            bCtrl = FALSE;
        }
        else if (Event == EInputEvent.IE_Pressed)
        {
            bCtrl = TRUE;
        }
        return TRUE;
    }
    else if (bCtrl && Event == EInputEvent.IE_Pressed && Outer.Outer.GamePlayers.Length > 0 && Outer.Outer.GamePlayers[0].Actor != None)
    {
        if (Key == 'V')
        {
            AppendInputText(Outer.Outer.GamePlayers[0].Actor.PasteFromClipboard());
            return TRUE;
        }
        else if (Key == 'C')
        {
            Outer.Outer.GamePlayers[0].Actor.CopyToClipboard(TypedStr);
            return TRUE;
        }
        else if (Key == 'X')
        {
            if (TypedStr != "")
            {
                Outer.Outer.GamePlayers[0].Actor.CopyToClipboard(TypedStr);
                SetInputText("");
                SetCursorPos(0);
            }
            return TRUE;
        }
    }
    return FALSE;
}
public function PurgeCommandFromHistory(string Command)
{
    local int HistoryIdx;
    local int idx;
    local int NextIdx;
    
    if (HistoryTop >= 0 && HistoryTop < 16)
    {
        for (HistoryIdx = 0; HistoryIdx < 16; ++HistoryIdx)
        {
            if (History[HistoryIdx] ~= Command)
            {
                idx = HistoryIdx;
                NextIdx = (HistoryIdx + 1) %  16;
                while (idx != HistoryTop)
                {
                    History[idx] = History[NextIdx];
                    idx = NextIdx;
                    NextIdx = (NextIdx + 1) %  16;
                }
                HistoryTop = HistoryTop == 0 ? 16 - 1 : HistoryTop - 1;
                HistoryIdx--;
            }
        }
    }
}
public function SaveHistoryToFile();

public function SetCursorPos(int Position)
{
    TypedStrPos = Position;
    if (bEnableUI)
    {
    }
}
public function SetInputText(string Text)
{
    TypedStr = Text;
    if (bEnableUI)
    {
    }
}
public function StartTyping(coerce string Text)
{
    GotoState('Typing', , , );
    SetInputText(Text);
    SetCursorPos(Len(Text));
}

state Open 
{
    public event function EndState(Name NextStateName);
    
    public event function BeginState(Name PreviousStateName)
    {
        bCaptureKeyInput = TRUE;
        HistoryCur = HistoryBot;
        SBPos = 0;
        bCtrl = FALSE;
        if (PreviousStateName == 'None')
        {
            FlushPlayerInput();
        }
    }
    public event function PostRender_Console(Canvas Canvas)
    {
        local float Height;
        local float XL;
        local float YL;
        local float Y;
        local float ScrollLineXL;
        local float ScrollLineYL;
        local float info_xl;
        local float info_yl;
        local string OutStr;
        local int idx;
        local int MatchIdx;
        
        if (!IsUIConsoleOpen())
        {
            Canvas.Font = Class'Engine'.static.GetSmallFont();
            Height = Canvas.ClipY * 0.75;
            Canvas.SetDrawColor(255, 255, 255, 255);
            Canvas.SetPos(0.0, 0.0);
            Canvas.DrawTile(DefaultTexture_Black, Canvas.ClipX, Height, 0.0, 0.0, 32.0, 32.0);
            OutStr = "(>" @ TypedStr;
            Canvas.StrLen(OutStr, XL, YL);
            Canvas.SetPos(0.0, Height - float(12) - YL);
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawTile(DefaultTexture_White, Canvas.ClipX, 2.0, 0.0, 0.0, 32.0, 32.0);
            Canvas.SetPos(0.0, Height);
            Canvas.DrawTile(DefaultTexture_White, Canvas.ClipX, 2.0, 0.0, 0.0, 32.0, 32.0);
            Canvas.SetPos(0.0, Height - float(5) - YL);
            Canvas.bCenter = FALSE;
            Canvas.DrawText(OutStr, FALSE);
            if (AutoCompleteIndices.Length > 0)
            {
                idx = AutoCompleteIndices[0];
                Canvas.SetPos(0.0 + XL, Height - float(5) - YL);
                Canvas.SetDrawColor(87, 148, 87);
                Canvas.DrawText(Right(AutoCompleteList[idx].Command, Len(AutoCompleteList[idx].Command) - Len(TypedStr)), FALSE);
                Canvas.StrLen("(>", XL, YL);
                for (MatchIdx = 0; MatchIdx < AutoCompleteIndices.Length && MatchIdx < 10; MatchIdx++)
                {
                    idx = AutoCompleteIndices[MatchIdx];
                    Canvas.StrLen(AutoCompleteList[idx].Desc, info_xl, info_yl);
                    Canvas.SetPos(0.0 + XL, Height + float(5) + YL * float(MatchIdx));
                    Canvas.SetDrawColor(0, 0, 0);
                    Canvas.DrawTile(DefaultTexture_White, info_xl, info_yl, 0.0, 0.0, 32.0, 32.0);
                    Canvas.SetPos(0.0 + XL, Height + float(5) + YL * float(MatchIdx));
                    Canvas.SetDrawColor(0, 255, 0);
                    Canvas.DrawText(AutoCompleteList[idx].Desc, FALSE);
                }
            }
            OutStr = "(>" @ Left(TypedStr, TypedStrPos);
            Canvas.StrLen(OutStr, XL, YL);
            Canvas.SetPos(XL, Height - float(3) - YL);
            Canvas.DrawText("_");
            idx = SBHead - SBPos;
            Y = Height - float(16) - YL * float(2);
            if (Scrollback.Length == 0)
            {
                return;
            }
            Canvas.SetDrawColor(255, 255, 255, 255);
            while (Y > YL && idx >= 0)
            {
                Canvas.SetPos(0.0, Y);
                Canvas.StrLen(Scrollback[idx], ScrollLineXL, ScrollLineYL);
                if (ScrollLineYL > YL)
                {
                    Y -= ScrollLineYL - YL;
                    Canvas.CurY = Y;
                }
                Canvas.DrawText(Scrollback[idx], FALSE);
                idx--;
                Y -= YL;
            }
        }
    }
    public function bool InputKey(int ControllerId, Name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = FALSE)
    {
        local string Temp;
        
        if (Event == EInputEvent.IE_Pressed)
        {
            bCaptureKeyInput = FALSE;
        }
        if (ProcessControlKey(Key, Event))
        {
            return TRUE;
        }
        else if (bGamepad)
        {
            return FALSE;
        }
        else if (Key == 'Escape' && Event == EInputEvent.IE_Released)
        {
            if (TypedStr != "")
            {
                SetInputText("");
                SetCursorPos(0);
                HistoryCur = HistoryBot;
                return TRUE;
            }
            else
            {
                GotoState('None', , , );
            }
        }
        else if (Key == ConsoleKey && Event == EInputEvent.IE_Pressed)
        {
            GotoState('None', , , );
            bCaptureKeyInput = TRUE;
            return TRUE;
        }
        else if (Key == TypeKey && Event == EInputEvent.IE_Pressed)
        {
            if (AutoCompleteIndices.Length > 0 && !bAutoCompleteLocked)
            {
                TypedStr = AutoCompleteList[AutoCompleteIndices[0]].Command;
                SetCursorPos(Len(TypedStr));
                bAutoCompleteLocked = TRUE;
            }
            else
            {
                GotoState('None', , , );
                bCaptureKeyInput = TRUE;
            }
            return TRUE;
        }
        else if (Key == 'Enter' && Event == EInputEvent.IE_Released)
        {
            if (TypedStr != "")
            {
                Temp = TypedStr;
                SetInputText("");
                SetCursorPos(0);
                if (Temp ~= "cls")
                {
                    ClearOutput();
                }
                else
                {
                    ConsoleCommand(Temp);
                }
                UpdateCompleteIndices();
            }
            return TRUE;
        }
        else if (Global.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad))
        {
            return TRUE;
        }
        else if (Event != EInputEvent.IE_Pressed && Event != EInputEvent.IE_Repeat)
        {
            if (!bGamepad)
            {
                return Key != 'LeftMouseButton' && Key != 'MiddleMouseButton' && Key != 'RightMouseButton';
            }
            return FALSE;
        }
        else if (Key == 'Up')
        {
            if (!bCtrl)
            {
                if (HistoryBot >= 0)
                {
                    if (HistoryCur == HistoryBot)
                    {
                        HistoryCur = HistoryTop;
                    }
                    else
                    {
                        HistoryCur--;
                        if (HistoryCur < 0)
                        {
                            HistoryCur = 16 - 1;
                        }
                    }
                    SetInputText(History[HistoryCur]);
                    SetCursorPos(Len(History[HistoryCur]));
                }
            }
            else if (SBPos < Scrollback.Length - 1)
            {
                SBPos++;
                if (SBPos >= Scrollback.Length)
                {
                    SBPos = Scrollback.Length - 1;
                }
            }
            return TRUE;
        }
        else if (Key == 'Down')
        {
            if (!bCtrl)
            {
                if (HistoryBot >= 0)
                {
                    if (HistoryCur == HistoryTop)
                    {
                        HistoryCur = HistoryBot;
                    }
                    else
                    {
                        HistoryCur = (HistoryCur + 1) %  16;
                    }
                    SetInputText(History[HistoryCur]);
                    SetCursorPos(Len(History[HistoryCur]));
                }
            }
            else if (SBPos > 0)
            {
                SBPos--;
                if (SBPos < 0)
                {
                    SBPos = 0;
                }
            }
            return TRUE;
        }
        else if (Key == 'BackSpace')
        {
            if (TypedStrPos > 0)
            {
                SetInputText(Left(TypedStr, TypedStrPos - 1) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
                SetCursorPos(TypedStrPos - 1);
                bAutoCompleteLocked = FALSE;
            }
            return TRUE;
        }
        else if (Key == 'Delete')
        {
            if (TypedStrPos < Len(TypedStr))
            {
                SetInputText(Left(TypedStr, TypedStrPos) $ Right(TypedStr, Len(TypedStr) - TypedStrPos - 1));
            }
            return TRUE;
        }
        else if (Key == 'Left')
        {
            SetCursorPos(Max(0, TypedStrPos - 1));
            return TRUE;
        }
        else if (Key == 'Right')
        {
            SetCursorPos(Min(Len(TypedStr), TypedStrPos + 1));
            return TRUE;
        }
        else if (bCtrl && Key == 'Home')
        {
            SBPos = 0;
        }
        else if (Key == 'Home')
        {
            SetCursorPos(0);
            return TRUE;
        }
        else if (bCtrl && Key == 'End')
        {
            SBPos = Scrollback.Length - 1;
        }
        else if (Key == 'End')
        {
            SetCursorPos(Len(TypedStr));
            return TRUE;
        }
        else if (Key == 'PageUp' || Key == 'MouseScrollUp')
        {
            if (SBPos < Scrollback.Length - 1)
            {
                if (bCtrl)
                {
                    SBPos += 5;
                }
                else
                {
                    SBPos++;
                }
                if (SBPos >= Scrollback.Length)
                {
                    SBPos = Scrollback.Length - 1;
                }
            }
            return TRUE;
        }
        else if (Key == 'PageDown' || Key == 'MouseScrollDown')
        {
            if (SBPos > 0)
            {
                if (bCtrl)
                {
                    SBPos -= 5;
                }
                else
                {
                    SBPos--;
                }
                if (SBPos < 0)
                {
                    SBPos = 0;
                }
            }
            return TRUE;
        }
        return TRUE;
    }
    public function bool InputChar(int ControllerId, string Unicode)
    {
        if (bCaptureKeyInput)
        {
            return TRUE;
        }
        AppendInputText(Unicode);
        return TRUE;
    }
    
    stop;
};
state Typing 
{
    public event function EndState(Name NextStateName)
    {
        bAutoCompleteLocked = FALSE;
    }
    public event function BeginState(Name PreviousStateName)
    {
        if (PreviousStateName == 'None')
        {
            FlushPlayerInput();
        }
        bCaptureKeyInput = TRUE;
        HistoryCur = HistoryBot;
    }
    public event function PostRender_Console(Canvas Canvas)
    {
        local float XL;
        local float YL;
        local float info_xl;
        local float info_yl;
        local string OutStr;
        local float ClipX;
        local float ClipY;
        local float LeftPos;
        local int MatchIdx;
        local int idx;
        local int StartIdx;
        
        if (!IsUIMiniConsoleOpen())
        {
            Global.PostRender_Console(Canvas);
            Canvas.Font = Class'Engine'.static.GetSmallFont();
            OutStr = "(>" @ TypedStr;
            Canvas.StrLen(OutStr, XL, YL);
            ClipX = Canvas.ClipX;
            ClipY = Canvas.ClipY;
            LeftPos = 0.0;
            if (Class'WorldInfo'.static.IsConsoleBuild())
            {
                ClipX -= float(32);
                ClipY -= float(32);
                LeftPos = 32.0;
            }
            Canvas.SetPos(LeftPos, ClipY - float(6) - YL);
            Canvas.DrawTile(DefaultTexture_Black, ClipX, YL + float(6), 0.0, 0.0, 32.0, 32.0);
            Canvas.SetPos(LeftPos, ClipY - float(6) - YL);
            Canvas.SetDrawColor(0, 255, 0);
            Canvas.DrawTile(DefaultTexture_White, ClipX, 2.0, 0.0, 0.0, 32.0, 32.0);
            Canvas.SetPos(LeftPos, ClipY - float(3) - YL);
            Canvas.bCenter = FALSE;
            Canvas.DrawText(OutStr, FALSE);
            if (AutoCompleteIndices.Length > 0)
            {
                idx = AutoCompleteIndices[AutoCompleteIndex];
                Canvas.SetPos(LeftPos + XL, ClipY - float(3) - YL);
                Canvas.SetDrawColor(87, 148, 87);
                Canvas.DrawText(Right(AutoCompleteList[idx].Command, Len(AutoCompleteList[idx].Command) - Len(TypedStr)), FALSE);
                Canvas.StrLen("(>", XL, YL);
                StartIdx = AutoCompleteIndex - 5;
                if (StartIdx < 0)
                {
                    StartIdx = Max(0, AutoCompleteIndices.Length + StartIdx);
                }
                idx = StartIdx;
                for (MatchIdx = 0; MatchIdx < 10; MatchIdx++)
                {
                    OutStr = AutoCompleteList[AutoCompleteIndices[idx]].Desc;
                    Canvas.StrLen(OutStr, info_xl, info_yl);
                    Canvas.SetPos(LeftPos + XL, ClipY - float(6) - YL * float((2 + MatchIdx)));
                    Canvas.SetDrawColor(0, 0, 0);
                    Canvas.DrawTile(DefaultTexture_White, info_xl, info_yl, 0.0, 0.0, 32.0, 32.0);
                    Canvas.SetPos(LeftPos + XL, ClipY - float(6) - YL * float((2 + MatchIdx)));
                    if (idx == AutoCompleteIndex)
                    {
                        Canvas.SetDrawColor(0, 255, 0);
                    }
                    else
                    {
                        Canvas.SetDrawColor(0, 150, 0);
                    }
                    Canvas.DrawText(OutStr, FALSE);
                    if (++idx >= AutoCompleteIndices.Length)
                    {
                        idx = 0;
                    }
                    if (idx == StartIdx)
                    {
                        break;
                    }
                }
                if (AutoCompleteIndices.Length >= 10)
                {
                    OutStr = "[" $ AutoCompleteIndices.Length - 10 + 1 @ "more matches]";
                    Canvas.StrLen(OutStr, info_xl, info_yl);
                    Canvas.SetPos(LeftPos + XL, ClipY - float(6) - YL * float(12));
                    Canvas.SetDrawColor(0, 0, 0);
                    Canvas.DrawTile(DefaultTexture_White, info_xl, info_yl, 0.0, 0.0, 32.0, 32.0);
                    Canvas.SetPos(LeftPos + XL, ClipY - float(6) - YL * float(12));
                    Canvas.SetDrawColor(0, 255, 0);
                    Canvas.DrawText(OutStr, FALSE);
                }
            }
            OutStr = "(>" @ Left(TypedStr, TypedStrPos);
            Canvas.StrLen(OutStr, XL, YL);
            Canvas.SetPos(LeftPos + XL, ClipY - float(1) - YL);
            Canvas.DrawText("_");
        }
    }
    public function bool InputKey(int ControllerId, Name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = FALSE)
    {
        local string Temp;
        local int NewPos;
        local int SpacePos;
        local int PeriodPos;
        
        if (Event == EInputEvent.IE_Pressed)
        {
            bCaptureKeyInput = FALSE;
        }
        if (ProcessControlKey(Key, Event))
        {
            return TRUE;
        }
        else if (bGamepad)
        {
            return FALSE;
        }
        else if (Key == 'Escape' && Event == EInputEvent.IE_Released)
        {
            if (TypedStr != "")
            {
                SetInputText("");
                SetCursorPos(0);
                HistoryCur = HistoryBot;
                return TRUE;
            }
            else
            {
                GotoState('None', , , );
            }
            return TRUE;
        }
        else if (Key == ConsoleKey && Event == EInputEvent.IE_Pressed)
        {
            GotoState('Open', , , );
            bCaptureKeyInput = TRUE;
            return TRUE;
        }
        else if (Key == TypeKey && Event == EInputEvent.IE_Pressed)
        {
            if (AutoCompleteIndices.Length > 0 && !bAutoCompleteLocked)
            {
                TypedStr = AutoCompleteList[AutoCompleteIndices[AutoCompleteIndex]].Command;
                SetCursorPos(Len(TypedStr));
                bAutoCompleteLocked = TRUE;
            }
            else
            {
                GotoState('None', , , );
                bCaptureKeyInput = TRUE;
            }
            return TRUE;
        }
        else if (Key == 'Enter' && Event == EInputEvent.IE_Released)
        {
            if (TypedStr != "")
            {
                Temp = TypedStr;
                SetInputText("");
                SetCursorPos(0);
                ConsoleCommand(Temp);
                OutputText("");
                GotoState('None', , , );
                UpdateCompleteIndices();
            }
            else
            {
                GotoState('None', , , );
            }
            return TRUE;
        }
        else if (Global.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad))
        {
            return TRUE;
        }
        else if (Event != EInputEvent.IE_Pressed && Event != EInputEvent.IE_Repeat)
        {
            if (!bGamepad)
            {
                return Key != 'LeftMouseButton' && Key != 'MiddleMouseButton' && Key != 'RightMouseButton';
            }
            return FALSE;
        }
        else if (Key == 'Up')
        {
            if (!bNavigatingHistory && (bRequireCtrlToNavigateAutoComplete && bCtrl || !bRequireCtrlToNavigateAutoComplete && !bCtrl && AutoCompleteIndices.Length > 1))
            {
                if (++AutoCompleteIndex == AutoCompleteIndices.Length)
                {
                    AutoCompleteIndex = 0;
                }
            }
            else if (HistoryBot >= 0)
            {
                if (HistoryCur == HistoryBot)
                {
                    HistoryCur = HistoryTop;
                }
                else
                {
                    HistoryCur--;
                    if (HistoryCur < 0)
                    {
                        HistoryCur = 16 - 1;
                    }
                }
                SetInputText(History[HistoryCur]);
                SetCursorPos(Len(History[HistoryCur]));
                UpdateCompleteIndices();
                bNavigatingHistory = TRUE;
            }
            return TRUE;
        }
        else if (Key == 'Down')
        {
            if (!bNavigatingHistory && (bRequireCtrlToNavigateAutoComplete && bCtrl || !bRequireCtrlToNavigateAutoComplete && !bCtrl && AutoCompleteIndices.Length > 1))
            {
                if (--AutoCompleteIndex < 0)
                {
                    AutoCompleteIndex = AutoCompleteIndices.Length - 1;
                }
                bAutoCompleteLocked = FALSE;
            }
            else if (HistoryBot >= 0)
            {
                if (HistoryCur == HistoryTop)
                {
                    HistoryCur = HistoryBot;
                }
                else
                {
                    HistoryCur = (HistoryCur + 1) %  16;
                }
                SetInputText(History[HistoryCur]);
                SetCursorPos(Len(History[HistoryCur]));
                UpdateCompleteIndices();
                bNavigatingHistory = TRUE;
            }
        }
        else if (Key == 'BackSpace')
        {
            if (TypedStrPos > 0)
            {
                SetInputText(Left(TypedStr, TypedStrPos - 1) $ Right(TypedStr, Len(TypedStr) - TypedStrPos));
                SetCursorPos(TypedStrPos - 1);
                bAutoCompleteLocked = FALSE;
            }
            return TRUE;
        }
        else if (Key == 'Delete')
        {
            if (TypedStrPos < Len(TypedStr))
            {
                SetInputText(Left(TypedStr, TypedStrPos) $ Right(TypedStr, Len(TypedStr) - TypedStrPos - 1));
            }
            return TRUE;
        }
        else if (Key == 'Left')
        {
            if (bCtrl)
            {
                NewPos = Max(InStr(TypedStr, ".", TRUE, FALSE, TypedStrPos), InStr(TypedStr, " ", TRUE, FALSE, TypedStrPos));
                SetCursorPos(Max(0, NewPos));
            }
            else
            {
                SetCursorPos(Max(0, TypedStrPos - 1));
            }
            return TRUE;
        }
        else if (Key == 'Right')
        {
            if (bCtrl)
            {
                SpacePos = InStr(TypedStr, " ", FALSE, FALSE, TypedStrPos + 1);
                PeriodPos = InStr(TypedStr, ".", FALSE, FALSE, TypedStrPos + 1);
                NewPos = SpacePos < 0 ? PeriodPos : PeriodPos < 0 ? SpacePos : Min(SpacePos, PeriodPos);
                if (NewPos == -1)
                {
                    NewPos = Len(TypedStr);
                }
                SetCursorPos(Min(Len(TypedStr), Max(TypedStrPos, NewPos)));
            }
            else
            {
                SetCursorPos(Min(Len(TypedStr), TypedStrPos + 1));
            }
            return TRUE;
        }
        else if (Key == 'Home')
        {
            SetCursorPos(0);
            return TRUE;
        }
        else if (Key == 'End')
        {
            SetCursorPos(Len(TypedStr));
            return TRUE;
        }
        return TRUE;
    }
    public function bool InputChar(int ControllerId, string Unicode)
    {
        if (IsUIMiniConsoleOpen())
        {
            return FALSE;
        }
        if (bCaptureKeyInput)
        {
            return TRUE;
        }
        AppendInputText(Unicode);
        return TRUE;
    }
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    ManualAutoCompleteList = ({Command = "Exit", Desc = "Exit (Exits the game)"}, 
                              {Command = "Open", Desc = "Open <MapName> (Opens the specified map)"}, 
                              {Command = "DisplayAll", Desc = "DisplayAll <ClassName> <PropertyName> (Display property values for instances of classname)"}, 
                              {Command = "DisplayAllState", Desc = "DisplayAllState <ClassName> (Display state names for all instances of classname)"}, 
                              {Command = "DisplayClear", Desc = "DisplayClear (Clears previous DisplayAll entries)"}, 
                              {Command = "FlushPersistentDebugLines", Desc = "FlushPersistentDebugLines (Clears persistent debug line cache)"}, 
                              {Command = "GetAll ", Desc = "GetAll <ClassName> <PropertyName> <Name=ObjectInstanceName> (Log property values of all instances of classname)"}, 
                              {Command = "GetAllState", Desc = "GetAllState <ClassName> (Log state names for all instances of classname)"}, 
                              {Command = "Obj List ", Desc = "Obj List <Class=ClassName> <Type=MetaClass> <Outer=OuterObject> <Package=InsidePackage> <Inside=InsideObject>"}, 
                              {Command = "Obj ListContentRefs", Desc = "Obj ListContentRefs <Class=ClassName> <ListClass=ClassName>"}, 
                              {Command = "Obj Classes", Desc = "Obj Classes (Shows all classes)"}, 
                              {Command = "EditActor", Desc = "EditActor <Class=ClassName> or <Name=ObjectName> or TRACE"}, 
                              {Command = "EditDefault", Desc = "EditDefault <Class=ClassName>"}, 
                              {Command = "EditObject", Desc = "EditObject <Class=ClassName> or <Name=ObjectName> or <ObjectName>"}, 
                              {Command = "ReloadCfg ", Desc = "ReloadCfg <Class/ObjectName> (Reloads config variables for the specified object/class)"}, 
                              {Command = "ReloadLoc ", Desc = "ReloadLoc <Class/ObjectName> (Reloads localized variables for the specified object/class)"}, 
                              {Command = "Set ", Desc = "Set <ClassName> <PropertyName> <Value> (Sets property to value on objectname)"}, 
                              {Command = "Show BOUNDS", Desc = "Show BOUNDS (Displays bounding boxes for all visible objects)"}, 
                              {Command = "Show BSP", Desc = "Show BSP (Toggles BSP rendering)"}, 
                              {Command = "Show COLLISION", Desc = "Show COLLISION (Toggles collision rendering)"}, 
                              {Command = "Show COVER", Desc = "Show COVER (Toggles cover rendering)"}, 
                              {Command = "Show DECALS", Desc = "Show DECALS (Toggles decal rendering)"}, 
                              {Command = "Show FOG", Desc = "Show FOG (Toggles fog rendering)"}, 
                              {Command = "Show LEVELCOLORATION", Desc = "Show LEVELCOLORATION (Toggles per-level coloration)"}, 
                              {Command = "Show PATHS", Desc = "Show PATHS (Toggles path rendering)"}, 
                              {Command = "Show POSTPROCESS", Desc = "Show POSTPROCESS (Toggles post process rendering)"}, 
                              {Command = "Show SKELMESHES", Desc = "Show SKELMESHES (Toggles skeletal mesh rendering)"}, 
                              {Command = "Show TERRAIN", Desc = "Show TERRAIN (Toggles terrain rendering)"}, 
                              {Command = "Show VOLUMES", Desc = "Show VOLUMES (Toggles volume rendering)"}, 
                              {Command = "Show SPLINES", Desc = "Show SPLINES (Toggles spline rendering)"}, 
                              {Command = "Stat FPS", Desc = "Stat FPS (Shows FPS counter)"}, 
                              {Command = "Stat UNIT", Desc = "Stat UNIT (Shows hardware unit framerate)"}, 
                              {Command = "Stat LEVELS", Desc = "Stat LEVELS (Displays level streaming info)"}, 
                              {Command = "Stat GAME", Desc = "Stat GAME (Displays game performance stats)"}, 
                              {Command = "Stat MEMORY", Desc = "Stat MEMORY (Displays memory stats)"}, 
                              {Command = "Stat XBOXMEMORY", Desc = "Stat XBOXMEMORY (Displays Xbox memory stats while playing on PC)"}, 
                              {Command = "Stat PHYSICS", Desc = "Stat PHYSICS (Displays physics performance stats)"}, 
                              {Command = "Stat STREAMING", Desc = "Stat STREAMING"}, 
                              {Command = "Stat COLLISION", Desc = "Stat COLLISION"}, 
                              {Command = "Stat PARTICLES", Desc = "Stat PARTICLES"}, 
                              {Command = "Stat SCRIPT", Desc = "Stat SCRIPT"}, 
                              {Command = "Stat AUDIO", Desc = "Stat AUDIO"}, 
                              {Command = "Stat ANIM", Desc = "Stat ANIM"}, 
                              {Command = "Stat NET", Desc = "Stat NET"}, 
                              {Command = "Stat LIST", Desc = "Stat LIST Groups/Sets/Group (List groups of stats, saved sets, or specific stats within a specified group)"}, 
                              {Command = "ListTextures", Desc = "ListTextures (Lists all loaded textures and their current memory footprint)"}, 
                              {Command = "RestartLevel", Desc = "RestartLevel (restarts the level)"}, 
                              {Command = "ListSounds", Desc = "ListSounds (Lists all the loaded sounds and their memory footprint)"}, 
                              {Command = "ListWaves", Desc = "ListWaves (List the WaveInstances and whether they have a source)"}, 
                              {Command = "ListSoundClasses", Desc = "ListSoundClasses (Lists a summary of loaded sound collated by class)"}, 
                              {Command = "ListSoundModes", Desc = "ListSoundModes (Lists loaded sound modes)"}, 
                              {Command = "ListAudioComponents", Desc = "ListAudioComponents (Dumps a detailed list of all AudioComponent objects)"}, 
                              {Command = "ListSoundDurations", Desc = "ListSoundDurations"}, 
                              {Command = "PlaySoundCue", Desc = "PlaySoundCue (Lists a summary of loaded sound collated by class)"}, 
                              {Command = "PlaySoundWave", Desc = "PlaySoundWave"}, 
                              {Command = "SetSoundMode", Desc = "SetSoundMode <ModeName>"}, 
                              {Command = "DisableLowPassFilter", Desc = "DisableLowPassFilter"}, 
                              {Command = "DisableEQFilter", Desc = "DisableEQFilter"}, 
                              {Command = "IsolateDryAudio", Desc = "IsolateDryAudio"}, 
                              {Command = "IsolateReverb", Desc = "IsolateReverb"}, 
                              {Command = "ResetSoundState", Desc = "ResetSoundState (Resets volumes to default and removes test filters)"}, 
                              {Command = "ModifySoundClass", Desc = "ModifySoundClass <SoundClassName> Vol=<new volume>"}, 
                              {Command = "DisableAllScreenMessages", Desc = "Disables all on-screen warnings/messages"}, 
                              {Command = "EnableAllScreenMessages", Desc = "Enables all on-screen warnings/messages"}, 
                              {Command = "ToggleAllScreenMessages", Desc = "Toggles display state of all on-screen warnings/messages"}, 
                              {Command = "CaptureMode", Desc = "Toggles display state of all on-screen warnings/messages"}
                             )
    ConsoleKey = 'Tilde'
    TypeKey = 'Tab'
    DefaultTexture_Black = Texture2D'EngineResources.Black'
    DefaultTexture_White = Texture2D'EngineResources.WhiteSquareTexture'
    MaxScrollbackSize = 1024
    HistoryBot = -1
    __OnReceivedNativeInputKey__Delegate = InputKey
    __OnReceivedNativeInputChar__Delegate = InputChar
}