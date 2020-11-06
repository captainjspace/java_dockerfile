#####################################################
# Base Dockerfile				    #
# docker cannot access parent directories	    #
# this should be referenced from the root directory #
# Author: joshua.s.landman@gmail.com		    #
# Date: 11/04/2020				    #
#####################################################


#build image
FROM maven:3-jdk-14 as maven-build

ARG DEPLOY_ENV
ENV DEPLOY_ENV ${DEPLOY_ENV}

RUN mkdir -p /usr/src/app/src
COPY pom.xml /usr/src/app

#caches dependencies in image
RUN mvn -f /usr/src/app/pom.xml dependency:go-offline
COPY src /usr/src/app/src

#P is the profile defined int pom.xml
RUN mvn -Dmaven.test.skip=true -f /usr/src/app/pom.xml -PDEPLOY,$DEPLOY_ENV clean package

#assemble deploy image
FROM openjdk:14-jdk-alpine
COPY --from=maven-build /usr/src/app/target/my-microservice-DEPLOY.jar /opt/my-microservice.jar

# pass in git hash so you can see the commit that was built in the container
ARG GIT_HASH=1234567
ENV GIT_HASH ${GIT_HASH}

ENTRYPOINT ["java","--enable-preview", "-XX:InitialRAMPercentage=70.0", "-XX:MinRAMPercentage=70.0", "-XX:MaxRAMPercentage=70.0", "-jar", "/opt/my-microservice.jar"]
