#!/bin/bash

source ./dns.config

# 1. Get current IP
#IP=$(curl -s http://whatismyip.akamai.com/)
IP=$(ip -6 addr show ppp0 |grep "scope global dynamic"|sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d')
echo "$IP"

# 2. Create/update DNS record
curl -X POST "https://api.vercel.com/v2/domains/$DOMAIN_NAME/records" \
  -H "Authorization: Bearer $VERCEL_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
  "name": "'$SUBDOMAIN'",
  "type": "A",
  "value": "'$IP'",
  "ttl": 60
}'

echo ''
echo "🎉 Done!"
