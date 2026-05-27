#!/bin/bash

YOUTUBE_URL="https://www.youtube.com/watch?v=HgWz05AsLxw"

echo "Mengambil senarai proxy baru untuk dapatkan link dinamik..."

# 1. Rembat senarai proxy percuma yang disahkan hidup sekarang dari API pubproxy
PROXY_LIST=$(curl -s "https://pubproxy.com/api/proxy?limit=3&format=txt&http=true&country=MY,ID,SG,TH")

M3U8_URL=""

# 2. Cuba tembus YouTube guna proxy Asia Tenggara yang kita dapat tadi
for PROXY in $PROXY_LIST; do
  echo "Cuba guna proxy: $PROXY"
  M3U8_URL=$(curl -sL --connect-timeout 8 -x "http://$PROXY" "$YOUTUBE_URL" \
    -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
    | grep -o '"hlsManifestUrl":"[^"]*"' | cut -d'"' -f4 | sed 's/\\//g')
  
  # Kalau berjaya dapat link panjang googlevideo, kita stop loop!
  if [[ ! -z "$M3U8_URL" && "$M3U8_URL" == *"googlevideo.com"* ]]; then
    echo "Fuyoo! Berjaya dapatkan link tulen dari YouTube via Proxy!"
    break
  fi
done

# 3. Bina fail stream.m3u8 baru
echo "#EXTM3U" > stream.m3u8
echo "#EXT-X-VERSION:3" >> stream.m3u8
echo "#EXTINF:-1, Alan Becker TV Live" >> stream.m3u8

# 4. Jika proxy berjaya, guna link panjang. Jika gagal, guna link fallback (tapi dipendekkan)
if [ ! -z "$M3U8_URL" ]; then
  echo "$M3U8_URL" >> stream.m3u8
else
  # Gunakan format link terus yang lebih senang dibaca oleh pemain video
  echo "https://www.youtube.com/embed/HgWz05AsLxw" >> stream.m3u8
  echo "Gagal proxy, menggunakan kaedah direct embed URL."
fi

echo "Selesai! Fail stream.m3u8 telah dikemas kini."
