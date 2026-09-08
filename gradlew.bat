@echo off
setlocal
set "GRADLE_VERSION=8.9"
if defined GRADLE_HOME if exist "%GRADLE_HOME%\bin\gradle.bat" (
  call "%GRADLE_HOME%\bin\gradle.bat" %*
  exit /b %ERRORLEVEL%
)
where gradle >nul 2>nul
if %ERRORLEVEL%==0 (
  call gradle %*
  exit /b %ERRORLEVEL%
)
set "CACHE=%USERPROFILE%\.gradle\pidgin-wrapper\gradle-%GRADLE_VERSION%"
if exist "%CACHE%\bin\gradle.bat" (
  call "%CACHE%\bin\gradle.bat" %*
  exit /b %ERRORLEVEL%
)
set "TMP=%TEMP%\pidgin-gradle-%GRADLE_VERSION%.zip"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -UseBasicParsing -Uri 'https://services.gradle.org/distributions/gradle-%GRADLE_VERSION%-bin.zip' -OutFile '%TMP%'"
if not exist "%TMP%" exit /b 1
powershell -NoProfile -ExecutionPolicy Bypass -Command "$d='%CACHE%'; New-Item -ItemType Directory -Force -Path (Split-Path $d) | Out-Null; Expand-Archive -Force '%TMP%' (Split-Path $d); Move-Item -Force (Join-Path (Split-Path $d) 'gradle-%GRADLE_VERSION%') $d"
call "%CACHE%\bin\gradle.bat" %*
exit /b %ERRORLEVEL%
