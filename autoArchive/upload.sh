#!/bin/sh

#  upload.sh
#  iOS自动打包签名
#
#  Created by vincentHK on 2018/3/19.
#  Copyright © 2018年 vincentHK. All rights reserved.

#上传到蒲公英
#蒲公英aipKey
#APIKEY="5aa79661959d6976c4c70b2b"
##蒲公英uKey
#UKEY="745cxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
#
#echo "--------蒲公英${output_ipa_dir}/${UPLOAD_IPA_NAME}---------"
#
#curl -F "file=@${output_ipa_dir}/${UPLOAD_IPA_NAME}" \
#-F "uKey=${UKEY}" \
#-F "_api_key=${APIKEY}" \
#https://www.pgyer.com/apiv1/app/upload



#if $is_uploadfir ; then
#fir login -T ee19875dcb941f0256c4c1a3224f3963      # fir.im token
#fir publish /Users/vincent/Documents/auto_path/ipa/TiKuForUniversal_debug_24.ipa
#fi


APPID="leiji117512@yeah.net"
APPPASSWORD="cnhs-ridn-qkzz-tloq"
ALTOOLPATH="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"

##上传到appstore
#验证信息
"${ALTOOLPATH}" --validate-app -f /Users/vincent/Documents/auto_path/ipa/TiKuForUniversal_destribute_24.ipa -u "${APPID}" -p "${APPPASSWORD}" --output-format xml
#上传iTunesConnect
"${ALTOOLPATH}" --upload-app -f /Users/vincent/Documents/auto_path/ipa/TiKuForUniversal_destribute_24.ipa -u "${APPID}" -p "${APPPASSWORD}" --output-format xml
