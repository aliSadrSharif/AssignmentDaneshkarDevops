#!/bin/bash

########## Variables ##########

dirPath="$HOME/exam_results/audit"
passwdDir="/etc/passwd"
groupDir="/etc/group"
hostsDir="/etc/hosts"
logDir="/var/log"

notesFile="notes.txt"
cwdFile="cwd.txt"
sysinfoFile="sysinfo.txt"
permFile="hosts_perm.txt"
snapshotFile="audit_snapshot_$(date '+%Y%m%d_%H%M%S').zip"
archiveFile="audit.zip"

########## Part 1: Enviroment setup ##########

mkdir -p "$dirPath"
cd "$dirPath" || exit 1

#notes file
touch "$notesFile"
{
    echo -e "#this file contains notes about the audit run\n"
    echo "date: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "host: $(hostname)"
    echo "user: $(whoami)"
} > "$notesFile"

#Working directory 
echo -e "#this file contains current working directory\n" > "$cwdFile"
pwd >> "$cwdFile"

########## Part 2: Users info #########

#all useres
echo -e "#this file contains all users\n" > "users.txt"
awk -F: '{print $1}' "$passwdDir" >> users.txt

#bash users
echo -e "#this file contains bash users\n" > "bash_users.txt"
grep '/bin/bash' "$passwdDir" >> bash_users.txt

#replace zsh
echo -e "#this file is replaced bash with zsh\n" > "shell_preview.txt"
sed 's|/bin/bash|/usr/bin/zsh|g' "$passwdDir" | head -n 5 >> shell_preview.txt

########## Part 3: System info ##########

#kernel name and version
echo -e "#this file contains kernel name, version, and architect\n" > "$sysinfoFile"
uname -sr >> "$sysinfoFile"

#system architect
arch >> "$sysinfoFile"

#group summary
echo -e "#this file contains group summaries\n" > "group_summary.txt"
{ head -n 3 "$groupDir"; tail -n 2 "$groupDir"; } >> "group_summary.txt"

########## Part 4: Config and Log files ##########

#config files
echo -e "#this file contains config files\n" > "conf_files.txt"
find /etc -type f -name "*.conf" 2>/dev/null >> "conf_files.txt"

#10 top log files
echo -e "#this file contains the 10 largest files of $logDir\n" > "top_logs.txt"
find "$logDir" -type f -exec du -h {} + 2>/dev/null | sort -rh 2>/dev/null | head -n 10 >> "top_logs.txt"

########## Part 5: Permissions management ##########

#copy file
cp "$hostsDir" "hosts.bak"

#permission file
chmod 600 hosts.bak

#file hosts-perm
echo -e "#this file contains hosts permissions\n" > "$permFile"
ls -l hosts.bak >> "$permFile"

########## Part 6: Audit summary in notes ##########

{
    echo
    echo "users: $(grep -cve '^#' -e '^$' users.txt)"
    echo "bash users: $(grep -cve '^#' -e '^$' bash_users.txt)"
    echo "conf files: $(grep -cve '^#' -e '^$' conf_files.txt)"
    echo "kernel: $(uname -sr)"
    echo "snapshot: $snapshotFile"
} >> "$notesFile"

########## Part 7: Snapshot (before cleanup) ##########

zip -q -r "$snapshotFile" . -x '*.zip'

########## Part 8: Cleanup ##########

find . -maxdepth 1 -type f -name "*.txt" ! -name "$notesFile" ! -name "$permFile" -delete

########## Part 9: Archive ##########

cd .. || exit 1
rm -f "$archiveFile"
zip -q -r "$archiveFile" "audit"
