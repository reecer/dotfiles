HOSTNAME="https://ultrawidewallpapers.net"
  grep -A 5 'id="tab-top-week"' | \
  grep -oP 'href="wallpapers/\K[^"]*' | \
  sed "s|^|$HOSTNAME/wallpapers/|" | \
  xargs -P 8 -I {} sh -c 'echo "Downloading {}" && curl -sO {}'
