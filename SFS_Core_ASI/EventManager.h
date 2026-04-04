#pragma once

// Called once at startup (from SFSCoreASI.cpp) so EventManager can log
// without pulling the ME3 SDK headers into this translation unit.
typedef void (*EventLogFn)(const char* msg);
void SetEventManagerLogger(EventLogFn fn);

// Logs funcName the first time it is seen; subsequent calls with the same name are no-ops.
void LogEventOnce(const char* funcName);

// Clears the seen-set (useful for testing or re-capture after a reset).
void ResetSeenEvents();
