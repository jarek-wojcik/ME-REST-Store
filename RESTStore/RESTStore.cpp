#define _CRT_SECURE_NO_WARNINGS

#include <windows.h>
#include <shlwapi.h>
#include <string>

#include "../ME3SDK/ME3TweaksHeader.h"
#include "../ME3SDK/SdkHeaders.h"
#include "../detours/detours.h"
#include "resource.h"
#include <vector>


#pragma comment(lib, "detours.lib")
#pragma comment(lib, "shlwapi.lib")

static HANDLE g_sidecarProcess = NULL;
static DWORD  g_sidecarPid = 0;
static HMODULE g_thisModule = NULL;

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

DWORD WINAPI onAttach(LPVOID)
{
    const std::wstring dir = GetModuleDirW(g_thisModule);
    const std::wstring sidecarPath = dir + L"\\RestSidecar.exe";

    if (!FileExistsW(sidecarPath))
    {
        if (!ExtractSidecarExeTo(sidecarPath))
        {
            // If you have a logger, log here.
            return 0;
        }
    }

    LaunchSidecar(sidecarPath, dir);
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
        return TRUE;
    }

    return TRUE;
}
