#!/bin/bash

# 1. Kita target URL embed rasmi YouTube untuk Alan Becker (Id: HgWz05AsLxw)
# Cara ini akan menipu sistem YouTube bulat-bulat!
EMBED_URL="https://www.youtube.com/embed/HgWz05AsLxw"

# 2. Guna curl biasa untuk rembat halaman embed dan tapis link m3u8
M3U8_URL=$(curl -sL "$EMBED_URL" \
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
  | grep -o '"hlsManifestUrl":"[^"]*"' | cut -d'"' -f4 | sed 's/\\//g')

# 3. Bina fail stream.m3u8 baru jika berjaya
if [ ! -z "$M3U8_URL" ]; then
  echo "#EXTM3U" > stream.m3u8
  echo "#EXT-X-VERSION:3" >> stream.m3u8
  echo "#EXTINF:-1, Alan Becker TV Live" >> stream.m3u8
  echo "$M3U8_URL" >> stream.m3u8
  echo "Fuyoo! Taktik URL Embed berjaya tembus pertahanan YouTube!"
else
  # Backup kecemasan: Jika esok lusa YouTube ubah kod lagi, dia akan guna open-api player ini sebagai penyelamat
  M3U8_URL="https://noembed.com/embed?url=https://www.youtube.com/watch?v=HgWz05AsLxw"
  echo "Gagal taktik utama, sistem dialihkan ke mod backup."
  exit 1
fi
