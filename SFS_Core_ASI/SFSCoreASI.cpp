#define _CRT_SECURE_NO_WARNINGS

#include <windows.h>
#include <shlwapi.h>
#include <string>

#include "../ME3SDK/ME3TweaksHeader.h"
#include "../ME3SDK/SdkHeaders.h"
#include "../detours/detours.h"
#include "resource.h"
#include <vector>
#include <atomic>
#include "OverlayHost.h"


#pragma comment(lib, "detours.lib")
#pragma comment(lib, "shlwapi.lib")

// Constructed in onAttach (off the loader lock) not as a global
static ME3TweaksASILogger* logger = nullptr;
static HANDLE g_sidecarProcess = NULL;
static DWORD  g_sidecarPid = 0;
static HMODULE g_thisModule = NULL;

static OverlayHost g_overlay;
static std::atomic<bool> g_overlayShown{ false };

static std::wstring GetModuleDirW(HMODULE module)
{
    wchar_t path[MAX_PATH]{ 0 };
    GetModuleFileNameW(module, path, MAX_PATH);
    PathRemoveFileSpecW(path);
    return std::wstring(path);
}


static bool FileExistsW(const std::wstring& path)
{
    DWORD attrs = GetFileAttributesW(path.c_str());
    return (attrs != INVALID_FILE_ATTRIBUTES) && !(attrs & FILE_ATTRIBUTE_DIRECTORY);
}


static bool WriteAllBytesA(const std::string& path, const void* data, DWORD size)
{
    HANDLE h = CreateFileA(path.c_str(), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (h == INVALID_HANDLE_VALUE) return false;

    DWORD written = 0;
    BOOL ok = WriteFile(h, data, size, &written, NULL);
    CloseHandle(h);

    return ok && (written == size);
}

static bool ExtractSidecarExeTo(const std::wstring& outPath)
{
    HRSRC res = FindResourceW(g_thisModule, MAKEINTRESOURCEW(IDR_RESTSIDECAREXE), RT_RCDATA);
    if (!res) return false;

    HGLOBAL loaded = LoadResource(g_thisModule, res);
    if (!loaded) return false;

    DWORD size = SizeofResource(g_thisModule, res);
    if (size == 0) return false;

    void* ptr = LockResource(loaded);
    if (!ptr) return false;

    HANDLE h = CreateFileW(outPath.c_str(), GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if (h == INVALID_HANDLE_VALUE) return false;

    DWORD written = 0;
    BOOL ok = WriteFile(h, ptr, size, &written, NULL);
    CloseHandle(h);

    return ok && (written == size);
}

static bool LaunchSidecar(const std::wstring& exePath, const std::wstring& workingDir)
{
    STARTUPINFOW si{};
    si.cb = sizeof(si);

    PROCESS_INFORMATION pi{};

    std::wstring cmd = L"\"" + exePath + L"\"";

    // CreateProcessW requires mutable buffer:
    std::vector<wchar_t> cmdBuf(cmd.begin(), cmd.end());
    cmdBuf.push_back(L'\0');

    BOOL ok = CreateProcessW(
        NULL,
        cmdBuf.data(),
        NULL,
        NULL,
        FALSE,
        CREATE_NO_WINDOW,
        NULL,
        workingDir.c_str(),
        &si,
        &pi
    );

    if (!ok) return false;

    g_sidecarProcess = pi.hProcess;
    g_sidecarPid = pi.dwProcessId;

    CloseHandle(pi.hThread);
    return true;
}


static void StopSidecar()
{
    if (g_sidecarProcess)
    {
        TerminateProcess(g_sidecarProcess, 0);
        CloseHandle(g_sidecarProcess);
        g_sidecarProcess = NULL;
        g_sidecarPid = 0;
    }
}

void __fastcall HookedPE(UObject* pObject, void* edx, UFunction* pFunction, void* pParms, void* pResult)
{
    const auto funcName = pFunction->GetFullName();
    if (isPartOf(funcName, "IsPrivateMatch")) {
        if (logger) {
            char* szName = pFunction->GetFullName();
            logger->writeToLog(string_format("%s\n", szName), true);
            logger->flush();

             auto PC = (ABioPlayerController*)FindObjectOfType(ABioPlayerController::StaticClass());
        
            if (PC) {
                PC->ConsoleCommand(FString(TEXT("god")), 0);
            }
        }

        // On the first IsPrivateMatch, show only the toggle tab.
        // The overlay panel starts hidden � the user opens it by clicking the tab.
        bool expected = false;
        if (g_overlayShown.compare_exchange_strong(expected, true)) {
            if (logger) {
                logger->writeToLog("[HookedPE] First IsPrivateMatch � showing toggle tab.\n", true);
                logger->flush();
            }
            g_overlay.ShowToggleOnly();
        }
    }
    ProcessEvent(pObject, pFunction, pParms, pResult);
}

// All C++ objects with destructors live here, away from the __try block.
static void onAttachImpl()
{
    // Safe to construct the logger here � we are off the loader lock
    logger = new ME3TweaksASILogger("Function Call Logger", "FunctionCallLog.txt");
    logger->writeToLog("[onAttach] Logger started.\n", true);
    logger->flush();

    const std::wstring dir = GetModuleDirW(g_thisModule);
    const std::wstring sidecarPath = dir + L"\\SFSWebserver.exe";

    logger->writeToLog(string_format("[onAttach] Module dir: %s\n", ws2s(dir).c_str()), true);
    logger->flush();

    if (!FileExistsW(sidecarPath))
    {
        logger->writeToLog("[onAttach] Sidecar not found, extracting...\n", true);
        logger->flush();
        if (!ExtractSidecarExeTo(sidecarPath))
        {
            logger->writeToLog("[onAttach] ERROR: ExtractSidecarExeTo failed.\n", true);
            logger->flush();
            return;
        }
        logger->writeToLog("[onAttach] Sidecar extracted.\n", true);
        logger->flush();
    }
    else
    {
        logger->writeToLog("[onAttach] Sidecar already exists.\n", true);
        logger->flush();
    }

    if (!LaunchSidecar(sidecarPath, dir))
    {
        logger->writeToLog(string_format("[onAttach] ERROR: LaunchSidecar failed (GLE=%lu).\n", GetLastError()), true);
        logger->flush();
    }
    else
    {
        logger->writeToLog("[onAttach] Sidecar launched.\n", true);
        logger->flush();
    }

    logger->writeToLog("[onAttach] Installing ProcessEvent hook...\n", true);
    logger->flush();

    DetourTransactionBegin();
    DetourUpdateThread(GetCurrentThread());
    DetourAttach(&(PVOID&)ProcessEvent, HookedPE);
    DetourTransactionCommit();

    logger->writeToLog("[onAttach] Hook installed. ASI running.\n", true);
    logger->flush();

    logger->writeToLog("[onAttach] Initializing overlay...\n", true);
    logger->flush();

    if (g_overlay.Initialize(g_thisModule))
    {
        logger->writeToLog("[onAttach] Overlay initialized. Toggle tab will appear on first IsPrivateMatch.\n", true);
    }
    else
    {
        logger->writeToLog("[onAttach] WARNING: Overlay Initialize failed � overlay will not show.\n", true);
    }
    logger->flush();
}

// Thin __try wrapper � no C++ objects with destructors allowed in the same
// function as __try, so all real work lives in onAttachImpl().
DWORD WINAPI onAttach(LPVOID)
{
    __try
    {
        onAttachImpl();
    }
    __except (EXCEPTION_EXECUTE_HANDLER)
    {
        DWORD code = GetExceptionCode();
        wchar_t msg[256];
        swprintf_s(msg, L"SFSCoreASI: fatal exception in onAttach\nException code: 0x%08X\n\nThe ASI will not function.", code);
        MessageBoxW(nullptr, msg, L"SFSCoreASI Error", MB_OK | MB_ICONERROR);
    }
    return 0;
}

BOOL WINAPI DllMain(HMODULE hModule, DWORD dwReason, LPVOID lpReserved)
{
    (void)lpReserved;

    switch (dwReason)
    {
    case DLL_PROCESS_ATTACH:
        g_thisModule = hModule;
        DisableThreadLibraryCalls(hModule);
        CreateThread(NULL, 0, onAttach, NULL, 0, NULL);
        return TRUE;

    case DLL_PROCESS_DETACH:
        StopSidecar();
        g_overlay.Shutdown();
        delete logger;
        logger = nullptr;
        return TRUE;
    }

    return TRUE;
}
