cd ~/work/git/bkirkware/kirklab-platform-automation/scripts

## Platform Automation
fly -t kirklab-control set-pipeline -p get-pa -c ../pipelines/get-pa.yml

## Ops Managers
fly -t kirklab-control set-pipeline -p upgrade-control-opsman -c ../pipelines/upgrade-control-opsman.yml -v foundation=kirklab-control -v product_version="^2\.7\..*$"
fly -t kirklab-control set-pipeline -p upgrade-opsman -c ../pipelines/upgrade-opsman.yml -v foundation=kirklab -v product_version="^2\.6\..*$"

fly -t kirklab-control set-pipeline -p upgrade-pcc -c ../pipelines/upgrade-pcc.yml -v foundation=kirklab -v product_slug=p-cloudcache -v product_shortname=pcc -v product_version="^1\.10\..*$"
fly -t kirklab-control set-pipeline -p upgrade-harbor -c ../pipelines/upgrade-harbor.yml -v foundation=kirklab -v product_slug=harbor-container-registry -v product_shortname=harbor -v product_version="^1\.10\..*$"
# fly -t kirklab-control set-pipeline -p upgrade-healthwatch -c ../pipelines/upgrade-healthwatch.yml -v foundation=kirklab -v product_slug=p-healthwatch -v product_shortname=healthwatch -v product_version="^1\.6\..*$"
fly -t kirklab-control set-pipeline -p upgrade-mysql -c ../pipelines/upgrade-mysql.yml -v foundation=kirklab -v product_slug=pivotal-mysql -v product_shortname=mysql -v product_version="^2\.7\..*$"
fly -t kirklab-control set-pipeline -p upgrade-pas-srt -c ../pipelines/upgrade-pas-srt.yml -v foundation=kirklab -v product_slug=cf -v product_shortname=pas-srt -v product_version="^2\.6\..*$"
fly -t kirklab-control set-pipeline -p upgrade-pks -c ../pipelines/upgrade-pks.yml -v foundation=kirklab -v product_slug=pivotal-container-service -v product_shortname=pks -v product_version="^1\.6\..*$"
fly -t kirklab-control set-pipeline -p upgrade-control-pks -c ../pipelines/upgrade-control-pks.yml -v foundation=kirklab-control -v product_slug=pivotal-container-service -v product_shortname=pks -v product_version="^1\.6\..*$"
fly -t kirklab-control set-pipeline -p upgrade-rabbitmq -c ../pipelines/upgrade-rabbitmq.yml -v foundation=kirklab -v product_slug=p-rabbitmq -v product_shortname=rabbitmq -v product_version="^1\.18\..*$"
fly -t kirklab-control set-pipeline -p upgrade-redis -c ../pipelines/upgrade-redis.yml -v foundation=kirklab -v product_slug=p-redis -v product_shortname=redis -v product_version="^2\.3\..*$"
fly -t kirklab-control set-pipeline -p upgrade-scdf -c ../pipelines/upgrade-scdf-credhub.yml -v foundation=kirklab -v product_slug=p-dataflow -v product_shortname=scdf -v product_version="^1\.6\..*$"
fly -t kirklab-control set-pipeline -p upgrade-credhub -c ../pipelines/upgrade-scdf-credhub.yml -v foundation=kirklab -v product_slug=credhub-service-broker -v product_shortname=credhub -v product_version="^1\.4\..*$"
# fly -t kirklab-control set-pipeline -p upgrade-scs -c ../pipelines/upgrade-scs.yml -v foundation=kirklab -v product_slug=p-spring-cloud-services -v product_shortname=scs -v product_version="^2\.0\..*$"
fly -t kirklab-control set-pipeline -p upgrade-scs3 -c ../pipelines/upgrade-scs3.yml -v foundation=kirklab -v product_slug=p-spring-cloud-services -v product_slug2=p_spring-cloud-services -v product_shortname=scs3 -v product_version="^3\.1\..*$"
fly -t kirklab-control set-pipeline -p upgrade-ncp -c ../pipelines/upgrade-ncp.yml -v foundation=kirklab -v product_slug=VMware-NSX-T -v product_shortname=ncp -v product_version="^2\.5\..*$"

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
# fly -t kirklab-control unpause-pipeline -p upgrade-healthwatch
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
# fly -t kirklab-control unpause-pipeline -p upgrade-scs
fly -t kirklab-control unpause-pipeline -p upgrade-scs3
fly -t kirklab-control unpause-pipeline -p upgrade-ncp
fly -t kirklab-control unpause-pipeline -p apply-changes
fly -t kirklab-control unpause-pipeline -p control-apply-changes
fly -t kirklab-control unpause-pipeline -p export-inst
fly -t kirklab-control unpause-pipeline -p control-export-inst