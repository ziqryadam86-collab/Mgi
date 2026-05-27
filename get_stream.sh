#!/bin/bash

# 1. Ambil URL m3u8 terus dari HTML YouTube menggunakan taktik curl + grep yang kita test tadi
YOUTUBE_URL="https://www.youtube.com/watch?v=HgWz05AsLxw"
M3U8_URL=$(curl -sL "$YOUTUBE_URL" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)" \
  | grep -o '"hlsManifestUrl":"[^"]*"' | cut -d'"' -f4 | sed 's/\\//g')

# 2. Semak jika link m3u8 tidak kosong, baru bina fail stream.m3u8
if [ ! -z "$M3U8_URL" ]; then
  echo "#EXTM3U" > stream.m3u8
  echo "#EXT-X-VERSION:3" >> stream.m3u8
  echo "#EXTINF:-1, Alan Becker TV Live" >> stream.m3u8
  echo "$M3U8_URL" >> stream.m3u8
  echo "Fail stream.m3u8 berjaya dikemas kini menggunakan power curl!"
else
  echo "Alamak, gagal dapatkan link m3u8 dari YouTube!"
  exit 1
fi
