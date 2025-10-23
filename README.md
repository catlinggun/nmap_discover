<font color="green">
#                                        ___
#   ____  ____ ___  ____ _____      ____/ (_)_____________ _   _____  _____
#  / __ \/ __ `__ \/ __ `/ __ \    / __  / / ___/ ___/ __ \ | / / _ \/ ___/
# / / / / / / / / / /_/ / /_/ /   / /_/ / (__  ) /__/ /_/ / |/ /  __/ /
#/_/ /_/_/ /_/ /_/\__,_/ .___/____\__,_/_/____/\___/\____/|___/\___/_/
#                     /_/   /_____/
</font>

A simple wrapper for nmap that performs several different types of discovery scans and aggregates them into live IP and live hostnames.

## Discovery Types

ICMP Echo
ICMP Netmask
ICMP Timestamp
ICMP Protocol
TCP SYN Port Discovery
	Ports 21,22,53,80,443,8080,8443
UDP Port Discovery
	53,161,500

## Output

Each discovery phase is output into .nmap, .gnmap, and .xml files for later parsing, if desired.
Non-resolved hosts are deduped and placed into the live_ips file.
Resolved hosts are deduped and placed into the live_fqdns file.

Enjoy!
