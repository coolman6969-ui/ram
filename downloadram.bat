@echo off
title RAM Downloader vUltimate (Universal)

echo =====================================================
echo                RAM EXPANSION UTILITY
echo =====================================================
echo.

set /p ramSize=Enter amount of RAM to create (in MB): 

echo.
echo =====================================================
echo Conversions:
echo.
echo 1 KB = 1024 bytes
echo 1 MB = 1024 KB = 1,048,576 bytes
echo 1 GB = 1024 MB
echo.
echo %ramSize% MB = %ramSize% MB
set /a gb=%ramSize%/1024
echo %ramSize% MB is approximately %gb% GB
echo =====================================================
echo.

:: Create base directory for substituted drive
set baseDir=C:\RAMDrive
if not exist "%baseDir%" mkdir "%baseDir%"

:: Create virtual drive R:
subst R: "%baseDir%" >nul
echo [+] Mounted virtual RAM drive as R:

:: Create RAM folder
set ramFolder=R:\Virtual_RAM
if not exist "%ramFolder%" mkdir "%ramFolder%"

echo.
echo [+] Generating 1MB RAM chunk files...
echo.

:: Each chunk = 1 MB = 1,048,576 bytes
set chunkSize=1048576

:: Total bytes required
set /a totalBytes=%ramSize%*1048576

:: Number of chunks
set /a chunks=%totalBytes%/%chunkSize%
if %chunks% LSS 1 set chunks=1

echo Creating %chunks% chunk files...
echo.

for /l %%A in (1,1,%chunks%) do (
    echo Creating chunk %%A of %chunks%...

    :: Create empty 1 MB file
    fsutil file createnew "%ramFolder%\ram_chunk_%%A.bin" %chunkSize% >nul

    :: Live KB progress variables
    set writtenKB=0
    set totalKB=1024

    :: Fill file with approx 1 MB of text
    for /l %%B in (1,1,6000) do (
        echo %%random%%%%random%%%%random%%%%random%%%%random%%>>"%ramFolder%\ram_chunk_%%A.bin"

        :: Update KB approx every 6 writes (to avoid spam)
        set /a mod=%%B%%6
        if !mod! EQU 0 (
            set /a writtenKB+=1
            <nul set /p ="Chunk %%A/%chunks%: !writtenKB!/!totalKB! KB written`r"
        )
    )

    echo.
)

echo.
echo =====================================================
echo [+] Finished generating %chunks% RAM chunks (1MB each)
echo [+] Virtual Drive: R:\
echo [+] Path: R:\Virtual_RAM\
echo =====================================================
echo.
echo This window will remain open until you press X.
echo.

:loop
timeout /t 1 >nul
goto loop
