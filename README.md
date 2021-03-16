# Vercel Dynamic DNS Shell Script

Script for exposing local server with [Vercel DNS](https://vercel.com/docs/custom-domains). 
 - support run on busybox(router), bash.
 - support multi sub-domains.
 - support ipv6/ipv4.
 - support manual run.

## Dependency  

 - jq https://stedolan.github.io/jq
 - curl
 
## Installation

1. Download
2. Move `dns.config.example` into `dns.config`
3. Edit config
4. Run `./vercel.sh IP-ADDRESS`

