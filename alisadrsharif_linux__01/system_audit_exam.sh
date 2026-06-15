#!/bin/bash

########## Variables ##########

dirPath="exam_results/audit"
passwdDir="/etc/passwd"
groupDir="/etc/group"
hostsDir="/etc/hosts"

########## Part 1: Enviroment setup ##########

cd ~
mkdir -p $dirPath
cd $dirPath

#empty notes file
echo -e "#this file contains notes\n" > "notes.txt"

#Working directory 
echo -e "#this file contains current working directory\n" > "cwd.txt"
pwd>>cwd.txt

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
echo -e "#this file contains kernel name, version, and architect\n" > "sysinfo.txt"
uname -sr >> sysinfo.txt

#system architect
arch >> sysinfo.txt

#group summary
echo -e "#this file contains group summaries\n" > "group_summary.txt"
{ head -n 3 $groupDir; tail -n 2 $groupDir; } >> "group_summary.txt"

########## Part 4: Config and Log files ##########

#config files
echo -e "#this file contains config files\n" > "conf_files.txt"
find /etc -type f -name "*.conf" 2>/dev/null >> "conf_files.txt"

#10 top log files
echo -e "#this file contains top log files\n" > "top_logs.txt"
ls -lhS /var/log 2>/dev/null | head -n 10 >> "top_logs.txt"

########## Part 5: Permissions management ##########

#copy file
cp $hostsDir "hosts.bak"

#permission file
chmod 600 hosts.bak

#file hosts-perm
echo -e "#this file contains hosts permissions\n" > "hosts_perm.txt"
ls -l hosts.bak >> "hosts_perm.txt"

########## Part 6: Cleanup ##########

find -type f -name "*.txt" ! -name "notes.txt" ! -name "hosts_perm.txt" -exec rm {} \;