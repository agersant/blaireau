@echo off
copy rtp/display.html bin/display.html
browserify obj/DBToDisplay.js > bin/DBToDisplay.js
