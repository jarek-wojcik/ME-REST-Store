Class SFXConsole extends Console within GameViewportClient
    native
    transient
    config(Input);

const breakChars = " .()='\\/\"";

var bool bShift;

public native function string FindNextPropertyMatching(Class<Object> C, string PropertyPrefix, string AfterThisProperty);

public static final native function Object FindObjectUnqualified(string ObjectName, Class<Object> ObjectClass);

public function Initialized()
{
    Super.Initialized();
    LoadHistory();
}
public final native function LoadHistory();

public final native function SaveHistory();

public function bool InputKey(int ControllerId, Name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = FALSE)
{
    if (Class'WorldInfo'.static.IsShippingPCBuild() && !Class'WorldInfo'.static.IsFinalReleaseDebugConsoleBuild())
    {
        return FALSE;
    }
    if (Event == EInputEvent.IE_Pressed)
    {
        bCaptureKeyInput = FALSE;
    }
    if (Key == ConsoleKey && Event == EInputEvent.IE_Pressed)
    {
        GotoState('Open', , , );
        bCaptureKeyInput = TRUE;
        return TRUE;
    }
    else if (Key == TypeKey && Event == EInputEvent.IE_Pressed)
    {
        GotoState('Typing', , , );
        bCaptureKeyInput = TRUE;
        return TRUE;
    }
    return bCaptureKeyInput;
}
public function SaveHistoryToFile()
{
    SaveHistory();
}
public function bool CommonInputKey(int ControllerId, Name Key, EInputEvent Event, float AmountDepressed, bool bGamepad)
{
    local int NextHistory;
    
    if (Key == 'LeftShift')
    {
        if (Event == EInputEvent.IE_Released)
        {
            bShift = FALSE;
        }
        else if (Event == EInputEvent.IE_Pressed)
        {
            bShift = TRUE;
        }
        return TRUE;
    }
    else if (Key == 'BackSpace' && bCtrl && Event == EInputEvent.IE_Pressed)
    {
        if (TypedStrPos > 0)
        {
            PurgeCommandFromHistory(TypedStr);
            SaveHistory();
            SetInputText("");
            SetCursorPos(0);
        }
        return TRUE;
    }
    else if (Key == 'Delete' && bCtrl && Event == EInputEvent.IE_Pressed)
    {
        if (TypedStrPos < Len(TypedStr))
        {
            SetInputText(Left(TypedStr, TypedStrPos) $ Mid(TypedStr, FindBreak(TypedStr, TypedStrPos, TRUE), ));
        }
        return TRUE;
    }
    else if (Key == 'Left' && !bCtrl && Event == EInputEvent.IE_Pressed)
    {
        SetCursorPos(Max(0, TypedStrPos - 1));
        return TRUE;
    }
    else if (Key == 'Right' && !bCtrl && Event == EInputEvent.IE_Pressed)
    {
        SetCursorPos(Min(Len(TypedStr), TypedStrPos + 1));
        return TRUE;
    }
    else if (Key == 'Left' && bCtrl && Event == EInputEvent.IE_Pressed)
    {
        SetCursorPos(FindBreak(TypedStr, TypedStrPos, FALSE));
        return TRUE;
    }
    else if (Key == 'Right' && bCtrl && Event == EInputEvent.IE_Pressed)
    {
        SetCursorPos(FindBreak(TypedStr, TypedStrPos, TRUE));
        return TRUE;
    }
    else if (Key == 'Tab' && bCtrl && Event == EInputEvent.IE_Pressed)
    {
        if (FindNextMatchingHistory(NextHistory, TypedStr, TypedStrPos))
        {
            HistoryCur = NextHistory;
            SetInputText(History[HistoryCur]);
            SetCursorPos(TypedStrPos);
        }
        return TRUE;
    }
    else if (Key == 'Tab' && bShift && Event == EInputEvent.IE_Pressed)
    {
        FindNextMatchingAutoComplete(TypedStr, TypedStrPos);
        SetCursorPos(TypedStrPos);
        return TRUE;
    }
    return FALSE;
}
public function int FindBreak(string CurrentString, int CurrentStringPos, bool bForward)
{
    local int breakCharsLen;
    local string si;
    local string sj;
    local int i;
    local int J;
    local int Start;
    local int Limit;
    local int increment;
    
    if (CurrentString != "")
    {
        breakCharsLen = Len(" .()='\\/\"");
        if (bForward)
        {
            Limit = Len(CurrentString);
            Start = Min(Limit, CurrentStringPos + 1);
            increment = 1;
        }
        else
        {
            Limit = 0;
            Start = Max(Limit, CurrentStringPos - 1);
            increment = -1;
        }
        i = Start;
        while (TRUE)
        {
            si = Mid(CurrentString, i, 1);
            for (J = 0; J != breakCharsLen; J++)
            {
                sj = Mid(" .()='\\/\"", J, 1);
                if (sj == si)
                {
                    return i;
                }
            }
            if (i == Limit)
            {
                break;
            }
            i += increment;
        }
        return Limit;
    }
    return 0;
}
public function FindNextMatchingAutoComplete(out string CurrentString, int CurrentStringPos)
{
    local array<string> Pieces;
    local string token;
    local string className;
    local string PropertyName;
    local string Prefix;
    local string outputstring;
    local int PrefixBegin;
    local int PrefixEnd;
    local Class<Object> SearchClass;
    local Object TestObj;
    
    ParseStringIntoArray(CurrentString, Pieces, " ", TRUE);
    if (Pieces.Length > 0)
    {
        token = Pieces[Pieces.Length - 1];
        if (InStr(token, "::", , , ) != -1)
        {
            PrefixBegin = InStr(CurrentString, "::", TRUE, , ) + 2;
            PrefixEnd = CurrentStringPos - PrefixBegin;
            if (PrefixBegin != PrefixEnd)
            {
                Prefix = Mid(CurrentString, PrefixBegin, PrefixEnd);
            }
            PropertyName = Right(token, Len(token) - (InStr(token, "::", FALSE, , ) + 2));
            className = Left(token, InStr(token, "::", FALSE, , ));
            SearchClass = Class<Object>(FindObjectUnqualified(className, Class'Object'));
            if (SearchClass != None)
            {
                token = FindNextPropertyMatching(SearchClass, Prefix, PropertyName);
                if (token != "")
                {
                    Pieces[Pieces.Length - 1] = className $ "::" $ token;
                }
            }
        }
        else if (Pieces.Length >= 2)
        {
            PrefixBegin = InStr(CurrentString, " ", TRUE, , ) + 1;
            PrefixEnd = CurrentStringPos - PrefixBegin;
            if (PrefixBegin != PrefixEnd)
            {
                Prefix = Mid(CurrentString, PrefixBegin, PrefixEnd);
            }
            PropertyName = token;
            className = Pieces[Pieces.Length - 2];
            TestObj = FindObjectUnqualified(className, Class'Object');
            SearchClass = Class<Object>(TestObj);
            if (SearchClass == None && TestObj != None)
            {
                SearchClass = TestObj.Class;
            }
            if (SearchClass != None)
            {
                token = FindNextPropertyMatching(SearchClass, Prefix, PropertyName);
                if (token != "")
                {
                    Pieces[Pieces.Length - 1] = token;
                }
            }
        }
    }
    JoinArray(Pieces, outputstring, " ");
    SetInputText(outputstring);
}
public function bool FindNextMatchingHistory(out int outNextHistory, string CurrentString, int CurrentStringPos)
{
    local string LeftCurrentString;
    local string LeftHistoryString;
    local int Top;
    local int bot;
    local int i;
    
    if (CurrentString != "" && Len(CurrentString) >= CurrentStringPos && CurrentStringPos > 0)
    {
        if (HistoryCur >= 0 && HistoryCur < 16 && History[HistoryCur] == CurrentString)
        {
            if (HistoryCur > 0)
            {
                Top = HistoryCur - 1;
            }
            else
            {
                Top = 16 - 1;
            }
            if (HistoryCur < 16 - 1)
            {
                bot = HistoryCur + 1;
            }
            else
            {
                bot = 0;
            }
        }
        else if (HistoryTop >= 0 && HistoryTop < 16 && HistoryBot >= 0 && HistoryBot < 16)
        {
            Top = HistoryTop;
            bot = HistoryBot;
        }
        else
        {
            Top = 0;
            bot = 0;
        }
        LeftCurrentString = Left(CurrentString, CurrentStringPos);
        i = Top;
        while (TRUE)
        {
            LeftHistoryString = Left(History[i], CurrentStringPos);
            if (LeftCurrentString ~= LeftHistoryString)
            {
                outNextHistory = i;
                return TRUE;
            }
            if (i == bot)
            {
                break;
            }
            if (i > 0)
            {
                i--;
                continue;
            }
            i = 16 - 1;
        }
    }
    return FALSE;
}
public function Actor GetCameraActor()
{
    local Actor HitActor;
    local Vector HitLocation;
    local Vector HitNormal;
    
    SFXPlayerCamera(Outer.Outer.GamePlayers[0].Actor.PlayerCamera).GetTrace(HitActor, HitLocation, HitNormal);
    return HitActor;
}
public function string PreParseCommand(string Command)
{
    local array<string> Pieces;
    local string token;
    local string outputstring;
    local int i;
    
    ParseStringIntoArray(Command, Pieces, " ", TRUE);
    for (i = 0; i < Pieces.Length; i++)
    {
        token = Pieces[i];
        if (Caps(token) == "$CAMERA")
        {
            Pieces[i] = PathName(GetCameraActor());
        }
        outputstring = outputstring @ Pieces[i];
    }
    return outputstring;
}

state Say extends Typing 
{
    public event function PostRender_Console(Canvas Canvas)
    {
        local float XL;
        local float YL;
        local string OutStr;
        local float ClipX;
        local float ClipY;
        local float LeftPos;
        
        if (!IsUIMiniConsoleOpen())
        {
            Global.PostRender_Console(Canvas);
            Canvas.Font = Class'Engine'.static.GetSmallFont();
            OutStr = " Say" @ TypedStr;
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
            Canvas.SetDrawColor(102, 204, 255);
            Canvas.DrawTile(DefaultTexture_White, ClipX, 2.0, 0.0, 0.0, 32.0, 32.0);
            Canvas.SetPos(LeftPos, ClipY - float(3) - YL);
            Canvas.bCenter = FALSE;
            Canvas.DrawText(OutStr, FALSE);
            OutStr = " Say" @ Left(TypedStr, TypedStrPos);
            Canvas.StrLen(OutStr, XL, YL);
            Canvas.SetPos(LeftPos + XL, ClipY - float(1) - YL);
            Canvas.DrawText("_");
        }
    }
    public function bool InputKey(int ControllerId, Name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = FALSE)
    {
        local string Temp;
        
        if (Key == 'Enter' && Event == EInputEvent.IE_Released)
        {
            if (TypedStr != "")
            {
                Temp = TypedStr;
                SetInputText("");
                SetCursorPos(0);
                ConsoleCommand("say " $ Temp);
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
        return Super.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
    }
    
    stop;
};
state Open 
{
    public function bool InputKey(int ControllerId, Name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = FALSE)
    {
        if (CommonInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad))
        {
            return TRUE;
        }
        return Super.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
    }
    
    stop;
};
state Typing 
{
    public function bool InputKey(int ControllerId, Name Key, EInputEvent Event, optional float AmountDepressed = 1.0, optional bool bGamepad = FALSE)
    {
        if (CommonInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad))
        {
            return TRUE;
        }
        return Super.InputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
    }
    
    stop;
};

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
    MapPathsForAutoComplete = ("Content\\Maps", "TestContent\\Maps\\EricCombat")
    HistoryTop = 4
    HistoryBot = 5
    HistoryCur = 4
}