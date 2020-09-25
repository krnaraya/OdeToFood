write-host "`n----------------------------"
write-host " Stop existing process, if any "
write-host "----------------------------`n"

$p = Get-Process -Name "dotnet"

if ($p) {
  # try gracefully first
  $p.CloseMainWindow()
  # kill after five seconds
  Sleep 5
  if (!$p.HasExited) {
    $p | Stop-Process -Force
  }
}

write-host "`n----------------------------"
write-host " Updating app"
write-host "----------------------------`n"

git pull


write-host "`n----------------------------"
write-host " npm packages installation  "
write-host "----------------------------`n"


Set-Location -Path '.\OdeToFood\OdeToFood\'

npm install

write-host "`n----------------------------"
write-host " Building application "
write-host "----------------------------`n"

dotnet build


write-host "`n----------------------------"
write-host " Starting web application"
write-host "----------------------------`n"

$env:ASPNETCORE_URLS="http://*:80"

Start-Process -FilePath 'dotnet' -ArgumentList 'run --debug'

exit