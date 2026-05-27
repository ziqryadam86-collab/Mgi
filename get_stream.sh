#!/bin/bash

# Guna Python untuk scan kod HTML YouTube dan bersihkan link m3u8 secara automatik
M3U8_URL=$(python3 -c '
import urllib.request, re
try:
    url = "https://www.youtube.com/watch?v=HgWz05AsLxw"
    req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"})
    html = urllib.request.urlopen(req, timeout=10).read().decode("utf-8")
    
    # Cari kod hlsManifestUrl yang disembunyikan oleh YouTube
    match = re.search(r"\"hlsManifestUrl\":\"([^\"]*)\"", html)
    if match:
        # Bersihkan simbol backslash (\/) supaya jadi url m3u8 yang sah
        print(match.group(1).replace("\\/", "/"))
except Exception as e:
    pass
')

# Sediakan fail stream.m3u8 baru jika link berjaya dijumpai
if [ ! -z "$M3U8_URL" ]; then
  echo "#EXTM3U" > stream.m3u8
  echo "#EXT-X-VERSION:3" >> stream.m3u8
  echo "#EXTINF:-1, Alan Becker TV Live" >> stream.m3u8
  echo "$M3U8_URL" >> stream.m3u8
  echo "Fail stream.m3u8 berjaya dikemas kini menggunakan kepintaran Python!"
else
  echo "Alamak, Python pun gagal menembus pertahanan YouTube!"
  exit 1
fi
