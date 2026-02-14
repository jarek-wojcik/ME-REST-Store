#pragma once

#include <fstream>
#include <string>
#include <unordered_map>

static inline bool containsColon(const std::string& s)
{
    return s.find(':') != std::string::npos;
}

static inline void writeData(const std::string& file_name, const std::unordered_map<std::string, std::string>& data)
{
    std::ofstream out(file_name, std::ios::out | std::ios::trunc);
    if (!out.is_open())
        return;

    // Format: key:value\n
    // Enforced: neither keys nor values may contain ':'
    for (const auto& kv : data)
    {
        if (kv.first.empty())
            continue;
        if (containsColon(kv.first) || containsColon(kv.second))
            continue;

        out << kv.first << ":" << kv.second << "\n";
    }

    out.close();
}

static inline void readData(const std::string& file_name, std::unordered_map<std::string, std::string>& data)
{
    std::ifstream in(file_name, std::ios::in);
    if (!in.is_open())
        return;

    data.clear();

    std::string line;
    while (std::getline(in, line))
    {
        if (line.empty())
            continue;

        const size_t pos = line.find(':');
        if (pos == std::string::npos)
            continue;

        std::string key = line.substr(0, pos);
        std::string value = line.substr(pos + 1);

        if (key.empty())
            continue;

        // Enforced: neither keys nor values may contain ':'
        if (containsColon(key) || containsColon(value))
            continue;

        data[key] = value;
    }

    in.close();
}
