FROM dylanmei/zeppelin

MAINTAINER Chaerim Yeo <yeochaerim@gmail.com>

# xgboost
RUN set -ex && \
    buildDeps="${buildDeps} git build-essential" && \
    apt-get update && apt-get install -y --no-install-recommends ${buildDeps} && \
    curl -sL http://archive.apache.org/dist/maven/maven-3/3.5.0/binaries/apache-maven-3.5.0-bin.tar.gz | gunzip | tar x -C /tmp/ && \
    curl -sL https://cmake.org/files/v3.8/cmake-3.8.2-Linux-x86_64.tar.gz | gunzip | tar x -C /tmp/ && \
    ln -s /tmp/cmake-3.8.2-Linux-x86_64/bin/cmake /usr/bin/cmake && \
    git clone --recursive https://github.com/dmlc/xgboost /usr/src/xgboost && \
    cd /usr/src/xgboost && \
    cd ./jvm-packages && \
    MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=1024m" /tmp/apache-maven-3.5.0/bin/mvn install -DskipTests -pl !xgboost4j-flink,!xgboost4j-example && \
    echo $'#!/bin/bash\nexport SPARK_SUBMIT_OPTIONS="--packages ml.dmlc:xgboost4j:0.7,ml.dmlc:xgboost4j-spark:0.7"' > $ZEPPELIN_CONF/zeppelin-env.sh
    apt-get purge -y --auto-remove ${buildDeps} && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/src/xgboost && \
    rm -rf /tmp/* && \
    rm -rf /usr/bin/cmake
