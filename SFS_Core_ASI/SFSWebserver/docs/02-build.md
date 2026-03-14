# Building SFSWebserver

## Prerequisites

- [Go 1.22+](https://go.dev/dl/) installed and on `PATH`
- Internet access for the initial `go get` (only needed once)

---

## First-time Setup

Run these commands once from the `SFSWebserver/` directory:

```cmd
go mod init sfswebserver
go get go.etcd.io/bbolt
```

This creates `go.mod` and `go.sum` and downloads the BoltDB dependency.

---

## Building the Executable

```cmd
go build -ldflags="-s -w" -o SFSWebserver.exe .
```

The `-s -w` flags strip the debug symbol table and DWARF info, reducing binary size significantly.

The build embeds all files referenced by `//go:embed` directives (templates) directly into the executable — no extra files are needed alongside the `.exe` at runtime.

---

## Quick Script

The `go-build` file at the project root contains all three steps:

```cmd
go mod init sfswebserver
go get go.etcd.io/bbolt
go build -ldflags="-s -w" -o SFSWebserver.exe .
```

Run it manually line-by-line or wrap it in a `.cmd` file for automation.

---

## Running

```cmd
SFSWebserver.exe                   # port 6060, default DB path
SFSWebserver.exe 7070              # custom port
SFSWebserver.exe 7070 C:\my.db    # custom port + DB path
```

Once running, open the UI at:

```
http://127.0.0.1:6060/spectreportal/
```
