%~dp0\ffmpeg.exe -i "%1" -map 0:v -c:v copy -map 0:a -c:a:0 copy -map 0:a -c:a:1 flac "%~dp1\roku.%~nx1"
pause