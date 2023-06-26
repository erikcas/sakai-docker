FROM maven:3.8.6-jdk-11 as build

# Work around a bug in Java 1.8u181 / the Maven Surefire plugin.
# See https://stackoverflow.com/questions/53010200 and
# https://issues.apache.org/jira/browse/SUREFIRE-1588.
ENV JAVA_TOOL_OPTIONS "-Djdk.net.URLClassPath.disableClassPathURLCheck=true"

ARG release=22.1

# Build Sakai.
RUN git clone https://github.com/sakaiproject/sakai.git
WORKDIR sakai
RUN git checkout ${release}

# nb. Skip tests to speed up the container build.
RUN mvn clean install -Dmaven.test.skip=true -DskipTests

# Download and install Apache Tomcat.
RUN mkdir -p /opt/tomcat
RUN curl "https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.76/bin/apache-tomcat-9.0.76.tar.gz" > /opt/tomcat/tomcat.tar.gz
RUN tar -C /opt/tomcat -xf /opt/tomcat/tomcat.tar.gz --strip-components 1

# Configure Tomcat.
# See https://confluence.sakaiproject.org/display/BOOT/Install+Tomcat+8
ENV CATALINA_HOME /opt/tomcat
COPY context.xml /opt/tomcat/conf/
COPY server.xml /opt/tomcat/conf/
# Install web app.
RUN mvn sakai:deploy -Dmaven.tomcat.home=/opt/tomcat

FROM openjdk:11

# Copy Sakai configuration.
COPY sakai.properties /opt/tomcat/sakai/

# Copy Sakai and Tomcat.
COPY --from=build /opt/tomcat /opt/tomcat

# Run Sakai
EXPOSE 8080
WORKDIR /opt/tomcat/bin
CMD ./startup.sh && tail -f ../logs/catalina.out
