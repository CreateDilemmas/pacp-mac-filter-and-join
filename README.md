# pcap-mac-filter-and-join
Filters multiple pcaps by MAC, and joins the results together into one file.

Decided to make this for the sake of speed.
It takes a MAC address as input (prompting the user interactively instead of using a command-line argument), creates a Wireshark filter for that MAC address for every .pcap file in the directory where the batch file resides, and then combines the filtered files in chronological order using Wireshark's tshark and mergecap tools, saving the result to a single output file, with the MAC in the filename for easy reference. The script assumes the default Windows installation path for Wireshark tools.

