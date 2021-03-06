#!/bin/bash
echo ${SAMBADA_VERSION} ${SAMBADA_OS_NAME}
PACKAGE_NAME=sambada-${SAMBADA_VERSION}-${SAMBADA_OS_NAME}
wget "https://github.com/Sylvie/sambada/releases/download/v${SAMBADA_VERSION}/${PACKAGE_NAME}.tar.gz"
tar -zxvf $PACKAGE_NAME.tar.gz
if [ "${SAMBADA_TEST_TYPE}" = "SMOKE" ]; then
  cd ${PACKAGE_NAME}/examples/subset-cattle-SNP
  time ../../binaries/sambada param-cattle.txt cattle-env.csv cattle-mark.txt
  head  cattle-mark-Out-1.txt
else
  ARCHIVE_NAME=sambada-${SAMBADA_VERSION}
  wget "https://github.com/Sylvie/sambada/releases/download/v${SAMBADA_VERSION}/${ARCHIVE_NAME}.zip"
  unzip ${ARCHIVE_NAME}.zip
  mkdir ${ARCHIVE_NAME}/build/
  cd ${ARCHIVE_NAME}/build/
  ../configure sambadahostsystemname=${SAMBADA_OS_NAME} --disable-manual
  make test/integration/SambadaIntegrationTests
  ln -s ../../${PACKAGE_NAME}/binaries/ binaries
  time test/integration/SambadaIntegrationTests
fi
