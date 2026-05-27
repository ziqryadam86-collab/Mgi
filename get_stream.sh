#!/bin/bash

# 1. Pasang yt-dlp secara senyap untuk dapatkan link m3u8 terkini
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o yt-dlp
chmod a+rx yt-dlp

# 2. Link live stream Berita RTM yang anda berikan
# (Gunakan id video HgWz05AsLxw secara statik atau URL penuh)
YOUTUBE_URL="https://www.youtube.com/watch?v=HgWz05AsLxw"

# 3. Ambil link m3u8 menggunakan yt-dlp
# Fungsi '-f b' memastikan kita ambil kualiti terbaik yang ada
M3U8_URL=$(./yt-dlp -g -f b "$YOUTUBE_URL")

# 4. Bina fail stream.m3u8 baru
echo "#EXTM3U" > stream.m3u8
echo "#EXT-X-VERSION:3" >> stream.m3u8
echo "#EXTINF:-1, Berita RTM Live" >> stream.m3u8
echo "$M3U8_URL" >> stream.m3u8

echo "Fail stream.m3u8 untuk Berita RTM berjaya dikemas kini!"

