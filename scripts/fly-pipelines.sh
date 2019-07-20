## Control Ops Manager
fly -t kirklab set-pipeline -p upgrade-control-opsman -c ../pipelines/upgrade-control-opsman.yml -v foundation=kirklab-control -v product_version="^2\.6\..*$"
fly -t kirklab unpause-pipeline -p upgrade-control-opsman

## Ops Manager
fly -t kirklab set-pipeline -p upgrade-opsman -c ../pipelines/upgrade-opsman.yml -v foundation=kirklab -v product_version="^2\.6\..*$"
fly -t kirklab unpause-pipeline -p upgrade-opsman

## Pivotal Cloud Cache
fly -t kirklab set-pipeline -p upgrade-pcc -c ../pipelines/upgrade-pcc.yml -v foundation=kirklab -v product_slug=p-cloudcache -v product_shortname=pcc -v product_version="^1\.7\..*$"
fly -t kirklab unpause-pipeline -p upgrade-pcc

## Harbor Container Registry
fly -t kirklab set-pipeline -p upgrade-harbor -c ../pipelines/upgrade-harbor.yml -v foundation=kirklab -v product_slug=harbor-container-registry -v product_shortname=harbor -v product_version="^1\.8\..*$"
fly -t kirklab unpause-pipeline -p upgrade-harbor

## Healthwatch
fly -t kirklab set-pipeline -p upgrade-healthwatch -c ../pipelines/upgrade-healthwatch.yml -v foundation=kirklab -v product_slug=p-healthwatch -v product_shortname=healthwatch -v product_version="^1\.6\..*$"
fly -t kirklab unpause-pipeline -p upgrade-healthwatch

## MySQL
fly -t kirklab set-pipeline -p upgrade-mysql -c ../pipelines/upgrade-mysql.yml -v foundation=kirklab -v product_slug=pivotal-mysql -v product_shortname=mysql -v product_version="^2\.6\..*$"
fly -t kirklab unpause-pipeline -p upgrade-mysql

## Pivotal Application Service - Small Runtime
fly -t kirklab set-pipeline -p upgrade-pas-srt -c ../pipelines/upgrade-pas-srt.yml -v foundation=kirklab -v product_slug=cf -v product_shortname=pas-srt -v product_version="^2\.6\..*$"
fly -t kirklab unpause-pipeline -p upgrade-pas-srt

## Control Plane Pivotal Application Service - Small Runtime
fly -t kirklab set-pipeline -p upgrade-control-pas-srt -c ../pipelines/upgrade-pas-srt.yml -v foundation=kirklab-control -v product_slug=cf -v product_shortname=pas-srt -v product_version="^2\.6\..*$"
fly -t kirklab unpause-pipeline -p upgrade-control-pas-srt

## Pivotal Container Service
fly -t kirklab set-pipeline -p upgrade-pks -c ../pipelines/upgrade-pks.yml -v foundation=kirklab -v product_slug=pivotal-container-service -v product_shortname=pks -v product_version="^1\.4\..*$"
fly -t kirklab unpause-pipeline -p upgrade-pks

## RabbitMQ
fly -t kirklab set-pipeline -p upgrade-rabbitmq -c ../pipelines/upgrade-rabbitmq.yml -v foundation=kirklab -v product_slug=p-rabbitmq -v product_shortname=rabbitmq -v product_version="^1\.17\..*$"
fly -t kirklab unpause-pipeline -p upgrade-rabbitmq

## Redis
fly -t kirklab set-pipeline -p upgrade-redis -c ../pipelines/upgrade-redis.yml -v foundation=kirklab -v product_slug=p-redis -v product_shortname=redis -v product_version="^2\.1\..*$"
fly -t kirklab unpause-pipeline -p upgrade-redis

## Spring Cloud Data Flow
fly -t kirklab set-pipeline -p upgrade-scdf -c ../pipelines/upgrade-scdf.yml -v foundation=kirklab -v product_slug=p-dataflow -v product_shortname=scdf -v product_version="^1\.5\..*$"
fly -t kirklab unpause-pipeline -p upgrade-scdf

## Spring Cloud Services
fly -t kirklab set-pipeline -p upgrade-scs -c ../pipelines/upgrade-scs.yml -v foundation=kirklab -v product_slug=p-spring-cloud-services -v product_shortname=scs -v product_version="^2\.0\..*$"
fly -t kirklab unpause-pipeline -p upgrade-scs

# Kirklab Manual Apply Changes
fly -t kirklab set-pipeline -p apply-changes -c ../pipelines/apply-changes.yml -v foundation=kirklab
fly -t kirklab unpause-pipeline -p apply-changes

# Kirklab Control Manual Apply Changes
fly -t kirklab set-pipeline -p control-apply-changes -c ../pipelines/apply-changes.yml -v foundation=kirklab-control
fly -t kirklab unpause-pipeline -p control-apply-changes


