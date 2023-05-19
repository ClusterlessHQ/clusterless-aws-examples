import json
import os
import sys

from cloudpathlib import CloudPath
from uritemplate import URITemplate

def main():
    # for name, value in os.environ.items():
    #     print("env: {0}: {1}".format(name, value))

    # raise an error to show how the state machine reports failures
    # raise "Intentional Error"

    args = sys.argv[1:]

    # load the CLS_ARC_PROPS_JSON metadata
    arcProps = json.loads(os.environ['CLS_ARC_PROPS_JSON'])
    sourcePath = arcProps['sources']['main']['pathURI']
    sinkPath = arcProps['sinks']['main']['pathURI']
    sinkManifestPath = arcProps['sinkManifestPaths']['main']
    print('source: {}, sink: {}, sinkManifest: {}'.format(sourcePath, sinkPath, sinkManifestPath))

    lot = args[0]
    manifestUri = args[1]

    print('lot: {}, sourceManifest: {}'.format(lot, manifestUri))

    manifest = CloudPath(manifestUri)

    print('manifest exists: {}'.format(manifest.exists()))

    body = json.loads(manifest.read_text())

    uris = body["uris"]

    sinks = []

    for source in uris:
        sink = sinkPath + source[len(sourcePath):]
        sinks.append(sink)
        print("copying: {}, to: {}".format(source, sink))
        CloudPath(source).copy(sink, force_overwrite_to_cloud=True)

    # write the sink manifest
    sinkManifest = json.dumps(
        {
            'state': 'complete',
            'comment': None,
            'dataset': arcProps['sinks']['main'],
            'lotId': lot,
            'uriType': 'identifier',
            'uris': sinks
        }
    )

    manifestUri = URITemplate(sinkManifestPath).expand(
        {
            'lot': lot
            , 'state': 'complete'
            # , "attempt": {'attempt': '0000'} # attempt is only for partial results
        })

    print("manifest uri: {}".format(manifestUri))
    CloudPath(manifestUri).write_text(sinkManifest)


if __name__ == "__main__":
    main()
    sys.exit(0)
