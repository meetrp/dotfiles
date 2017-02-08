#!/bin/sh


#
#--------------------------------- constants
fn_check_dependencies() {
	local __cmd=${1}
	local __path=$(which ${__cmd})

	if [ $? -ne 0 ]; then
		echo "****************** !! \${__cmd}\' IS NOT AVAILABLE !! ******************"
		exit 1
	fi

	echo ${__path}
}

#
#--------------------------------- constants
AWK=$(fn_check_dependencies awk)
ECHO=$(fn_check_dependencies echo)
DEPMOD=$(fn_check_dependencies depmod)
GREP=$(fn_check_dependencies grep)
IP=$(fn_check_dependencies ip)
IPTABLES=$(fn_check_dependencies iptables)
MODPROBE=$(fn_check_dependencies modprobe)
NETSTAT=$(fn_check_dependencies netstat)

#
#--------------------------------- functions
fn_get_wan_iface() {
	${ECHO} $(${IP} route show | ${GREP} default | ${AWK} '{print $5}')
}

fn_get_lan_iface() {
	local _wan_ip=$(fn_get_wan_iface)
	${ECHO} $(${NETSTAT} -i | ${GREP} -ve lo -ve Iface -ve Kernel -ve ${_wan_ip} | ${AWK} '{print $1}')
}

fn_load_mod() {
	local __mod_name=${1}
	${ECHO} " |->; ${__mod_name}"
	${MODPROBE} ${__mod_name}
	if [ $? -ne 0 ]; then
		${ECHO} "****************** !! FAILED TO LOAD ${__mod_name} !! ******************"
		exit 1
	fi
}

fn_load_modules() {
	${ECHO} " - Loading kernel modules: "
	${DEPMOD} -a
	fn_load_mod ip_tables
	fn_load_mod nf_conntrack
	fn_load_mod nf_conntrack_ftp
	fn_load_mod nf_conntrack_irc
	fn_load_mod iptable_nat
	fn_load_mod nf_nat_ftp
	${ECHO}
}

fn_enable_ipv4_forwarding() {
	${ECHO} " - Enabling forwarding.."
	${ECHO} "1" > /proc/sys/net/ipv4/ip_forward
}

fn_enable_ipv4_dynamic_addr() {
	${ECHO} " - Enabling DynamicAddr.."
	${ECHO} "1" > /proc/sys/net/ipv4/ip_dynaddr
}

fn_clear_previous_fw_rules() {
	${ECHO} " - Clearing existing firewall rules"
	${IPTABLES} -t nat -D POSTROUTING -o "$WANIF" -j MASQUERADE
	${IPTABLES} -t filter -D FORWARD -i "$WANIF" -o "$LANIF" -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT 
	${IPTABLES} -t filter -D FORWARD -i "$LANIF" -o "$WANIF" -j ACCEPT
	${IPTABLES} -t filter -D FORWARD -j LOG
}

fn_create_fw_rules() {
	${ECHO} " - Enabling firewall rules"
	${IPTABLES} -t nat -A POSTROUTING -o "$WANIF" -j MASQUERADE
	${IPTABLES} -t filter -A FORWARD -i "$WANIF" -o "$LANIF" -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT 
	${IPTABLES} -t filter -A FORWARD -i "$LANIF" -o "$WANIF" -j ACCEPT
	${IPTABLES} -t filter -A FORWARD -j LOG
}

#
#--------------------------------- Main
${ECHO}
${ECHO} "======================= Enabling NAT on Ubuntu Linux ======================="
${ECHO}

WANIF=$(fn_get_wan_iface)
LANIF=$(fn_get_lan_iface)

${ECHO} "WAN Interface: $WANIF"
${ECHO} "LAN Interface: $LANIF"
${ECHO}

${ECHO} "Setting up network:"
fn_load_modules
fn_enable_ipv4_forwarding
fn_enable_ipv4_dynamic_addr
fn_clear_previous_fw_rules
fn_create_fw_rules
${ECHO}
