cd ~/work/git/bkirkware/kirklab-platform-automation/scripts

## Platform Automation
fly -t kirklab-control set-pipeline -p get-pa -c ../pipelines/get-pa.yml

## Ops Managers
fly -t kirklab-control set-pipeline -p upgrade-control-opsman -c ../pipelines/upgrade-control-opsman.yml -v foundation=kirklab-control -v product_shortname=opsman -v product_version="^2\.8\..*$"
fly -t kirklab-control set-pipeline -p upgrade-opsman -c ../pipelines/upgrade-opsman.yml -v foundation=kirklab -v product_shortname=opsman -v product_version="^2\.8\..*$"

## Tiles
fly -t kirklab-control set-pipeline -p upgrade-scs -c ../pipelines/upgrade-scs.yml -v foundation=kirklab -v product_slug=p-spring-cloud-services -v product_shortname=scs -v product_version="^2\.1\..*$"
fly -t kirklab-control set-pipeline -p upgrade-scs3 -c ../pipelines/upgrade-scs3-scg.yml -v foundation=kirklab -v product_slug=p-spring-cloud-services -v product_slug2=p_spring-cloud-services -v product_shortname=scs3 -v product_version="^3\.1\..*$"
fly -t kirklab-control set-pipeline -p upgrade-scg -c ../pipelines/upgrade-scs3-scg.yml -v foundation=kirklab -v product_slug=spring-cloud-gateway -v product_slug2=p_spring-cloud-gateway-service -v product_shortname=scg -v product_version="^1\.0\..*$"
fly -t kirklab-control set-pipeline -p upgrade-sso -c ../pipelines/upgrade-sso.yml -v foundation=kirklab -v product_slug=Pivotal_Single_Sign-On_Service -v product_shortname=sso -v product_version="^1\.11\..*$"
fly -t kirklab-control set-pipeline -p upgrade-scdf -c ../pipelines/upgrade-scdf-credhub-wavefront.yml -v foundation=kirklab -v product_slug=p-dataflow -v product_shortname=scdf -v product_version="^1\.6\..*$"
fly -t kirklab-control set-pipeline -p upgrade-credhub -c ../pipelines/upgrade-scdf-credhub-wavefront.yml -v foundation=kirklab -v product_slug=credhub-service-broker -v product_shortname=credhub -v product_version="^1\.4\..*$"
fly -t kirklab-control set-pipeline -p upgrade-wavefront -c ../pipelines/upgrade-scdf-credhub-wavefront.yml -v foundation=kirklab -v product_slug=wavefront-nozzle -v product_shortname=wavefront -v product_version="^2\.0\..*$"
fly -t kirklab-control set-pipeline -p upgrade-pcc -c ../pipelines/upgrade-pcc.yml -v foundation=kirklab -v product_slug=p-cloudcache -v product_shortname=pcc -v product_version="^1\.10\..*$"
fly -t kirklab-control set-pipeline -p upgrade-ncp -c ../pipelines/upgrade-ncp.yml -v foundation=kirklab -v product_slug=VMware-NSX-T -v product_shortname=ncp -v pks_product_slug=pivotal-container-service -v product_version="^2\.5\..*$"
fly -t kirklab-control set-pipeline -p upgrade-rabbitmq -c ../pipelines/upgrade-rabbitmq.yml -v foundation=kirklab -v product_slug=p-rabbitmq -v product_shortname=rabbitmq -v product_version="^1\.18\..*$"
fly -t kirklab-control set-pipeline -p upgrade-redis -c ../pipelines/upgrade-redis.yml -v foundation=kirklab -v product_slug=p-redis -v product_shortname=redis -v product_version="^2\.3\..*$"
fly -t kirklab-control set-pipeline -p upgrade-mysql -c ../pipelines/upgrade-mysql.yml -v foundation=kirklab -v product_slug=pivotal-mysql -v product_shortname=mysql -v product_version="^2\.7\..*$"
fly -t kirklab-control set-pipeline -p upgrade-pas-srt -c ../pipelines/upgrade-pas-srt.yml -v foundation=kirklab -v product_slug=cf -v product_shortname=pas-srt -v product_version="^2\.8\..*$"
fly -t kirklab-control set-pipeline -p upgrade-harbor -c ../pipelines/upgrade-harbor.yml -v foundation=kirklab -v product_slug=harbor-container-registry -v product_shortname=harbor -v product_version="^1\.10\..*$"
fly -t kirklab-control set-pipeline -p upgrade-pks -c ../pipelines/upgrade-pks.yml -v foundation=kirklab -v product_slug=pivotal-container-service -v product_shortname=pks -v product_version="^1\.6\..*$"

## Control Plane Tiles
fly -t kirklab-control set-pipeline -p upgrade-control-pks -c ../pipelines/upgrade-control-pks.yml -v foundation=kirklab-control -v product_slug=pivotal-container-service -v product_shortname=pks -v product_version="^1\.6\..*$"

## Currently Not Installed
#fly -t kirklab-control set-pipeline -p upgrade-healthwatch -c ../pipelines/upgrade-healthwatch.yml -v foundation=kirklab -v product_slug=p-healthwatch -v product_shortname=healthwatch -v product_version="^1\.8\..*$"
#fly -t kirklab-control set-pipeline -p upgrade-metrics -c ../pipelines/upgrade-metrics.yml -v foundation=kirklab -v product_slug=apm -v product_slug2=apmPostgres -v product_shortname=metrics -v product_version="^1\.6\..*$"


# Apply Changes
fly -t kirklab-control set-pipeline -p apply-changes -c ../pipelines/apply-changes.yml -v foundation=kirklab
fly -t kirklab-control set-pipeline -p control-apply-changes -c ../pipelines/control-apply-changes.yml -v foundation=kirklab-control

# Export Installation
fly -t kirklab-control set-pipeline -p export-inst -c ../pipelines/export-inst.yml -v foundation=kirklab
fly -t kirklab-control set-pipeline -p control-export-inst -c ../pipelines/export-inst.yml -v foundation=kirklab-control







# Unpause
fly -t kirklab-control unpause-pipeline -p get-pa
fly -t kirklab-control unpause-pipeline -p upgrade-control-opsman
fly -t kirklab-control unpause-pipeline -p upgrade-opsman
fly -t kirklab-control unpause-pipeline -p upgrade-healthwatch
fly -t kirklab-control unpause-pipeline -p upgrade-metrics
fly -t kirklab-control unpause-pipeline -p upgrade-pcc
fly -t kirklab-control unpause-pipeline -p upgrade-harbor
fly -t kirklab-control unpause-pipeline -p upgrade-mysql
fly -t kirklab-control unpause-pipeline -p upgrade-pas-srt
fly -t kirklab-control unpause-pipeline -p upgrade-pks
fly -t kirklab-control unpause-pipeline -p upgrade-control-pks
fly -t kirklab-control unpause-pipeline -p upgrade-rabbitmq
fly -t kirklab-control unpause-pipeline -p upgrade-redis
fly -t kirklab-control unpause-pipeline -p upgrade-scdf
fly -t kirklab-control unpause-pipeline -p upgrade-credhub
fly -t kirklab-control unpause-pipeline -p upgrade-scs
fly -t kirklab-control unpause-pipeline -p upgrade-scs3
fly -t kirklab-control unpause-pipeline -p upgrade-ncp
fly -t kirklab-control unpause-pipeline -p upgrade-scg
fly -t kirklab-control unpause-pipeline -p apply-changes
fly -t kirklab-control unpause-pipeline -p control-apply-changes
fly -t kirklab-control unpause-pipeline -p export-inst
fly -t kirklab-control unpause-pipeline -p control-export-inst