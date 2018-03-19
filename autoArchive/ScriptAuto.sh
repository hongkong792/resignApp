#!/bin/sh

#  ScriptAuto.sh
#  realm三部曲
#
#  Created by vincentHK on 2018/2/8.
#  Copyright © 2018年 vincentHK. All rights reserved.
# Define Scheme name
PACKAGE_PROJECT_NAME="realm三部曲"
PACKAGE_SCHEME_NAME="realm三部曲"

# Get Username
PACKAGE_USER_NAME="$(whoami)"

# Scheme Path
PACKAGE_SCHEME_DIR="$SRCROOT/${PACKAGE_PROJECT_NAME}.xcodeproj/xcuserdata/${PACKAGE_USER_NAME}.xcuserdatad/xcschemes"
PACKAGE_SCHEME_PATH="${PACKAGE_SCHEME_DIR}/${PACKAGE_SCHEME_NAME}.xcscheme"

echo "PACKAGE_SCHEME_PATH = ${PACKAGE_SCHEME_PATH}"

# Set Configuration
# WARNING: BACKUP_CONFIGURATION MUST be same with build configuration of archive action in MyApp scheme
BACKUP_CONFIGURATION="Distribution"

# WARNING: Archive name of archive action in MyApp scheme MUST be set explicitly.
# WARNING: BACKUP_ARCHIVENAME MUST be same with archive name of archive action in MyApp scheme
BACKUP_ARCHIVENAME="MyAppArchive"

echo "BACKUP_CONFIGURATION = ${BACKUP_CONFIGURATION}"
echo "BACKUP_ARCHIVENAME = ${BACKUP_ARCHIVENAME}"

## -------------------------------Archive Distribution---------------------------------------
## Set Configuration
#OLD_CONFIGURATION="${BACKUP_CONFIGURATION}"
#NEW_CONFIGURATION="Distribution"
#OLD_ARCHIVENAME="${BACKUP_ARCHIVENAME}"
#NEW_ARCHIVENAME="${PACKAGE_SCHEME_NAME}_${NEW_CONFIGURATION}"
#
## Clean
#xcodebuild -workspace ${PACKAGE_PROJECT_NAME}.xcodeproj/project.xcworkspace -sdk iphoneos -scheme ${PACKAGE_SCHEME_NAME} -configuration ${NEW_CONFIGURATION} clean
#
## Change archive configuration
#sed -i .bak "/<ArchiveAction/,/<\/ArchiveAction>/{s/\"${OLD_CONFIGURATION}\"/\"${NEW_CONFIGURATION}\"/;s/\"${OLD_ARCHIVENAME}\"/\"${NEW_ARCHIVENAME}\"/;}" ${PACKAGE_SCHEME_PATH}
#
## Archive
#xcodebuild -workspace ${PACKAGE_PROJECT_NAME}.xcodeproj/project.xcworkspace -sdk iphoneos -scheme ${PACKAGE_SCHEME_NAME} archive
#
## -------------------------------Archive Inhouse------------------------------------------
## Set Configuration
#OLD_CONFIGURATION="${NEW_CONFIGURATION}"
#NEW_CONFIGURATION="Inhouse"
#OLD_ARCHIVENAME="${NEW_ARCHIVENAME}"
#NEW_ARCHIVENAME="${PACKAGE_SCHEME_NAME}_${NEW_CONFIGURATION}"
#
## Clean
#xcodebuild -workspace ${PACKAGE_PROJECT_NAME}.xcodeproj/project.xcworkspace -sdk iphoneos -scheme ${PACKAGE_SCHEME_NAME} -configuration ${NEW_CONFIGURATION} clean
#
## Change archive configuration
#sed -i .bak "/<ArchiveAction/,/<\/ArchiveAction>/{s/\"${OLD_CONFIGURATION}\"/\"${NEW_CONFIGURATION}\"/;s/\"${OLD_ARCHIVENAME}\"/\"${NEW_ARCHIVENAME}\"/;}" ${PACKAGE_SCHEME_PATH}
#
## Archive
#xcodebuild -workspace ${PACKAGE_PROJECT_NAME}.xcodeproj/project.xcworkspace -sdk iphoneos -scheme ${PACKAGE_SCHEME_NAME} archive

# -------------------------------Archive Adhoc-------------------------------------------
# Set Configuration
OLD_CONFIGURATION="${NEW_CONFIGURATION}"
NEW_CONFIGURATION="Release"
OLD_ARCHIVENAME="${NEW_ARCHIVENAME}"
NEW_ARCHIVENAME="${PACKAGE_SCHEME_NAME}_${NEW_CONFIGURATION}"

# Clean
xcodebuild -workspace ${PACKAGE_PROJECT_NAME}.xcodeproj/project.xcworkspace -sdk iphoneos -scheme ${PACKAGE_SCHEME_NAME} -configuration ${NEW_CONFIGURATION} clean

# Change archive configuration
sed -i .bak "/<ArchiveAction/,/<\/ArchiveAction>/{s/\"${OLD_CONFIGURATION}\"/\"${NEW_CONFIGURATION}\"/;s/\"${OLD_ARCHIVENAME}\"/\"${NEW_ARCHIVENAME}\"/;}" ${PACKAGE_SCHEME_PATH}

# Archive
xcodebuild -workspace ${PACKAGE_PROJECT_NAME}.xcodeproj/project.xcworkspace -sdk iphoneos -scheme ${PACKAGE_SCHEME_NAME} archive

# ------------------------------Restore Configuration-------------------------------------
#sed -i .bak "/<ArchiveAction/,/<\/ArchiveAction>/{s/\"${NEW_CONFIGURATION}\"/\"${BACKUP_CONFIGURATION}\"/;s/\"${NEW_ARCHIVENAME}\"/\"${BACKUP_ARCHIVENAME}\"/;}" ${PACKAGE_SCHEME_PATH}
