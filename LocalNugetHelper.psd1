#
# Modulmanifest für das Modul "LocalNugetHelper"
#
# Generiert von: Otter
#
# Generiert am: 28.06.2021
#

@{

# Die diesem Manifest zugeordnete Skript- oder Binärmoduldatei.
RootModule = 'LocalNugetHelper.psm1'

# Die Versionsnummer dieses Moduls
ModuleVersion = '0.1.0'

# Unterstützte PSEditions
# CompatiblePSEditions = @()

# ID zur eindeutigen Kennzeichnung dieses Moduls
GUID = '482ac39e-24af-4566-9bc3-2c5c2df66e8e'

# Autor dieses Moduls
Author = 'Johann-Peter Duchon'

# Unternehmen oder Hersteller dieses Moduls
CompanyName = 'Otter'

# Urheberrechtserklärung für dieses Modul
Copyright = '(c) 2021 Johann-Peter Duchon. Alle Rechte vorbehalten.'

# Beschreibung der von diesem Modul bereitgestellten Funktionen
Description = '1. Creates a folder for the local nuget path under C:\p\localnugetfeed
2. Adds the folder as a nuget source
3. Packs the C# project of the current folder and puts the output into the local nuget source
4. Purges local global-package cache of the created package version
5. Updates the global-package cache with the new package'

# Die für dieses Modul mindestens erforderliche Version des Windows PowerShell-Moduls
# PowerShellVersion = ''

# Der Name des für dieses Modul erforderlichen Windows PowerShell-Hosts
# PowerShellHostName = ''

# Die für dieses Modul mindestens erforderliche Version des Windows PowerShell-Hosts
# PowerShellHostVersion = ''

# Die für dieses Modul mindestens erforderliche Microsoft .NET Framework-Version. Diese erforderliche Komponente ist nur für die PowerShell Desktop-Edition gültig.
DotNetFrameworkVersion = '3.0'

# Die für dieses Modul mindestens erforderliche Version der CLR (Common Language Runtime). Diese erforderliche Komponente ist nur für die PowerShell Desktop-Edition gültig.
# CLRVersion = ''

# Die für dieses Modul erforderliche Prozessorarchitektur ("Keine", "X86", "Amd64").
# ProcessorArchitecture = ''

# Die Module, die vor dem Importieren dieses Moduls in die globale Umgebung geladen werden müssen
# RequiredModules = @()

# Die Assemblys, die vor dem Importieren dieses Moduls geladen werden müssen
# RequiredAssemblies = @()

# Die Skriptdateien (PS1-Dateien), die vor dem Importieren dieses Moduls in der Umgebung des Aufrufers ausgeführt werden.
# ScriptsToProcess = @()

# Die Typdateien (.ps1xml), die beim Importieren dieses Moduls geladen werden sollen
# TypesToProcess = @()

# Die Formatdateien (.ps1xml), die beim Importieren dieses Moduls geladen werden sollen
# FormatsToProcess = @()

# Die Module, die als geschachtelte Module des in "RootModule/ModuleToProcess" angegebenen Moduls importiert werden sollen.
# NestedModules = @()

# Aus diesem Modul zu exportierende Funktionen. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Funktionen vorhanden sind.
FunctionsToExport = @( 'Publish-LocalPackage' )

# Aus diesem Modul zu exportierende Cmdlets. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Cmdlets vorhanden sind.
CmdletsToExport = @()

# Die aus diesem Modul zu exportierenden Variablen
VariablesToExport = '*'

# Aus diesem Modul zu exportierende Aliase. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Aliase vorhanden sind.
AliasesToExport = @('plp')

# Aus diesem Modul zu exportierende DSC-Ressourcen
# DscResourcesToExport = @()

# Liste aller Module in diesem Modulpaket
# ModuleList = @()

# Liste aller Dateien in diesem Modulpaket
# FileList = @()

# Die privaten Daten, die an das in "RootModule/ModuleToProcess" angegebene Modul übergeben werden sollen. Diese können auch eine PSData-Hashtabelle mit zusätzlichen von PowerShell verwendeten Modulmetadaten enthalten.
PrivateData = @{

    PSData = @{

        # 'Tags' wurde auf das Modul angewendet und unterstützt die Modulermittlung in Onlinekatalogen.
        # Tags = @()

        # Eine URL zur Lizenz für dieses Modul.
        # LicenseUri = ''

        # Eine URL zur Hauptwebsite für dieses Projekt.
        # ProjectUri = ''

        # Eine URL zu einem Symbol, das das Modul darstellt.
        # IconUri = ''

        # 'ReleaseNotes' des Moduls
        # ReleaseNotes = ''

    } # Ende der PSData-Hashtabelle

} # Ende der PrivateData-Hashtabelle

# HelpInfo-URI dieses Moduls
# HelpInfoURI = ''

# Standardpräfix für Befehle, die aus diesem Modul exportiert werden. Das Standardpräfix kann mit "Import-Module -Prefix" überschrieben werden.
# DefaultCommandPrefix = ''

}

