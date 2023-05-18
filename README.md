# Clusterless Examples

_Warning, much assembly required._

## Prerequisites

Currently Clusterless isn't downloadable, to install see:

- https://github.com/ClusterlessHQ/clusterless#prerequisites

Optionally you should to install:

- jsonnet
- jq

## Bootstrap

After installing the CDK above for a given region, configure the region below:

Copy `.properties.libsonnet.template` to `.properties.libsonnet` and edit.

Then bootstrap Clusterless into the region:

```
jsonnet bootstrap.jsonnet | jq -r '.[0]'
```

Copy/paste the bootstrap command to run.

## Current limitations

Clusterless is under active development. There are bugs, please post them.

See the [Roadmap](https://github.com/ClusterlessHQ/clusterless/blob/main/ROADMAP.md).

- Currently the only ingress boundary will accept one file every 5 minutes. A future version will handle unlimited arrivals per interval.
