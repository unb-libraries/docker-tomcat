FROM unblibraries/jdk:oracle8
MAINTAINER Jacob Sanford <jsanford_at_unb.ca>

ENV WAYBACK_HOST localhost

ENV JAVA_MAJOR_VERSION 8
ENV TOMCAT_VERSION 7.0.64
ENV TOMCAT_MAJOR_VERSION 7
ENV TOMCAT_NATIVE_VERSION 1.1.33
ENV APR_VERSION 1.5.2
ENV JAVA_OPTS="-Djava.awt.headless=true -Xmx128M"

ENV TOMCAT_USER tomcat${TOMCAT_MAJOR_VERSION}
ENV APP_INSTALL_ROOT /var/opt
ENV CATALINA_HOME ${APP_INSTALL_ROOT}/apache-tomcat-${TOMCAT_VERSION}
ENV TOMCAT_BIN_PATH ${CATALINA_HOME}/bin
ENV TOMCAT_WEBAPPS_PATH ${CATALINA_HOME}/webapps
ENV JRE_HOME /usr/lib/jvm/java-${JAVA_MAJOR_VERSION}-oracle/jre

ENV APR_ARCHIVE_FILENAME apr-${APR_VERSION}.tar.gz  
ENV APR_DOWNLOAD_URL http://apache.sunsite.ualberta.ca/apr/${APR_ARCHIVE_FILENAME}
ENV TOMCAT_ARCHIVE_FILENAME apache-tomcat-${TOMCAT_VERSION}.tar.gz
ENV TOMCAT_DOWNLOAD_URL http://apache.mirror.gtcomm.net/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_VERSION}/bin/${TOMCAT_ARCHIVE_FILENAME}

# Install required packages.
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes
RUN apt-get update && \
  apt-get install -y git build-essential

# Setup install path.
RUN mkdir -p ${APP_INSTALL_ROOT}
WORKDIR ${APP_INSTALL_ROOT}

RUN wget ${APR_DOWNLOAD_URL} && tar xvzpf ${APR_ARCHIVE_FILENAME}
WORKDIR ${APP_INSTALL_ROOT}/apr-${APR_VERSION}
RUN ./configure && \
  make && \
  make test && \
  make install && \
  make clean

# Download Tomcat and extract.
WORKDIR ${APP_INSTALL_ROOT}
RUN wget ${TOMCAT_DOWNLOAD_URL} && tar xvzpf ${TOMCAT_ARCHIVE_FILENAME}

# Compile tomcat native libs and install, while disabling SSL.
WORKDIR ${TOMCAT_BIN_PATH}
RUN tar xvzpf tomcat-native.tar.gz
WORKDIR ${TOMCAT_BIN_PATH}/tomcat-native-${TOMCAT_NATIVE_VERSION}-src/jni/native
RUN ./configure --with-apr=/usr/local/apr --without-ssl --with-java-home=$JAVA_HOME
RUN make && \
  cp .libs/libtcnative-1.so /usr/lib && \
  make clean
RUN sed -i -e 's|Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="on"|Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="off"|g' ${CATALINA_HOME}/conf/server.xml

# Add phusion inits.
CMD ["/sbin/my_init"]
ADD services/ /etc/service/
RUN chmod -v +x /etc/service/*/run

# Add running user
RUN useradd -u 918 -U -s /bin/false ${TOMCAT_USER} && \
  usermod -G users ${TOMCAT_USER} && \
  chown -R ${TOMCAT_USER}:users ${APP_INSTALL_ROOT}

# Clean up.
RUN apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8080
