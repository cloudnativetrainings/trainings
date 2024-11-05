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

<!-- TODO should be moved to kkp secrtion -->
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

<!-- TODO should be moved to kkp secrtion -->
### Get Kubermatic Configuration Files

```bash
make setup_kkp_folder
```
