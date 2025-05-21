# Wasp Docker Setup

This setup consists of two components: the IOTA node and the Wasp node.



## Prerequisites

First, clone the repository and navigate into its root directory:

```bash
git clone https://github.com/iotaledger/wasp-docker-setup
cd wasp-docker-setup
```

Next, create a Docker network that will be used by both the IOTA and Wasp nodes:

```
docker network create iota-evm-network
```

## Run the IOTA node

### Prepare

To prepare the IOTA node:

```
cd iota-node
./prepare.sh
```

This script sets up the necessary directories and downloads the `genesis.blob`.

### Run the node

To start the IOTA node:

```
docker compose up -d
```

## Run the Wasp Node

### Prepare

A similar preparation script exists for the Wasp setup:

```
cd wasp-node
./prepare.sh
```

The script will prompt you to download the archive database.

**Note: Only Archive mode is currently supported. Confirm with `y` and wait for the download and extraction to complete.**

### Run the Wasp node

Start the Wasp node with:
```
docker compose up -d
```

## Wasp Peering Setup
### Retrieve Peering Info Using wasp-cli

Download the `wasp-cli` binary from the official GitHub release page and extract the archive appropriate for your OS.

https://github.com/iotaledger/wasp/releases/tag/v2.0.1

Then run the following commands:

```
# set L1 address
$ ./wasp-cli set l1.apiaddress http://localhost:9000

# set wasp address
$ ./wasp-cli wasp add my-node http://localhost:9090

# login
$ ./wasp-cli login
Username: wasp
Password: (default is wasp)
Successfully authenticated
```

Upon successful login, retrieve your node's peering info:

```
$ ./wasp-cli peering info
```

Example output:
```
PubKey: 0x20a56daa0b5e86b196c37f802089a2b6007a655a12337d287f7313a214af2ec0
PeeringURL: 0.0.0.0:4000
```

**Important: Send your PubKey and public IPv4 address to the IOTA Foundation (IF) or your peering partner.**

### Wait for the other party to peer
Now, wait for the other node(s) to complete the peering process on their side.

### Trust and Configure Peers

Once both parties are ready, use wasp-cli to trust the peers and configure your chain:

```bash
# trust peers
$ ./wasp-cli peering trust peer1 <pubkey> <URL>
$ ./wasp-cli peering trust peer2 <pubkey> <URL>

# add chain
$ ./wasp-cli chain add iota-evm 0x0dc448563a2c54778215b3d655b0d9f8f69f06cf80a4fc9eada72e96a49e409d

# activate
$ ./wasp-cli chain activate --chain iota-evm

# add peers as access nodes of the chain
$ ./wasp-cli chain access-nodes add --peers=peer1,peer2
```

## Endpoints

The following endpoints are exposed once the nodes are running:

### IOTA Node (L1)

JSON-RPC endpoint:
```
http://localhost:9000
```

### Wasp Node (L2)
JSON-RPC and Websocket endpoints:
```
http://localhost:9090/v1/chain/evm
http://localhost:9090/v1/chain/evm/ws
```
Health check endpoint (should return HTTP 200 when synced):
```
curl -v http://localhost:9090/health
```
Example output:

```
> GET /health HTTP/1.1
< HTTP/1.1 200 OK
```

