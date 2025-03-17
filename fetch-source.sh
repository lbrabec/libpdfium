#!/bin/bash
set -e

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SPEC=${SCRIPTDIR}/libpdfium.spec
PDFIUM_VERSION=$(rpmspec -q --qf "%{version}\n" $SPEC | head -n1 | awk -F^ '{print $1}')

echo "Fetching sources for PDFium ${PDFIUM_VERSION}"

DOWNLOAD=${SCRIPTDIR}/pdfium-${PDFIUM_VERSION}.tar.gz
CLEAN=${SCRIPTDIR}/pdfium-${PDFIUM_VERSION}-clean.tar.gz

if [ ! -f $DOWNLOAD ]; then
    curl -fL -o $DOWNLOAD https://pdfium.googlesource.com/pdfium/+archive/refs/heads/chromium/${PDFIUM_VERSION}.tar.gz
fi


if [ ! -f $CLEAN ]; then
    # testing/resources/pixel/bug_867501.pdf is flagged by clamav
    echo "Repacking ${DOWNLOAD} as ${CLEAN}"
    rm -f $CLEAN
    gzip -c -d $DOWNLOAD | tar -O -f - --delete 'testing/resources/pixel/bug_867501*' | gzip > $CLEAN
fi

tar -C $SCRIPTDIR -xf $CLEAN DEPS

echo ""
echo "%global build_revision $(awk '/build_revision/ {print substr($2,2,40)}' DEPS)"
echo "%global abseil_revision $(awk '/abseil_revision/ {print substr($2,2,40)}' DEPS)"
echo "%global fast_float_revision $(awk '/fast_float_revision/ {print substr($2,2,40)}' DEPS)"
echo "%global gtest_revision $(awk '/gtest_revision/ {print substr($2,2,40)}' DEPS)"
echo "%global test_fonts_revision $(awk '/test_fonts_revision/ {print substr($2,2,40)}' DEPS)"

rm ${SCRIPTDIR}/DEPS

CHROMIUM_TAG=$(git ls-remote --sort -version:refname --tags https://chromium.googlesource.com/chromium/src "*.*.${PDFIUM_VERSION}.0" | awk -F/ '{print $3}')
echo "%global chromium_tag $CHROMIUM_TAG"
