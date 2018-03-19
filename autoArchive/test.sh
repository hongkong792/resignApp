#!/bin/sh

#  test.sh
#  realm三部曲
#
#  Created by vincentHK on 2018/3/6.
#  Copyright © 2018年 vincentHK. All rights reserved.

#hello=`/Users/vincent/Documents/自动批量打包/realm三部曲/parseProvision.sh`
#echo "yyyyyyyy"
#echo $hello


projectDir="/Users/vincent/Documents/svn_huanqiu/dev_for_majiabao/tiku-ios_develop"
PODS_ROOT="$projectDir/Pods"
echo $PODS_ROOT
diff "${PODS_ROOT}/../Podfile.lock" "${PODS_ROOT}/Manifest.lock" > /dev/null
if [[ $? != 0 ]] ; then
#cat << EOM
#error: The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation.
#EOM
#exit 1
#pod install --verbose
echo "they are not common"
fi
