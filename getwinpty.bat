@echo off
REM Download the native winpty component
echo Downloading winpty 0.4.2...
curl -#Lo winpty-native.zip "https://github.com/rprichard/winpty/releases/download/0.4.2/winpty-0.4.2-msvc2015.zip"
echo Extracting binaries...
call 7z e -y -o"content\winpty\x86" winpty-native.zip "ia32\bin\winpty.dll" > nul
call 7z e -y -o"content\winpty\x86" winpty-native.zip "ia32\bin\winpty-agent.exe" > nul
call 7z e -y -o"content\winpty\x86" winpty-native.zip "ia32\bin\winpty-debugserver.exe" > nul
call 7z e -y -o"content\winpty\x64" winpty-native.zip "x64\bin\winpty.dll" > nul
call 7z e -y -o"content\winpty\x64" winpty-native.zip "x64\bin\winpty-agent.exe" > nul
call 7z e -y -o"content\winpty\x64" winpty-native.zip "x64\bin\winpty-debugserver.exe" > nul
rm winpty-native.zip
echo Done!
