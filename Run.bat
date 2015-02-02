@echo off
neko bin\MusicToDB\MusicToDB.n N:\Music\Genres\ --output bin\full_new.db
REM neko bin\MusicToDB\MusicToDB.n bin\test --output bin\test.db
pause
bin\DBToDisplay\display.html
