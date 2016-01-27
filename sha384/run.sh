#!/bin/sh
set -e

if [ "${OS}" == "Windows_NT" ]; then
  JDK="c:\\Program Files (x86)\\Java\\jre7\\lib\\rt.jar"
else
  JDK=`(java -verbose 2>&1) | grep Opened | head -1 | cut -d ' ' -f 2 | cut -d ']' -f 1`
fi
${SAW:-../bin/saw} -j "${JDK}" -j core-1.51-b08.jar sha384.saw
