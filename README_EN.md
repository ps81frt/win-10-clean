# win-10-clean

Batch script for Windows 10/11 that cleans temporary files, caches, and applies system performance tweaks. Requires administrator privileges.

---

## Requirements

- Windows 10 or Windows 11
- Administrator account

---

## Usage

Right-click `cleanup.bat` and select **Run as administrator**.

---

## What it does

### Cleanup (steps 1–12)

| Step | Target | Path(s) |
|------|--------|---------|
| 1 | Temporary files | `%TEMP%`, `C:\Windows\Temp`, `C:\Temp` |
| 2 | Prefetch cache | `C:\Windows\Prefetch` |
| 3 | Windows Event Logs | All logs via `wevtutil` |
| 4 | Recent files list | `%APPDATA%\Microsoft\Windows\Recent` |
| 5 | Thumbnail & icon cache | `%LOCALAPPDATA%\Microsoft\Windows\Explorer` |
| 6 | DNS cache, ARP table, NetBIOS cache | `ipconfig`, `arp`, `nbtstat` |
| 7 | Windows Update download cache | `C:\Windows\SoftwareDistribution\Download` |
| 8 | Windows Error Reporting data | `C:\ProgramData\Microsoft\Windows\WER` |
| 9 | Crash dumps | `C:\Windows\Minidump`, `MEMORY.DMP`, `%LOCALAPPDATA%\CrashDumps` |
| 10 | Windows Search index data | `C:\ProgramData\Microsoft\Search\Data` |
| 11 | Browser caches | Chrome, Edge, Firefox (default profiles) |
| 12 | Explorer run history | Registry keys `RunMRU`, `TypedPaths` |

### Performance tweaks (step 13)

| Tweak | Method | Notes |
|-------|--------|-------|
| Power plan | `powercfg -setactive SCHEME_MIN` | Switches to High Performance |
| Visual effects | Registry (`VisualFXSetting = 2`) | Reduces animations |
| Game DVR / App Capture | Registry | Disables background game recording |
| TCP auto-tuning | `netsh int tcp` | Sets `autotuninglevel=normal`, enables RSS, disables chimney |
| Background apps | Registry (`GlobalUserDisabled = 1`) | Disables UWP background activity |
| Explorer restart | `taskkill /f /im explorer.exe` | Applies UI registry changes |
| SysMain (Superfetch) | `sc config SysMain start= disabled` | Stops and disables the service |
| DiagTrack (telemetry) | `sc config DiagTrack start= disabled` | Stops and disables the service |

---

## Caveats

**Event logs** are cleared entirely. If you need logs for auditing or troubleshooting an ongoing issue, run the script after resolving it.

**Browser caches** only target default profiles. Additional profiles are not cleaned.

**SysMain** (Superfetch) improves launch times on HDDs; disabling it on SSD systems has no measurable benefit but is harmless.

**DiagTrack** disabling reduces Windows telemetry. This does not affect system stability.

**Explorer restart** closes and reopens the desktop shell. Open Explorer windows will close briefly.

**TCP chimney offload** (`chimney=disabled`) was deprecated in Windows 8.1 and has no effect on modern systems; the command runs without error but does nothing.

---

## What it does not do

- Does not uninstall software
- Does not modify user files or documents
- Does not alter firewall or security settings
- Does not clean browser profiles other than cache (cookies, passwords, history are untouched)

---

## Author

[ps81frt](https://github.com/ps81frt) — [github.com/ps81frt/win-10-clean](https://github.com/ps81frt/win-10-clean)

---

## License

MIT — Copyright (c) 2025 ps81frt
