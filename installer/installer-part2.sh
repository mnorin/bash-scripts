EOF

echo -n "Decoding..."
base64 -d /tmp/archive.base > /tmp/archive.tar.bz2
echo "Done"

echo -n "Extracting..."
tar xf /tmp/archive.tar.bz2 --strip=3 -C $INSTALLATION_PATH
echo "Done"
