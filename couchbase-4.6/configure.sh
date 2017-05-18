set -m

#echo "listing directories on the container"

#ls

echo "docker host ip = " $DOCKER_HOST_IP 

/entrypoint.sh couchbase-server &

echo "sleeping..."

sleep 30

echo "Start configuring env by calling REST endpoints"

echo "call 1"
curl -v -X POST http://127.0.0.1:8091/pools/default -d memoryQuota=256 -d indexMemoryQuota=256 -d ftsMemoryQuota=256

sleep 5
echo "call 2"
curl -v http://127.0.0.1:8091/node/controller/setupServices -d 'services=kv%2Cn1ql%2Cindex%2Cfts'
sleep 5

echo "call 3"
curl -i -u Administrator:password -X POST http://127.0.0.1:8091/settings/indexes -d 'storageMode=memory_optimized'

echo "call 4"
curl -v -X POST http://127.0.0.1:8091/settings/web -d port=8091 -d username=Administrator -d password=password

echo "bucket set up start"

echo "bucket name = " $BUCKET_NAME

echo "call 5"
curl -v -X POST http://127.0.0.1:8091/pools/default/buckets -u Administrator:password -d "name="$BUCKET_NAME"" -d 'ramQuotaMB=200' -d 'authType=none' -d 'proxyPort=11222'

echo "bucket set up done"

sleep 15

echo "call 6"
#curl -v http://127.0.0.1:8093/query/service -d "statement=CREATE PRIMARY INDEX ON "`$BUCKET_NAME`""
curl -v http://127.0.0.1:8093/query/service -d "statement=CREATE PRIMARY INDEX ON \`$BUCKET_NAME\`;"

# echo "Set up primary index on bucket done"

fg 1