#!/bin/sh

#项目路径，根据你的配置进行修改
projectDir="/Users/vincent/Documents/svn_huanqiu/dev_for_majiabao/tiku-ios_develop"

# 打包生成路径 需修改
ipaPath="/Users/vincent/Documents/auto_path/ipa"

# Provisioning Profile 需修改 查看本地配置文件
PROVISIONING_PROFILE=`/Users/vincent/Documents/自动批量打包/realm三部曲/parseProvision.sh`

# Project Name
projectName="tiku"

# 版本号
bundleVersion="1.0.0"

############# 重签名需要文件
# 以下文件需放在 ipaPath 路径下
Entitlements=$ipaPath/entitlements.plist

schemeName="TiKuForUniversal"

#资源文件夹
bundleSourcesPath="/Users/Harvey/Desktop/ArchievePods/bundleResource"


# Code Sign ID
#CODE_SIGN_IDENTITY="iOS Developer: 香港 杨 (Beijing Global Xingxue Technology Development Co., Ltd)"
CODE_SIGN_IDENTITY="iPhone Developer: YIN XIANG (6NNP32G68F)"
# xcodebuild -workspace 后生成 APP 路径
buildDir="build/Build/Products/Release-iphoneos"

# 创建打包目录
mkdir ${ipaPath}/AllPack


# 本地存放全部 IPA 的路径
allIPAPackPath="${ipaPath}/allPack"

# 清除缓存
rm -rf ${projectDir}/$buildDir

#build 生成app
echo "打包参数"
echo "${projectDir}.xcworkspace\n"
echo "${PROVISIONING_PROFILE}\n"
echo "$CODE_SIGN_IDENTITY"
echo "$PROVISIONING_PROFILE"

#xcodebuild -workspace ${projectDir}/${projectName}.xcworkspace \
#-scheme ${schemeName} \
#-sdk iphoneos \
#build CODE_SIGN_IDENTITY="${CODE_SIGN_IDENTITY}" \
#PROVISIONING_PROFILE="${PROVISIONING_PROFILE}" \
#-configuration Release \
#-derivedDataPath ${projectDir}/build


xcodebuild  \
-workspace ${projectDir}/${projectName}.xcworkspace \
-scheme ${schemeName} \
-configuration Release \
clean \
build \
-derivedDataPath ${projectDir}/build

if [[ $? = 0 ]]; then
echo "\033[31m 编译成功\n \033[0m"
else
echo "\033[31m 编译失败\n \033[0m"
fi

# 先创建 payload 文件夹
mkdir ${ipaPath}/Payload
# 移动编译生成的 app 到的 Payload 文件夹下
cp -Rf ${projectDir}/${buildDir}/${schemeName}.app ${ipaPath}/Payload
if [[ $? = 0 ]]; then
echo "\033[31m app移动成功\n \033[0m"
else
echo "\033[31m app移动失败\n \033[0m"
fi


# App Bundle Name (CFBundleName)
appName="建造师"

# App DisPlay Name
appDisplayName="建造师"

# App Icon Name
appIconName="byy"

# App Download Name
appDownloadName="IPA名字"

# App Bundle id
appBundleId="com.huanqiu.architect"

# 创建不同 app ipa 目录
mkdir $allIPAPackPath/$appName
rm -rf $allIPAPackPath/$appName/*

# 修改 Plist
defaults write ${ipaPath}/Payload/${schemeName}.app/info.plist "CFBundleName" $appName
defaults write ${ipaPath}/Payload/${schemeName}.app/info.plist "CFBundleDisplayName" $appDisplayName

defaults write ${ipaPath}/Payload/${schemeName}.app/info.plist "CFBundleIdentifier" $appBundleId
defaults write ${ipaPath}/Payload/${schemeName}.app/info.plist "Channel" $appDownloadName

if [[ $? = 0 ]]; then
echo "\033[31m 修改 Plist 成功\033[0m"
else
echo "\033[31m 修改 Plist 失败\033[0m"
fi

# 将对应的 资源文件（icon，lauchscreen，等资源文件） 复制到需要修改的 app 的目录下
#cp -Rf $bundleSourcesPath/* $ipaPath/Payload/${schemeName}.app   ###


if [[ $? = 0 ]]; then
echo "\033[31m 修改 icon 成功\033[0m"
else
echo "\033[31m 修改 icon 失败\033[0m"
fi

#重新签名

cd ${ipaPath}
SOURCEAPPFOLDER=${ipaPath}
DEVELOPER="${CODE_SIGN_IDENTITY}"
MOBILEPROV="${PROVISIONING_PROFILE}"
rootProvisionPath="/Users/vincent/Library/MobileDevice/Provisioning Profiles/"
TARGET=$appName # target ipa name(relative path)


APPLICATION=$(ls Payload/)

cp "$rootProvisionPath/$MOBILEPROV" "Payload/$APPLICATION/embedded.mobileprovision"

echo "Resigning with certificate: $DEVELOPER" >&2
find -d Payload  \( -name "*.app" -o -name "*.appex" -o -name "*.framework" -o -name "*.dylib" \) > directories.txt
security cms -D -i "Payload/$APPLICATION/embedded.mobileprovision" > t_entitlements_full.plist
/usr/libexec/PlistBuddy -x -c 'Print:Entitlements' t_entitlements_full.plist > t_entitlements.plist
#/usr/libexec/PlistBuddy -c 'Print:application-identifier' t_entitlements.plist > t_entitlements_application-identifier   #save developer application-identifier to file
#/usr/libexec/PlistBuddy -c 'Print:com.apple.developer.team-identifier' t_entitlements.plist > t_entitlements_com.apple.developer.team-identifier  #save com.apple.developer.team-identifier application-identifier to file
while IFS='' read -r line || [[ -n "$line" ]]; do
#/usr/bin/codesign -d --entitlements :-  "$line" > t_entitlements_original.plist    #save original entitlements from the app
#/usr/libexec/PlistBuddy -x -c 'Import application-identifier t_entitlements_application-identifier' t_entitlements_original.plist #overwrite application-identifier
#/usr/libexec/PlistBuddy -x -c 'Import com.apple.developer.team-identifier t_entitlements_com.apple.developer.team-identifier' t_entitlements_original.plist #overwrite com.apple.developer.team-identifier
/usr/bin/codesign --continue -f -s "$DEVELOPER" --entitlements "t_entitlements.plist"  "$line"
done < directories.txt

echo "Creating the Signed IPA"
xcrun -sdk iphoneos PackageApplication -v Payload/$APPLICATION  -o `pwd`/"$TARGET"
echo "Created ipa $TARGET"

rm -rf "extracted"
rm directories.txt
rm t_entitlements.plist
rm t_entitlements_full.plist
#rm t_entitlements_original.plist
#rm t_entitlements_application-identifier
#rm t_entitlements_com.apple.developer.team-identifier


#ios_resign_from_app_to_ipa app-extracted $Developer_code_sign $mobileprovision $target_ipa_related_path
## 重签名
#codesign -f -s "iPhone Distribution: Chengdu Bestwise Technology Co. Ltd (N*******A)"  --entitlements $Entitlements ${ipaPath}/Payload/${schemeName}.app
#if [[ $? = 0 ]]; then
#echo "\033[31m 签名成功\n \033[0m"
#else
#echo "\033[31m 签名失败\n \033[0m"
#fi
#
#
## 生成 ipa
#xcrun -sdk iphoneos -v PackageApplication ${ipaPath}/Payload/${schemeName}.app -o ${ipaPath}/$appDownloadName.ipa
##xcodebuild -exportArchive -archivePath ${ipaPath}/Payload/${schemeName}.app -exportPath ${ipaPath}/$appDownloadName.ipa -exportOptionsPlist '/Users/Harvey/Downloads/entitlements.plist'
#
#if [[ $? = 0 ]]; then
#echo "\033[31m \n 生成 IPA 成功 \n\n\n\n\n\033[0m"
#else
#echo "\033[31m \n 生成 IPA 失败 \n\n\n\n\n\033[0m"
#fi


# 移动


