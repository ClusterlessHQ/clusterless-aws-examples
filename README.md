# Clusterless Examples

_Warning, much assembly required._

Here are a few examples using the [Clusterless](https://github.com/ClusterlessHQ/clusterless) cli.

To learn more, see the documentation:

* [User Guide](https://docs.clusterless.io/guide/1.0-wip/index.html)
* [Reference](https://docs.clusterless.io/reference/1.0-wip/index.html)
 
Consider exploring them in order:

- [native-copy](/native-copy)
- [native-copy-chain](/native-copy-chain)
- [python-batch](/python-batch)

## Notes

The examples rely on `jsonnet` to generate the JSON files. This is not a requirement imposed by Clusterless but a
convenience to creating simple project files that don't need to be edited before deployment. e.g. S3 bucket names are
global, so need to be unique to the deployment.

See [0002-static-json-as-configuration.md](https://github.com/ClusterlessHQ/clusterless/blob/main/docs/adr/0002-static-json-as-configuration.md).

The [default boundary](https://docs.clusterless.io/reference/1.0-wip/components/aws-core-s3-put-listener-boundary.html) has `eventArrival: "infrequent"`, this means the boundary will only be triggered once per upload
per interval. Two uploads in the same interval will cause an error (error management here is a TODO).

You can change this to `eventArrival: "frequent"` to have the boundary accumulate events within an interval. This has a
slightly higher cost as the boundary polls for events at the end of every interval.

## Prerequisites

To install see:

- https://github.com/ClusterlessHQ/clusterless#installing-clusterless

You should also install these tools:

- jsonnet
- jq

## Bootstrap

After installing the AWS CDK for a given region, configure the region below:

Copy `.properties.libsonnet.template` to `.properties.libsonnet` and edit.

Then bootstrap Clusterless into the region:

```shell
jsonnet bootstrap.jsonnet | jq -r '.[0]'
```

Copy/paste the bootstrap command to run.

## Current limitations

Clusterless is under active development. There are bugs, please post them.
- https://github.com/ClusterlessHQ/clusterless/issues

See the [Roadmap](https://github.com/ClusterlessHQ/clusterless/blob/main/ROADMAP.md).
