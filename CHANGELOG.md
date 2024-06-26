# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

\-

## [1.0.1] - 2024-06-04

### Fixed

-   Fixed breaking change of .NET 8: dotnet pack now uses "-c Debug" explicitly

## [1.0.0] - 2021-10-25

### Removed

-   Watch feature

## [0.3.4] - 2021-08-13

### Fixed

-   Compatibility issue with Windows Powershell 5.x (Join-Path only supports 2 arguments)
-   Multiple watch action iterations because of changes in several temp/cache files (only watch for *.cs)

## [0.3.3] - 2021-08-12

### Fixed

-   Compatibility issue with Windows Powershell 5.x (encoding changed to utf8bom)

## [0.3.2] - 2021-08-09

### Fixed

-   Wrong csproj directory path in verbose message
-   Exclude filter of watch mode if the current location and the package project path are the same

## [0.3.1] - 2021-08-09

### Fixed

-   Pausing on each watch cycle

## [0.3.0] - 2021-08-07

###  Added

-   Automated integration test ("smoke test")
-   `PackageProjectPath` parameter that will publish a package from a different directory than the current location
-   `Watch` parameter that will publish a package continuously on each change

## [0.2.0] - 2021-07-25

### Added

-   README documentation
-   Requirements check of an available dotnet CLI
-   Detailed verbose log outputs

### Changed

-   Replace hard coded values with function parameters for feed name and directory
-   Tidy up log outputs and separate them with colors

## [0.1.0] - 2021-07-19

### Added

-   Prepare local environment with hard coded values
-   build, pack and publish the project of the current directory to the local feed and cache
