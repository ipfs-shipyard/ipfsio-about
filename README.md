# About IPFS.io

[![GitHub deployments](https://img.shields.io/github/deployments/ipfs-shipyard/ipfsio-about/Production?style=flat&logo=vercel&label=vercel)](https://vercel.com/ipfsdevs/ipfsio-about-wkov)

This is the home of the "About IPFS.io" site that explains everything about the IPFS.io gateway service.

## Local Development

```bash
make serve  # Start development server
make build  # Build static site
make clean  # Clean generated files
```

Requires: `make`, `curl`, `tar`. Hugo extended version is hardcoded in `Makefile` and `hugo.toml`.

## Publishing

Currently published to `about.ipfs.io` via Vercel. GitHub Pages is also configured as a backup deployment option.

