REM 1. Usuń stare pliki - oszczedzaj miejsce na dysku
REM 2. Robocopy nowe wersje, logfile - oszczedza transfer
REM 3. Spakuj i przenieś do archiwum- zaraz po replikacji, żeby data się zgadzała

:setVariables
REM Set %mydate% for further use in file naming
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c%%a%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%time%") do (set mytime=%%a%%b)
REM echo %mydate%_%mytime%
REM Set destination folder variable - %dFolder%
set dFolder=\\krvfpp01\Proj\60R18506KRV\DESIGN\REFSECURE\RVT\RevitBackup
REM echo %dFolder%

:delete
For /d %%d in ("%dFolder%\*") do ROBOCOPY "%%d\archive" "%temp%\~robodel" *.zip /mov /minage:30
del "%temp%\~robodel" /q

:robocopy
REM Robocopy compares files last modified date in source and destination folder and updates out of date copies
For /d %%d in ("%dFolder%\*") do If not exist "%%d\log" mkdir "%%d\log"
For /d %%d in ("%dFolder%\*") do ROBOCOPY "\\Gbwni0vs01\JMBM\BIM\01-WIP\%%~nd\Revit Model" "%%d" *.rvt /log:"%%d\log\%mydate%_%mytime%_%%~nd.log"

:archive
For /d %%d in ("%dFolder%\*") do If not exist "%%d\archive" mkdir "%%d\archive"
For /d %%d in ("%dFolder%\*") do "C:\Program Files\7-Zip\7z.exe" a -tzip  "%%d\archive\%mydate%_%mytime%_%%~nd.zip" "%%d\*.rvt"
REM Pause
