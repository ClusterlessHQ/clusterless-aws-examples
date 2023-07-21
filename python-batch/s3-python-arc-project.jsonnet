local props = import '../.properties.libsonnet';
local stage = props.stage;
local account = props.account;
local region = props.region;
local bucketName = stage +'-clusterless-simple-python-copy-' + account + '-' + region;
local bucketPrefix = 's3://' + bucketName;
local unit = 'Twelfths';

{
  project: {
    name: 'S3Python',
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
    {
      type: 'aws:core:computeEnvironment',
      name: 'simple',
      computeEnvironmentName: 'simpleComputeEnvironment'
    },
  ],
  boundaries: [
    {
      type: 'aws:core:s3PutListenerBoundary',
      name: 'IngressListener',
      // infrequent: one event per interval
      // frequent: many events per interval, slightly higher cost
      eventArrival: "infrequent",
      dataset: {
        name: 'ingress-python-example-source',
        version: '20230101',
        pathURI: bucketPrefix + '/ingress/',
      },
      lotUnit: unit,
    },
  ],
  arcs: [
    {
      type: 'aws:core:batchExecArc',
      name: 'pythonCopy',
      sources: {
        main: {
          name: 'ingress-python-example-source',
          version: '20230101',
          pathURI: bucketPrefix + '/ingress/',
        },
      },
      sinks: {
        main: {
          name: 'ingress-python-example-copy',
          version: '20230101',
          pathURI: bucketPrefix + '/copy/',
        },
      },
      workload: {
        computeEnvironmentRef: 'simple',
        imagePath: 'app',
        environment: {},
        command: [
          'python3',
          'copyS3.py',
          '$.arcNotifyEvent.lot',
          '$.arcNotifyEvent.manifest',
        ],
      },
    },
  ],
}
