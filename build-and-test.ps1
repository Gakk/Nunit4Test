# Restore NuGet packages (PackageReference)
msbuild /t:Restore /maxcpucount

# Build Debug for Test
msbuild /t:Rebuild /p:Configuration=Debug

# Install NUnit Console
nuget.exe install NUnit.Console -Version 3.16.3 -o packages

# Run tests
.\packages\NUnit.ConsoleRunner.3.16.3\tools\nunit3-console.exe .\bin\Debug\net48\NUnit4Test.dll
