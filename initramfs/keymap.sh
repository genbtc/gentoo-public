# extracted from https://github.com/gentoo/genkernel/blob/master/defaults/initrd.scripts

chooseKeymap() {
	good_msg "Loading keymaps"
	if [ -z "${keymap}" ]
	then
		#splash 'verbose' >/dev/null &
		cat /lib/keymaps/keymapList
		read -t 10 -p '<< Load keymap (Enter for default): ' keymap
		case ${keymap} in
			1|azerty) keymap=azerty ;;
			2|be) keymap=be ;;
			3|bepo) keymap=bepo ;;
			4|bg) keymap=bg ;;
			5|br-a) keymap=br-a ;;
			6|br-l) keymap=br-l ;;
			7|by) keymap=by ;;
			8|cf) keymap=cf ;;
			9|colemak) keymap=colemak ;;
			10|croat) keymap=croat ;;
			11|cz) keymap=cz ;;
			12|de) keymap=de ;;
			13|dk) keymap=dk ;;
			14|dvorak) keymap=dvorak ;;
			15|es) keymap=es ;;
			16|et) keymap=et ;;
			17|fi) keymap=fi ;;
			18|fr) keymap=fr ;;
			19|gr) keymap=gr ;;
			20|hu) keymap=hu ;;
			21|il) keymap=il ;;
			22|is) keymap=is ;;
			23|it) keymap=it ;;
			24|jp) keymap=jp ;;
			25|la) keymap=la ;;
			26|lt) keymap=lt ;;
			27|mk) keymap=mk ;;
			28|nl) keymap=nl ;;
			29|no) keymap=no ;;
			30|pl) keymap=pl ;;
			31|pt) keymap=pt ;;
			32|ro) keymap=ro ;;
			33|ru) keymap=ru ;;
			34|se) keymap=se ;;
			35|sf|ch*) keymap=sf ;;
			36|sg) keymap=sg ;;
			37|sk-y) keymap=sk-y ;;
			38|sk-z) keymap=sk-z ;;
			39|slovene) keymap=slovene ;;
			40|trf) keymap=trf ;;
			41|ua) keymap=ua ;;
			42|uk) keymap=uk ;;
			43|us) keymap=us ;;
			44|wangbe) keymap=wangbe ;;
		esac
	fi

	if [ -e /lib/keymaps/${keymap}.map ]
	then
		good_msg "Loading the '${keymap}' keymap ..."
		loadkmap < /lib/keymaps/${keymap}.map

		mkdir -p /etc/sysconfig
		echo "XKEYBOARD=${keymap}" > /etc/sysconfig/keyboard
#		splash set_msg "Set keymap to '${keymap}'"
		good_msg "Set keymap to '${keymap}'"
	elif [ -z "${keymap}" ]
	then
		good_msg
		good_msg "Keeping default keymap"
#		splash set_msg "Keeping default keymap"
	else
		bad_msg "Sorry, but keymap '${keymap}' is invalid!"
		unset keymap
		chooseKeymap
	fi
}

#
# Copy over user selected keymap
#
copyKeymap() {
	if [ -e /etc/sysconfig/keyboard -a ${CDROOT} -eq 1 ]
	then
		[ ! -d ${NEW_ROOT}/etc/sysconfig ] && mkdir -p ${NEW_ROOT}/etc/sysconfig
		cp /etc/sysconfig/keyboard ${NEW_ROOT}/etc/sysconfig/keyboard
	fi
}

log_msg() {
	#is_log_enabled || return

	if [ ! -f "${GK_INIT_LOG}" ]
	then
		touch "${GK_INIT_LOG}" 2>/dev/null || return
	fi

	local log_prefix=
	[ -n "${GK_INIT_LOG_PREFIX}" ] && log_prefix="${GK_INIT_LOG_PREFIX}: "

	local msg=${1}

	# Cannot use substitution because $msg could contain infinite color
	# codes and substitution can't be greedy.
	# Because Busybox's sed cannot deal with control characters, we
	# have to get rid of all non-printable characters like "^[" first...
	LANG=C echo "] ${log_prefix}${msg}" | sed \
		-e "s,[^[:print:]],,g" \
		-e 's,\(\\033\)\?\[[0-9;]\+m,,g' \
		| ts '[ %Y-%m-%d %H:%M:%.S' >> "${GK_INIT_LOG}"
}

good_msg() {
	local msg_string=${1}
	msg_string="${msg_string:-...}"

	log_msg "[OK] ${msg_string}"

	is_true "${2-${QUIET}}" || printf "%b\n" "${GOOD}>>${NORMAL}${BOLD} ${msg_string} ${NORMAL}"
}

bad_msg() {
	local msg_string=${1}
	msg_string="${msg_string:-...}"

	log_msg "[!!] ${msg_string}"

	#splash 'verbose' >/dev/null &
	printf "%b\n" "${BAD}!!${NORMAL}${BOLD} ${msg_string} ${NORMAL}"
}

#splash is for plymouth
