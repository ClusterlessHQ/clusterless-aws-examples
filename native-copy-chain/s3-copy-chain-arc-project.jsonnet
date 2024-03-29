local props = import '../.properties.libsonnet';
local stage = props.stage;
local account = props.account;
local region = props.region;
local bucketName = stage +'-native-copy-chain-' + account + '-' + region;
local bucketPrefix = 's3://' + bucketName;
local unit = 'Twelfths';

{
  project: {
    name: 'S3Chain',
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
  boundaries: [
    {
      type: 'aws:core:s3PutListenerBoundary',
      name: 'IngressPutListener',
      // infrequent: one event per interval
      // frequent: many events per interval, slightly higher cost
      eventArrival: "infrequent",
      dataset: {
        name: 'ingress-chain',
        version: '20220101',
        pathURI: bucketPrefix+'/ingress/',
      },
      lotUnit: unit,
    },
  ],
  arcs: [
    {
      type: 'aws:core:s3CopyArc',
      name: 'copyA',
      sources: {
        main: {
          name: 'ingress-chain',
          version: '20220101',
        },
      },
      sinks: {
        main: {
          name: 'copy-a-chain',
          version: '20230101',
          pathURI: bucketPrefix+'/copy-a/',
        },
      },
    },
    {
      type: 'aws:core:s3CopyArc',
      name: 'copyB',
      sources: {
        main: {
          name: 'copy-a-chain',
          version: '20230101',
        },
      },
      sinks: {
        main: {
          name: 'copy-b-chain',
          version: '20230101',
          pathURI: bucketPrefix+'/copy-b/',
        },
      },
      workload: {
        workloadProps: {
          failArcOnPartialPercent: 0.1,
        },
      },
    },
    {
      type: 'aws:core:s3CopyArc',
      name: 'copyC',
      sources: {
        main: {
          name: 'copy-b-chain',
          version: '20230101',
        },
      },
      sinks: {
        main: {
          name: 'copy-c-chain',
          version: '20230101',
          pathURI: bucketPrefix+'/copy-c/',
        },
      },
    },
  ],
}
