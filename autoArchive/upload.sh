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



if $is_uploadfir ; then
fir login -T $upload_token       # fir.im token
fir publish $export_ipa_path/$ipa_name.ipa
fi
