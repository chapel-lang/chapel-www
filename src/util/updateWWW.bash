#!/bin/bash

echo ""
if [ -z ${CHPL_WWW} ]; then echo "Error: CHPL_WWW un-set" && echo "Note: set it to point to your clone of the 'chapel-www' repo" && exit 1; fi
if [ -z ${CHPL_WWW_HOST} ]; then echo "Error: CHPL_WWW_HOST un-set" && echo "Note: set it to name the hostname of your web server" && exit 1; fi
if [ -z ${CHPL_WWW_HOST_USERNAME} ]; then echo "Error: CHPL_WWW_HOST_USERNAME un-set" && echo "Note: set it to the username to rsync as on your web server' repo" && exit 1; fi
if [ -z ${CHPL_WWW_HOST_PATH} ]; then echo "Error: CHPL_WWW_HOST_PATH un-set" && echo "Note: set it to name the target directory on your web server" && exit 1; fi

if [ ! -d "${CHPL_WWW}/chapel-lang.org" ]; then
    echo "Error: CHPL_WWW doesn't seem to be set properly; it doesn't contain a chapel-lang.org/ subdirectory" && exit 1; else echo "'rsync'-ing from $CHPL_WWW/chapel-lang.org"; fi

cd $CHPL_WWW/chapel-lang.org
echo ""
echo "Here are untracked files:"
echo "-------------------------"
git ls-files --others
echo "-------------------------"
echo "(Hit Ctrl-C if non-empty)"
echo ""
echo "Here are files with apparently internal URLs"
echo "--------------------------------------------"
grep hpecorp.net *.html
grep urldefense *.html
echo "--------------------------------------------"
echo "(Hit Ctrl-C if non-empty)"
echo ""
chmod ugo+rx .
chmod -R ugo+rX *
echo ""
echo "Syncing to www..."
rsync -alvz --exclude='.git/' --exclude=docs/master/ --exclude=.well-known/ --exclude=favicon.gif --delete ./ $CHPL_WWW_HOST_USERNAME@$CHPL_WWW_HOST:$CHPL_WWW_HOST_PATH
