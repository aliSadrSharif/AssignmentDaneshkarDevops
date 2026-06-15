#!/bin/bash

# ftp_operations.sh
# Demonstrates basic FTP client operations:
# 1. Connect to an FTP server
# 2. List files
# 3. Download a file
# 4. Upload a file (if server allows upload)

SERVER="ftp.ubuntu.com"
REMOTE_DIR="/ubuntu"
DOWNLOAD_FILE="ls-lR.gz"
UPLOAD_FILE="sample_upload.txt"

echo "======================================"
echo " FTP Operations Demo Script"
echo " Server: $SERVER"
echo "======================================"

# Create a sample file for upload demonstration
echo "This is a sample file for FTP upload test." > "$UPLOAD_FILE"

echo
echo "1) Connecting to FTP server and listing files..."
ftp -inv "$SERVER" <<EOF
user anonymous anonymous
cd $REMOTE_DIR
ls
bye
EOF

echo
echo "2) Downloading a file from FTP server..."
ftp -inv "$SERVER" <<EOF
user anonymous anonymous
cd $REMOTE_DIR
get $DOWNLOAD_FILE
bye
EOF

if [ -f "$DOWNLOAD_FILE" ]; then
    echo "Download successful: $DOWNLOAD_FILE"
else
    echo "Download failed."
fi

echo
echo "3) Attempting to upload a file (may fail if server is read-only)..."
ftp -inv "$SERVER" <<EOF
user anonymous anonymous
put $UPLOAD_FILE
bye
EOF

echo
echo "4) Alternative download using wget..."
wget "ftp://$SERVER$REMOTE_DIR/$DOWNLOAD_FILE" -O "wget_$DOWNLOAD_FILE"

echo
echo "5) Alternative download using curl..."
curl -o "curl_$DOWNLOAD_FILE" "ftp://$SERVER$REMOTE_DIR/$DOWNLOAD_FILE"

echo
echo "Script execution finished."
echo "Note: Upload to public FTP servers like ftp.ubuntu.com is usually disabled."
