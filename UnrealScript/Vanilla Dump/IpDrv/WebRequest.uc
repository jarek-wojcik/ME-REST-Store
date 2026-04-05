Class WebRequest
    native;

enum ERequestType
{
    Request_GET,
    Request_POST,
};

var const native Map_Mirror HeaderMap;
var const native Map_Mirror VariableMap;
var string RemoteAddr;
var string URI;
var string Username;
var string Password;
var string ContentType;
var int ContentLength;
var ERequestType RequestType;

public final native function string GetVariable(string VariableName, optional string DefaultValue);

public final native function string GetVariableNumber(string VariableName, int Number, optional string DefaultValue);

public final native function AddHeader(string HeaderName, coerce string Value);

public final native function AddVariable(string VariableName, coerce string Value);

public final native function string DecodeBase64(string Encoded);

public final native function Dump();

public final native function string EncodeBase64(string Decoded);

public final native function string GetHeader(string HeaderName, optional string DefaultValue);

public final native function GetHeaders(out array<string> headers);

public final native function int GetVariableCount(string VariableName);

public final native function GetVariables(out array<string> varNames);

public function DecodeFormData(string Data)
{
    local string token[2];
    local string ch;
    local int i;
    local int H1;
    local int H2;
    local int Limit;
    local int T;
    
    T = 0;
    for (i = 0; i < Len(Data); i++)
    {
        if (Limit > Class'WebConnection'.default.MaxValueLength || i > Class'WebConnection'.default.MaxLineLength)
        {
            break;
        }
        ch = Mid(Data, i, 1);
        switch (ch)
        {
            case "+":
                token[T] $= " ";
                Limit++;
                break;
            case "&":
            case "?":
                if (token[0] != "")
                {
                    AddVariable(token[0], token[1]);
                }
                token[0] = "";
                token[1] = "";
                T = 0;
                Limit = 0;
                break;
            case "=":
                if (T == 0)
                {
                    Limit = 0;
                    T = 1;
                }
                else
                {
                    token[1] $= "=";
                    Limit++;
                }
                break;
            case "%":
                H1 = GetHexDigit(Mid(Data, ++i, 1));
                if (H1 != -1)
                {
                    Limit++;
                    H1 *= float(16);
                    H2 = GetHexDigit(Mid(Data, ++i, 1));
                    if (H2 != -1)
                    {
                        token[T] $= Chr(H1 + H2);
                    }
                }
                Limit++;
                break;
            default:
                token[T] $= ch;
                Limit++;
        }
    }
    if (token[0] != "")
    {
        AddVariable(token[0], token[1]);
    }
}
public function int GetHexDigit(string D)
{
    switch (Caps(D))
    {
        case "0":
            return 0;
        case "1":
            return 1;
        case "2":
            return 2;
        case "3":
            return 3;
        case "4":
            return 4;
        case "5":
            return 5;
        case "6":
            return 6;
        case "7":
            return 7;
        case "8":
            return 8;
        case "9":
            return 9;
        case "A":
            return 10;
        case "B":
            return 11;
        case "C":
            return 12;
        case "D":
            return 13;
        case "E":
            return 14;
        case "F":
            return 15;
        default:
    }
    return -1;
}
public function ProcessHeaderString(string S)
{
    local int i;
    
    if (Left(S, 21) ~= "Authorization: Basic ")
    {
        S = DecodeBase64(Mid(S, 21, ));
        i = InStr(S, ":", , , );
        if (i != -1)
        {
            Username = Left(S, i);
            Password = Mid(S, i + 1, );
        }
    }
    else if (Left(S, 16) ~= "Content-Length: ")
    {
        ContentLength = int(Mid(S, 16, 64));
    }
    else if (Left(S, 14) ~= "Content-Type: ")
    {
        ContentType = Mid(S, 14, );
    }
    i = InStr(S, ":", , , );
    if (i > -1)
    {
        AddHeader(Left(S, i), Mid(S, i + 2, ));
    }
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}