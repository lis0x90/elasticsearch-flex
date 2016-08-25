FROM centos:7

ADD yum.repos.d /etc/yum.repos.d/

RUN rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch \
	&& yum -y install epel-release \
	&& yum -y install java-1.8.0-openjdk-headless elasticsearch wget \
	&& /usr/share/elasticsearch/bin/plugin install discovery-multicast \
	&& yum clean all 

VOLUME ["/data"]

EXPOSE 9200 9300 9300/udp 54328/udp
CMD ["/usr/share/elasticsearch/bin/elasticsearch"]
