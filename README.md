## Description of the Script kaliqtor.sh

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
