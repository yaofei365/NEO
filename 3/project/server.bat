@ECHO OFF
@SETLOCAL EnableDelayedExpansion
@SET CURRENT_DIR=%~dp0
"%CURRENT_DIR%lua5.1.exe" server.lua server.config
PAUSE