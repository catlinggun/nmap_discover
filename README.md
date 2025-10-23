# nmap_discover

A simple wrapper for nmap that performs several different types of discovery scans and aggregates them into live IP and live hostnames.

## Discovery Types

1. ICMP Echo
2. ICMP Netmask
3. ICMP Timestamp
4. ICMP Protocol
5. TCP SYN Port Discovery
	1. Ports 21,22,53,80,443,8080,8443
6. UDP Host Discovery
	1. 53,161,500

## Output

Each discovery phase is output into .nmap, .gnmap, and .xml files for later parsing, if desired.
Non-resolved hosts are deduped and placed into the live_ips file.
Resolved hosts are deduped and placed into the live_fqdns file.

Enjoy!
