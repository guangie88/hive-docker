# Debian based
ARG JAVA_VERSION=8
ARG HADOOP_VERSION=
FROM guangie88/hadoop:${HADOOP_VERSION}_java-${JAVA_VERSION}

ARG HIVE_VERSION=

ENV HIVE_NAME "hive-${HIVE_VERSION}"
ENV HIVE_DIR "/opt/${HIVE_NAME}"
ENV HIVE_HOME "/usr/local/hive"

RUN set -eux; \
    # Setup and install 
    if [ -z "${HIVE_VERSION}" ]; then \
        echo "Please set --build-arg HIVE_VERSION for Docker build!" >&2; \
        sh -c "exit 1"; \
    fi; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        # Build-time only deps
        wget \
        # Required deps
        libmysql-java \
        libpostgresql-jdbc-java \
        procps; \
    #
    # Hadoop installation
    #
    PACKAGE_NAME=apache-hive-${HIVE_VERSION}-bin.tar.gz; \
    wget https://archive.apache.org/dist/hive/hive-${HIVE_VERSION}/${PACKAGE_NAME}; \
    mkdir ${HIVE_DIR}; \
    tar zxf ${PACKAGE_NAME} --strip-components=1 -C ${HIVE_DIR}; \
    rm ${PACKAGE_NAME}; \
    ln -s ${HIVE_DIR} ${HIVE_HOME}; \
    ln -s /usr/share/java/mysql-connector-java.jar $HIVE_HOME/lib/mysql-connector-java.jar; \
    ln -s /usr/share/java/postgresql-jdbc4.jar $HIVE_HOME/lib/postgresql-jdbc4.jar; \
    #
    # Remove unnecessary build-time only dependencies
    #
    apt-get remove -y wget; \
    rm -rf /var/lib/apt/lists/*

ENV PATH "${PATH}:${HIVE_HOME}/bin"
