# Description of the Script kaliqtor.sh

This Bash script is designed to manage and secure a system's network traffic by routing it through the Tor network. Although primarily intended to work on Kali Linux, it can also be used on other Linux distributions (to be tested).

### User Features

The script offers two main operating modes: via proxychains and via a transparent proxy.

### Usage with Proxychains

**Connection via Tor:**
   - **Command `c`:** Starts the Tor service and checks for data leaks using proxychains. Compares the initial IP address to the current IP address to ensure traffic is routed through Tor. Also performs tests to detect DNS leaks and IPv6 connections.

**Leak Test:**
   - **Command `t`:** Allows checking for data leaks using proxychains. Ideal for testing the security of the current configuration in use.

**Disconnection and Display of Public IP:**
   - **Command `d`:** Stops the Tor service and displays the user's current public IP address, allowing confirmation that traffic is no longer routed through Tor.

### Usage of a Transparent Proxy

**Transparent Proxy via Tor:**
   - **Command `ap`:** Activates the transparent proxy via Tor and checks for data leaks. Securely redirects all network traffic through Tor.
   - **Command `tp`:** Simply checks for leaks in transparent proxy mode to ensure the configuration is secure, ideal for testing the security of the current configuration in use.

**Deactivation of Transparent Proxy:**
   - **Command `dp`:** Deactivates the transparent proxy via Tor and restores the default iptables rules, allowing a return to a standard network configuration.

### Functions for IPv6 Management

**Disabling IPv6 via GRUB:**
   - **Command `dg6`:** This function modifies the GRUB configuration to disable IPv6 at the system boot level. It adds the `ipv6.disable=1` parameter to the `GRUB_CMDLINE_LINUX_DEFAULT` and `GRUB_CMDLINE_LINUX` variables in `/etc/default/grub`, then updates GRUB to apply the changes. This method ensures that IPv6 is disabled from the moment the system starts, providing a more secure and persistent solution.

**Enabling IPv6 via GRUB:**
   - **Command `eg6`:** This function reverts the changes made by `disable_ipv6_grub` by removing the `ipv6.disable=1` parameter from the GRUB configuration. It ensures that IPv6 is re-enabled at the system boot level, allowing IPv6 traffic after the system restarts.

**Disabling IPv6 via sysctl:**
   - **Command `ds6`:** This function dynamically disables IPv6 at runtime using `sysctl` commands. It sets `net.ipv6.conf.all.disable_ipv6=1` and `net.ipv6.conf.default.disable_ipv6=1` to disable IPv6 immediately and adds these settings to `/etc/sysctl.conf` to ensure the changes persist after a reboot. This method provides a quick way to disable IPv6 without needing a system restart.

**Enabling IPv6 via sysctl:**
   - **Command `es6`:** This function dynamically re-enables IPv6 using `sysctl` commands. It sets `net.ipv6.conf.all.disable_ipv6=0` and `net.ipv6.conf.default.disable_ipv6=0` to enable IPv6 immediately and removes the corresponding entries from `/etc/sysctl.conf` to ensure the changes persist after a reboot. This method allows IPv6 traffic to resume without needing a system restart.

By incorporating these functions, the script offers flexible and persistent control over IPv6 configuration, enhancing the ability to manage network security and privacy effectively.

### Miscellaneous Functions

**Checking Applications Using External Network:**
   - **Command `i`:** Checks which applications are using the external network or the Tor network via proxychains. This helps identify potentially vulnerable or insecure processes.

**Displaying Help:**
   - **Command `h`:** Displays a help message detailing all available commands and their usage.

### Custom Configuration

The configuration variables `LAN_RANGE`, `SSH_PORT`, and `VNC_PORT` at the beginning of the script allow easy definition of:
- The local network range (`LAN_RANGE`).
- The ports used for SSH (`SSH_PORT`) and VNC (`VNC_PORT`).

This enables the user to customize the network configuration according to their specific needs. For example, you can configure the script to allow SSH and VNC connections, which is useful for remote use or in a virtual machine (VM).

### Security Benefits

1. **Anonymity and Privacy:**
   - By routing all network traffic through the Tor network, this script helps mask the user's real IP address, thereby enhancing online anonymity and privacy.

2. **Protection Against DNS Leaks:**
   - The script includes checks to detect and prevent DNS leaks, preventing DNS requests from being exposed to unsecured third parties.

3. **IPv6 Deactivation:**
   - Checks and ensures that IPv6 is disabled, reducing the risk of data leaks via unsecured IPv6 connections. Although IPv6 is disabled by default, an IPv6 configuration check is integrated.

4. **Automatic Firewall Rules Management:**
   - Automatically configures iptables rules to redirect traffic through Tor and block unsecured connections, thereby strengthening the user's network security.

5. **Monitoring and Control:**
   - Allows checking which applications are using the external network or the Tor network, helping to identify processes that might compromise security or anonymity.

### Techniques Used

- **Proxychains:** Used to redirect network traffic through Tor without requiring major modifications to existing network configurations.
- **Transparent Proxy:** Automatically configures iptables to redirect all network traffic through Tor, providing a comprehensive solution to secure traffic without requiring additional configuration on applications.
- **Leak Tests:** The script performs IPv4, IPv6, and DNS tests to ensure no sensitive data is leaked.
- **Color Display:** Script messages are colored for easier reading and status identification (success, failure, warning).

By using this script, users can significantly improve their online security by ensuring that all their network traffic is anonymized and protected against potential leaks. This script is a powerful tool for those looking to enhance their privacy and security on the Internet.

# Installation and Uninstallation Instructions for `kaliqtor.sh`

The following instructions will guide you through the process of installing and uninstalling the `kaliqtor.sh` script on a Kali Linux system. These scripts will ensure that `kaliqtor.sh` is correctly downloaded, installed, and executable, and that it can be easily removed when no longer needed.

### Installation Instructions

To install the `kaliqtor.sh` script, execute the following command in your terminal:

```bash
curl -s https://raw.githubusercontent.com/M3ro20j1/kaliqtor/main/install_kaliqtor.sh | zsh
```

**What this command does:**
1. **Downloads the Installation Script:** The command uses `curl` to download the `install_kaliqtor.sh` script from the GitHub repository.
2. **Executes the Script:** The downloaded script is immediately executed using `zsh`.
3. **Creates Directory:** The script creates a directory `~/.local/bin` if it doesn't already exist.
4. **Downloads `kaliqtor.sh`:** The main script `kaliqtor.sh` is downloaded to `~/.local/bin`.
5. **Makes the Script Executable:** The script is made executable.
6. **Updates PATH:** The script adds `~/.local/bin` to your `PATH` by modifying `~/.zprofile` if it is not already included.
7. **Sources `.zprofile`:** The script reloads `.zprofile` to apply the changes immediately.

### Uninstallation Instructions

To uninstall the `kaliqtor.sh` script, execute the following command in your terminal:

```bash
curl -s https://raw.githubusercontent.com/M3ro20j1/kaliqtor/main/uninstall_kaliqtor.sh | zsh
```

**What this command does:**
1. **Downloads the Uninstallation Script:** The command uses `curl` to download the `uninstall_kaliqtor.sh` script from the GitHub repository.
2. **Executes the Script:** The downloaded script is immediately executed using `zsh`.
3. **Removes `kaliqtor.sh`:** The script removes the `kaliqtor.sh` script from `~/.local/bin`.
4. **Removes Directory:** If the `~/.local/bin` directory is empty after the script removal, the directory is also removed.
5. **Updates PATH:** The script removes `~/.local/bin` from your `PATH` by modifying `~/.zprofile` if it was previously added.
6. **Sources `.zprofile`:** The script reloads `.zprofile` to apply the changes immediately.

### Summary

These commands provide a simple and efficient way to manage the `kaliqtor.sh` script on your Kali Linux system. The installation script ensures that the script is correctly placed and executable, while the uninstallation script cleans up all associated files and path entries. This approach keeps your environment tidy and ensures that you can easily switch between using and not using the `kaliqtor.sh` script.
