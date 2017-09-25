#!/bin/bash

function paths_flink {
  paths $KAFKA_HOME/bin $FLINK_HOME/bin
}

function paths_spark {
  paths $KAFKA_HOME/bin $SPARK_HOME/bin
}
