#! /bin/bash

project_path=$(dirname $0)

project_config=Release

output_path=~/Desktop

build_scheme=realm三部曲

workspace_name=realm三部曲

parameter=":p:c:o:s:w:h:"

while getopts $parameter optname
do
case "$optname" in
"p" )
project_path=$OPTARG
;;
"c" )
project_config=$OPTARG
;;
"o" )
output_path=$OPTARG
;;
"s" )
build_scheme=$OPTARG
;;
"w" )
workspace_name=$OPTARG
;;
"h" )
echo " -p 项目路径，默认为当前路径"
echo " -c 定制版配置名称，默认为Release"
echo " -o 打包输出路径，默认为桌面"
echo " -s 打包使用策略，默认为YKTicketsApp"
echo " -w 打包workspace名，默认为YKTicketsApp"
exit 20
;;
*     )
echo " 无效参数"
echo " -p 项目路径，默认为当前路径"
echo " -c 定制版配置名称，默认为Release"
echo " -o 打包输出路径，默认为桌面"
echo " -s 打包使用策略，默认为YKTicketsApp"
echo " -w 打包workspace名，默认为YKTicketsApp"
exit 21
;;
esac
done

workspace_file="${project_path}/${workspace_name}.xcworkspace"

date_time="$(date +"%Y%m%d_%H%M%S")"

archive_file="${output_path}/${date_time}_${project_config}.xcarchive"

ipa_file="${output_path}/${date_time}_${project_config}.ipa"

#cd $project_path

#pod_cmd='pod update --verbose --no-repo-update'

#$pod_cmd

#clean_cmd="xcodebuild clean"
#clean_cmd="${clean_cmd} -workspace ${workspace_file}"
#clean_cmd="${clean_cmd} -scheme ${build_scheme}"
#clean_cmd="${clean_cmd} -configuration ${project_config}"

#echo ${clean_cmd}

#$clean_cmd

#if [ $? -ne 0 ]; then
#    echo "清理项目失败，请检查工程。"
#    exit 30
#fi

#xcc='/Users/YKSE/Desktop/iPhone/ChannelConfig/HongTan/YK_HongDiTan_Enterprise.xcconfig'
#sign='iPhone Distribution: YKSE Co., Ltd.'
#pf='92d73c46-f9f5-4e7f-b37c-11f933dbe395'

build_cmd="xcodebuild -workspace ${workspace_file}"
build_cmd="${build_cmd} -scheme ${build_scheme}"
build_cmd="${build_cmd} -destination generic/platform=iOS archive"
build_cmd="${build_cmd} -configuration ${project_config}"
build_cmd="${build_cmd} ONLY_ACTIVE_ARCH=NO -archivePath ${archive_file}"
#build_cmd="${build_cmd} CODE_SIGN_IDENTITY=${sign}"
#build_cmd="${build_cmd} PROVISIONING_PROFILE=${pf}"

echo ${build_cmd}

$build_cmd

if [ $? -ne 0 ]; then
echo "构建项目失败，请检查工程。"
exit 31
fi

run_cmd="xcrun -sdk iphoneos"
run_cmd="${run_cmd} PackageApplication -v"
run_cmd="${run_cmd} ${archive_file}/Products/Applications/realm三部曲.app"
run_cmd="${run_cmd} -o ${ipa_file}"

echo ${run_cmd}

$run_cmd

if [ $? -ne 0 ]; then
echo "打包项目失败，请检查工程。"
exit 32
fi
