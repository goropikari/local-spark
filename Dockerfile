FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y vim wget openjdk-14-jdk python3 python3-pip mlocate tree less && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1

RUN pip3 install awscli

RUN cd /usr/local && \
    wget https://ftp.jaist.ac.jp/pub/apache/spark/spark-3.0.1/spark-3.0.1-bin-hadoop3.2.tgz && \
    tar xf spark-3.0.1-bin-hadoop3.2.tgz && \
    rm -f spark-3.0.1-bin-hadoop3.2.tgz

RUN cd /usr/local && \
    wget https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-common/apache-maven-3.6.0-bin.tar.gz && \
    tar xf apache-maven-3.6.0-bin.tar.gz

# RUN cd /usr/local/spark-3.0.1-bin-hadoop3.2/jars && \
#     wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar && \
#     wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk/1.11.917/aws-java-sdk-1.11.917.jar && \
#     wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.11.917/aws-java-sdk-core-1.11.917.jar && \
#     wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/1.11.917/aws-java-sdk-s3-1.11.917.jar && \
#     wget https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-dynamodb/1.11.917/aws-java-sdk-dynamodb-1.11.917.jar && \
#     wget https://repo1.maven.org/maven2/net/java/dev/jets3t/jets3t/0.9.4/jets3t-0.9.4.jar && \
#     rm httpclient-4.5.6.jar && \
#     wget https://repo1.maven.org/maven2/org/apache/httpcomponents/httpclient/4.5.9/httpclient-4.5.9.jar

COPY spark-defaults.conf /root/conf/spark-defaults.conf
COPY pom.xml /root/pom.xml
COPY .bashrc /root/.bashrc

RUN cd /root && \
    /usr/local/apache-maven-3.6.0/bin/mvn -f pom.xml -DoutputDirectory=/root/jars dependency:copy-dependencies && \
    rm /root/jars/jackson*

WORKDIR /root
