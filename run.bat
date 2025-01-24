@echo off
Setlocal EnableDelayedExpansion

if "%PROCESSOR_ARCHITECTURE%" == "ARM64" (
    echo Sorry, ARM64 systems are not supported at the moment.
    exit /b
)

REM use findstr to strip blank lines
for /f "usebackq skip=1 tokens=*" %%i in (`wmic OS get OSArchitecture ^| findstr /r /v "^$"`) do (
    set "_bits=%%i"
    
    REM extract first 2 characters
    set "_bits=!_bits:~0,2!"

    if !_bits! == 64 (
        :begin
        if exist "C:\Program Files\NASM\nasm.exe" (
            nasm -f win64 -o out.obj src/windows-x86_64.asm
            gcc -o some-password-required.exe out.obj -lkernel32 -luser32 -lgcc -nostartfiles -e _start
            .\some-password-required.exe
        ) else (
            choice /C:YN /M:"NASM is not installed. Do you want to install it?"
            if errorlevel == 2 goto :exit
            if errorlevel == 1 goto :install

            :install
            echo Downloading NASM...
            for /f "tokens=*" %%i in ('winget download -e --id NASM.NASM ^| findstr /R /C:"C:\\.*"') do (
                set "dir=%%i"
            )
            set "dir=!dir:Installer downloaded: =!"
            powershell -command Start-Process !dir! -Verb runas
            echo Installing NASM...
            echo Don't worry, we'll also set your PATH to include NASM.
            set "PATH=%PATH%;C:\Program Files\NASM"
            choice /C:YN /M:"Sadly, you need to restart your terminal first to use NASM. Do you want us to restart your terminal?"
            if errorlevel == 2 goto :exit
            if errorlevel == 1 powershell
            goto :begin

            :exit
            echo Exiting...
            exit /b
        )
    ) else (
        echo Sorry, 32-bit systems are not supported at the moment.
    )
)
endlocal