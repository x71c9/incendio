# incendio

**incendio** is a command-line utility that provisions an ephemeral VM on AWS, GCP, or Hetzner to create a private, temporary VPN tunnel. It automatically connects your local machine and ensures complete teardown and cleanup on exit or failure for maximum privacy.

## Stato corrente

Ci sono due script:

`generate-server.sh`
`generate-client.sh`

`generate-server` crea le chiavi per il server e il client, e lo script cloud-init
che deve girare sulla macchina virtuale effimera per installare le librerie e
far partire il servizio.

la macchina deve aprire la porta 51820 con protocollo UDP

`generate-client` create il file di configurazione per la macchina locale

per avviare la connessione:
```
sudo wg-quick up /Users/x71c9/wireguard-poc/wg0-client.conf
```

per chiudere la connessione:
```
sudo wg-quick down /Users/x71c9/wireguard-poc/wg0-client.conf
```

Il server può essere avviato dal repository "fuoco":
```
cargo run -- deploy \
    --provider aws \
    --region eu-central-1 \
    --script-path /home/x71c9/wireguard-poc/cloud-init.sh \
    --inbound-rule tcp:22 \
    --inbound-rule udp:51820 \
    --debug
```

Bisogna correggere il nome dell'interfaccia "ens5" nel file cloud-init generato
con una variable in quanto ogni ditribuzione ha la sua interfaccia.


## Key Features

*   **Ephemeral & Private:** Creates a temporary VPN on a dedicated virtual machine.
*   **Multi-Cloud:** Supports AWS, GCP, and Hetzner.
*   **Automatic Connection:** Sets up the VPN tunnel on your local machine automatically.
*   **Secure Cleanup:** Tears down all cloud resources upon exit or failure, leaving no trace.
*   **Privacy-Focused:** Designed to enhance your online privacy and security.

## Getting Started

### Prerequisites

Before you begin, ensure you have the following installed and configured:

*   [Rust and Cargo](https://www.rust-lang.org/tools/install)
*   A cloud provider account with one of the following:
    *   [AWS CLI](https://aws.amazon.com/cli/)
    *   [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
    *   [Hetzner Cloud CLI](https://github.com/hetznercloud/cli)

You will also need to have your cloud provider credentials configured on your local machine.

### Installation

You can install `incendio` directly from the source:

```bash
git clone https://github.com/x71c9/incendio.git
cd incendio
cargo install --path .
```

### Usage

Here are some examples of how to use `incendio`:

**Create a VPN tunnel on AWS:**

```bash
incendio up --provider aws
```

**Create a VPN tunnel on GCP:**

```bash
incendio up --provider gcp
```

**Create a VPN tunnel on Hetzner:**

```bash
incendio up --provider hetzner
```

**Tear down the VPN tunnel and all associated resources:**

```bash
incendio down
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
