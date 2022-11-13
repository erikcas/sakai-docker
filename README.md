# sakai-docker

Docker container for the stable version of [Sakai v12](https://github.com/sakaiproject/sakai).

## Setup

First, run a Git submodule update to fetch/update the source code for Sakai.

Set the proper url for your instace in `server.xml`

```sh
git submodules update --init
```

To build the Docker image for Sakai and launch containers for Sakai and MySQL,
run:

```sh
docker-compose up
```

The first time this command is run the Docker image for Sakai will be built,
which can take 10 minutes or more. Additionally when the Sakai starts for the
first time it will spend several minutes initializing.

## Logging into Sakai

Once the Sakai container image has been built and the container is created,
you can access Sakai by browsing to http://localhost:8080/portal.

The default admin user is `admin` and the password is `admin`.

## Troubleshooting

If you have problems building or running the Docker container on macOS, you may
need to increase the memory allowance for Docker Engine up from the default of
2GB to 3GB or more.

This can be done in the "Advanced" section of Docker for Mac's Preferences UI.

## References

[Quick Start from Source](https://github.com/sakaiproject/sakai/wiki/Quick-Start-from-Source)
