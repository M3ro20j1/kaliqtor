#!/bin/bash

set -e

# program information
readonly prog_name="kaliqtor"
readonly version="0.1"
readonly signature="Copyright (C) 2024 M3ro20j1"
readonly git_url="https://github.com/M3ro20j1/kaliqtor"

# Configuration variables
LAN_RANGE="192.168.0.0/16"
SSH_PORT=22
VNC_PORT=5901
DEBIAN_TOR_UID=$(id -u debian-tor)

# Function to print messages with color
print_message() {
  local color=$1
  local message=$2
  case $color in
    "green")
      echo -e "\e[32m$message\e[0m"
      ;;
    "red")
      echo -e "\e[31m$message\e[0m"
      ;;
    "yellow")
      echo -e "\e[33m$message\e[0m"
      ;;
    "blue")
      echo -e "\e[34m$message\e[0m"
      ;;
    *)
      echo "$message"
      ;;
  esac
}

# Function to display banner with program information
banner() {
  print_message "red" "░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓██████▓▒░▒▓████████▓▒░▒▓██████▓▒░░▒▓███████▓▒░ "
  print_message "red" "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ "
  print_message "red" "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ "
  print_message "red" "░▒▓███████▓▒░░▒▓████████▓▒░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░  "
  print_message "red" "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ "
  print_message "red" "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ "
  print_message "red" "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓█▓▒░░▒▓██████▓▒░  ░▒▓█▓▒░   ░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░ "
  print_message "red" "                                                ░▒▓█▓▒░                                          "
  print_message "red" "                                                 ░▒▓██▓▒░                                        "
  print_message "red" "================================================================================================ "
  print_message "green" "Program Name : $prog_name   Version : $version"
  print_message "green" "Signature : $signature   Git URL : $git_url"
  print_message "green" "================================================================================================ "
}

# Ensure jq is installed
if ! command -v jq &> /dev/null; then
  print_message "red" "jq is not installed. Installing jq..."
  sudo apt-get update && sudo apt-get install -y jq
fi

# Function to get external IP address
get_external_ip() {
  local ip=$(curl -s https://ident.me || curl -s https://icanhazip.com)
  if [ -z "$ip" ]; then
    print_message "red" "Failed to get external IP address."
    exit 1
  fi
  echo "$ip"
}

# Function to get external IP address using proxychains
get_external_ip_proxychains() {
  local ip=$(proxychains curl -s https://ident.me || proxychains curl -s https://icanhazip.com)
  if [ -z "$ip" ]; then
    print_message "red" "Failed to get external IP address through proxychains."
    exit 1
  fi
  echo "$ip"
}

# Function to check external IP address
check_ip() {
  print_message "blue" "Checking external IP address..."
  local current_ip=$1
  local initial_ip=$2

  if [ "$current_ip" != "$initial_ip" ]; then
    print_message "green" "IP address is correctly routed through Tor: $current_ip"
    return 0
  else
    print_message "red" "IP address is not routed through Tor: $current_ip"
    return 1
  fi
}

# Function to check DNS leaks
check_dns_leaks() {
  print_message "blue" "Checking for DNS leaks using dnsleaktest.com..."
  local dns_servers=$(curl -s https://dnsleaktest.com/test | grep -oP '(?<=<td>)[\d\.]+(?=</td>)')

  if [ -z "$dns_servers" ]; then
    print_message "green" "No DNS leaks detected."
    return 0
  else
    print_message "red" "DNS leaks detected: $dns_servers"
    return 1
  fi
}

# Function to check DNS leaks using proxychains
check_dns_leaks_proxychains() {
  print_message "blue" "Checking for DNS leaks using dnsleaktest.com through proxychains..."
  local dns_servers=$(proxychains curl -s https://dnsleaktest.com/test | grep -oP '(?<=<td>)[\d\.]+(?=</td>)')

  if [ -z "$dns_servers" ]; then
    print_message "green" "No DNS leaks detected."
    return 0
  else
    print_message "red" "DNS leaks detected: $dns_servers"
    return 1
  fi
}

# Function to check for IPv6 connectivity using ping6
check_ipv6_connectivity() {
  print_message "blue" "Checking for IPv6 connectivity with ping6..."
  if ping6 -c 1 google.com &> /dev/null; then
    print_message "red" "IPv6 connectivity detected. IPv6 is not properly disabled."
    return 1
  else
    print_message "green" "No IPv6 connectivity detected. IPv6 is properly disabled."
    return 0
  fi
}

# Function to configure iptables for Tor transparent proxy
setup_iptables() {
  # Flush existing rules
  sudo iptables -F
  sudo iptables -X
  sudo iptables -t nat -F
  sudo iptables -t nat -X

  # Default policies
  sudo iptables -P INPUT DROP
  sudo iptables -P FORWARD DROP
  sudo iptables -P OUTPUT DROP

  # Allow loopback traffic
  sudo iptables -A INPUT -i lo -j ACCEPT
  sudo iptables -A OUTPUT -o lo -j ACCEPT

  # Allow established and related traffic
  sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
  sudo iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  # Allow LAN access for specified range and ports
  sudo iptables -A INPUT -p tcp -s $LAN_RANGE --dport $SSH_PORT -j ACCEPT
  sudo iptables -A INPUT -p tcp -s $LAN_RANGE --dport $VNC_PORT -j ACCEPT

  sudo iptables -A OUTPUT -d $LAN_RANGE -p tcp --dport $SSH_PORT -j ACCEPT
  sudo iptables -A OUTPUT -d $LAN_RANGE -p tcp --dport $VNC_PORT -j ACCEPT
  sudo iptables -A OUTPUT -d $LAN_RANGE -j ACCEPT

  # Redirect all other TCP traffic to Tor
  sudo iptables -t nat -A OUTPUT -d 10.192.0.0/10 -p tcp --syn -j REDIRECT --to-ports 9040 -m comment --comment "Redirecting TCP traffic to Tor"
  sudo iptables -t nat -A OUTPUT -d 127.0.0.1/32 -p udp --dport 53 -j REDIRECT --to-ports 5353 -m comment --comment "Redirecting DNS traffic to Tor"
  sudo iptables -t nat -A OUTPUT -m owner --uid-owner $DEBIAN_TOR_UID -j RETURN -m comment --comment "Allow Tor process output"
  sudo iptables -t nat -A OUTPUT -o lo -j RETURN -m comment --comment "Allow loopback output"
  sudo iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040 -m comment --comment "Redirecting all other TCP traffic to Tor"

  # Drop invalid packets
  sudo iptables -A OUTPUT -m conntrack --ctstate INVALID -j DROP -m comment --comment "Dropping invalid packets"

  # Allow Tor process output
  sudo iptables -A OUTPUT -m owner --uid-owner $DEBIAN_TOR_UID -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -m state --state NEW -j ACCEPT

  # Allow loopback output
  sudo iptables -A OUTPUT -d 127.0.0.1/32 -o lo -j ACCEPT

  # Allow traffic to Tor's TransPort
  sudo iptables -A OUTPUT -d 127.0.0.1/32 -p tcp --dport 9040 --tcp-flags FIN,SYN,RST,ACK SYN -j ACCEPT
}

# Function to start Tor service
start_tor_service() {
  print_message "blue" "Verify Tor service..."
  
  # Ensure tor is installed and running
  if ! command -v tor &> /dev/null; then
    print_message "red" "Tor is not installed. Installing tor..."
    sudo apt-get update && sudo apt-get install -y tor
  fi

  # Check if Tor service is running, and restart it if necessary
  if sudo systemctl is-active --quiet tor; then
    print_message "yellow" "Tor service is already running. Restarting Tor service..."
    sudo systemctl restart tor
  else
    print_message "yellow" "Starting Tor service..."
    sudo systemctl start tor
  fi
}

# Function to start Tor and configure the transparent proxy
start_tor() {
  setup_iptables
  start_tor_service
}

# Function to stop Tor and restore default iptables rules
stop_tor() {
  print_message "blue" "Stopping Tor and restoring default iptables rules..."
  
  # Stop Tor service
  sudo systemctl stop tor
}

# Function to stop Tor and restore default iptables rules
stop_tor_proxy() {
  print_message "blue" "Stopping Tor and restoring default iptables rules..."
  
  # Stop Tor service
  sudo systemctl stop tor

  # Flush iptables rules
  sudo iptables -F
  sudo iptables -X
  sudo iptables -t nat -F
  sudo iptables -t nat -X

  # Default policies
  sudo iptables -P INPUT ACCEPT
  sudo iptables -P FORWARD ACCEPT
  sudo iptables -P OUTPUT ACCEPT
}

# Function to check for applications using external network
check_external_network_usage() {
  print_message "blue" "Checking for applications using external network..."

  # Get list of applications using external network
  local external_connections=$(lsof -i -P -n | grep 'ESTABLISHED' | grep -v '127.0.0.1' | grep -v "$LAN_RANGE")

  if [ -n "$external_connections" ]; then
    print_message "green" "Applications using external network found:"
    echo "$external_connections"
    
    # Ask if the user wants to stop the Tor service
    read -p "Do you want to stop the Tor service? (y/n): " answer
    if [ "$answer" == "y" ]; then
      sudo systemctl stop tor
      print_message "yellow" "Tor service stopped."
      return 0
    else
      print_message "yellow" "Tor service continues running."
      return 1
    fi
  else
    print_message "green" "No applications using external network found."
    return 0
  fi
}

# Function to check for applications using Tor network
check_tor_network_usage() {
  print_message "blue" "Checking for applications using Tor or proxychains..."

  # Get list of applications using Tor network
  local tor_connections=$(lsof -i -P -n | grep 'ESTABLISHED' | grep ':9050\|:9040')

  if [ -n "$tor_connections" ]; then
    print_message "green" "Applications using Tor network found:"
    echo "$tor_connections"
    
    # Ask if the user wants to stop the Tor service
    read -p "Do you want to stop the Tor service? (y/n): " answer
    if [ "$answer" == "y" ]; then
      sudo systemctl stop tor
      print_message "yellow" "Tor service stopped."
      return 0
    else
      print_message "yellow" "Tor service continues running."
      return 1
    fi
  else
    print_message "green" "No applications using Tor network found."
    return 0
  fi
}

# Function to check for applications using external network
check_external_network_usage_info() {
  print_message "blue" "Checking for applications using external network..."

  # Get list of applications using external network
  local external_connections=$(lsof -i -P -n | grep 'ESTABLISHED' | grep -v '127.0.0.1' | grep -v "$LAN_RANGE")

  if [ -n "$external_connections" ]; then
    print_message "green" "Applications using external network found:"
    echo "$external_connections"
  else
    print_message "green" "No applications using external network found."
  fi
}

# Function to check for applications using Tor network
check_tor_network_usage_info() {
  print_message "blue" "Checking for applications using Tor or proxychains..."

  # Get list of applications using Tor network
  local tor_connections=$(lsof -i -P -n | grep 'ESTABLISHED' | grep ':9050\|:9040')

  if [ -n "$tor_connections" ]; then
    print_message "green" "Applications using Tor network found:"
    echo "$tor_connections"
  else
    print_message "green" "No applications using Tor network found."
    return 0
  fi
}

# Function to disable IPv6 in GRUB
disable_ipv6_grub() {
  local grub_config="/etc/default/grub"
  local grub_backup="/etc/default/grub.bak"

  # Create a backup of the current GRUB configuration
  sudo cp $grub_config $grub_backup
  print_message "yellow" "Backup of GRUB configuration created at $grub_backup"

  # Function to add ipv6.disable=1 if not already present
  add_ipv6_disable() {
    local line=$1
    if [[ $line != *"ipv6.disable=1"* ]]; then
      echo "$line ipv6.disable=1"
    else
      echo "$line"
    fi
  }

  # Modify GRUB_CMDLINE_LINUX_DEFAULT
  local current_default=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" $grub_config)
  local new_default=$(add_ipv6_disable "$current_default")
  sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|$new_default|" $grub_config

  # Modify GRUB_CMDLINE_LINUX
  local current_linux=$(grep "^GRUB_CMDLINE_LINUX=" $grub_config)
  local new_linux=$(add_ipv6_disable "$current_linux")
  sudo sed -i "s|^GRUB_CMDLINE_LINUX=.*|$new_linux|" $grub_config

  print_message "green" "IPv6 disabled in GRUB configuration."

  # Update GRUB
  sudo update-grub
  print_message "blue" "GRUB configuration updated. Please reboot your system for the changes to take effect."
}

# Function to enable IPv6 in GRUB
enable_ipv6_grub() {
  local grub_config="/etc/default/grub"
  local grub_backup="/etc/default/grub.bak"

  # Create a backup of the current GRUB configuration
  sudo cp $grub_config $grub_backup
  print_message "yellow" "Backup of GRUB configuration created at $grub_backup"

  # Function to remove ipv6.disable=1 if present
  remove_ipv6_disable() {
    local line=$1
    echo "$line" | sed 's/ipv6\.disable=1//g'
  }

  # Modify GRUB_CMDLINE_LINUX_DEFAULT
  local current_default=$(grep "^GRUB_CMDLINE_LINUX_DEFAULT=" $grub_config)
  local new_default=$(remove_ipv6_disable "$current_default")
  sudo sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|$new_default|" $grub_config

  # Modify GRUB_CMDLINE_LINUX
  local current_linux=$(grep "^GRUB_CMDLINE_LINUX=" $grub_config)
  local new_linux=$(remove_ipv6_disable "$current_linux")
  sudo sed -i "s|^GRUB_CMDLINE_LINUX=.*|$new_linux|" $grub_config

  print_message "green" "IPv6 enabled in GRUB configuration."

  # Update GRUB
  sudo update-grub
  print_message "blue" "GRUB configuration updated. Please reboot your system for the changes to take effect."
}

# Function to disable IPv6 using sysctl
disable_ipv6_sysctl() {
  print_message "yellow" "Disabling IPv6 with sysctl..."

  # Disable IPv6 immediately
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1

  # Ensure the changes persist after reboot
  echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf
  echo "net.ipv6.conf.default.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf

  # Reload sysctl settings
  sudo sysctl -p >/dev/null 2>&1

  print_message "green" "IPv6 has been disabled using sysctl."
}

# Function to enable IPv6 using sysctl
enable_ipv6_sysctl() {
  print_message "yellow" "Enabling IPv6 with sysctl..."

  # Enable IPv6 immediately
  sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0 >/dev/null 2>&1
  sudo sysctl -w net.ipv6.conf.default.disable_ipv6=0 >/dev/null 2>&1

  # Ensure the changes persist after reboot
  sudo sed -i '/net.ipv6.conf.all.disable_ipv6 = 1/d' /etc/sysctl.conf
  sudo sed -i '/net.ipv6.conf.default.disable_ipv6 = 1/d' /etc/sysctl.conf

  # Reload sysctl settings
  sudo sysctl -p >/dev/null 2>&1

  print_message "green" "IPv6 has been enabled using sysctl."
}

# Function to display help
show_help() {
  banner
  echo "Usage: $0 [OPTION]"
  echo "Options:"
  echo "  c    Connect to Tor and check for leaks using proxychains"
  echo "  t    Test for leaks using proxychains without starting Tor"
  echo "  tp   Test for leaks in transparent proxy mode without proxychains"
  echo "  d    Disconnect Tor and display public IP"
  echo "  ap   Activate transparent proxy through Tor and check for leaks without proxychains"
  echo "  dp   Deactivate transparent proxy through Tor"
  echo "  dg6   Disable IPV6 in grub"
  echo "  eg6   Enable IPV6 in grub"
  echo "  ds6   Disable IPV6 in sysctl"
  echo "  es6   Enable IPV6 in sysctl"
  echo "  i    Tasks using external network or tor via proxchains"
  echo "  h    Display this help message"
}

# Main script execution
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

case "$1" in
  c)
    banner
    print_message "blue" "Starting Tor and checking for leaks using proxychains..."
    
    initial_ip=$(get_external_ip)
    print_message "yellow" "Initial IP address: $initial_ip"

    start_tor_service

    sleep 5

    current_ip=$(get_external_ip_proxychains)
    check_ip "$current_ip" "$initial_ip"
    IP_CHECK=$?

    check_dns_leaks_proxychains
    DNS_CHECK=$?

    check_ipv6_connectivity
    IPV6_CHECK=$?

    if [ $IP_CHECK -eq 0 ] && [ $DNS_CHECK -eq 0 ] && [ $IPV6_CHECK -eq 0 ]; then
      print_message "green" "No leaks detected. Your Tor configuration is secure."
    else
      print_message "red" "Leaks detected. Please check your Tor configuration."
    fi
    ;;

  t)
    banner
    print_message "blue" "Checking for leaks using proxychains without starting Tor..."
    
    initial_ip=$(get_external_ip)
    print_message "yellow" "Initial IP address: $initial_ip"

    check_tor_network_usage_info

    start_tor_service

    sleep 5

    current_ip=$(get_external_ip_proxychains)
    check_ip "$current_ip" "$initial_ip"
    IP_CHECK=$?

    check_dns_leaks_proxychains
    DNS_CHECK=$?

    check_ipv6_connectivity
    IPV6_CHECK=$?

    if [ $IP_CHECK -eq 0 ] && [ $DNS_CHECK -eq 0 ] && [ $IPV6_CHECK -eq 0 ]; then
      print_message "green" "No leaks detected. Your Tor configuration is secure."
    else
      print_message "red" "Leaks detected. Please check your Tor configuration."
    fi
    ;;

  d)
    banner
    print_message "blue" "Stopping Tor and displaying public IP..."
    
    if check_tor_network_usage; then
      stop_tor
    else
      print_message "yellow" "Tor service continues running. Exiting dp without stopping Tor."
    fi

    public_ip=$(get_external_ip)
    print_message "yellow" "Public IP address: $public_ip"
    ;;

  ap)
    banner
    print_message "blue" "Activating transparent proxy through Tor and checking for leaks without proxychains..."

    initial_ip=$(get_external_ip)
    print_message "yellow" "Initial IP address: $initial_ip"

    start_tor

    sleep 5

    current_ip=$(get_external_ip)
    check_ip "$current_ip" "$initial_ip"
    IP_CHECK=$?

    check_dns_leaks
    DNS_CHECK=$?

    check_ipv6_connectivity
    IPV6_CHECK=$?

    if [ $IP_CHECK -eq 0 ] && [ $DNS_CHECK -eq 0 ] && [ $IPV6_CHECK -eq 0 ]; then
      print_message "green" "No leaks detected. Your Tor configuration is secure."
    else
      print_message "red" "Leaks detected. Please check your Tor configuration."
    fi
    ;;

  tp)
    banner
    print_message "blue" "Checking for leaks in transparent proxy mode without proxychains..."
    
    initial_ip=$(get_external_ip)
    print_message "yellow" "Initial IP address: $initial_ip"

    current_ip=$(get_external_ip)
    check_ip "$current_ip" "$initial_ip"
    IP_CHECK=$?

    check_external_network_usage_info

    check_dns_leaks
    DNS_CHECK=$?

    check_ipv6_connectivity
    IPV6_CHECK=$?

    if [ $IP_CHECK -eq 0 ] && [ $DNS_CHECK -eq 0 ] && [ $IPV6_CHECK -eq 0 ]; then
      print_message "green" "No leaks detected. Your Tor configuration is secure."
    else
      print_message "red" "Leaks detected. Please check your Tor configuration."
    fi
    ;;

  dp)
    banner
    print_message "blue" "Deactivating transparent proxy through Tor..."
    if check_external_network_usage; then
      stop_tor_proxy
    else
      print_message "yellow" "Tor service continues running. Exiting dp without stopping Tor."
    fi
    ;;

  dg6)
    banner
    print_message "blue" "Disable IPV6 in grub"
    disable_ipv6_grub
    ;;

  eg6)
    banner
    print_message "blue" "Enable IPV6 in grub"
    enable_ipv6_grub
    ;;

  ds6)
    banner
    print_message "blue" "Enable IPV6 in sysctl"
    enable_ipv6_sysctl
    ;;

  es6)
    banner
    print_message "blue" "Enable IPV6 in sysctl"
    enable_ipv6_sysctl
    ;;

  h)
    banner
    show_help
    ;;

  i)
    banner
    print_message "blue" "Current task using external network or tor via proxchains..."
    initial_ip=$(get_external_ip)
    print_message "yellow" "External IP address: $initial_ip"
    check_external_network_usage_info
    check_tor_network_usage_info
    ;;

  *)
    banner
    print_message "red" "Invalid option. Use 'h' for help."
    show_help
    exit 1
    ;;
esac
