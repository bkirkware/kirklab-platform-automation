# Kirklab Platform Automation

Repository for my homelab using [Platform Automation for PCF](http://docs.pivotal.io/platform-automation/v3.0/).

My approach is focused on keeping an existing homelab environment up-to-date with the latest Pivnet software releases.

## Current Configuration

- Configuration in this repository is for my homelab environment
- The following pipelines are available:
  - Ops Manager
  - Pivotal Cloud Cache

## Repo Directory Structure

[kirklab-env](https://github.com/bkirkware/kirklab-env) has the following structure.

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

### General Concepts

- `Locks` - Each pipeline leverages locks to ensure that only one pipeline is working on the foundation at any given point.  If a pipeline is triggered while another pipeline has the lock, then it will poll every 1 minute waiting for the lock to be released.  Check out info on the concourse [pool-resource](https://github.com/concourse/pool-resource).  The corresponding lock repository used in my lab is [platform-automation-example-locks](https://github.com/doddatpivotal/platform-automation-example-locks)
- `Building blocks` - Platform Automation for PCF provides a *secure container image* with tools for interacting with PCF, *common tasks* to be performed against ops manager, and a set of *documentation*.  Creation of automation is an iterative process that requires feedback and adjustements.  Pipelines may start out similar accross organizations, but ultimately they should be tuned provide benefit of the users and resolve toil.  This is an engineering discipline and benefits from the same practices common to software development.  Please use all the tools available through Platform Automation for PCF and create something efficent and useful for you

### Errands

TO-DO

### Ops Manager and Director Pipeline

The ops manager and director pipeline is a single pipeline used for both installation and upgrade of ops manager and director pair.

![upgrade-opsman](/docs/upgrade-opsman.png)

1. `lock-tiles` - Claim the lock for the specific foundation.  Waits untile the lock is unclaimed before it progresses.
2. `export-installation` - Exports the opsmanager and tile configuration and pushes it to S3 compatible bucket.
3. `upgrade-opsman` - Tears down existing Ops Manager and deploys a new one. Imports the installation settings.
4. `apply-product-changes` - Run an apply changes to update the BOSH director.
5. `unlock-tile` - Releases the lock on the foundation.

The following notable configuration files exist:

- `state.yml` - Stores an id associated with the opsmanager.  Required for opsman upgrades.  This file must exist and can be blank for an intial install.  The pipeline will update the file after the pipeline is run.  Located in the kirklab env repo in the `<foundation>//state` folder
- `<foundation>/config` folder - Contains Ops Manager deployment configuration files used by the pipeline to deploy the Ops Manager VM.
- `<foundation>/env` folder - Contains Ops Manager environment files used by the pipeline to access Ops Manager.

Following jobs within the `ad-hoc-jobs` group

1. `force-unlock` - Releases lock on the foundation.  Used when there is a failure at somepoint in the pipeline

### Product Tile Pipelines (example: Pivotal Cloud Cache)

Each tile has a separate pipeline due to the unique errands each tile runs.

Two groups are defined in the pipeline.  `deployment-pipeline` is the primary pipeline, while `ad-hoc-jobs` contains one-off jobs that can be executed.

Following jobs within the `deployment-pipeline` group

![upgrade-pcc](/docs/upgrade-pcc.png)

1. `fetch-pcc` - Watch for new versions and download the latest release of the product from Pivnet
2. `lock-tiles` - Claim the lock for the specific foundation.  Waits untile the lock is unclaimed before it progresses.
3. `upload-and-stage-pcc` - Upload the newer release of the product to Ops Manager and stage it.
4. `apply-product-changes` - Apply changes. If the tile upgrade introduced a configuration change, the pipeline will fail at this step. If it does, manually configure the tile in Ops Managaer and re-run this step.
5. Run errands. The list and order of errands to be run varies by tile. For PCC, first `register-broker` then `upgrade-all-service-instances` are run.
6. `unlock-tile` - Releases the lock on the foundation.

The following notable configuration files exist:

- `<foundation>/download-product-configs` folder - Contains product download configuration files used by the pipeline.
- `<foundation>/env` folder - Contains Ops Manager environment files used by the pipeline to access Ops Manager.

Following jobs within the `ad-hoc-jobs` group

1. `force-unlock` - Releases lock on the foundation.  Used when there is a failure at somepoint in the pipeline

## Updating a major version of a tile

1. Bump the versions
    1. In kirklab-env repo, update `kirklab/download-product-configs/<product>.yml` and change `product-version-regex`
    2. In kirklab-platform-automation repo, Update `upgrade-<product>.yml` and change the `pivnet-<product>` resource's `product_version` regular expression
2. Deploy
    1. Commit the configuration changes and push to code repo
    2. Fly the updated pipeline (see fly-pipelines.sh for syntax)

If the major version update requires tile configuration, the pipeline will fail at the `apply-product-changes` step. Make the configuration changes manually in Ops Manager and re-run this step to complete the upgrade.

## Fly Pipelines

Use the `./scripts/fly-pipelines.sh` script to set and unpause all pipelines.  Optionally, you can view that script to extract the commands to fly or unpause a specific pipeline.  The scirpt assumes you have already logged into concourse.  If not, use `fly -t lab login -k` to login.

## Left Out

As this is a lab automation configuration there are certain things left out and not accounted for.  Here are a few notables.

- `Upgrade Planner` - Pivotal is in the process of creating an Upgrade Planner tool that provides guidance on the order and process to upgrade from one configuration to another.  This is tremdous insight and is not incorporated into this automation.  It is up to the user (me) to run the upgrade planner off-line and follow the recommendations by triggering pipelines in order
- `Install from S3` - The way these pipelines check Pivnet resources results in duplicate downloads from Pivnet as the pipeline runs. I intend to refactor these pipelines to copy Pivnet releases to my local Minio S3-compatible endpoint so that they are only downloaded once. Currently there is a bug in `om` tool that prevents me from using unencrypted S3 endpoint.
- `Install from Scratch` - These pipelines only work with a pre-configured environment. Building an environment from scratch or making configuration changes to tiles are still done through Ops Manager. I intend to adopt forward engineering practices in the future.

## To Do

- Provide Credhub seed script