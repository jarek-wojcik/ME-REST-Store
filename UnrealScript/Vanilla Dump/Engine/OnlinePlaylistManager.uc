Class OnlinePlaylistManager
    native
    config(Playlist);

struct native Playlist 
{
    var array<ConfiguredGameSetting> ConfiguredGames;
    var string LocalizationString;
    var array<int> ContentIds;
    var string Name;
    var int PlaylistId;
    var int TeamSize;
    var int TeamCount;
    var bool bIsArbitrated;
    var bool bDisableDedicatedServerSearches;
};
struct native ConfiguredGameSetting 
{
    var string GameSettingsClassName;
    var string URL;
    var int GameSettingId;
    var transient OnlineGameSettings GameSettings;
};

var config array<Playlist> Playlists;
var array<string> PlaylistFileNames;
var config array<Name> DatastoresToRefresh;
var delegate<OnReadPlaylistComplete> __OnReadPlaylistComplete__Delegate;
var int DownloadCount;
var int SuccessfulCount;
var config int VersionNumber;

public native function DetermineFilesToDownload();

public native function FinalizePlaylistObjects();

public delegate function OnReadPlaylistComplete();

public function OnReadTitleFileComplete(bool bWasSuccessful, string Filename)
{
    local int FileIndex;
    
    for (FileIndex = 0; FileIndex < PlaylistFileNames.Length; FileIndex++)
    {
        if (PlaylistFileNames[FileIndex] == Filename)
        {
            DownloadCount++;
            SuccessfulCount += int(bWasSuccessful);
            if (DownloadCount == PlaylistFileNames.Length)
            {
                if (SuccessfulCount != DownloadCount)
                {
                }
                FinalizePlaylistObjects();
                __OnReadPlaylistComplete__Delegate();
            }
        }
    }
}
public function Reset()
{
    DownloadCount = 0;
    SuccessfulCount = 0;
}
public function DownloadPlaylist()
{
    if (SuccessfulCount == 0)
    {
        if (TRUE)
        {
            FinalizePlaylistObjects();
            __OnReadPlaylistComplete__Delegate();
        }
    }
    else
    {
        __OnReadPlaylistComplete__Delegate();
    }
}
public function GetContentIdsFromPlaylist(int PlaylistId, out array<int> ContentIds)
{
    local int PlaylistIndex;
    local int ContentIdx;
    
    for (PlaylistIndex = 0; PlaylistIndex < Playlists.Length; PlaylistIndex++)
    {
        if (Playlists[PlaylistIndex].PlaylistId == PlaylistId)
        {
            for (ContentIdx = 0; ContentIdx < Playlists[PlaylistIndex].ContentIds.Length; ContentIdx++)
            {
                ContentIds.AddItem(Playlists[PlaylistIndex].ContentIds[ContentIdx]);
            }
            return;
        }
    }
}
public function OnlineGameSettings GetGameSettings(int PlaylistId, int GameSettingsId)
{
    local int PlaylistIndex;
    local int GameIndex;
    
    for (PlaylistIndex = 0; PlaylistIndex < Playlists.Length; PlaylistIndex++)
    {
        if (Playlists[PlaylistIndex].PlaylistId == PlaylistId)
        {
            for (GameIndex = 0; GameIndex < Playlists[PlaylistIndex].ConfiguredGames.Length; GameIndex++)
            {
                if (Playlists[PlaylistIndex].ConfiguredGames[GameIndex].GameSettingId == GameSettingsId)
                {
                    return Playlists[PlaylistIndex].ConfiguredGames[GameIndex].GameSettings;
                }
            }
        }
    }
    return None;
}
public function GetTeamInfoFromPlaylist(int PlaylistId, out int TeamSize, out int TeamCount)
{
    local int PlaylistIndex;
    
    for (PlaylistIndex = 0; PlaylistIndex < Playlists.Length; PlaylistIndex++)
    {
        if (Playlists[PlaylistIndex].PlaylistId == PlaylistId)
        {
            TeamSize = Playlists[PlaylistIndex].TeamSize;
            TeamCount = Playlists[PlaylistIndex].TeamCount;
            return;
        }
    }
    TeamSize = 0;
    TeamCount = 0;
}
public function bool HasAnyGameSettings(int PlaylistId)
{
    local int PlaylistIndex;
    local int GameIndex;
    
    for (PlaylistIndex = 0; PlaylistIndex < Playlists.Length; PlaylistIndex++)
    {
        if (Playlists[PlaylistIndex].PlaylistId == PlaylistId)
        {
            for (GameIndex = 0; GameIndex < Playlists[PlaylistIndex].ConfiguredGames.Length; GameIndex++)
            {
                if (Playlists[PlaylistIndex].ConfiguredGames[GameIndex].GameSettings != None)
                {
                    return TRUE;
                }
            }
        }
    }
    return FALSE;
}
public function bool PlaylistSupportsDedicatedServers(int PlaylistId)
{
    local int PlaylistIndex;
    
    for (PlaylistIndex = 0; PlaylistIndex < Playlists.Length; PlaylistIndex++)
    {
        if (Playlists[PlaylistIndex].PlaylistId == PlaylistId)
        {
            return !Playlists[PlaylistIndex].bDisableDedicatedServerSearches;
        }
    }
    return FALSE;
}

//class default properties can be edited in the Properties tab for the class's Default__ object.
defaultproperties
{
}