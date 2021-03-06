#!/usr/bin/env bash

set -x

# Show current version of C_R_Y_P_T_O_P_R_0... >_<

CSP_VERSION=$(cat /etc/opt/cprocsp/release | awk '{print $4}')

# Download CADES Plugin

# https://cryptopro.ru/system/files/private/csp/50/11944/ru.cryptopro.csp-5.0.11944.dmg

CSP_DMG="ru.cryptopro.csp-5.0.11944.pkg"
CSP_PLUGIN="cprocsp-pki-2.0.14071.pkg"
IFC_PLUGIN="IFCPlugin.pkg"

# curl -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36' \
#   -sLo "/tmp/$CSP_DMG" \
#   -XGET "https://cryptopro.ru/system/files/private/csp/50/11944/$CSP_DMG"

# curl \
#   -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36' \
#   -XGET 'https://cryptopro.ru/products/cades/plugin/get_2_0' \
#   -o '~/Downloads/cprocsp.dmg'

# Download CADES Plugin

# curl -s "https://cryptopro.ru/products/cades/plugin/get_2_0" -o "./vendor/$CSP_PLUGIN"

# Download IFC Plugin / gosuslugi.ru

# curl -s "https://ds-plugin.gosuslugi.ru/plugin/upload/assets/distrib/IFCPlugin.pkg" -o "./vendor/IFCPlugin.pkg"

# Download Chromium GOST

CHROMIUM_GOST_VERSION="87.0.4280.66"

curl -s "https://github.com/deemru/chromium-gost/releases/download/$CHROMIUM_GOST_VERSION/chromium-gost-$CHROMIUM_GOST_VERSION-macos-amd64.tar.bz2" -o "./vendor/chromium-gost.tar.bz2"

bzip2 -d ./vendor/chromium-gost.tar.bz2
tar -xvf ./vendor/chromium-gost.tar

# Install C_R_Y_P_T_O_P_R_0... >_< and others

# open '~/Downloads/cprocsp.dmg'
# open '~/Downloads/IFCPlugin.pkg'

open ./vendor/uninstall_csp.app

sudo installer -pkg "./vendor/$CSP_DMG" -target /
sudo installer -pkg "./vendor/$CSP_PLUGIN" -target /
sudo installer -pkg "./vendor/$IFC_PLUGIN" -target /

########
## @TODO This shit is not completed right here.
########

# Fix incorrect config files

sudo rm '/Library/Internet Plug-Ins/IFCPlugin.plugin/Contents/ifc.cfg'
sudo cp './ifc.cfg' '/Library/Internet Plug-Ins/IFCPlugin.plugin/Contents'

sudo cp '/Library/Google/Chrome/NativeMessagingHosts/ru.rtlabs.ifcplugin.json' '/Library/Application Support/Chromium/NativeMessagingHosts'

# Add OIDs

sudo /opt/cprocsp/sbin/cpconfig -ini '\cryptography\OID\1.2.643.7.1.1.1.1!3' -add string 'Name' 'GOST R 34.10-2012 256 bit'
sudo /opt/cprocsp/sbin/cpconfig -ini '\cryptography\OID\1.2.643.7.1.1.1.2!3' -add string 'Name' 'GOST R 34.10-2012 512 bit'

# Add CA's certs

# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/4BC6DC14D97010C41A26E058AD851F81C842415A.cer
# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/8CAE88BBFD404A7A53630864F9033606E1DC45E2.cer
# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/0408435EB90E5C8796A160E69E4BFAC453435D1D.cer
# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/460B97F34AF1AA20C31467A30203DB755F1FDF36.cer
# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/3BE756196B4AB2918B53BE72DED2D36AB87DD1E6.cer
# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/E64464F8A6BD6E3E6A68B82A563B942B2FC2EDFE.cer
# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/91C2A8AC26DE616FFF487A75C5343DD8A05032FB.cer
# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/2ADB1DE3CA137D0761AB6F0739DAC43707563440.cer
# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/75EBEEC60D23DDA6606351A020F9FB614755746E.cer
# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/7FBBA5122D382BA7CABE64B25C2922C6B5D1B329.cer
# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/580A4F8BC58AA5D37A4C433A580EC9AAFF6EB8E3.cer
# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/5FF9F207B82627CE94F415E59E9017EB496C4989.cer
# sudo /opt/cprocsp/bin/certmgr -inst -store mroot -f ./ca-certs/AA524A7440E5365D6812016F74C54E516641A18D.cer

# cat /etc/opt/cprocsp/config.ini | iconv -f windows-1251 -t utf-8

/opt/cprocsp/bin/csptestf -absorb -certs
/opt/cprocsp/bin/csptest -oid -general
/opt/cprocsp/bin/csptest -card -enum -v -v