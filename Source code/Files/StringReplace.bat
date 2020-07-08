@echo off
setlocal EnableDelayedExpansion

::
:: StringReplace function 1.0 by anic17
:: Wednesday 06/24/2020
::
:: This function searches a string in a file and it will replace it by another
:: in a different output file
::
:: It can replace characters with ASCII code between 1 and 32, and 34 to extended ASCII
::


:: Get current code page because we will change it to Unicode to handle special characters


for /f "tokens=2 delims=:" %%A in ('chcp') do set codepage=%%A


:: Check if first argument is for help
if /i "%~1"=="--help" goto help
if /i "%~1"=="/?" goto help
if /i "%~1"=="" goto help
if /i "%~1"=="-?" goto help
if /i "%~1"=="-h" goto help
if /i "%~1"=="/h" goto help
if /i "%~1"=="-help" goto help
if /i "%~1"=="/help" goto help

:: If specified the parameter '/v' or '-v', show version and quit the program
if /i "%~1"=="-v" (echo 1.0 & goto exit)
if /i "%~1"=="/v" (echo 1.0 & goto exit)



:: If there are not 4 arguments specified, show the 'Missing required parameters' 
:: message and quit the program
if "%~4"=="" (
	echo Missing required parameters.
	echo Try with 'StringReplace --help'

goto exit
)

:: Check if the specified file exists
:: If not, throw an error and quit the program

if not exist "%~3" (
	echo Could not file '%~3'
	goto exit
)


:: Change code page to Unicode
chcp 65001 > nul

:: Set variables to find and to replace
set "find=%~1"
set "StringReplace=%~2"

:: Set output file

set "output=%~4"

:: Check if the output file exists
:: If true, prompt user for keeping the file or overwriting it
if exist "%~4" (
	set /p "confirm_overwrite='%~4' already exists. Create a renamed file (y/n): "
	
	rem If not Y, assume no and quit the program
	if /i not "!confirm_overwrite!"=="y" goto exit
	
	rem Change the output file, to evit losing any data
	set "output=%~dpn4.stringreplace%~x4"
	
)




:: Read the file and call the function 'StringReplace_str'
for /f "usebackq delims=" %%R in ("%~3") do (call :StringReplace_str "%%R")
goto exit


:StringReplace_str
:: Set line variable to the content of the file
set "line=%~1"

:: Replace the content of the variable using SET
set "line=!line:%find%=%StringReplace%!"

:: Write the content of the replaced variable to the output file
(echo !Line!)>> "%output%"

:: Quit function and process new line
exit /B


:help
:: Display help
echo.
echo Syntax:
echo.
echo StringReplace "string to find" "string to StringReplace" [file] [output]
echo.
echo Example:
echo.
echo StringReplace "1234" "anic17" user.txt Replaced.txt
echo Will replace the string '1234' to the string 'anic17' in the file 'user.txt'
echo and then saving the result into 'Replaced.txt'
echo.
echo Find more creations at www.thebateam.org
echo #anic17 with #TheBATeam

:exit
:: Quit the program restoring the original codepage
chcp %codepage% > nul

:: Restore used variables with ENDLOCAL
endlocal

:: Quit the program with the specified ERRORLEVEL
exit /B %errorlevel%
