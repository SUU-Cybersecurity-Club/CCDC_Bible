# First 30 Minutes

## **Windows**

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
        
## **Linux**

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
    tar -cf <new_file_name> <thing getting backed up>
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
    ```

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
    firewall-cmd --reload
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

## **Palo Alto**

### 1. Create new users and delete old admins

### 2. Check admin roles and delete unnecessary ones

### 3. Check Global protect settings under network

### 4. Perform updates

- Download 11.1.0 (software page) and new content version (dynamic page) refresh to show

- Download 11.1.4-h7 (or current preferred version) and current antivirus (dynamic page)

- This should take about 20 min with a 4 min lapse in connection for each install

### 5. Start making rules