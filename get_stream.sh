#!/bin/bash

YOUTUBE_URL="https://www.youtube.com/watch?v=HgWz05AsLxw"

echo "Mencuba dapatkan m3u8 menggunakan Free Malaysia Proxy..."

# 1. Kita minta curl lalu ikut proxy server Malaysia (MY) yang aktif untuk bypass bot US
# Kita gunakan open proxy list secara direct
M3U8_URL=$(curl -sL --connect-timeout 10 -x "http://103.159.214.114:80" "$YOUTUBE_URL" \
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
  | grep -o '"hlsManifestUrl":"[^"]*"' | cut -d'"' -f4 | sed 's/\\//g')

# 2. Jika proxy pertama lambat, gunakan proxy Malaysia kedua sebagai backup
if [ -z "$M3U8_URL" ]; then
  echo "Proxy utama sibuk, mencuba proxy backup Malaysia 2..."
  M3U8_URL=$(curl -sL --connect-timeout 10 -x "http://210.187.31.22:80" "$YOUTUBE_URL" \
    | grep -o '"hlsManifestUrl":"[^"]*"' | cut -d'"' -f4 | sed 's/\\//g')
fi

# 3. Jika proxy Malaysia pun gagal, kita guna taktik feed data ringan (RSS embed bypass)
if [ -z "$M3U8_URL" ]; then
  echo "Mencuba taktik direct feed rasmi..."
  M3U8_URL=$(curl -sL --connect-timeout 10 "https://www.youtube.com/embed/HgWz05AsLxw" \
    -H "User-Agent: Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36" \
    | grep -o '"hlsManifestUrl":"[^"]*"' | cut -d'"' -f4 | sed 's/\\//g')
fi

# 4. Bina fail stream.m3u8 baru
echo "#EXTM3U" > stream.m3u8
echo "#EXT-X-VERSION:3" >> stream.m3u8
echo "#EXTINF:-1, Alan Becker TV Live" >> stream.m3u8

if [ ! -z "$M3U8_URL" ]; then
  echo "$M3U8_URL" >> stream.m3u8
  echo "Fuyoo! Taktik Proxy Malaysia berjaya tembus live stream Alan Becker!"
else
  # Letakkan link fallback statik yang paling selamat supaya stream tak kosong terus
  echo "https://manifest.googlevideo.com/api/manifest/hls_playlist/playlist.m3u8" >> stream.m3u8
  echo "Gunakan mod penyelamat statik."
fi
