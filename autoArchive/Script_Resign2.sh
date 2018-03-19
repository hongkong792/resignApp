#!/usr/bin/env bash

#  Script_Resign2.sh
#  iOS自动打包签名
#
#  Created by vincentHK on 2018/3/12.
#  Copyright © 2018年 vincentHK. All rights reserved.


# 重签名
#[[ -d "$resultDir" ]] && rm -rdf "$resultDir"
#mkdir "$resultDir"
#echo [INFO] $downurl
#curl -O -k ${downurl} || { echo "curl failed"; exit 1; }
#[[ -d "$packName" ]] && rm -rdf $packName



currentDir="/Users/vincent/Documents/自动批量打包/iOS自动打包签名/auto"
newMobileProfile="/Users/vincent/Downloads/jiaozaokaodian.mobileprovision"
ipapath="/Users/vincent/Documents/auto_path/ipa"
#packName="/Users/vincent/Documents/auto_path/ipa"
cd $ipapath
packName="unzipDir"
unzip -q "TiKuForUniversal.zip" -d $packName

#修改plist
# App Bundle Name (CFBundleName)
appName="建造考点"

# App DisPlay Name
appDisplayName="建造考点"

# App Icon Name
appIconName="byy"

# App Download Name
appDownloadName="IPA名字"

# App Bundle id
appBundleId="com.huanqiu.jiaozaokaodian"

# 创建不同 app ipa 目录
mkdir $allIPAPackPath/$appName
rm -rf $allIPAPackPath/$appName/*

applicationName=$(ls -1 "$packName/Payload" | grep ".*\.app$" | head -n1)
# 修改 Plist
defaults write ${ipapath}/${packName}/Payload/${applicationName}/info.plist "CFBundleName" $appName
defaults write ${ipapath}/${packName}/Payload/${applicationName}/info.plist "CFBundleDisplayName" $appDisplayName

defaults write ${ipapath}/${packName}/Payload/${applicationName}/info.plist "CFBundleIdentifier" $appBundleId
defaults write ${ipapath}/${packName}/Payload/${applicationName}/info.plist "Channel" $appDownloadName

if [[ $? = 0 ]]; then
echo "\033[31m 修改 Plist 成功\033[0m"
else
echo "\033[31m 修改 Plist 失败\033[0m"
fi

cp -rf "resource"/* ${packName}/Payload/${applicationName}
if [[ $? = 0 ]]; then
echo "\033[31m 资源替换 成功\033[0m"
else
echo "\033[31m 资源替换 失败\033[0m"
fi
bundleid=$appBundleId

ipa_swift_frameworks=`find ${packName}/Payload/${applicationName}/Frameworks/ -name "libswift*" 2> /dev/null || true`
if [[ -n ${ipa_swift_frameworks} ]]; then
for LINE in ${ipa_swift_frameworks}
do
echo "rm $LINE"
rm $LINE
done
fi

if [ ! -f "newMobileProfile.plist" ];then
  touch newMobileProfile.plist
  chmod 775 newMobileProfile.plist
  tempPlist="newMobileProfile.plist"
fi


`openssl smime -inform der -verify -noverify -in ${newMobileProfile} > ${tempPlist}`
teamName=$(/usr/libexec/PlistBuddy -c 'Print :TeamName' ${tempPlist})


#codeSignIdentify="iPhone Distribution: $teamName"
codeSignIdentify="iPhone Developer: YIN XIANG (6NNP32G68F)"
echo "codeSignIdentify=${codeSignIdentify}"

`openssl smime -inform der -verify -noverify -in ${newMobileProfile} > new_${packName}_ENTITLEMENTS.entitlements`
/usr/libexec/PlistBuddy -x -c "print :Entitlements" new_${packName}_ENTITLEMENTS.entitlements



codesign -d --entitlements :- ${packName}/Payload/${applicationName} > temp_${packName}_ENTITLEMENTS.plist
python $currentDir/update-entitlements-data.py temp_${packName}_ENTITLEMENTS.plist new_${packName}_ENTITLEMENTS.entitlements
rm -r ${packName}/Payload/${applicationName}/_CodeSignature

/usr/libexec/PlistBuddy -c "Set CFBundleIdentifier ${bundleid}" ${packName}/Payload/${applicationName}/Info.plist
/usr/libexec/PlistBuddy -c "Set CFBundleName $appName" ${packName}/Payload/${applicationName}/Info.plist
/usr/libexec/PlistBuddy -c "Set CFBundleDisplayName ${appDisplayName}" ${packName}/Payload/${applicationName}/Info.plist
#/usr/libexec/PlistBuddy -c "Set Channel ${Channel}" ${packName}/Payload/${applicationName}/Info.plist


cp ${newMobileProfile} ${packName}/Payload/${applicationName}/embedded.mobileprovision



#ipa_plugins=`find ${packName}/Payload/${applicationName}/PlugIns -name "notificationService.appex" 2> /dev/null || true`
#if [[ -n ${ipa_plugins} ]]; then
#for LINE in ${ipa_plugins}
#do
#identifier=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' $LINE/Info.plist)
#pluginName=notificationService
#new_identifier="${bundleid}.${pluginName}"
#echo "new_identifier=$new_identifier"
#pluginMobileProfile=$(find ${HOME}/ProvisioningProfiles -name "*_${new_identifier}.mobileprovision")
##pluginTeamName=$(/usr/libexec/PlistBuddy -c 'Print :TeamName' /dev/stdin <<< $(security cms -D -i "${pluginMobileProfile}"))
##plugincodeSignIdentify="iPhone Distribution: $pluginTeamName"
##echo "plugincodeSignIdentify=${plugincodeSignIdentify}"
#
#`openssl smime -inform der -verify -noverify -in ${pluginMobileProfile} > new_${pluginName}_ENTITLEMENTS.entitlements`
#/usr/libexec/PlistBuddy -x -c "print :Entitlements" new_${pluginName}_ENTITLEMENTS.entitlements
#codesign -d --entitlements :- ${LINE} > temp_${pluginName}_ENTITLEMENTS.plist
#echo "rm $LINE/_CodeSignature"
#rm -r $LINE/_CodeSignature
#/usr/libexec/PlistBuddy -c "Set CFBundleIdentifier ${new_identifier}" $LINE/Info.plist
#cp ${pluginMobileProfile} ${LINE}/embedded.mobileprovision
#/usr/bin/codesign -f -s "${codeSignIdentify}" --identifier "${new_identifier}" --entitlements "new_${pluginName}_ENTITLEMENTS.entitlements" "${LINE}"
#done
#fi

find -d ${packName}  \( -name "*.app" -o -name "*.appex" -o -name "*.framework" -o -name "*.dylib" \) > directories.txt
`openssl smime -inform der -verify -noverify -in ${newMobileProfile} > t_entitlements_full.plist`
/usr/libexec/PlistBuddy -x -c 'Print:Entitlements' t_entitlements_full.plist > t_entitlements.plist
#/usr/libexec/PlistBuddy -c 'Print:application-identifier' t_entitlements.plist > t_entitlements_application-identifier   #save developer application-identifier to file
#/usr/libexec/PlistBuddy -c 'Print:com.apple.developer.team-identifier' t_entitlements.plist > t_entitlements_com.apple.developer.team-identifier  #save com.apple.developer.team-identifier application-identifier to file
while IFS='' read -r line || [[ -n "$line" ]]; do
#/usr/bin/codesign -d --entitlements :-  "$line" > t_entitlements_original.plist    #save original entitlements from the app
#/usr/libexec/PlistBuddy -x -c 'Import application-identifier t_entitlements_application-identifier' t_entitlements_original.plist #overwrite application-identifier
#/usr/libexec/PlistBuddy -x -c 'Import com.apple.developer.team-identifier t_entitlements_com.apple.developer.team-identifier' t_entitlements_original.plist #overwrite com.apple.developer.team-identifier
/usr/bin/codesign --continue -f -s "$codeSignIdentify" --entitlements "t_entitlements.plist"  "$line"
done < directories.txt

echo "Creating the Signed IPA"
cd $packName
zip -qry ../jiaozaokaodian_.ipa *
cd ..
#mv extracted.ipa "$TARGET"


#ipa_frameworks=`find ${packName}/Payload/${applicationName}/Frameworks/ -name "*.framework" 2> /dev/null || true`
#if [[ -n ${ipa_frameworks} ]]; then
#for LINE in ${ipa_frameworks}
#do
#echo "rm $LINE/_CodeSignature"
#rm -r $LINE/_CodeSignature
#echo "frame路径:\n"
#echo $LINE
#identifier=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' $LINE/Info.plist)
#/usr/bin/codesign -f -s "${codeSignIdentify}" --identifier "${identifier}" --entitlements "new_${packName}_ENTITLEMENTS.entitlements" "${LINE}"
#done
#fi



#/usr/bin/codesign -f -s "${codeSignIdentify}" --identifier "${bundleid}" --entitlements "new_${packName}_ENTITLEMENTS.entitlements" "${packName}/Payload/${applicationName}"
#newIpaName="_jianzoakaodian"
#pushd $packName &&  zip -qr ${newIpaName}.ipa Payload
#popd
#mv ${packName}/${newIpaName}.ipa ${packName}


rm -rf new_${packName}_ENTITLEMENTS.entitlements
rm -rf temp_${packName}_ENTITLEMENTS.plist
rm -rf new_${packName}_ENTITLEMENTS.entitlements

