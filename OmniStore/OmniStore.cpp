#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <io.h>
#include <fcntl.h>

#include <string>
#include <fstream>
#include <iostream>
#include <ostream>
#include <streambuf>
#include <sstream>
#include <unordered_map>

#include <windows.h>
#include <shlwapi.h>

#include "../ME3SDK/ME3TweaksHeader.h"
#include "../ME3SDK/SdkHeaders.h"
#include "../detours/detours.h"

#include "OmniSerializer.h"

#pragma comment(lib, "detours.lib")

ME3TweaksASILogger logger("Function Call Logger", "FunctionCallLog.txt");

using std::string;
using std::wstring;
using std::wstringstream;

static const char* storeFileName = "omniStore";

static std::unordered_map<std::string, std::string> savedData;
static std::string retrievedData;

wstringstream& operator<<(wstringstream& ss, const FString& fStr)
{
    for (auto i = 0; i < fStr.Num() && fStr(i) != 0; i++)
    {
        ss << fStr(i);
    }
    return ss;
}

static inline bool containsColonW(const std::wstring& s)
{
    return s.find(L':') != std::wstring::npos;
}

static inline std::string wstringToUtf8(const std::wstring& ws)
{
    if (ws.empty())
        return std::string();

    // Get required size (not including a null terminator because we pass explicit length)
    int required = WideCharToMultiByte(
        CP_UTF8,
        0,
        ws.c_str(),
        (int)ws.size(),
        NULL,
        0,
        NULL,
        NULL
    );

    if (required <= 0)
        return std::string();

    std::string out;
    out.resize(required);

    WideCharToMultiByte(
        CP_UTF8,
        0,
        ws.c_str(),
        (int)ws.size(),
        &out[0],          // writable buffer
        required,
        NULL,
        NULL
    );

    return out;
}

static inline std::wstring trimW(const std::wstring& s)
{
    size_t start = 0;
    while (start < s.size() && (s[start] == L' ' || s[start] == L'\t'))
        start++;

    if (start >= s.size())
        return L"";

    size_t end = s.size() - 1;
    while (end > start && (s[end] == L' ' || s[end] == L'\t'))
        end--;

    return s.substr(start, end - start + 1);
}

static inline bool startsWith(const std::wstring& s, const wchar_t* prefix)
{
    const size_t plen = wcslen(prefix);
    if (s.size() < plen)
        return false;
    return s.compare(0, plen, prefix) == 0;
}

void HandleConsoleCommand(USFXConsole* console, const wstring& cmd)
{
    // Command patterns:
    //  - savedata key:value
    //  - loaddata key
    //  - deletedata key
    //
    // Enforced: neither keys nor values may contain ':'

    if (startsWith(cmd, L"savedata "))
    {
        std::wstring payload = trimW(cmd.substr(wcslen(L"savedata ")));
        if (payload.empty())
            return;

        const size_t colonPos = payload.find(L':');
        if (colonPos == std::wstring::npos)
            return;

        std::wstring keyW = trimW(payload.substr(0, colonPos));
        std::wstring valueW = trimW(payload.substr(colonPos + 1));

        if (keyW.empty() || valueW.empty())
            return;

        // enforce: no ':' in key or value (note valueW cannot have ':' because we split on first,
        // but we still enforce for safety if someone passes weird input)
        if (containsColonW(keyW) || containsColonW(valueW))
            return;

        std::string key = wstringToUtf8(keyW);
        std::string value = wstringToUtf8(valueW);

        // enforce again on bytes
        if (containsColon(key) || containsColon(value))
            return;

        savedData[key] = value;
        writeData(storeFileName, savedData);
    }
    else if (startsWith(cmd, L"loaddata "))
    {
        std::wstring keyW = trimW(cmd.substr(wcslen(L"loaddata ")));
        if (keyW.empty())
            return;

        if (containsColonW(keyW))
            return;

        std::string key = wstringToUtf8(keyW);
        if (containsColon(key))
            return;

        // Model A: read from memory only
        auto it = savedData.find(key);
        if (it != savedData.end())
        {
            retrievedData = it->second;
        }
        else
        {
            retrievedData.clear();
        }
    }
    else if (startsWith(cmd, L"deletedata "))
    {
        std::wstring keyW = trimW(cmd.substr(wcslen(L"deletedata ")));
        if (keyW.empty())
            return;

        if (containsColonW(keyW))
            return;

        std::string key = wstringToUtf8(keyW);
        if (containsColon(key))
            return;

        const size_t erased = savedData.erase(key);
        if (erased > 0)
        {
            writeData(storeFileName, savedData);
        }
    }
}

void __fastcall HookedPE(UObject* pObject, void* edx, UFunction* pFunction, void* pParms, void* pResult)
{
    const auto funcName = pFunction->GetFullName();
    if (IsA<USFXConsole>(pObject) && isPartOf(funcName, "Function Console.Typing.InputChar"))
    {
        const auto inputCharParams = static_cast<UConsole_execInputChar_Parms*>(pParms);
        if (inputCharParams->Unicode.Count >= 1 && inputCharParams->Unicode(0) == '\r')
        {
            const auto console = static_cast<USFXConsole*>(pObject);
            wstringstream ss;
            ss << console->TypedStr;
            HandleConsoleCommand(console, ss.str());
        }
    }

    if (!isPartOf(funcName, "Tick")) {
        char* szName = pFunction->GetFullName();
        logger.writeToLog(string_format("%s\n", szName), true);
        logger.flush();
    }

    ProcessEvent(pObject, pFunction, pParms, pResult);
}

DWORD WINAPI onAttach(LPVOID)
{
    DetourTransactionBegin();
    DetourUpdateThread(GetCurrentThread());
    DetourAttach(&(PVOID&)ProcessEvent, HookedPE);
    DetourTransactionCommit();

    // Model A: load once
    if (_access_s(storeFileName, 0) == 0)
    {
        readData(storeFileName, savedData);
    }
    else
    {
        // Create empty store immediately
        writeData(storeFileName, savedData);
    }

    return 0;
}

BOOL WINAPI DllMain(HMODULE hModule, DWORD dwReason, LPVOID lpReserved)
{
    (void)lpReserved;

    switch (dwReason)
    {
    case DLL_PROCESS_ATTACH:
        DisableThreadLibraryCalls(hModule);
        CreateThread(NULL, 0, onAttach, NULL, 0, NULL);
        return TRUE;

    case DLL_PROCESS_DETACH:
        return TRUE;
    }

    return TRUE;
}
