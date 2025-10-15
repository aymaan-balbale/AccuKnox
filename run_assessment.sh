#!/bin/bash

# =================================================================
# Security Assessment Script for itsecgames.com
# Author: Aymaan Balbale
# Date: October 15, 2025
#
# This script automates the reconnaissance and vulnerability
# scanning process performed during the assessment.
# =================================================================

# --- Configuration ---
TARGET="itsecgames.com"
OUTPUT_DIR="scans"
WORDLIST="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"

# --- Script Start ---
echo "--- Starting Security Assessment for $TARGET ---"

# Create a directory to store scan results
echo "[+] Creating output directory: $OUTPUT_DIR"
mkdir -p $OUTPUT_DIR

# --- 1. Nmap - Network Reconnaissance ---
echo "[+] Starting Nmap scan... (This may take a while)"
nmap -sV -p- -T4 $TARGET -oA "$OUTPUT_DIR/nmap_full"
echo "[*] Nmap scan complete. Results saved in '$OUTPUT_DIR/'."

# --- 2. Nikto - Web Server Vulnerability Scanning ---
echo "[+] Starting Nikto scan on HTTP..."
nikto -h http://$TARGET -output "$OUTPUT_DIR/nikto_http.txt"
echo "[*] Nikto HTTP scan complete."

echo "[+] Starting Nikto scan on HTTPS..."
nikto -h https://$TARGET -output "$OUTPUT_DIR/nikto_https.txt"
echo "[*] Nikto HTTPS scan complete."

# --- 3. sslscan - SSL/TLS Configuration Analysis ---
echo "[+] Starting sslscan for detailed TLS analysis..."
sslscan $TARGET > "$OUTPUT_DIR/sslscan_results.txt"
echo "[*] sslscan complete. Results saved to '$OUTPUT_DIR/sslscan_results.txt'."

# --- 4. Gobuster - Directory and File Enumeration ---
echo "[+] Starting Gobuster for directory discovery..."
if [ -f "$WORDLIST" ]; then
    gobuster dir -u https://$TARGET -w "$WORDLIST" -t 50 -k -o "$OUTPUT_DIR/gobuster_results.txt"
    echo "[*] Gobuster scan complete. Results saved to '$OUTPUT_DIR/gobuster_results.txt'."
else
    echo "[!] Wordlist not found at $WORDLIST. Skipping Gobuster scan."
fi

echo "--- Security Assessment Script Finished ---"
echo "All results are located in the '$OUTPUT_DIR' directory."
