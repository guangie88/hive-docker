# Hive Docker Builder

Dockerfile setup to install various versions of Hive in a minimalist
environment.

The Java version `JAVA_VERSION` defaults to 8, while both `HADOOP_VERSION` and
`HIVE_VERSION` build arguments must be specified. You may find out more about
the compatibility between Hive and Hadoop
[here](https://hive.apache.org/downloads.html).

This set-up also includes both MySQL and PostgreSQL JDBC JAR files to connect
to these two databases.

There is no default `hive-site.xml` file set up for this image. You should
bind mount the Hive configuration into `/usr/local/hive/conf/hive-site.xml` to
give it the configuration to connect to your custom backend.

## Example build and run commands

```bash
HADOOP_VERSION=2.7.7
HIVE_VERSION=2.3.4

# Build
docker build . \
    --build-arg HADOOP_VERSION=${HADOOP_VERSION} \
    --build-arg HIVE_VERSION=${HIVE_VERSION} \
    -t guangie88/hive:${HIVE_VERSION}

# Check Hadoop version
docker run --rm -it \
    guangie88/hive:${HIVE_VERSION} \
    hive --version
```
