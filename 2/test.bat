@ECHO OFF
@SETLOCAL EnableDelayedExpansion
@SET CURRENT_DIR=%~dp0
"%CURRENT_DIR%lua53.exe" test_bag.lua
PAUSE