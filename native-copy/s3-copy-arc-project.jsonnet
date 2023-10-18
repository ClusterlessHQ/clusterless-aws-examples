local props = import '../.properties.libsonnet';
local stage = props.stage;
local account = props.account;
local region = props.region;
local bucketName = stage +'-native-copy-' + account + '-' + region;
local bucketPrefix = 's3://' + bucketName;
local unit = 'Twelfths';

{
  project: {
    name: 'S3Simple',
    version: '20230101-00',
  },
  placement: {
    stage: stage,
    provider: 'aws',
    account: account,
    region: region,
  },
  resources: [
    {
      type: 'aws:core:s3Bucket',
      name: 'bucket',
      bucketName: bucketName,
    },
  ],
  // Boundaries are the interface with the outside world.
  boundaries: [
    {
      type: 'aws:core:s3PutListenerBoundary',
      name: 'IngressPutListener',
      // infrequent: one event per interval
      // frequent: many events per interval, slightly higher cost
      eventArrival: "infrequent",
      dataset: {
        name: 'ingress-simple',
        version: '20220101',
        pathURI: bucketPrefix + '/ingress/',
      },
      lotUnit: unit,
    },
  ],
  // Arcs listen for availability events, run the declared workload, and publish new availability events
  arcs: [
    {
      // a native built in arc module
      type: 'aws:core:s3CopyArc',
      name: 'copyA',
      sources: {
        main: {
          name: 'ingress-simple',
          version: '20220101',
        },
      },
      sinks: {
        main: {
          name: 'copy-a-simple',
          version: '20230101',
          pathURI: bucketPrefix + '/copy-a/',
        },
      },
    },
  ],
}
