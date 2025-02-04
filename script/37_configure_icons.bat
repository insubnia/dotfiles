@echo off
:: 관리자 권한으로 실행 필요

set ICONS_DIR=%USERPROFILE%/icons
if not exist "%ICONS_DIR%" mkdir "%ICONS_DIR%"

set DLL_LIST=shell32.dll imageres.dll ddores.dll compstui.dll wmploc.dll moricons.dll pifmgr.dll
for %%F in (%DLL_LIST%) do (
    mklink "%ICONS_DIR%/%%F" "%SystemRoot%/System32/%%F"
)
