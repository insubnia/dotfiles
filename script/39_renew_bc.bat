@ECHO OFF
REG DELETE "HKCU\SOFTWARE\Scooter Software\Beyond Compare 4" /v "CacheID" /f  :: Win10
:: REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Scooter Software\Beyond Compare 5" /v "CacheID" /f  :: Win11
