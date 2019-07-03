## Control Ops Manager
fly -t kirklab set-pipeline -p upgrade-control-opsman -c ../pipelines/upgrade-opsman.yml -v foundation=kirklab-control
fly -t kirklab unpause-pipeline -p upgrade-control-opsman

## Control Ops Manager
fly -t kirklab set-pipeline -p upgrade-opsman -c ../pipelines/upgrade-opsman.yml -v foundation=kirklab
fly -t kirklab unpause-pipeline -p upgrade-opsman

## Pivotal Cloud Cache
fly -t kirklab set-pipeline -p upgrade-pcc -c ../pipelines/upgrade-pcc.yml -v foundation=kirklab
fly -t kirklab unpause-pipeline -p upgrade-pcc