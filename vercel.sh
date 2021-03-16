#!/bin/sh
# VERCEL_TOKEN="CREATE-AT-https://vercel.com/account/tokens"
# DOMAIN_NAME="example.com"
# SUBDOMAIN_LIST="www www2 www3"
source ./dns.config

JQ_BIN=jq
CURL_BIN=curl
CURL_OPTS='-s -H "Authorization: Bearer $VERCEL_TOKEN"'
#for padavan 
#CURL_OPTS='--cacert /etc/ssl/cert.pem -s -H "Authorization: Bearer $VERCEL_TOKEN"'

URL_GET_LIST="https://api.vercel.com/v4/domains/${DOMAIN_NAME}/records?limit=100"
URL_DNS_OP="https://api.vercel.com/v2/domains/${DOMAIN_NAME}/records"

IP=$1
IP_TYPE="A"

function update_ip(){
subdomain=$1

echo "update  ${subdomain}.${DOMAIN_NAME} to ip $IP  ..."
eval ${CURL_BIN} ${CURL_OPTS} ${URL_GET_LIST} > /tmp/records.tmp 
	
SUBDOMAIN_ID=`cat /tmp/records.tmp | ${JQ_BIN} -r  --arg SD "$subdomain"  '.records  | map (select( .name == $SD ))| .[].id'`

if [ "X" != ${SUBDOMAIN}"X" ] && [ -z ${SUBDOMAIN_ID##rec*} ]; then	
	eval ${CURL_BIN} ${CURL_OPTS} -X DELETE ${URL_DNS_OP}/${SUBDOMAIN_ID}
fi

DATA_NEW_DNS="-H 'Content-Type: application/json'  -d '{ \"name\": \"$subdomain\", \"type\": \"$IP_TYPE\", \"value\": \"$IP\",\"ttl\": 60 }'"
eval ${CURL_BIN} ${CURL_OPTS} -X POST ${URL_DNS_OP}  ${DATA_NEW_DNS}

#display info after updated
eval ${CURL_BIN} ${CURL_OPTS} ${URL_GET_LIST} \
	| ${JQ_BIN} -r  --arg SD "$subdomain"  '.records  | map (select( .name == $SD ))'
}

if  ! ${JQ_BIN} -h &> /dev/null ; then
	echo "${JQ_BIN} not exist, download it from https://stedolan.github.io/jq ."
	exit 1
fi

if [ ""X = ${IP}X ];then
	read -p "Enter ip address: " IP
fi

if [ -z ${IP##*:*} ]; then
  IP_TYPE="AAAA"
fi

for i in $SUBDOMAIN_LIST
do
	update_ip $i
done
