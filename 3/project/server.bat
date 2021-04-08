@ECHO OFF
@SETLOCAL EnableDelayedExpansion
@SET CURRENT_DIR=%~dp0

IF NOT EXIST "%CURRENT_DIR%server.lua" ECHO 需要按要求实现 server.lua 并放到 %CURRENT_DIR% 目录下 && pause && exit
"%CURRENT_DIR%lua.exe" server.lua server.config
PAUSE