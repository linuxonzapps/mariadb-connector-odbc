#!/bin/bash
set -e -o pipefail
read -ra arr <<< "$@"
version=${arr[1]}
trap 0 1 2 ERR
# Extract DISTRO details for tagging
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID-$VERSION_ID"
    if [ "$VERSION_CODENAME" != "" ]; then
        DISTRO="$ID-$VERSION_CODENAME"
    fi
fi
current_dir="$PWD"
echo $DISTRO > .distro_zab.txt
apt update; apt install sudo git -y
# Clone linux-on-ibm-z to keep it current
git clone https://github.com/linux-on-ibm-z/scripts.git /tmp/linux-on-ibm-z
bash /tmp/linux-on-ibm-z-scripts/MariaDB-Connector-ODBC/${version}/build_mariadb_connector_odbc.sh -y
cd mariadb-connector-odbc && make package
mv mariadb-connector-odbc-${version}-linux-s390x.tar.gz ${current_dir}
exit 0
