# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

EConn2026 is a Delphi VCL application. The repository is small and currently serves as a base/skeleton (form with a single `Soma` method) with a working CI/CD pipeline built around a self-hosted Windows GitHub Actions runner with Embarcadero Delphi installed.

Two Delphi projects, joined by a project group:

- `Fontes/EConn2026.dproj` — the main VCL application (`Fontes/EConn2026.dpr`, form unit `Fontes/FEConn2026.pas`, form `TForm1`).
- `Tests/EConn2026_Test.dproj` — a DUnitX console test runner (`Tests/EConn2026_Test.dpr`, test unit `Tests/EConn2026.Test.pas`).
- `Fontes/EConn2026_GRoup.groupproj` — MSBuild project group that builds both.

The test project references the main project's source via `..\Fontes` on its unit search path (see `Tests/EConn2026_Test.dproj`), so `Tests/EConn2026.Test.pas` can `uses FEConn2026` directly and instantiate `TForm1` to test its methods — there is no separate business-logic unit yet, logic lives on the form class itself.

The test project also depends on DUnitX at a machine-local absolute path: `C:\workspace\Delphi\Frameworks\Tests\DUnitX\Source` (in `DCC_UnitSearchPath`). This must exist on any machine that builds the test project, including the self-hosted CI runner.

## Build and test commands

Building requires Delphi (Embarcadero Studio, version 37.0 in CI) and its `rsvars.bat` environment on the PATH/env. This is a Windows-only toolchain; there is no cross-platform build.

From a Delphi command prompt (after running `rsvars.bat`), or from `cmd.exe`:

```bash
call "C:\Program Files (x86)\Embarcadero\Studio\37.0\bin\rsvars.bat"
```

Build the test project (Release):

```bash
msbuild Tests\EConn2026_Test.dproj /p:Config=Release /t:Build
```

Run the tests (DUnitX console runner — runs all `[TestFixture]` classes found via RTTI, no per-test filtering flag is configured):

```bash
Tests\Win32\Release\EConn2026_Test.exe
```

Build the main application (Release):

```bash
msbuild Fontes\EConn2026.dproj /p:Config=Release /t:Build
```

Or build everything via the group project:

```bash
msbuild Fontes\EConn2026_GRoup.groupproj /t:Build
```

Alternatively, open `Fontes/EConn2026_GRoup.groupproj` in the Delphi IDE to build/run/debug both projects.

Adding a test: add a `[Test]` (optionally with `[TestCase('Name', 'arg1,arg2,expected')]`) method to the `[TestFixture]` class in `Tests/EConn2026.Test.pas`, following the existing `Test1` pattern (Setup creates `FForm1 := TForm1.Create(nil)`, TearDown frees it).

## CI/CD

- `.github/workflows/workflow.yml` ("Integracao continua - CI") runs on push/PR to `develop` and `master`, on a `self-hosted` Windows runner. It builds the test project, runs the resulting `.exe` directly (failure = non-zero exit code from DUnitX), then builds the main project. Both builds set `Config=Release` and redirect `DCC_ExeOutput` under `%GITHUB_WORKSPACE%\Bin`.
- `.github/workflows/release.yml` ("Entrega continua - CD") runs when a PR into `master` is merged. It computes a version as `yy.MM.NN` (current year.month, incrementing build number per month, based on existing git tags matching that prefix), prepends an entry to `CHANGELOG.md` (created if missing) with the merged PR's number/title/author, commits it as `github-actions[bot]`, pushes to `master`, then tags and pushes the new version tag.
- `Docs/Passo a passo configurar actions.txt` (Portuguese) documents how to register a self-hosted Windows runner with Delphi installed for this repo.

## Repository conventions

- Comments, unit/identifier names, and workflow/doc text are in Portuguese (pt-BR); keep new code and comments consistent with that where they touch existing Portuguese-named members.
- `__history/` and `__recovery/` directories are Delphi IDE backup folders (git-ignored) — never treat their contents as source of truth.
- Compiler output (`Win32/`, `*.exe`, `*.dcu`, etc.), `*.local`, `*.identcache`, and `dunitx-results.xml` are git-ignored; don't commit them.
