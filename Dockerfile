#########################################################
# Base Dockerfile	                                #
# docker cannot access parent directories	        #
# this should be referenced from the root directory     #
# Author: joshua.s.landman@gmail.com                    #
# Date: 1/15/2020				        #
#########################################################

FROM openjdk:8
EXPOSE 8080

# This will be passed in from build system
ARG MVN_VERSION
ARG KEYFILE=<my key file>.json
ARG PROFILE=dev
ARG DATE
ARG JAR_TARGET=./target

# Record build args in container environment for reference
ENV LMS_VERSION ${MVN_VERSION}
ENV BUILD_KEYFILE ${KEYFILE}
ENV BUILD_PROFILE ${PROFILE}
ENV BUILD_DATE ${DATE}


# GCP PROJECT CREDENTIALS
COPY ./${KEYFILE} <my service key file>.json
ENV GOOGLE_APPLICATION_CREDENTIALS <my service key file>.json

# Executable APPLICATION JAR
COPY ${JAR_TARGET}/myservice-${MVN_VERSION}-SNAPSHOT-exec.jar myservice.jar

# for -t in development
ENV LSCOLORS ExFxCxDxBxegedabagacad

ENTRYPOINT ["java","-jar" ,"myservice.jar"]
