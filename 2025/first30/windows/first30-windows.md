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