#!/bin/sh

#  Script_upload.sh
#  realm三部曲
#
#  Created by vincentHK on 2018/2/9.
#  Copyright © 2018年 vincentHK. All rights reserved.
fir p "/Users/vincent/Documents/auto_path/Build/Products/Release-iphoneos/realm三部曲.ipa"
changelog=`cat $projectDir/README`
curl -X PUT --data "changelog=$changelog" http://fir.im/api/v2/app/5a7c1368959d692a9ea43b11?token=ee19875dcb941f0256c4c1a3224f3963
echo "\n打包上传更新成功！"
