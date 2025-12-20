@echo off
cd /d "%~dp0artifacts"
if exist "FXServer.exe" (
	start "" "%cd%\FXServer.exe" +exec "%~dp0server.cfg" +set onesync_enableInfinity 1 +set sv_enforceGameBuild 2802
) else (
	echo FXServer.exe não encontrado em "%cd%"
)
pause