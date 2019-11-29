FROM alpine AS alpine-build-trimmomatic
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

ARG TRIMMOMATIC_VERSION=0.39

RUN apk update && apk add wget unzip

WORKDIR /build

RUN wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-${TRIMMOMATIC_VERSION}.zip && \
    unzip Trimmomatic-${TRIMMOMATIC_VERSION}.zip

FROM alpine

ARG TRIMMOMATIC_VERSION=0.39

WORKDIR /
RUN apk update && apk add --no-cache openjdk8-jre-base
COPY --from=alpine-build-trimmomatic /build/Trimmomatic-${TRIMMOMATIC_VERSION}/trimmomatic-${TRIMMOMATIC_VERSION}.jar /usr/loca/bin/trimmomatic-${TRIMMOMATIC_VERSION}.jar
ENTRYPOINT ["java", "-jar", "/usr/loca/bin/trimmomatic-${TRIMMOMATIC_VERSION}.jar"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version=${TRIMMOMATIC_VERSION}