# crda-images

## Images generated using this script

Ecosystem     | Version       | IMAGE                                     | TAG               | 
------------- | ------------- | ------------------------------------------|-------------------|
python        | python3.8     |  crda-python                              | 3.8               |
python        | python3.6     |  crda-python                              | 3.6               |
python        | python3.7     |  crda-python                              | 3.7               | 


## Creating Maven CRDA image and runing the scan in a container.

#### creating CRDA Maven image and publishing to the repo.

```
podman build -f ./Dockerfiles/Dockerfile.maven . -t crda-maven:4.0 
podman tag localhost/crda-maven:4.0 quay.io/lrangine/crda-maven:4.0
podman push quay.io/lrangine/crda-maven:4.0
```

### Running CRDA scan on a maven project.

```shell
# Go to root directory of the maven project where you can access pom.xml
$ podman run -ti --rm \
-e AUTH_TOKEN=<replace_auth_token> \
-e CRDA_KEY=<replace_crda_key> \
-e CONSENT_TELEMETRY=false \
-e HOST="https://f8a-analytics-2445582058137.production.gw.apicast.io" \
-v $(pwd):/usr/src/project  \
quay.io/lrangine/crda-maven:3.0 /crda.sh /usr/src/project/pom.xml /usr/src/project/scan_results.json

# Example of the command with dummy tokens.
$ podman run -ti --rm \
-e AUTH_TOKEN=9e7ab12345fe123d8c12fa752e12345f \
-e CRDA_KEY=12345678-ab1c-12ad-b123-a04a12345d9a \
-e CONSENT_TELEMETRY=false \
-e HOST="https://f8a-analytics-2445582058137.production.gw.apicast.io" \
-v $(pwd):/usr/src/project  \
quay.io/lrangine/crda-maven:3.0 /crda.sh /usr/src/project/pom.xml /usr/src/project/scan_results.json
```
