@echo off
set /p ticket=enter username to authenticate as: 
echo starting mercury...
MercuryPlayerBeta.exe --play -a http://banland.xyz/game/negotiate.ashx -t DEBUG:%ticket% -j http://banland.xyz/game/join.ashx