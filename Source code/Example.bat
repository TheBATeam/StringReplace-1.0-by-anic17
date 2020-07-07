@echo off
cls
title StringReplace Usage - Demo - www.thebateam.org - Example by anic17
Set "Path=%Path%;%CD%;%CD%\Files;"
echo Contents of the file 'Example.txt'
echo.
type Example.txt
echo.
echo.
set /p "find=String to find > "
set /p "replace=String to be replaced > "
call StringReplace "%find%" "%replace%" Example.txt Replaced.txt
echo.
echo Content of the new file 'Replaced.txt'
echo.
type Replaced.txt
echo.
pause
exit /B 0