# Python

This is a trivial example in Python that copies a file from one location to another.

Use this example as a basis to create your own custom python applications.

## Setup

To generate the project file:

```shell
jsonnet -o .project.json s3-python-arc-project.jsonnet
```

This applies the properties from the bootstrap phase (see the jsonnet file).

Note clusterless does not rely on jsonnet, but it is a convenience for generating JSON files from property files.

## Editing and Running Locally

You can run the app as-is deployed, but if you want to make local edits and test them, follow along.

```shell
cd app
python3 -m venv .venv
source .venv/bin/activate
pip3 install -r requirements.txt
```

After any edits, update the `requirements.txt` file.

```shell
pip freeze > requirements.txt
```

### Deploying Only Boundaries and Resources

In order to test locally, we need ingress data, and to do that, we need to create all the required boundaries and resources.

```shell
cd ..
cls verify -p .project.json --exclude-all-arcs
cls deploy -p .project.json --exclude-all-arcs
```

Note that `verify` is an optional step to confirm the JSON is correct.

Now upload a file into the `/ingress/` folder of the bucket created. Note there won't be any folders in a new bucket, you need to create it.

After uploading, the `clusterless-manifest-*` bucket will list a new dataset, having data in a given `lot`, e,g `/lot=20230518PT5M006/`. Use the lot id below.

To run the code locally, generate a shell script using a valid lot id.

```shell
cls local -p .project.json --arc pythonCopy --lot ... > local.sh
```

Use the `local.sh` script to run the code in the `app` folder.

```shell
cd app
../local.sh
```

## Full Deployment

This deploys the whole project:

```shell
cd ..
cls verify -p .project.json
cls deploy -p .project.json
```

Once deployed, drop a file in the `/ingress` folder.

To destroy the project when done:

```shell
cls destroy -p .project.json
```
