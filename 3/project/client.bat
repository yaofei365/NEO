@ECHO OFF
@SETLOCAL EnableDelayedExpansion
@SET CURRENT_DIR=%~dp0

IF NOT EXIST "%CURRENT_DIR%client.lua" ECHO 需要按要求实现 client.lua 并放到 %CURRENT_DIR% 目录下 && pause && exit
"%CURRENT_DIR%lua5.1.exe" client.lua client.config
PAUSE
