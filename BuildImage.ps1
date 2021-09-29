[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [String]$UnityVersion,

  [Parameter(Mandatory = $true)]
  [String]$Module,

  [Boolean]$Cleanup = $true
)

if (
  !($Module -eq "android" `
      -or "ios" `
      -or "linux" `
      -or "lumin" `
      -or "appletv" `
      -or "webgl" `
      -or "mac" `
      -or "linuxil2cpp" `
      -or "windowsil2cpp" `
      -or "uwp" `
      -or "editor")) {
  throw "Unknown module $Module"
}

$ImageVersion = "0.3.0"

$UnityInstallPath = "'/InstallationPath:C:\Program Files\Unity\Hub\Editor\" + $UnityVersion + "f1'"

$Tag = "huszky/unity_windows_container:" + $UnityVersion + "f1-" + $Module + "-" + $ImageVersion

if ($Module -like "android") {
  Write-Host "Unzipping Android tools"
  Expand-Archive -Path "OpenJDK.zip" -DestinationPath  "OpenJDK"
  Expand-Archive -Path "NDK.zip" -DestinationPath  "NDK"
  Expand-Archive -Path "SDK.zip" -DestinationPath  "SDK"
}


if ($Module -eq "editor") {
  docker build --tag $Tag -f editor.DockerFile . `
    --build-arg UnityVersion=$UnityVersion `
    --build-arg UnityInstallPath=$UnityInstallPath
}
elseif ($Module -eq "android") {

  $AndroidPlayerPath = "C:/Program Files/Unity/Hub/Editor/" + $UnityVersion + "f1/Editor/Data/PlaybackEngines/AndroidPlayer/"

  $NDKPath = $AndroidPlayerPath + "NDK"
  $SDKPath = $AndroidPlayerPath + "SDK"
  $OpenJDKPath = $AndroidPlayerPath + "OpenJDK"

  docker build --tag $Tag -f android.DockerFile . `
    --build-arg UnityVersion=$UnityVersion `
    --build-arg UnityInstallPath=$UnityInstallPath `
    --build-arg NDKPath=$NDKPath `
    --build-arg SDKPath=$SDKPath `
    --build-arg OpenJDKPath=$OpenJDKPath

  if ($Cleanup) {
    Write-Host "Removing Android tools"
    Remove-Item "OpenJDK" -Recurse
    Remove-Item "NDK" -Recurse
    Remove-Item "SDK" -Recurse
  }
}
else {
  $ChocoModule = "unity-" + $Module
  docker build --tag $Tag -f regular.DockerFile . `
    --build-arg UnityVersion=$UnityVersion `
    --build-arg UnityInstallPath=$UnityInstallPath `
    --build-arg ChocoModule=$ChocoModule
}
