# Toubleshooting NUnit4 with MSBUILD

## Background

When migrating from NUnit 3 to NUnit 4 everything works as expected when building with `dotnet`:

 - `dotnet build`
 - `dotnet test`

It also works when using msbuild for dotnet:

- `dotnet msbuild -target:Build`

But fails when using plain `msbuild` together with _NUnit ConsoleRunner_:

- `msbuild /t:Build`
- `NUnit.ConsoleRunner.3.16.3\tools\nunit3-console.exe .\bin\Debug\net48\NUnit4Test.dll`

The error message is that the file is invalid as there were no suitable tests found:

```
1) Invalid : .\bin\Debug\net48\NUnit4Test.dll
No suitable tests found in '.\bin\Debug\net48\NUnit4Test.dll'.
Either assembly contains no tests or proper test driver has not been found.
```

## Demonstration

This repository has a minimal example that demonstrates my issue. It has configured a GitHub Action
workflow to build and test using `msbuild` and `NUnit.ConsoleRunner`:

```
- name: Build Debug for Test
  run: msbuild /t:Rebuild /p:Configuration=Debug

- name: Run tests
  run: .\packages\NUnit.ConsoleRunner.3.16.3\tools\nunit3-console.exe .\bin\Debug\net48\NUnit4Test.dll
```

The branch **main** is building with **`<PackageReference Include="NUnit" Version="3.14.0" />`**.

The branch **nunit4** is building with **`<PackageReference Include="NUnit" Version="4.0.0" />`**.

Further both branches are using:
 - **`<PackageReference Include="NUnit3TestAdapter" Version="4.5.0" />`**
 - **`<PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.8.0" />`**

### Test results

The branch with NUnit 3.14.0 is succeeding, and the branch with NUnit 4.0 is failing:

> ![image](https://github.com/Gakk/Nunit4Test/assets/5013909/5e8af40f-6d44-4834-b6a4-0e2a35eb7092)

_Ref: https://github.com/Gakk/Nunit4Test/actions/workflows/ci.yml_


#### NUnit 3

```
NUnit.ConsoleRunner.3.16.3\tools\nunit3-console.exe .\bin\Debug\net48\NUnit4Test.dll
NUnit Console 3.16.3 (Release)
Copyright (c) 2022 Charlie Poole, Rob Prouse
Tuesday, December 5, 2023 10:33:34 AM

Runtime Environment
   OS Version: Microsoft Windows NT 6.2.9200.0
   Runtime: .NET Framework CLR v4.0.30319.42000

Test Files
    .\bin\Debug\net48\NUnit4Test.dll


Run Settings
    DisposeRunners: True
    WorkDirectory: D:\a\Nunit4Test\Nunit4Test
    ImageRuntimeVersion: 4.0.30319
    ImageTargetFrameworkName: .NETFramework,Version=v4.8
    ImageRequiresX86: True
    RunAsX86: True
    ImageRequiresDefaultAppDomainAssemblyResolver: False
    TargetRuntimeFramework: net-4.8
    NumberOfTestWorkers: 4

Test Run Summary
  Overall result: Passed
  Test Count: 1, Passed: 1, Failed: 0, Warnings: 0, Inconclusive: 0, Skipped: 0
```
_Ref: https://github.com/Gakk/Nunit4Test/actions/runs/7099460949/job/19323504665_

#### NUnit 4

```
NUnit.ConsoleRunner.3.16.3\tools\nunit3-console.exe .\bin\Debug\net48\NUnit4Test.dll
NUnit Console 3.16.3 (Release)
Copyright (c) 2022 Charlie Poole, Rob Prouse
Tuesday, December 5, 2023 12:06:28 PM

Runtime Environment
   OS Version: Microsoft Windows NT 6.2.9200.0
   Runtime: .NET Framework CLR v4.0.30319.42000

Test Files
    .\bin\Debug\net48\NUnit4Test.dll


Errors, Failures and Warnings

1) Invalid : D:\a\Nunit4Test\Nunit4Test\bin\Debug\net48\NUnit4Test.dll
No suitable tests found in 'D:\a\Nunit4Test\Nunit4Test\bin\Debug\net48\NUnit4Test.dll'.
Either assembly contains no tests or proper test driver has not been found.

Test Run Summary
  Overall result: Failed
  Test Count: 0, Passed: 0, Failed: 0, Warnings: 0, Inconclusive: 0, Skipped: 0
```
_Ref: https://github.com/Gakk/Nunit4Test/actions/runs/7100454106/job/19326575405_

## Open questions

- Is NUnit4 not working with old `msbuild`?
- Is NUnit4 not compatible with `NUnit3TestAdapter`?
- Is NUnit4 not supported by `nunit3-console`?

And follow-up, will there be released a `NUnit4TestAdapter` or `nunit4-console`?
