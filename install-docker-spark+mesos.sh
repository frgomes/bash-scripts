#!/bin/bash -x

function install_spark_mesos {

  local apache=$HOME/sources/github.com/apache
  local zeppelin=${apache}/zeppelin
  local tag=v0.7.1

#  if [ -d ${zeppelin} ] ;then
#    pushd ${zeppelin}
#    git pull
#  else
#    mkdir -p ${apache} && pushd ${apache}
#    git clone http://github.com/apache/zeppelin
#    pushd ${zeppelin}
#  fi

#  git checkout ${tag}
#  git reset --hard

#  cd scripts/docker/spark-cluster-managers/spark_mesos

  pushd $HOME/scripts/install-docker-spark+mesos
  echo docker build \
           --build-arg SPARK_VERSION=$SPARK_VERSION \
           --build-arg SPARK_PROFILE=$SPARK_PROFILE \
           --build-arg HADOOP_VERSION=$HADOOP_VERSION \
           --build-arg HADOOP_PROFILE=$HADOOP_PROFILE \
           -t "spark_mesos" .
  popd

  [[ ! -d /opt/bin ]] && mkdir -p /opt/bin

  cat << EOD > /opt/bin/spark_mesos.sh
#!/bin/bash -x

docker run -it \
  --net=host   \
  -p 8080:8080 \
  -p 7077:7077 \
  -p 8888:8888 \
  -p 8081:8081 \
  -p 8082:8082 \
  -p 5050:5050 \
  -p 5051:5051 \
  -p 4040:4040 \
  -h \$( hostname ) \
  --name spark_mesos \
  spark_mesos bash;
EOD

  chmod 755 /opt/bin/zeppelin.sh
}


install_spark_mesos
