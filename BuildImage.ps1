[CmdletBinding()]
param(
  [Parameter(Mandatory=$true)]
  [String]$UnityVersion,

  [Parameter(Mandatory=$true)]
  [String]$Module
)

$ChangeSet = unity-changeset $UnityVersion

Write-Host $ChangeSet

docker build --tag "unitywindows$UnityVersion" . --build-arg UNITYVERSION=$UnityVersion --build-arg CHANGESET=$ChangeSet --build-arg MODULE=$Module