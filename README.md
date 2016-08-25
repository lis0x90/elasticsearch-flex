# elasticsearch-flex
Container with elasticsearch onboard and clean configuration. Intended to expermienting using docker command line kung-fu

# Running
To run elasticsearch cluster on local docker machine with 3 data nodes, 3 master nodes and one client(routing) node just run:
```bash
./cluster-up.sh
```

Wait a minite and check cluster state by:
```bash
curl http://localhost:9200/_cluster/state
```
