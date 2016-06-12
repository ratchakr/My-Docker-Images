set -m

/entrypoint.sh couchbase-server &

sleep 10

echo "Starting Curls"

curl -v -X POST http://192.168.99.100:8091/pools/default -d memoryQuota=256 -d indexMemoryQuota=256

curl -v http://192.168.99.100:8091/node/controller/setupServices -d 'services=kv%2Cn1ql%2Cindex'

curl -v -X POST http://192.168.99.100:8091/settings/web -d port=8091 -d username=Administrator -d password=password

fg 1