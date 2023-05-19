# Native copy

This is a trivial example that uses a built in funcion to copy a file from one path to another, then another.

Use this example to see how arcs can be chained together. 

Modfiy the last arc to listen to the first so instead of a chain, there is a fork.

## Setup

To generate the project file:

```
jsonnet -o .project.json s3-copy-chain-arc-project.jsonnet
```

This applies the properties from the bootstrap phase (see the jsonnet file).

Note clusterless does not rely on jsonnet, but it is a convenience for generating JSON files from property files.

## Deployment

This deploys the project.

```
cd ..
cls verify -p .project.json
cls deploy -p .project.json
```

Once deployed, drop a file in the `/ingress` folder.

To destroy the project when done:

```
cls destroy -p .project.json
```