# Kirklab Platform Automation

Repository for my homelab using [Platform Automation for PCF](http://docs.pivotal.io/platform-automation/v3.0/).

My approach is focused on keeping an existing homelab environment up-to-date with the latest Pivnet software releases.

## Current Configuration

- Configuration in this repository is for my homelab environment
- The following pipelines are available:
  - PCF Ops Manager
  - Pivotal CloudCache
  - VMware Harbor Registry
  - Healthwatch
  - MySQL for PCF v2
  - Pivotal Application Service
  - Enterprise PKS
  - RabbitMQ
  - Redis
  - Spring Cloud Data Flow
  - Spring Cloud Services

## Repo Directory Structures

[kirklab-platform-automation](https://github.com/bkirkware/kirklab-platform-automation) contains Concourse pipelines and scripts to fly them. **You are here.**

[kirklab-locks](https://github.com/bkirkware/kirklab-locks) contains lock files used by the Concourse [pool-resource](https://github.com/concourse/pool-resource) to ensure only one pipeline is working on a foundation at any given time.

[kirklab-env](https://github.com/bkirkware/kirklab-env) contains custom Concourse tasks and foundation configurations and has the following structure.

```ascii
├── custom-tasks
│   └── run-errand.yml
├── foundation-1
│   ├── config
│   │   └── download-opsman.yml
│   │   └── opsman.yml
│   ├── download-product-configs
│   │   └── ...
│   ├── env
│   │   └── auth.yml
│   │   └── env.yml
│   ├── state
│   │   └── state.yml
```

## Pipelines Explained

### General Information

- **Triggered by Pivnet** - These pipelines watch a Pivnet resource for new updates based on a product version regular expression.
- **Slack Notifications** - These pipelines leverage Dylan Arbourd's [Concourse Slack Alert Resource](https://github.com/arbourd/concourse-slack-alert-resource).
- **Custom Tasks** - These pipelines use one custom task (run-errand)
- **Errands** - All tiles in Ops Manager have all post-deploy errands disabled. This is done to make a full apply changes take less time and be more likely to succeed. Individual errands are run during the upgrade pipeline for each tile as required.

### Ops Manager and Director Pipeline

The Ops Manager and director pipeline is a single pipeline used for upgrade of ops manager and director pair.

![upgrade-opsman](/docs/upgrade-opsman.png)

1. `lock-tiles` - Claim the lock for the specific foundation. Waits until the lock is unclaimed before it progresses.
2. `export-installation` - Exports the Ops Manager and tile configuration and pushes it to S3 compatible bucket.
3. `upgrade-opsman` - Tears down existing Ops Manager and deploys a new one. Imports the installation settings.
4. `apply-product-changes` - Run an apply changes to update the BOSH director.
5. `unlock-tile` - Releases the lock on the foundation.

The following notable configuration files exist:

- `state.yml` - Stores an id associated with the Ops Manager. Required for upgrades. Located in the kirklab env repo in the `<foundation>/state` folder
- `<foundation>/config` folder - Contains Ops Manager deployment configuration files used by the pipeline to deploy the Ops Manager VM.
- `<foundation>/env` folder - Contains Ops Manager environment files used by the pipeline to access Ops Manager.

Following jobs within the `ad-hoc-jobs` group

1. `force-unlock` - Releases lock on the foundation. Used when there is a failure at somepoint in the pipeline

### Product Tile Pipelines (example: Pivotal Cloud Cache)

Each tile has a separate pipeline due to the unique errands each tile runs.

Two groups are defined in the pipeline. `deployment-pipeline` is the primary pipeline, while `ad-hoc-jobs` contains one-off jobs that can be executed.

Following jobs within the `deployment-pipeline` group

![upgrade-pcc](/docs/upgrade-pcc.png)

1. `fetch-pcc` - Watch for new versions and download the latest release of the product from Pivnet
2. `lock-tiles` - Claim the lock for the specific foundation. Waits until the lock is unclaimed before it progresses.
3. `upload-and-stage-pcc` - Upload the newer release of the product to Ops Manager and stage it.
4. `apply-product-changes` - Apply changes. If the tile upgrade introduced a configuration change, the pipeline will fail at this step. If it does, manually configure the tile in Ops Managaer and re-run this step.
5. Run errands. The list and order of errands to be run varies by tile. For PCC, first `register-broker` then `upgrade-all-service-instances` are run.
6. `unlock-tile` - Releases the lock on the foundation.

The following notable configuration files exist:

- `<foundation>/download-product-configs` folder - Contains product download configuration files used by the pipeline.
- `<foundation>/env` folder - Contains Ops Manager environment files used by the pipeline to access Ops Manager.

Following jobs within the `ad-hoc-jobs` group

1. `force-unlock` - Releases lock on the foundation. Used when there is a failure at somepoint in the pipeline

## Updating a major version of a tile

1. Bump the versions
    1. In kirklab-env repo, update `kirklab/download-product-configs/<product>.yml` and change `product-version-regex`
    2. In kirklab-platform-automation repo, Update `scripts/fly-pipelines.sh` with the updated `product_version` variable
2. Deploy
    1. Commit the configuration changes and push to code repo
    2. Re-fly the pipeline with the updated product_version

If the major version update requires tile configuration, the pipeline will fail at the `apply-product-changes` step. Make the configuration changes manually in Ops Manager and re-run this step to complete the upgrade.

## Fly Pipelines

Use the `./scripts/fly-pipelines.sh` script to set and unpause all pipelines. Optionally, you can view that script to extract the commands to fly or unpause a specific pipeline. The scirpt assumes you have already logged into concourse. If not, use `fly -t lab login -k` to login.

## Left Out

As this is a lab automation configuration there are certain things left out and not accounted for. Here are a few notables.

- `Upgrade Planner` - Pivotal is in the process of creating an Upgrade Planner tool that provides guidance on the order and process to upgrade from one configuration to another. This is tremdous insight and is not incorporated into this automation. It is up to the user (me) to run the upgrade planner off-line and follow the recommendations by triggering pipelines in order
- `Install from S3` - The way these pipelines check Pivnet resources results in duplicate downloads from Pivnet as the pipeline runs. I intend to refactor these pipelines to copy Pivnet releases to my local Minio S3-compatible endpoint so that they are only downloaded once. Currently there is a bug in `om` tool that prevents me from using unencrypted S3 endpoint.
- `Install from Scratch` - These pipelines only work with a pre-configured environment. Building an environment from scratch or making configuration changes to tiles are still done through Ops Manager. I intend to adopt forward engineering practices in the future.

## To Do

- Provide Credhub seed script
- Fix PKS pipeline stemcell issue