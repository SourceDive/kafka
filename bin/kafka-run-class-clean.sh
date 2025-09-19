#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ $# -lt 1 ];
then
  echo "USAGE: $0 [-daemon] [-name servicename] [-loggc] classname [opts]"
  exit 1
fi

if [ -z "$INCLUDE_TEST_JARS" ]; then
  INCLUDE_TEST_JARS=false
fi

# Exclude jars not necessary for running commands.
regex="(-(test|src|scaladoc|javadoc)\.jar|jar.asc)$"
should_include_file() {
  if [ "$INCLUDE_TEST_JARS" = true ]; then
    return 0
  fi
  file=$1
  if [ -z "$(echo "$file" | egrep "$regex")" ] ; then
    return 0
  else
    return 1
  fi
}

base_dir=$(dirname $0)/..

if [ -z "$SCALA_VERSION" ]; then
	SCALA_VERSION=2.10.6
fi

if [ -z "$SCALA_BINARY_VERSION" ]; then
	SCALA_BINARY_VERSION=2.10
fi

# run ./gradlew copyDependantLibs to get all dependant jars in a local dir
shopt -s nullglob
for dir in "$base_dir"/core/build/dependant-libs-${SCALA_VERSION}*;
do
  if [ -z "$CLASSPATH" ] ; then
    CLASSPATH="$dir/*"
  else
    CLASSPATH="$CLASSPATH:$dir/*"
  fi
done

for file in "$base_dir"/examples/build/libs/kafka-examples*.jar;
do
  if should_include_file "$file"; then
    CLASSPATH="$CLASSPATH":"$file"
  fi
done

for file in "$base_dir"/clients/build/libs/kafka-clients*.jar;
do
  if should_include_file "$file"; then
    CLASSPATH="$CLASSPATH":"$file"
  fi
done

for file in "$base_dir"/streams/build/libs/kafka-streams*.jar;
do
  if should_include_file "$file"; then
    CLASSPATH="$CLASSPATH":"$file"
  fi
done

for file in "$base_dir"/streams/examples/build/libs/kafka-streams-examples*.jar;
do
  if should_include_file "$file"; then
    CLASSPATH="$CLASSPATH":"$file"
  fi
done

for file in "$base_dir"/streams/build/dependant-libs-${SCALA_VERSION}/rocksdb*.jar;
do
  CLASSPATH="$CLASSPATH":"$file"
done

for file in "$base_dir"/tools/build/libs/kafka-tools*.jar;
do
  if should_include_file "$file"; then
    CLASSPATH="$CLASSPATH":"$file"
  fi
done

for dir in "$base_dir"/tools/build/dependant-libs-${SCALA_VERSION}*;
do
  CLASSPATH="$CLASSPATH:$dir/*"
done

for cc_pkg in "api" "runtime" "file" "json" "tools"
do
  for file in "$base_dir"/connect/${cc_pkg}/build/libs/connect-${cc_pkg}*.jar;
  do
    if should_include_file "$file"; then
      CLASSPATH="$CLASSPATH":"$file"
    fi
  done
  if [ -d "$base_dir/connect/${cc_pkg}/build/dependant-libs" ] ; then
    CLASSPATH="$CLASSPATH:$base_dir/connect/${cc_pkg}/build/dependant-libs/*"
  fi
done

# classpath addition for release
for file in "$base_dir"/libs/*;
do
  if should_include_file "$file"; then
    CLASSPATH="$CLASSPATH":"$file"
  fi
done

for file in "$base_dir"/core/build/libs/kafka_${SCALA_BINARY_VERSION}*.jar;
do
  if should_include_file "$file"; then
    CLASSPATH="$CLASSPATH":"$file"
  fi
done
shopt -u nullglob

# JMX settings
if [ -z "$KAFKA_JMX_OPTS" ]; then
  KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false  -Dcom.sun.management.jmxremote.ssl=false "
fi

# JMX port to use
if [  $JMX_PORT ]; then
  KAFKA_JMX_OPTS="$KAFKA_JMX_OPTS -Dcom.sun.management.jmxremote.port=$JMX_PORT "
fi

# Log directory to use
if [ "x$LOG_DIR" = "x" ]; then
    LOG_DIR="$base_dir/logs"
fi

# Log4j settings
if [ -z "$KAFKA_LOG4J_OPTS" ]; then
  KAFKA_LOG4J_OPTS="-Dlog4j.configuration=file:$base_dir/config/tools-log4j.properties"
fi

# Add log4j settings for tools
KAFKA_LOG4J_OPTS="$KAFKA_LOG4J_OPTS -Dlog4j.configuration=file:$base_dir/config/tools-log4j.properties"

# Add SLF4J warning suppression
KAFKA_LOG4J_OPTS="$KAFKA_LOG4J_OPTS -Dorg.slf4j.simpleLogger.defaultLogLevel=warn"
KAFKA_LOG4J_OPTS="$KAFKA_LOG4J_OPTS -Dorg.slf4j.simpleLogger.showDateTime=false"
KAFKA_LOG4J_OPTS="$KAFKA_LOG4J_OPTS -Dorg.slf4j.simpleLogger.showThreadName=false"
KAFKA_LOG4J_OPTS="$KAFKA_LOG4J_OPTS -Dorg.slf4j.simpleLogger.showLogName=false"

# JVM performance options
if [ -z "$KAFKA_JVM_PERFORMANCE_OPTS" ]; then
  KAFKA_JVM_PERFORMANCE_OPTS="-server -XX:+UseG1GC -XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35 -XX:+ExplicitGCInvokesConcurrent -XX:MaxInlineLevel=15 -Djava.awt.headless=true"
fi

# GC options
if [ -z "$KAFKA_GC_LOG_OPTS" ]; then
  KAFKA_GC_LOG_OPTS="-Xloggc:$LOG_DIR/kafkaServer-gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps"
fi

# Memory options
if [ -z "$KAFKA_HEAP_OPTS" ]; then
  KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"
fi

# JVM options
if [ -z "$KAFKA_OPTS" ]; then
  KAFKA_OPTS=""
fi

# Add SLF4J warning suppression to KAFKA_OPTS
KAFKA_OPTS="$KAFKA_OPTS -Dorg.slf4j.simpleLogger.defaultLogLevel=warn"
KAFKA_OPTS="$KAFKA_OPTS -Dorg.slf4j.simpleLogger.showDateTime=false"
KAFKA_OPTS="$KAFKA_OPTS -Dorg.slf4j.simpleLogger.showThreadName=false"
KAFKA_OPTS="$KAFKA_OPTS -Dorg.slf4j.simpleLogger.showLogName=false"

# Set JAVA if not set
if [ -z "$JAVA" ]; then
  JAVA="java"
fi

# Launch mode
if [ "x$DAEMON_MODE" = "xtrue" ]; then
  nohup $JAVA $KAFKA_HEAP_OPTS $KAFKA_JVM_PERFORMANCE_OPTS $KAFKA_GC_LOG_OPTS $KAFKA_JMX_OPTS $KAFKA_LOG4J_OPTS $KAFKA_OPTS -cp $CLASSPATH $@ > "$LOG_DIR/server.out" 2>&1 < /dev/null &
else
  exec $JAVA $KAFKA_HEAP_OPTS $KAFKA_JVM_PERFORMANCE_OPTS $KAFKA_GC_LOG_OPTS $KAFKA_JMX_OPTS $KAFKA_LOG4J_OPTS $KAFKA_OPTS -cp $CLASSPATH $@
fi
