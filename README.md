# Clusterless Examples

_Warning, much assembly required._

Here are a few examples using the [Clusterless](https://github.com/ClusterlessHQ/clusterless) cli.

Consider exploring them in order:

- [native-copy](/native-copy)
- [native-copy-chain](/native-copy-chain)
- [python-batch](/python-batch)

## Prerequisites

Currently Clusterless isn't downloadable, to install see:

- https://github.com/ClusterlessHQ/clusterless#prerequisites

You should also install these tools:

- jsonnet
- jq

## Bootstrap

After installing the AWS CDK for a given region, configure the region below:

Copy `.properties.libsonnet.template` to `.properties.libsonnet` and edit.

Then bootstrap Clusterless into the region:

```
jsonnet bootstrap.jsonnet | jq -r '.[0]'
```

Copy/paste the bootstrap command to run.

## Current limitations

Clusterless is under active development. There are bugs, please post them.
- https://github.com/ClusterlessHQ/clusterless/issues

See the [Roadmap](https://github.com/ClusterlessHQ/clusterless/blob/main/ROADMAP.md).

- Currently the default ingress boundary will accept one file every 5 minutes. A future version will handle unlimited arrivals per interval.
