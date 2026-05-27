#!/bin/bash

# 1. Guna proxy percuma (kita cuba request melaui proxy web Scraper atau anoymous proxy)
# Taktik ni akan sorokkan IP GitHub Actions daripada dikesan oleh YouTube bot detector
YOUTUBE_URL="https://www.youtube.com/watch?v=HgWz05AsLxw"

echo "Mencuba dapatkan link m3u8 menggunakan taktik Proxy Masking..."

M3U8_URL=$(curl -sL "https://api.allorigins.win/raw?url=$(urlencode $YOUTUBE_URL)" \
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)" \
  | grep -o '"hlsManifestUrl":"[^"]*"' | cut -d'"' -f4 | sed 's/\\//g')

# 2. Jika proxy pertama gagal, kita guna proxy backup kedua (Cors-anywhere bypass)
if [ -z "$M3U8_URL" ]; then
  echo "Proxy utama sibuk, mencuba proxy backup..."
  M3U8_URL=$(curl -sL "https://corsproxy.io/?$(urlencode $YOUTUBE_URL)" \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)" \
    | grep -o '"hlsManifestUrl":"[^"]*"' | cut -d'"' -f4 | sed 's/\\//g')
fi

# Fungsi helper untuk encode URL supaya proxy faham
function urlencode() {
  python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$1"
}

# 3. Bina fail stream.m3u8 baru
if [ ! -z "$M3U8_URL" ]; then
  echo "#EXTM3U" > stream.m3u8
  echo "#EXT-X-VERSION:3" >> stream.m3u8
  echo "#EXTINF:-1, Alan Becker TV Live" >> stream.m3u8
  echo "$M3U8_URL" >> stream.m3u8
  echo "Fail stream.m3u8 berjaya dikemas kini dengan taktik Proxy Masking!"
else
  echo "Alamak, YouTube masih kuat menepis! Kita kena cari jalan lain."
  exit 1
fi
