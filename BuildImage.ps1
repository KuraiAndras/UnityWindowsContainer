[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [String]$UnityVersion,

  [Parameter(Mandatory = $true)]
  [String]$Module,

  [Parameter(Mandatory = $true)]
  [String]$ImageVersion
)

$UnityInstallPath = "'/InstallationPath:C:\Program Files\Unity\Hub\Editor\" + $UnityVersion + "f1'"

$ChocoModule = "unity-" + $Module
$Tag = "huszky/unity_windows_container:" + $UnityVersion + "f1-" + $Module + "-" + $ImageVersion

docker build --tag $Tag . --build-arg UnityVersion=$UnityVersion --build-arg ChocoModule=$ChocoModule --build-arg UnityInstallPath=$UnityInstallPath
