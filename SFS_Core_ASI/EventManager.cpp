#include "EventManager.h"
#include <string>
#include <unordered_set>

static EventLogFn s_logFn = nullptr;
static std::unordered_set<std::string> s_seenEvents;

void SetEventManagerLogger(EventLogFn fn)
{
    s_logFn = fn;
}

void ResetSeenEvents()
{
    s_seenEvents.clear();
}

void LogEventOnce(const char* funcName)
{
    if (!s_logFn || !funcName)
        return;

    if (!s_seenEvents.insert(funcName).second)
        return; // already seen

    std::string msg = std::string(funcName) + "\n";
    s_logFn(msg.c_str());
}
