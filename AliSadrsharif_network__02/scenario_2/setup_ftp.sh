#!/bin/bash
set -e

# FTP setup script for vsftpd
# Run as root or with sudo

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

echo "Updating package list..."
apt update -y

echo "Installing vsftpd..."
apt install -y vsftpd

echo "Backing up existing config..."
if [ -f /etc/vsftpd.conf ]; then
  cp /etc/vsftpd.conf /etc/vsftpd.conf.bak.$(date +%F-%H%M%S)
fi

echo "Creating FTP user..."
FTP_USER="ftpuser"
FTP_PASS="ftp1234"

if id "$FTP_USER" >/dev/null 2>&1; then
  echo "User $FTP_USER already exists."
else
  useradd -m -s /bin/bash "$FTP_USER"
  echo "$FTP_USER:$FTP_PASS" | chpasswd
  echo "User $FTP_USER created with password: $FTP_PASS"
fi

echo "Configuring vsftpd..."
cat > /etc/vsftpd.conf << 'EOF'
listen=YES
listen_ipv6=NO

anonymous_enable=YES
local_enable=YES
write_enable=YES
chroot_local_user=YES

# Allow local users to upload files
allow_writeable_chroot=YES

# Anonymous access settings
no_anon_password=YES
anon_root=/srv/ftp
anon_upload_enable=NO
anon_mkdir_write_enable=NO

# Logging
xferlog_enable=YES
log_ftp_protocol=YES
EOF

echo "Preparing anonymous FTP directory..."
mkdir -p /srv/ftp
chown -R ftp:ftp /srv/ftp
chmod 755 /srv/ftp

echo "Restarting vsftpd service..."
systemctl enable vsftpd
systemctl restart vsftpd

echo "Service status:"
systemctl status vsftpd --no-pager

echo "FTP setup completed successfully."
echo "Anonymous directory: /srv/ftp"
echo "FTP user: $FTP_USER"
