FROM alpine AS alpine-build-trimmomatic
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories

RUN apk update && apk add wget unzip

WORKDIR /build

RUN wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.39.zip && \
    unzip Trimmomatic-0.39.zip

FROM alpine
WORKDIR /
RUN apk update && apk add --no-cache openjdk8-jre-base
COPY --from=alpine-build-trimmomatic /build/Trimmomatic-0.39/trimmomatic-0.39.jar /usr/loca/bin/trimmomatic-0.39.jar
ENTRYPOINT ["java", "-jar", "/usr/loca/bin/trimmomatic-0.39.jar"]

LABEL maintainer='github.com/bschiffthaler'
LABEL software.version='0.39'