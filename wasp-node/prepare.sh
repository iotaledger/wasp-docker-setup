#!/bin/bash -ex
WORKDIR="$(dirname "${BASH_SOURCE[0]}")"
DATA_DIR="$WORKDIR/data"

# check if the "data" folder exists
if [ -d "$CONFIG_DIR" ] && [ -f "$CONFIG_DIR/identity/identity.key" ]; then
	echo "Config folder found and snapshot files already exist. Aborting."
	exit 1
fi

# Pull latest images
docker compose pull

read -p "Download WASP database (y/*)? " ASK
[[ "$ASK" != "y" ]] && {
	echo "not downloaded"
	exit 0
}

curl -L https://wasp-backup.mainnet.iota.cafe/dbs/wasp/latest-wasp_chains.tgz | tar xzv -C "$DATA_DIR/"

# fix permissions
chown 65532:65532 "$DATA_DIR" -R
