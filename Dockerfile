FROM alpine/git as clone
ARG url
WORKDIR /app
RUN git clone ${url}

FROM maven:3.5-jdk-8-alpine as build
ARG project
WORKDIR /app
COPY --from=clone /app/${project} /app
RUN mvn install

FROM openjdk:8-jre-alpine
ARG artifactid
ARG version
ENV artifactnameinfull ${artifactid}-${version}.jar
WORKDIR /app
COPY --from=build /app/target/${artifactnameinfull} /app
ENTRYPOINT [ "sh", "-c" ]
CMD ["java -jar ${artifactnameinfull}"]


#docker build --force-rm --build-arg url=https://github.com/arkham02/maven-github-docker.git --build-arg project=maven-github-docker --build-arg artifactid=maven-github-docker --build-arg version=1.1 --tag nits0202/mvn-git-jar-docker .
#docker run --rm nits0202/mvn-git-jar-docker
#docker push nits0202/mvn-git-jar-docker

# --no-cache
#docker build --force-rm --build-arg url=https://github.com/arkham02/maven-github-docker.git --build-arg project=maven-github-docker --build-arg artifactid=maven-github-docker --build-arg version=1.1 --tag nits0202/mvn-git-jar-docker --no-cache .
