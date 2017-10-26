#!/bin/bash

##########################
## Java utilities
##########################

function java_enableMD5 {
  _info "Enabling MD5 on ${JAVA_HOME}/jre/lib/security/java.security"
  if [ ! -f ${JAVA_HOME}/jre/lib/security/java.security.ORIGINAL ] ;then
    cp -v ${JAVA_HOME}/jre/lib/security/java.security ${JAVA_HOME}/jre/lib/security/java.security.ORIGINAL
  fi
  sed -i 's/^jdk.certpath.disabledAlgorithms=.*/jdk.certpath.disabledAlgorithms=MD2, RSA keySize < 1024/' ${JAVA_HOME}/jre/lib/security/java.security
  sed -i 's/^jdk.tls.disabledAlgorithms=.*/jdk.tls.disabledAlgorithms=SSLv3, RC4, DH keySize < 768/'      ${JAVA_HOME}/jre/lib/security/java.security
}            

function java_disableMD5 {
  _info "Disabling MD5 on ${JAVA_HOME}/jre/lib/security/java.security"
  if [ -f ${JAVA_HOME}/jre/lib/security/java.security.ORIGINAL ] ;then
    cp -v ${JAVA_HOME}/jre/lib/security/java.security.ORIGINAL ${JAVA_HOME}/jre/lib/security/java.security
  else
    _error could not find ${JAVA_HOME}/jre/lib/security/java.security.ORIGINAL
  fi
}            
