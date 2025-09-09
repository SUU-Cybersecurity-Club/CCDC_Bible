# CCDC BIBLE

# First 30 Minutes
## Windows
### 1. Run Hayden's Script
- Quick Install:
    ```
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest https://github.com/archHavik/Useful-Scripts/archive/refs/heads/main.zip -Outfile Useful-Scripts.zip;
    Expand-Archive -Path Useful-Scripts.zip -DestinationPath Useful-Scripts;
    ```
- Run
    ```
    cd useful-scripts\windows-hardening;
    .\start.bat;
    ```
### 2. Take Screenshot of login
- Note service versions
- Nmap scan
### 3. Disable or change passwords to all unneeded users
        
## Linux
### 1. Password Change, Check Sudoers
- Run
    ```
    passwd
    ```
- Add a new backup user, and add them to sudo group
    ```
    useradd <username>
    passwd <username>
    sudo usermod -aG sudo
    ```
- Check sudoers
    ```
    visudo
    /etc/sudoers
    /etc/sudoers.d
    ```
Confirm from another terminal that updated password and backup user works
### 2. Backup scored services

**Backup `/etc` every time**
- Backup Syntax
    ```
    tar -cf <new_file_name> <what's getting backed up>
    cd /
    tar -cf ettc etc
    mv ettc <someplace/in excel>
    ```

Remember to check `/var/www/html`

- Database
    ```
    mysql -u <username> -p -e "SHOW DATABASES; EXIT;"
    mysqldump -u <username> -p <database_name> > <database_name>_backup.sql
    mysqldump -u <username> -p <database_name table_name> > <table_name>_backup.sql
    mysqldump -u <username> -p <database_name table{num}> > backup.sql
### 3. Remove SSH if not scored, if needed backup keys, then remove
- Ubuntu/Debian
    ```
    apt remove openssh-server
    ```
- Fedora/CentOS
    ```
    yum erase openssh-server
    dnf remove openssh-server
    ```
### 4. Login Banner
- Edit `/etc/ssh/sshd_config`
    ```
    banner /etc/issue.net
    ```
- Edit or create `/etc/issue.net`
    - Place banner text
- Restart `sshd` if needed
    ```
    systemctl restart sshd
    ```
- Take a screenshot of banner
### 5. Install Wazuh Agent
- Debian/Ubuntu
    ```
    wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.10.1-1_amd64.deb
    sudo WAZUH_MANAGER='172.20.241.20' dpkg -i ./wazuh-agent_4.10.1-1_amd64.deb
    sudo systemctl daemon-reload
    sudo systemctl enable --now wazuh-agent
    ```
- CentOS/Fedora
    ```
    curl -o wazuh-agent.rpm
    https://packages.wazuh.com/4.x/yum/wazuh-agent-4.10.1-1.x86_64.rpm
    sudo WAZUH_MANAGER='172.20.241.20' WAZUH_AGENT_NAME='Fedora' rpm -ihv wazuh-agent.rpm
    sudo systemctl daemon-reload; sudo systemctl enable --now wazuh-agent
    ```
### 6. Remove RevShells - Cron, Bad/Faulty Services
- List crontabs
    ```
    crontab -l
    crontab -l -u <user>
    ```
- Edit crontabs
    ```
    crontab -e
    crontab -e -u <user>
    ```
### 7. Backup any other important services
- Figure out what that is there
### 8. Run nmap scan
- Run scan, and save to file
    ```
    nmap -sV -T4 -p- localhost > nmap.txt
    ```
### 9. Firewall
- CentOS/Fedora (`firewall-cmd`)
    ```
    firewall-cmd --state
    firewall-cmd --list-all-zones
    firewall-cmd --set-target=DROP --permanent
    firewall-cmd --add-port=80/tcp --permanent
    firewall-cmd --add-service=http --permanent
    firewall-cmd --add-rich-rule='rule family="ipv4" destination port=25 protocol=tcp reject' --permanent
    fir
    ewall-cmd --reload
    ```
- Ubuntu < 20.04, Debian < 10 (`ufw`)
    ```
    ufw status
    ufw status verbose
    ufw default deny incoming
    ufw allow 80
    ufw allow 80/tcp
    ufw deny out 25/tcp
    ufw enable
    ```
- Ubuntu >= 20.04, Debian >= 10, Fedora >= 32, RHEL >= 8 (`nftables`)
    ```
    nft list ruleset
    nft add table inet filter
    nft add chain inet filter input { type filter hook input priority 0 \; policy drop \; }
    nft add chain inet filter output { type filter hook output priority 0 \; policy accept \; }
    nft add rule inet filter input tcp dport 80 accept
    nft add rule inet filter output tcp dport 25 drop
    nft list ruleset > /etc/nftables.conf
    ```
- Generic Linux (`iptables`)
    ```
    iptables -P INPUT DROP
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    iptables -A OUTPUT -p tcp --dport 25 -j REJECT
    apt-get install iptables-persistent
    netfilter-persistent save
    systemctl enable netfilter-persistent
    iptables -S
    iptables -L
    iptables -L -v
    iptables -t filter -L -v
    iptables -t nat -L -v
    iptables -t mangle -L -v
    iptables -t raw -L -v
    iptables -t security -L -v
    ```
### 10. Backup Again
- Backup `/etc`
    ```
    tar -cf <backup_name> /etc
    ```
### Scripts or Steps
- Download scripts
    ```
    curl -O https://raw.githubusercontent.com/archHavik/Useful-Scripts/refs/heads/main/linux-hardening/start.sh -O https://raw.githubusercontent.com/archHavik/Useful-Scripts/refs/heads/main/linux-hardening/linux_wazuh_agent.sh
    ```
- Mark executable
    ```
    chmod +x start.sh linux_wazuh_agent.sh
    ```
- Run Scripts
    ```
    ./start.sh
    ```
### Wazuh
- Setup Wazuh Server on Splunk/Unused machine
- Create Groups for each scored service
- Setup Conditional Filters
- Create secondary admin user
- File Integrity Monitoring
### Firewall
- Change Admin Password
- Remove other Admins
- Fix Weird Firewall Rules
- Configure Objects
- Backup Firewall
- Note Service Versions
- TAKE A Screenshot
## Palo Alto
### 1. Create new users and delete old admins
### 2. Check admin roles and delete unnecessary ones
### 3. Check Global protect settings under network
### 4. Perform updates
- Download 11.1.0 (software page) and new content version (dynamic page) refresh to show
- Download 11.1.4-h7 (or current preferred version) and current antivirus (dynamic page)
- This should take about 20 min with a 4 min lapse in connection for each install
### 5. Start making rules
# General Stuff
## PEMDAS
### **P**atch **E**verything, **M**onitor **D**ata, **A**uthenticate **S**ecurely
1. Password changes
2. Backup services (etc, var, sql databases.)
3. Patch immediate vulnerabilities (remove bad users, clear crontabs, uninstall unnecessary services)
4. Add redundant users
5. Scan network from win 10 for services that shouldnt be open
6. Profit
## Linux
### Account/Group
- Add user
    ```
    useradd -m -G <groups> -s /bin/bash <username>
    ```
- Add user to sudo group
    ```
    sudo usermod -aG sudo <username>
    ```
- Change password (leave<username>blank to change password for current user)
    ```
    passwd <username>
    ```
### Archives
- Make tarball
    ```
    tar -cf <filename>.tar <file/dir to archive>
    ```
- List tarball contents
    ```
    tar -tf <filename>.tar
    ```
- Unpack tarball
    ```
    tar -xf <filename>.tar
    ```
- Unpack `/etc/passwd`
    ```
    tar -xf <filename>.tar --strip-components=2 etc/passwd
    ```
### Database 
- Change root password
    ```
    mysql -u root -p -e "USE mysql; ALTER USER 'root'@'%' IDENTIFIED BY 'new_secure_password'; FLUSH PRIVILEGES; SHOW TABLES; EXIT;"
    ```
- Backup
    ```
    mysqldump -u <username> -p <database_name table_name> > <table_name>_backup.sql
    mysqldump -u <username> -p <database_name table{num}> > backup.sql
    ```
- Show Users
    ```
    mysql -u root -p -e "SELECT User, Host FROM mysql.user;"
    ```
- Restore Backup
    ```
    mysql -u <username> -p <database_name> < <database_name>_backup.sql
    ```
- Overwrite Backup
    ```
    mysql -u <username> -p -e "DROP DATABASE IF EXISTS <database_name>; CREATE DATABASE <database_name>;"
    mysql -u <username> -p <database_name> < <database_name>_backup.sql
- Restore Table Backup
    ```
    mysql -u <username> -p <database_name> < <table_name>_backup.sql
    ```
- Overwrite Table Backup
    ```
    mysql -u <username> -p -e "USE <database_name>; DROP TABLE IF EXISTS <table_name>;"
    mysql -u <username> -p <database_name> < <table_name>_backup.sql
    ```
### Processes
- List process as forest
    ```
    ps -eaf --forest
    ```
- List processes using ports
    ```
    ss -autpn
    ```
- Check where process is running from
    ```
    cd /proc/<pid>
    ls -la | grep cwd
    ```
- Show socket information from pid
    ```
    ss -anp | grep <pid>
    ```
- Force kill process (SIGKILL)
    ```
    kill -9 <pid>
    ```
- Graceful kill process (SIGTERM)
    ```
    kill -15 <pid>
    ```
### Files
- Check for NFS and SMB shares on host
    ```
    nmap --script="nfs-showmount,smb-os-discovery" -p 2049,445 localhost
    ```
- Open multiple files in directory
    ```
    find <dir_path> -type f -exec cat {} + | less
    ```
### LinPeas
- Increase readability
    ```
    ./linpeas.sh | less -RN
    ```
## Windows
### 2016 Docker/Remote
### **Run Hayden's script**
If you're lame and don't run Hayden's script follow these instructions
1. Change passwords
2. Disable all unnecessary accounts (If the accounts are required because score goes down make sure to reenable them then remove them from all groups and resources and give them no permissions.)
3. Create new admin user for team use
4. Remove SMB 1
5. Disable RDP - ServerManager/Local Server/Remote Desktop Disabled
6. Fix the DNS on the Machine (IPV4 Driver)
7. Setup the Powershell Connection Script (From now on you will watch this periodically to see if Redteam is in.)
8. Install Wazuh Agent on the machine.
9. Turn on Firewall
10. Ensure that Defender Antivirus is Enabled
11. Open Services, Disable the Printer Spooler Service and Stop it
12. Start Windows Update

**--Once you're done the above, continue below--**

13. Check the SMB Shares for bad setup (Like the entire C: being shared) Check Share Permissions.
14. Check for Unnecessary Services/Programs and uninstall.
15. Save Process and Services list to XML so that you can check if things change later.
16. Check Firewall Rules
17. Setup Good Group Policy.

**--Injects information--**
1. Setup a Warning Message for those who login (Group Policy Object)
2. Run an NMAP against the box and take a screenshot (Preferably from a different machine, Zenmap include netcat capabilities which you don't need. use Windows 10)

- Check for remote connections
    ```
    where(1) { Get-NetTCPConnection -State Established | Select LocalAddress,LocalPort, RemoteAddress,RemotePort,OwningProcess,@{Name="cmdline";Expression={(Get-WmiObject Win32_Process -filter "ProcessId” = $($_.OwningProcess)).commandline} | Where-Object {$_.RemoteAddress -NE "127.0.0.1" -AND $_.RemoteAddress -NE "127.0.0.0” -AND $_.RemoteAddress -NE "::" -AND $_.RemoteAddress -NE "::1" -AND $_.RemoteAddress -NE "172.20.240.10" -AND $_.RemotePort -NE "80" -AND $_.RemotePort -NE "443"}; sleep 5; clear;}
    ```
### Hardening Script
- Located at https://github.com/archHavik/Useful-Scripts/tree/main/windows-hardening
- README has instructions for running the script
- Installation instructions
    ```
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;
    Invoke-WebRequest https://github.com/archHavik/Useful-Scripts/archive/refs/heads/main.zip -Outfile Useful-Scripts.zip;
    Expand-Archive -Path Useful-Scripts.zip -DestinationPath Useful-Scripts;
    ```
- Run Script
    ```
    cd Useful-Scripts\Useful-Scripts-main\windows-hardening;
    .\start.bat;
    ```
# Operating Systems
## Debian 9
- Update DNS in `/etc/resolv.conf` to `8.8.8.8`
- Update `/etc/apt/sources.list` to use correct repo location
    ```
    sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list
    sed -i '/stretch-updates/d' /etc/apt/sources.list
## Debian 10
### Network
- DNS: Should be `8.8.8.8`
### User Admin
- Change passwords
    ```
    passwd
    passwd sysadmin
    passwd produdu
    ```
- Add backup user
    ```
    useradd <backup_username>
    password <backup_password>
    ```
- Add backup user to sudo group
    ```
    usermod -aG sudo <backup_username>
    ```
### Backup 1
- Backup `/etc`
    ```
    cd /
    tar -cf bcte etc/
    ```
### Script
- Download Script
    ```
    curl -O https://raw.githubusercontent.com/archHavik/Useful-Scripts/refs/heads/main/linux-hardening/start.sh -O https://raw.githubusercontent.com/archHavik/Useful-Scripts/refs/heads/main/linux-hardening/linux_wazuh_agent.sh
    ```
- Change permissions and run script
    ```
    chmod +x start.sh linux_wazuh_agent.sh && ./start.sh
    ```
### Services
- Nuke SSH
    ```
    apt remove openssh-server
    ```
- Disable vulnerable services
    ```
    systemctl stop sshd
    systemctl stop exim4
    systemctl disable exim4
    systemctl stop avahi-daemon
    systemctl disable avahi-daemon
    systemctl stop minissdpd
    systemctl disable minissdpd
    systemctl stop proftpd
    systemctl disable proftpd
    systemctl stop apache2
    systemctl disable apache2
    systemctl stop rpcbind
    systemctl disable rpcbind
    systemctl stop ntpd
    systemctl disable nptd
    ```
- Remove packages for services we don't want
    ```
    apt remove apache2 proftpd-basic postfix nginx
    ```
### Cron
- Remove user cron jobs
    ```
    crontab -e -u sysadmin
    ```
- Restart cron service to apply changes
    ```
    systemctl restart cron
    ```
### Banner
- Uncomment lines and add message
    ```
    vim /etc/gdm3/greeter.d/conf-defaults

    banner-message-enable=true
    banner-message-text=’<message>’
    ```
- Restart machine to apply changes
### Confirm Bind
- Add these lines
    ```
    vim /etc/apparmor.d/usr.sbin.named

    /var/log/bind9** rw,
    /var/log/bing9/ rw,
    ```
- Restart apparmor and start bind
    ```
    systemctl restart apparmor
    systemctl start bind9
    systemctl status bind9
    ```
### Backup 2
- Backup `/etc`
    ```
    cd /
    tar -cf bcte etc/
    ```
### Firewall
- Install `ufw`
    ```
    apt install ufw
    ```
- Set firewall rules
    ```
    ufw status
    ufw status verbose
    ufw default deny incoming
    ufw allow 53
    ufw allow 953/tcp
    ufw enable
    ```
### Security
- Download LinPeas
    ```
    wget https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh
    ```
- Run Script
    ```
    chmod +x linpeas.sh
    ./linpeas.sh | less -RN
    ```
## Ubuntu 18 Server
### Network
- DNS: Should be `8.8.8.8`
### User Admin
- Change passwords
    ```
    passwd
    passwd sysadmin
    ```
- Add backup user
    ```
    useradd <backup_username>
    password <backup_password>
    ```
- Add backup user to sudo group
    ```
    usermod -aG sudo <backup_username>
    ```
### Services
- Nuke SSH
    ```
    systemctl stop sshd
    apt remove openssh-server
    ```
- Disable vulnerable services
    ```
    systemctl stop apache2
    systemctl disable apache2
    ```
### Database
- Backup and stop database
    ```
    mkdir /usr/lib64/b/

    cd <backup directory>

    mysqldump -p openshop_db > opensho.sql
    (password just press enter)
    mysqldump -p db > data.sql
    mysqldump -p mysql > my.sql

    systemctl stop mariadb
    ```
### Script
- Download Script
    ```
    curl -O https://raw.githubusercontent.com/archHavik/Useful-Scripts/refs/heads/main/linux-hardening/start.sh -O https://raw.githubusercontent.com/archHavik/Useful-Scripts/refs/heads/main/linux-hardening/linux_wazuh_agent.sh
    ```
- Run Script
    ```
    chmod +x start.sh linux_wazuh_agent.sh && ./start.sh
    ```
### Banner
- Edit ssh config 
    ```
    vim /etc/ssh/sshd_config

    banner /etc/issuse.net
    ```
- Edit or create `/etc/issuse.net`
    ```
    vim /etc/issuse.net
    cp /etc/issuse.net /etc/issue
    ```
### Backup
- Backup `/etc`
    ```
    cd /
    tar -cf ettc etc/
    mkdir
    cp /ettc <dest>
    ```
- Backup `/var/www`
    ```
    cd /var/www
    tar -cf web html/
    mv web /etc/<dir>
    ```
### Firewall
- Shouldn't have anything scored so deny incoming traffic
    ```
    apt install ufw
    ufw status
    ufw default deny incoming
    ufw enable
    ```
## Ubuntu Workstation
### Networking
- Point DNS to `8.8.8.8`
### User Admin
- Change passwords
    ```
    passwd
    passwd sysadmin
    ```
- Add backup user
    ```
    useradd <backup_username>
    password <backup_password>
    ```
- Add backup user to sudo group
    ```
    usermod -aG sudo <backup_username>
    ```
### Services
- Nuke SSH
    ```
    apt remove openssh-server
    ```
- Stop and disable services
    ```
    systemctl stop avahi-daemon
    systemctl disable avahi-daemon
    systemctl stop cupsd
    systemctl disable cupsd
    systemctl stop redis-server
    systemctl disable redis-server
    ```
### Banner
- Uncomment lines and add message
    ```
    vim /etc/gdm3/greeter.d/conf-defaults

    banner-message-enable=true
    banner-message-text=’<message>’
    ```
- Restart machine to apply changes
### Script
- Download Script
    ```
    curl -O https://raw.githubusercontent.com/archHavik/Useful-Scripts/refs/heads/main/linux-hardening/start.sh -O https://raw.githubusercontent.com/archHavik/Useful-Scripts/refs/heads/main/linux-hardening/linux_wazuh_agent.sh
    ```
- Run Script
    ```
    chmod +x start.sh linux_wazuh_agent.sh && ./start.sh
    ```
### Firewall
- Shouldn't have anything scored so deny incoming traffic
    ```
    apt install ufw
    ufw status
    ufw default deny incoming
    ufw enable
    ```
## CentOS 7 E-Comm
### Network
- DNS: Should be `8.8.8.8`
### User Admin
- Change passwords
    ```
    passwd
    passwd sysadmin
    ```
- Add backup user
    ```
    useradd <backup_username>
    password <backup_password>
    ```
- Add backup user to sudo group
    ```
    usermod -aG sudo <backup_username>
    ```
### Packages
- Update repos
    ```
    sed -i -e '/^mirrorlist/d;/^#baseurl=/{s,^#,,;s,/mirror,/vault,;}' /etc/yum.repos.d/CentOS*.repo
    ```
### Services
- Nuke SSH
    ```
    yum remove openssh-server
    systemctl stop sshd
    systemctl disable sshd
    ```
- Mess with services
    ```
    systemctl stop chronyd
    crontab -e (remove currl)
    systemctl restart cron
    chmod -R 555 prestashop

    rm /etc/httpd/conf.d/phpMyAdmin.conf
    ```
### Backup 1
- Backup `/etc`
    ```
    cd /
    tar -cf bcte etc/
    ```
- Backup webserver stuff
    ```
    cd /var/
    tar -cf wwww www/
    (While here move admin site)
    mysqldump -p prestashop > p.sql
    (password just press enter)
    Mysqldump -p mysql > my.sql
    ```
### Script
- Download Script
    ```
    curl -O https://raw.githubusercontent.com/archHavik/Useful-Scripts/refs/heads/main/linux-hardening/start.sh -O https://raw.githubusercontent.com/archHavik/Useful-Scripts/refs/heads/main/linux-hardening/linux_wazuh_agent.sh
    ```
- Run Script
    ```
    chmod +x start.sh linux_wazuh_agent.sh && ./start.sh
    ```
### Firewall
- Set firewall rules
    ```
    firewall-cmd --list-all-zones > fireb

    firewall-cmd --set-target=DROP
    firewall-cmd --add-service=http --permanent
    firewall-cmd --remove-service=ssh --permanent
    firewall-cmd --reload
    ```
### Database
- Update admin password
- cp settings change `settings.inc.php` file
- mv to sql file
- Update `ps_employee set passwd = md5(‘<cookie>more-secure-with-this’) where id_employee = 1;`
### Backup 2
- Backup `/etc`
    ```
    cd /
    tar -cf ettc etc/
    ```
- Backup webserver stuff
    ```
    cd /var/
    tar -cf wwww www/
    mysqldump -p prestashop > p.sql
    (password just press enter)
    Mysqldump -p mysql > my.sql
    ```
## Fedora 21 Webmail
### Network
- DNS: Should be `1.1.1.1`
### User Admin
- Change passwords
    ```
    passwd
    passwd sysadmin
    ```
- Add backup user
    ```
    useradd <backup_username>
    password <backup_password>
    ```
- Add backup user to wheel group
    ```
    usermod -aG wheel <backup_username>
    ```
### Script
- Download Script
    ```
    curl -O https://raw.githubusercontent.com/archHavik/Useful-Scripts/refs/heads/main/linux-hardening/start.sh -O https://raw.githubusercontent.com/archHavik/Useful-Scripts/refs/heads/main/linux-hardening/linux_wazuh_agent.sh
    ```
- Run Script
    ```
    chmod +x start.sh linux_wazuh_agent.sh && ./start.sh
    ```
### Backup 1
- Backup `/etc`
    ```
    cd /
    tar -cf bcte etc/
    ```
- Backup mail, website, and db
    ```
    /var/mail
    /var/ww/html
    mysqldump -p roundcubemail > r.sql
    (password just press enter)
    Mysqldump -p mysql > my.sql
    ```
### Services
- Nuke SSH
    ```
    yum remove openssh-server
    systemctl stop sshd
    systemctl disable sshd
    ```
- Disable other services
    ```
    systemctl stop cockpit
    systemctl disable cockpit
    systemctl stop httpd
    systemctl disable httpd
    ```
- Remove packages
    ```
    yum remove cockpit
    ```
### Security
- Remove apacheapache from wheel group
    ```
    vim /etc/group
    
    Wheel delete the apache apache text
    ```
- Remove user `system` disable `apache` login
    ```
    vim /etc/passwd
    Delete system user at the bottom
    Also update apache from /bin/bash to /sbin/nologin
    ```
- Move `/root/passlist.txt` and `user.sh` to safe place
    ```
    mv to new safe place
    ```
- Remove passlist from `/etc/dovecot`
    ```
    rm /etc/dovecoct/passlist.txt
    ```
### Firewall
- Make sure fallwall service is up
    ```
    firewall-cmd --list-all-zones > fireb
    systemctl start firewalld
    ```
- Set firewall rules
    ```
    firewall-cmd --set-target=DROP --permanent
    firewall-cmd --remove-service=cockpit --permanent
    firewall-cmd --remove-service=ssh --permanent
    firewall-cmd --remove-service=dhcpv6-client --permanent
    firewall-cmd --add-service=smtp --permanent
    firewall-cmd --add-service=pop3 --permanent
    firewall-cmd --reload
    ```
- Backup firewall
    ```
    firewall-cmd --list-all-zones > firebafter
    ```
### Backup 2
- Backup `/etc`
    ```
    cd /
    tar -cf etc2 etc/
    ```
- Backup mail, website, and db
    ```
    /var/mail
    /var/ww/html
    mysqldump -p roundcubemail > r.sql
    (password just press enter)
    Mysqldump -p mysql > my.sql
    ```
### Distro Upgrade
**22**
- Run
    ```
    systemctl enable postfix
    yum install fedup
    fedup --network 22
    dnf system-upgrade reboot
    check openssh-server and cockpit
    ```
    As per https://fedoramagazine.org/upgrade-fedora-21-fedora-22/

**23**
- Run
    ```
    dnf update
    fedup --network 23
    dnf system-upgrade reboot
    ```
- Make sure to check services and firewall

## 2019 AD/DNS/DHCP
### Network
- To get to network adapter settings: run -> ncpa.cpl
- To see default nameserver run nslookup
- If it’s an IPv6 address, just turn off IPv6

### AD Users
- Descriptions have scoring users
## Splunk
### Network
- DNS: Should be `8.8.8.8`
### Services
- Nuke SSH
    ```
    yum remove openssh
    ```
- Disable other services
    ```
    systemctl stop cockpit
    systemctl disable cockpit
    ```
### Backup
- Backup `/opt` and `/etc`
### Firewall
- Add ports to `firewalld`
    ```
    1514, 1515, 1516
    5500, 443
    9200 / 9300 / 9400
    ```
### Notes
- Ui_access log
    ```
    /opt/splunk/var/log/splunk/splunkd_ui_access.log
    ```
- Backup `/opt` move to `/home`
- Change passwords to splunk users in the web gui (localhost:8000)
- Find cve allowing remote access splunk 9.1.1
# Services
## Passlist
- CSV update user passwords on windows and linux script
## FTPS
- https://www.youtube.com/watch?v=ISVyGxYfAGg
- https://github.com/rhrn/docker-vsftpd/tree/master
## WAF
- Website application firewall
- https://owasp.org/www-project-coraza-web-application-firewall/#
- https://hub.docker.com/_/caddy
- https://github.com/jptosso/coraza-waf-docker/blob/master/Caddyfile
- https://medium.com/@jptosso/implementing-coraza-waf-with-docker-a55a995f055e
## LibreNMS
- https://docs.librenms.org/Installation/Docker/
- https://nagios-plugins.org/doc/man/check_http.html
### Useful info
- Needs to ping
- In docker container `librenms`
    ```
    lnms user:add --role=admin <username>
    ```
# Networks
## Palo Alto
### Wazuh
- Ports needed
    ```
    1514, 1515, 1516
    5500, 443
    9200 / 9300 / 9400
    ```
### Rules
- Interface mgmt disable ping telnet ssh http http ocsp
- Block 3306 port for all machines
- Block 4444 this is metasploits default

## Windows 10
## Security Onion
## HoneyPots