
# Prepare KubeOne and KKP installation

```bash
cd ~/01_prepare
```

## Install Binaries

### Install KubeOne

```bash
make install_k1

# Verify installation
kubeone version
```

### Install Kubermatic

```bash
make install_kkp

# Verify installation
kubermatic-installer --version
```

## Get Configuration Files

### Get KubeOne Configuration Files

```bash
make setup_k1_folder
```

### Get Kubermatic Configuration Files

```bash
make setup_kkp_folder
```

Jump > [Home](../README.md) | Previous > [Setup Environment](../00_setup/README.md) | Next > [Create KubeOne Cluster](../02_create_kubeone_cluster/README.md)
