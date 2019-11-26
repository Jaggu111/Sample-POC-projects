#!/bin/bash -x -u

#  Fat.sh
#  BRTCrashReporter
#
#  Created by Carl a Baltrunas on 5/13/19.
#  Copyright © 2019 AT&T CDO. All rights reserved.

#   Print script and function line numbers
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

arg="${1}"

#   Set defaults for platform and suffixes
MYPLATFORM=""
MY_OS_SUBDIRECTORY=""
case "${arg}" in
ios)
MYPLATFORM="iphone"
MY_OS_SUBDIRECTORY="iOS"
;;
tvos)
MYPLATFORM="appletv"
MY_OS_SUBDIRECTORY="tvOS"
;;
*)
export PS4=
set +x
echo "USAGE: Fat.sh platform"
echo ""
echo "          ios:    iPhone/iPad device & simulator"
echo "         tvos:    AppleTV device & simulator"
echo "         help:    Usage"
exit 1
;;
esac

MYCONFIG="${CONFIGURATION}"
ARM_DIR="${MYPLATFORM}os"
X86_DIR="${MYPLATFORM}simulator"
ARM_BUILD="${BUILD_DIR}/${MYCONFIG}-${ARM_DIR}"
UNIVERSAL_BUILD="${BUILD_DIR}/${MYCONFIG}-${MYPLATFORM}universal"
X86_BUILD="${BUILD_DIR}/${MYCONFIG}-${X86_DIR}"
ARM_SDK=`xcodebuild -showsdks | grep "sdk ${ARM_DIR}" | awk '{ field = $NF }; END{ print field }'`
X86_SDK=`xcodebuild -showsdks | grep "sdk ${X86_DIR}" | awk '{ if (!field) { field = $NF }}; END{ print field }'`
XFLAGS="-fembed-bitcode-marker -Wno-ambiguous-macro"
if [ "${XCONFIG:0:7}" = "Release" ]; then
XFLAGS="-fembed-bitcode -Wno-ambiguous-macro"
fi

read -r -a XARCHS <<< "-arch arm64 -arch armv7 -arch armv7s -arch arm64e"
if [ "${MYPLATFORM}" = "appletv" ]; then
read -r -a XARCHS <<< "-arch arm64"
fi

echo "${XARCHS[@]}"
MYPROJ="BRTCrashReporter.xcodeproj"
MYPRODUCT="BRTCrashReporter.framework/BRTCrashReporter"
if [ "${MYPLATFORM}" = "appletv" ]; then
    MYPRODUCT="BRTCrashReporterTV.framework/BRTCrashReporterTV"
fi

MYPRODUCTDIR=`dirname "${MYPRODUCT}"`
echo "${MYPRODUCTDIR}"
MYSCHEME=`basename "${MYPRODUCT}"`
echo  "${MYSCHEME}"

echo " **** Build for Device **** "
echo "xcodebuild -project  \"${MYPROJ}\" -scheme \"${MYSCHEME}\" -configuration \"${MYCONFIG}\" \"${XARCHS[@]}\" only_active_arch=NO  -sdk \"${ARM_SDK}\" OTHER_CFLAGS=\"${XFLAGS}\" -UseModernBuildSystem=NO clean build "

xcodebuild -project  "${MYPROJ}" -scheme "${MYSCHEME}" -configuration "${MYCONFIG}" "${XARCHS[@]}" only_active_arch=NO  -sdk "${ARM_SDK}" OTHER_CFLAGS="${XFLAGS}" -UseModernBuildSystem=NO clean build  2>&1

echo " **** Build for Simulator **** "
xcodebuild -project "${MYPROJ}" -scheme "${MYSCHEME}" -configuration "${MYCONFIG}" -sdk "${X86_SDK}" OTHER_CFLAGS="${XFLAGS}" -UseModernBuildSystem=NO clean build  2>&1

echo " **** Build Fat Binary **** "
rm -rf "${UNIVERSAL_BUILD}"
mkdir -p "${UNIVERSAL_BUILD}"
ls -lr "${ARM_BUILD}/${MYPRODUCTDIR}"
cp -pr "${ARM_BUILD}/${MYPRODUCTDIR}" "${UNIVERSAL_BUILD}/"
echo "${ARM_BUILD}/${MYPRODUCT} ${X86_BUILD}/${MYPRODUCT}  -output   ${UNIVERSAL_BUILD}/${MYPRODUCT}"
ls -l "${ARM_BUILD}/${MYPRODUCT}" "${X86_BUILD}/${MYPRODUCT}" "${UNIVERSAL_BUILD}/${MYPRODUCT}"
lipo -create "${ARM_BUILD}/${MYPRODUCT}" "${X86_BUILD}/${MYPRODUCT}" -output "${UNIVERSAL_BUILD}/${MYPRODUCT}"
lipo -info "${UNIVERSAL_BUILD}/${MYPRODUCT}"
