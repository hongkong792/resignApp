#!/bin/sh

#  parseProvision.sh
#  realm三部曲
#
#  Created by vincentHK on 2018/3/5.
#  Copyright © 2018年 vincentHK. All rights reserved.
#provision_profile_file_path="/Users/vincent/Library/MobileDevice/Provisioning Profiles/4dd485c5-7092-46e0-8c1b-4ba28b2ef19a.mobileprovision"

function findMobileProvision()
{

    rootpath="/Users/vincent/Library/MobileDevice/Provisioning Profiles/"
    cd "$rootpath"
    output_plist_file="/Users/vincent/Documents/auto_path/test.plist"
#    echo provision_profile_file_path

    for file in *  # ./
    do
    if test -f $file
    then
    #echo $file 文件
    `openssl smime -inform der -verify -noverify -in $file > $output_plist_file`
    applicationidentifier=$(/usr/libexec/PlistBuddy -c 'Print :Entitlements:application-identifier' $output_plist_file)
    #bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" ${output_plist_file})
    #bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" ${output_plist_file})
    #    if [[ $applicationidentifier =~ “com.edu24ol.TiKuForAccountant” ]]
        result=$(echo $applicationidentifier | grep "com.huanqiu.architect")
        if [[ "$result" != "" ]]
        then
#             echo $applicationidentifier
             echo $file
#             echo "找到了签名文件" #使用该profile文件签名
# echo $file
             break

        else
              echo ""
        fi
    else
    echo $file #是目录
    fi
    done
}

ret=`findMobileProvision`

echo "${ret}"
#main()
#{
#  `findMobileProvision`
#}
#main

# Clear
exit  0
