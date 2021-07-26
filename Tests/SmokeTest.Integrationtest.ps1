Describe "Publish-LocalPackage smoke test" {
    BeforeAll {
        if (Test-Path ~/localnugetfeed/TestPackageProject.1.0.0.nupkg) {
            Remove-Item ~/localnugetfeed/TestPackageProject.1.0.0.nupkg -Recurse -Force -ErrorAction Stop
        }
        
        Import-Module ./LocalNuGetHelper/LocalNuGetHelper.psm1 -force
    }

    AfterAll {
        Set-Location ..
    }

    It "should create the file TestPackageProject.1.0.0.nupkg in the local NuGet feed" {
        Set-Location TestPackageProject
        Publish-LocalPackage -Verbose
        Test-Path ~/localnugetfeed/TestPackageProject.1.0.0.nupkg | Should -Be $true
    }
}
