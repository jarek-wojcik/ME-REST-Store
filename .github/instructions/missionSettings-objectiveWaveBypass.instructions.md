---
description: Architecture and implementation guide for the MissionSettings system and the Disable Objective Waves feature. Load when working on SFSMissionSettingsService, SFSMissionParamsManager, MissionSettings model, mission_params_controller, or any objective-wave bypass logic.
applyTo: '**/SFSMission*.uc, **/mission_params*.go, **/missionSettings*.go'
---

# Mission Settings — Objective Wave Bypass

## Overview

The Mission Settings system allows the host to configure per-match behaviour flags
through the Spectre Portal UI. Settings are persisted to BoltDB by the Go sidecar and
exposed to ME3 via the `/missionSettings` endpoint. The first flag implemented is
**Disable Objective Waves**.

When active, objective waves (upload, annex, assassination, etc.) are suppressed
entirely, but players are still awarded the full credit compensation that a successful
objective wave would have paid.

---

## Data Layer

### Model — `model/missionSettings.go`
```go
type MissionSettings struct {
    DisableObjectiveWaves bool `json:"disableObjectiveWaves"`
}
```
Belongs in the `model` package alongside `Spectre`, `Team`, etc.
Add future flags here as new fields.

### Shared BoltDB bucket
Both the UI controller and the ME3 JSON endpoint share the **same bucket and key**:

| Constant             | Value             |
|----------------------|-------------------|
| `missionSettingsBucket` | `"missionSettings"` |
| `missionSettingsKey`    | `"config"`          |

This is defined in `controllers/mission_params_controller.go` (UI) and
`controllers/me3Integration/me3_integration_missionSettings.go` (ME3 JSON). Keep
them in sync when adding fields.

---

## Go Server Layer

### UI controller — `controllers/mission_params_controller.go`

Serves the Spectre Portal "Mission Parameters" tab as an HTMX partial.

| Route | Handler | Notes |
|---|---|---|
| `GET /api/missionParams` | Load from DB, render `mission_params` template | HTMX `hx-swap="outerHTML"` |
| `POST /api/missionParams` | Parse form values, save to DB, re-render partial | Checkbox: `disableObjectiveWaves=on` |

The checkbox auto-submits via `onchange="this.form.requestSubmit()"`. The partial
swaps itself on every save, so no extra JS state is needed.

### ME3 JSON endpoint — `controllers/me3Integration/me3_integration_missionSettings.go`

| Route | Method | Returns |
|---|---|---|
| `GET /missionSettings` | `Me3MissionSettingsController` | JSON or `simpleJson` flat text |
| `POST /missionSettings` | `Me3MissionSettingsController` | JSON or `simpleJson` flat text |

Use `?simpleJson=true` to get the flat `key:value` format that UnrealScript can
parse with `SFSMissionSettingsParser.FromSimpleJson`.

Registration in `SFSWebserver.go`:
```go
controllers.NewMissionParamsController(db, tmpl).Register()
me3integration.NewMe3MissionSettingsController(db).Register()
```

### Template — `templates/partials/mission_params.html`

Define block name: `mission_params`. Contains a "Wave Settings" card with one row
per flag. Follow the existing toggle-switch pattern when adding new flags:

```html
<input type="checkbox" name="disableObjectiveWaves" value="on"
       {{if .DisableObjectiveWaves}}checked{{end}}
       onchange="this.form.requestSubmit()">
```

---

## UnrealScript Layer

Four new SFS classes implement the bypass. They live in `UnrealScript/SFS_Multiplayer/`
and follow the same `SFSManager within SFXPawn` pattern as the rest of the portal.

### `SFSMissionSettingsModel`

A plain (non-`within`) class that declares the shared struct. **Not** an SFSManager.

```unrealscript
Class SFSMissionSettingsModel;

struct SFSMissionSettingsStruct
{
    var bool bDisableObjectiveWaves;
    // Add new fields here as MissionSettings grows.
};
```

All other UC classes reference `SFSMissionSettingsStruct` from this declaration.
Do **not** re-declare the struct in the service or manager.

### `SFSMissionSettingsParser`

Static parser class — the UnrealScript equivalent of `SFSCharacterJsonParser`.
Lives in `UnrealScript/SFS_Multiplayer/SFSMissionSettingsParser.uc`.

Core API:

| Function | Returns | Use for |
|---|---|---|
| `ExtractJsonField(body, key)` | `string` | Raw line extraction |
| `ExtractBool(body, key)` | `bool` | Boolean flags |
| `ExtractInt(body, key)` | `int` | Integer fields |
| `ExtractString(body, key)` | `string` | String fields |
| `FromSimpleJson(body, out Settings)` | `bool` | Full parse entry point |

`FromSimpleJson` always returns `TRUE`; missing fields default to zero/false so new
server-side flags degrade gracefully on older clients without crashing.

When adding new field types (arrays, nested objects) follow the same indexed-key
conventions used by `SFSCharacterJsonParser` — e.g. `key[N].field:value` — and
add a dedicated typed helper rather than inlining the parsing in `FromSimpleJson`.

### `SFSMissionSettingsService`

HTTP client. Calls `GET /missionSettings?simpleJson=true` and delegates parsing
to `SFSMissionSettingsParser.FromSimpleJson`.

Delegate signature:
```unrealscript
function OnSettingsRetrieved(SFSMissionSettingsStruct Settings, bool bSuccess)
```

In `OnHTTPResponse`:
```unrealscript
bSuccess = Class'SFSMissionSettingsParser'.static.FromSimpleJson(request.mResultBody, Settings);
```

defaultproperties:
```
SFS_REST_URL             = "http://localhost:6060/"
MISSION_SETTINGS_MAPPING = "missionSettings"
SIMPLE_JSON_PARAM        = "simpleJson"
```

### `SFSMissionParamsManager`

Orchestrator. Retrieved as a module by `SFSSpectrePortalManager`.

**On `HandlePostAdd()`:**
1. Calls `SFSMissionSettingsService.RetrieveSettings(OnSettingsRetrieved)`.

**On `OnSettingsRetrieved(Settings, bSuccess)` (if `bDisableObjectiveWaves == true`):**
1. Calls `ApplyObjectiveWaveBypass()`.

**`ApplyObjectiveWaveBypass()`:**
1. Finds the live `SFXWaveCoordinator_HordeOperation` via `FindActorsOfClass`.
2. If `WaveCoordinator == None`, self-reschedules with `SetTimer(1.0, FALSE, 'ApplyObjectiveWaveBypass', Self)` and returns.
3. If `WaveCoordinator.OperationManager == None`, self-reschedules and returns.
4. **Snapshots** all entries except the last (extraction) from `WaveCoordinator.OperationWaves[]`
   into `SavedOperationWaves[]` (WaveNumber + CreditScale).
5. **Truncates** `WaveCoordinator.OperationWaves` to 1 entry via
   `WaveCoordinator.OperationWaves.Remove(0, WaveCoordinator.OperationWaves.Length - 1)`
   — the remaining entry is the extraction wave, preserved so end-of-match extraction fires normally.
   Because `IsCurrentWaveAnOperation()` walks this array, objective wave numbers no longer match
   and `StartNewWave()` never adds an `SFXWave_Operation` to `ActiveWaves`.
6. Sets `bBypassActive = TRUE`, records `LastKnownWaveNumber`, starts `SetTimer(0.5, TRUE, 'PollWaveNumber', Self)`.

**`PollWaveNumber()`:**
- Detects when `WaveCoordinator.CurrentWaveNumber` advances.
- On advance, calls `OnWaveCompleted(LastKnownWaveNumber)`.

**`OnWaveCompleted(CompletedWaveNumber)`:**
- Looks up `CompletedWaveNumber` in `SavedOperationWaves[]`.
- If no matching entry with `CreditScale > 0` is found, returns immediately (non-op wave).
- If a match exists, replicates the vanilla credit formula:
  ```
  BaseReward = DifficultyHandler.GetMinFloat('ObjectiveCreditsReward', 'MPGlobal')
  BaseReward *= SavedOperationWaves[i].CreditScale
  BaseReward = float(int(BaseReward) - int(BaseReward) % 25)   // round down to nearest 25
  ```
- **All players:** `SFXPRI(PC.PlayerReplicationInfo).AddCredits(BaseReward)` — updates
  the replicated in-match `CreditsEarned` field (scoreboard display).
- **Local player only:**
  - `BioCheatManagerNonNative(PC.CheatManager).GrantMPCredits(int(BaseReward))` —
    persists credits to `MPSaveManager` (the permanent wallet).
  - `PC.HintSystem.AddNotification_CreditRecovery(int(BaseReward))` — wave-end credit notification.
  - `ScoreManager.LastCreditsEarned = int(BaseReward)` then `ScoreManager.ShowCreditsEarnedMessage()` —
    plays the `MPCreditsEarned` sound and shows the vanilla credits popup.

### Wire-up in `SFSSpectrePortalManager`

```unrealscript
var SFSMissionParamsManager MissionParamsManager;

// In HandlePostAdd():
MissionParamsManager = Outer.GetModule(Class'SFSMissionParamsManager');
```

### Registration in `SFSContextMP`

The two new classes must be added to `ManagerClasses` **in this order**, before
`SFSSpectrePortalManager` so the service is resolvable when the manager initialises:

```unrealscript
Class'SFSMissionSettingsService',
Class'SFSMissionParamsManager',
Class'SFSSpectrePortalManager'
```

---

## Credit Schedule (vanilla default config)

The default `OperationWaves` in `SFXWaveCoordinator_HordeOperation.defaultproperties`:

| Wave # | CreditScale | Notes |
|--------|-------------|-------|
| 2      | 0.15        | First op-wave — snapshotted and suppressed |
| 5      | 0.25        | Mid op-wave — snapshotted and suppressed |
| 9      | 0.60        | Late op-wave — snapshotted and suppressed |
| 10     | 0.0         | Extraction — **preserved** in `OperationWaves[0]`, not snapshotted |

The snapshot loop iterates `Length - 1` entries; `Remove(0, Length - 1)` drops waves 2/5/9
and leaves the extraction entry at index 0. The bypass awards credits for waves 2, 5, and 9
only (CreditScale > 0 guard).

---

## Timing Considerations

- The HTTP fetch is local (`localhost:6060`) and resolves in milliseconds.
- `SFXWaveCoordinator_HordeOperation.InitialStartDelay` (the pre-match countdown)
  provides a large window before wave 1 starts.
- `ApplyObjectiveWaveBypass()` reschedules itself until `OperationManager` is live —
  safe even if wave generation races the HTTP response.

## Future Flags

Add new fields to `MissionSettings` (Go) and `SFSMissionSettingsStruct` (UC) together.
Declare new `var` fields in `SFSMissionSettingsModel.uc`, add corresponding parser calls
in `SFSMissionSettingsParser.FromSimpleJson`, and add handler branches in
`SFSMissionParamsManager.OnSettingsRetrieved`. In the UI partial, add a new row inside
the relevant card (or a new card for a different category).

## Implementation Notes

- `BioCheatManagerNonNative.GrantMPCredits` call in `OnWaveCompleted` is currently
  commented out pending verification that double-crediting does not occur when combined
  with `SFXPRI.AddCredits`. Uncomment once confirmed.
- `SFSMissionSettingsModel` extends nothing (plain class) — do **not** add `within SFXPawn`
  or `extends SFSManager`; it is a pure data container.
