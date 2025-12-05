HOSTNAME="https://ultrawidewallpapers.net"

echo "Fetching $HOSTNAME..."

curl -s "$HOSTNAME" | \
  grep -A 5 'id="tab-top-week"' | \
  tee >(echo "Found $(wc -l) lines matching tab-top-week" >&2) | \
  grep -o 'href="wallpapers/[^"]*' | sed 's/href="wallpapers\///' | \
  tee >(echo "Extracted $(wc -l) wallpaper URLs" >&2) | \
  sed "s|^|$HOSTNAME/wallpapers/|" | \
  tee >(cat >&2) | \
  xargs -P 8 -I {} sh -c 'echo "Downloading {}" && curl -sO {}'

echo "Done."
