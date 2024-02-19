@echo off
setlocal enabledelayedexpansion

REM Set the output directory to the current directory
set "outputDirectory=%CD%"
echo Output Directory set.
REM Set the path to avifenc.exe in the current directory
set "avifencPath=%CD%\avifenc.exe"
echo avifenc.exe found.
REM Create a new folder named avif
set "avifFolder=%CD%\Output"
if not exist "!avifFolder!" mkdir "!avifFolder!"
REM Set the path to the log file
set "logFile=%CD%\avifenc.log"

REM Process files in the current directory
call :ProcessFiles "%CD%"

REM Recursively process files in subdirectories
for /r /d %%D in (*) do (
    call :ProcessFiles "%%D"
)

REM Move all output files into the avif folder
move "%outputDirectory%\*.avif" "!avifFolder!"

echo Batch script completed.
pause
exit /b

:ProcessFiles
REM Loop through all JPG files
for %%F in ("%1\*.jpg") do (
    set "input=%%~F"
    set "output=!outputDirectory!\%%~nF.avif"
    "!avifencPath!" -d 10 -q 90 --qalpha 90 -a aq-mode=1 -a enable-qm=1 -a enable-chroma-deltaq=1 -a enable-dnl-denoising=1 -a denoise-noise-level=12 "!input!" "!output!" >> "!logFile!"
    echo "!input!" Processed!
)

REM Loop through all PNG files
for %%F in ("%1\*.png") do (
    set "input=%%~F"
    set "output=!outputDirectory!\%%~nF.avif"
    "!avifencPath!" -d 10 -q 90 --qalpha 90 -a aq-mode=1 -a enable-qm=1 -a enable-chroma-deltaq=1 -a enable-dnl-denoising=1 -a denoise-noise-level=12 "!input!" "!output!" >> "!logFile!"
    echo "!input!" Processed!
)
exit /b
