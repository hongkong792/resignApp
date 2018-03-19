#!/bin/sh

#  parseProvision.sh
#  realm三部曲
#
#  Created by vincentHK on 2018/3/5.
#  Copyright © 2018年 vincentHK. All rights reserved.
#provision_profile_file_path="/Users/vincent/Library/MobileDevice/Provisioning Profiles/4dd485c5-7092-46e0-8c1b-4ba28b2ef19a.mobileprovision"

function findMobileProvision()
{

    flag=0
#    rootpath="/Users/vincent/Library/MobileDevice/Provisioning Profiles/"
    rootpath=$1
#    echo "路径：："$rootpath

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
        result=$(echo $applicationidentifier | grep "com.huanqiu.jiaozaokaodian")
        if [[ "$result" != "" ]]
        then
#             echo $applicationidentifier
#              fstr=`echo $file | cut -d \. -f 1`
#              echo $fstr
              echo ${rootpath}/${file}
              flag=1
#             echo "找到了签名文件" #使用该profile文件签名
#             echo $file
             break

#        else
#              echo ""
        fi
#    else
#      echo $file #是目录
    fi
    done


}

#rootpath="/Users/vincent/Library/MobileDevice/Provisioning Profiles/"
#ret=`findMobileProvision "${rootpath}"`
#if [ -z "$ret" ]
#then
#  rootpath="/Users/vincent/Documents/auto_path/mobileprovision"
  ret=`findMobileProvision "${rootpath}"`
#fi
echo "${ret}"
#main()
#{
#  `findMobileProvision`
#}
#main

# Clear
exit  0
