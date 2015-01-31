@echo off
neko bin\MusicToDB\MusicToDB.n bin\test --output bin\test.db
bin\DBToDisplay\display.html
