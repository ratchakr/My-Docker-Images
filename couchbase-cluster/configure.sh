set -m



/entrypoint.sh couchbase-server &

sleep 60

echo "Calling CB REST services to set up the Couchbase Server with My Settings"

curl -v -X POST http://127.0.0.1:8091/pools/default -d memoryQuota=256 -d indexMemoryQuota=256 -d ftsMemoryQuota=256

curl -v http://127.0.0.1:8091/node/controller/setupServices -d services=kv%2Cn1ql%2Cindex%2Cfts

curl -v http://127.0.0.1:8091/settings/web -d port=8091 -d username=Administrator -d password=password

# Setup Memory Optimized Indexes
curl -i -u Administrator:password -X POST http://127.0.0.1:8091/settings/indexes -d 'storageMode=memory_optimized'

curl -v -X POST http://127.0.0.1:8091/pools/default/buckets -u Administrator:password -d 'name=default' -d 'ramQuotaMB=200' -d 'authType=none' -d 'proxyPort=11222' 

fg 1