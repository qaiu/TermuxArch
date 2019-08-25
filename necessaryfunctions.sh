#!/bin/env bash
# Copyright 2017-2018 by SDRausty. All rights reserved.  🌎 🌍 🌏 🌐 🗺
# Hosted sdrausty.github.io/TermuxArch courtesy https://pages.github.com
# https://sdrausty.github.io/TermuxArch/README has info about this project. 
# https://sdrausty.github.io/TermuxArch/CONTRIBUTORS Thank you for your help.  
# _STANDARD_="function name" && STANDARD="variable name" are under construction.
################################################################################


LC_TYPE=( "LANG" "LANGUAGE" "LC_ADDRESS" "LC_COLLATE" "LC_CTYPE" "LC_IDENTIFICATION" "LC_MEASUREMENT" "LC_MESSAGES" "LC_MONETARY" "LC_NAME" "LC_NUMERIC" "LC_PAPER" "LC_TELEPHONE" "LC_TIME" )

_ADDADDS_() {
	addREADME
	addae
	addauser
	addbash_logout 
	addbash_profile 
	addbashrc 
	addcdtd
	addcdth
	addcdtmp
	addch 
	adddfa
	addfbindexample
	addbinds
	addexd
	addfibs
	addga
	addgcl
	addgcm
	addgp
	addgpl
	addkeys
	addmotd
	addmoto
	addpc
	addpci
	addprofile 
	addresolvconf 
	addt 
	addtour
	addtrim 
	addyt
	addwe  
	addv 
}
	
_CALLSYSTEM_() {
	declare COUNTER=""
	if [[ "$CPUABI" = "$CPUABIX86" ]] || [[ "$CPUABI" = "$CPUABIX86_64" ]];then
		_GETIMAGE_
	else
		if [[ "$CMIRROR" = "os.archlinuxarm.org" ]] || [[ "$CMIRROR" = "mirror.archlinuxarm.org" ]]; then
			until _FTCHSTND_;do
				_FTCHSTND_ ||: 
				sleep 2
				printf "\\n"
				COUNTER=$((COUNTER + 1))
				if [[ "$COUNTER" = 4 ]];then 
					_PRINTMAX_ 
					exit
				fi
			done
		else
			_FTCHIT_
		fi
	fi
}

_COPYSTARTBIN2PATH_() {
	if [[ ":$PATH:" == *":$HOME/bin:"* ]] && [[ -d "$HOME"/bin ]]; then
		BPATH="$HOME"/bin
	else
		BPATH="$PREFIX"/bin
	fi
	cp "$INSTALLDIR/$STARTBIN" "$BPATH"
	printf "\\e[0;34m 🕛 > 🕦 \\e[1;32m$STARTBIN \\e[0mcopied to \\e[1m$BPATH\\e[0m.\\n\\n"
}

_DETECTSYSTEM_() {
	_PRINTDETECTEDSYSTEM_
	if [[ "$CPUABI" = "$CPUABI5" ]];then
		_ARMV5L_
	elif [[ "$CPUABI" = "$CPUABI7" ]];then
		_DETECTSYSTEM2_ 
	elif [[ "$CPUABI" = "$CPUABI8" ]];then
		_AARCH64_
	elif [[ "$CPUABI" = "$CPUABIX86" ]];then
		_I686_ 
	elif [[ "$CPUABI" = "$CPUABIX86_64" ]];then
		_X86_64_
	else
		_PRINTMISMATCH_ 
	fi
}

_DETECTSYSTEM2_() {
	if [[ "$(getprop ro.product.device)" == *_cheets ]];then
		armv7lChrome 
	else
		armv7lAndroid  
	fi
}

_KERNID_() {
	declare KID=""
	ur="$("$PREFIX"/bin/uname -r)"
	declare -i KERNEL_VERSION="$(echo "$ur" |awk -F'.' '{print $1}')"
	declare -i MAJOR_REVISION="$(echo "$ur" |awk -F'.' '{print $2}')"
	declare -- TMP="$(echo "$ur" |awk -F'.' '{print $3}')"
	declare -- MINOR_REVISION="$(echo "${TMP:0:3}" |sed 's/[^0-9]*//g')"
	if [[ "$KERNEL_VERSION" -le 2 ]]; then
		KID=1
	else
		if [[ "$KERNEL_VERSION" -eq 3 ]]; then
			if [[ "$MAJOR_REVISION" -lt 2 ]]; then
				KID=1
			else
				if [[ "$MAJOR_REVISION" -eq 2 ]] && [[ "$MINOR_REVISION" -eq 0 ]]; then
					KID=1
				fi
			fi
		fi
	fi
}

_KERNID_ 

_MAINBLOCK_() { 
	_NAMESTARTARCH_ 
	_SPACEINFO_
	_PREPINSTALLDIR_
	_DETECTSYSTEM_ 
	_WAKEUNLOCK_ 
	_PRINTFOOTER_
	set +Eeuo pipefail
	"$INSTALLDIR/$STARTBIN" ||:
	set -Eeuo pipefail
	_PRINTSTARTBIN_USAGE_
	_PRINTFOOTER2_
}

_MAKEFINISHSETUP_() {
	BINFNSTP=finishsetup.sh  
	_CFLHDR_ root/bin/"$BINFNSTP"
	cat >> root/bin/"$BINFNSTP" <<- EOM
	printf "\\n\\e[0;32m%s\\e[1;32m%s\\e[0;32m%s\\e[1;32m%s\\e[0;32m%s\\n\\n\\e[1;32m%s\\e[0;32m" "To generate locales in a preferred language use " "Settings > Language & Keyboard > Language " "in Android; Then run " "${0##*/} r " "for a quick system refresh; For full system refresh use ${0##*/} re[fresh]." "==> "
   	locale-gen ||:
	printf "\\n\\e[1;34m:: \\e[1;37mRemoving redundant packages for Termux PRoot installation…\\n"
	EOM
	if [[ -z "${LCR:-}" ]] ; then
	 	if [[ "$CPUABI" = "$CPUABI5" ]];then
	 		printf "pacman -Rc linux-armv5 linux-firmware --noconfirm --color=always 2>/dev/null ||:\\n" >> root/bin/"$BINFNSTP"
	 	elif [[ "$CPUABI" = "$CPUABI7" ]];then
	 		printf "pacman -Rc linux-armv7 linux-firmware --noconfirm --color=always 2>/dev/null ||:\\n" >> root/bin/"$BINFNSTP"
	 	elif [[ "$CPUABI" = "$CPUABI8" ]];then
	 		printf "pacman -Rc linux-aarch64 linux-firmware --noconfirm --color=always 2>/dev/null ||:\\n" >> root/bin/"$BINFNSTP"
	 	fi
		if [[ "$CPUABI" = "$CPUABIX86" ]];then
			printf "./root/bin/keys x86\\n" >> root/bin/"$BINFNSTP"
		elif [[ "$CPUABI" = "$CPUABIX86_64" ]];then
			printf "./root/bin/keys x86_64\\n" >> root/bin/"$BINFNSTP"
		else
	 		printf "./root/bin/keys\\n" >> root/bin/"$BINFNSTP"
		fi
		if [[ "$CPUABI" = "$CPUABIX86" ]] || [[ "$CPUABI" = "$CPUABIX86_64" ]];then
			printf "./root/bin/pci gzip sed \\n" >> root/bin/"$BINFNSTP"
		else
	 		printf "./root/bin/pci \\n" >> root/bin/"$BINFNSTP"
		fi
	fi
	if [[ -e "$HOME"/.bash_profile ]];then
		grep "proxy" "$HOME"/.bash_profile | grep "export" >> root/bin/"$BINFNSTP" 2>/dev/null ||:
	fi
	if [[ -e "$HOME"/.bashrc ]];then
		grep "proxy" "$HOME"/.bashrc  | grep "export" >> root/bin/"$BINFNSTP" 2>/dev/null ||:
	fi
	if [[ -e "$HOME"/.profile ]];then
		grep "proxy" "$HOME"/.profile | grep "export" >> root/bin/"$BINFNSTP" 2>/dev/null ||:
	fi
	cat >> root/bin/"$BINFNSTP" <<- EOM
	printf "\\n\\e[1;34m%s  \\e[0m" "🕛 > 🕤 Arch Linux in Termux is installed and configured 📲 " 
	printf "\\e]2;%s\\007" " 🕛 > 🕤 Arch Linux in Termux is installed and configured 📲 "
	EOM
	chmod 700 root/bin/"$BINFNSTP" 
}

_MAKESETUPBIN_() {
	_CFLHDR_ root/bin/setupbin.sh 
	cat >> root/bin/setupbin.sh <<- EOM
	set +Eeuo pipefail
	EOM
	echo "$PROOTSTMNT /root/bin/finishsetup.sh ||:" >> root/bin/setupbin.sh 
	cat >> root/bin/setupbin.sh <<- EOM
	set -Eeuo pipefail
	EOM
	chmod 700 root/bin/setupbin.sh
}

_MAKESTARTBIN_() {
	_CFLHDR_ "$STARTBIN" 
	printf "%s\\n" "${FLHDRP[@]}" >> "$STARTBIN"
	cat >> "$STARTBIN" <<- EOM
	COMMANDIF="\$(command -v getprop)" ||:
	if [[ "\$COMMANDIF" = "" ]] ; then
 		printf "\\n\\e[1;48;5;138m  %s\\e[0m\\n\\n" "\${0##*/} WARNING: Run \${0##*/} and $INSTALLDIR/\${0##*/} from the BASH shell in the OS system in Termux, e.g., Amazon Fire, Android and Chromebook."
		exit 202
	fi
	declare -g ar2ar="\${@:2}"
	declare -g ar3ar="\${@:3}"
	_PRINTUSAGE_() { 
	printf "\\e]2;%s\\007" "TermuxArch $STARTBIN help 📲" 
	printf "\\n\\e[1;32m%s\\e[0;32m%s\\n\\n" "$STARTBIN" ": Start Arch Linux as root.  This account is reserved for system administration."  
	printf "\\e[1;32m%s\\e[0;32m%s\\n\\n" "$STARTBIN c[md] cmd" ": Run Arch Linux command from Termux as root user." 
	printf "\\e[1;32m%s\\e[0;32m%s\\e[1;32m%s\\e[0;32m%s\\n\\n" "$STARTBIN u[ser]|l[ogin] user" ": Login as user.  Use " "$STARTBIN c addauser user " "first to create this user and user's home directory."
	printf "\\e[1;32m%s\\e[0;32m%s\\e[1;32m%s\\e[0;32m%s\\e[1;32m%s\\e[0;32m%s\\n\\n" "$STARTBIN r[aw]" ": Construct the " "$STARTBIN " "proot statement from exec.../bin/.  For example " "$STARTBIN r su " "will exec su in Arch Linux."
	printf "\\e[1;32m%s\\e[0;32m%s\\e[1;32m%s\\e[0;32m%s\\n\\n\\e[0m" "$STARTBIN s[u] user cmd" ": Login as user and execute command.  Use " "$STARTBIN c addauser user " "first to create this user and user's home directory."
	}

	# [] Default Arch Linux in Termux PRoot root login.
	if [[ -z "\${1:-}" ]];then
		set +Eeuo pipefail
	EOM
		echo "$PROOTSTMNT /bin/bash -l ||: " >> "$STARTBIN"
	cat >> "$STARTBIN" <<- EOM
		set -Eeuo pipefail
		printf '\033]2; TermuxArch $STARTBIN 📲  \007'
	# [?|help] Displays usage information.
	elif [[ "\${1//-}" = [?]* ]] || [[ "\${1//-}" = [Hh]* ]] ; then
		_PRINTUSAGE_
	# [command ARGS] Execute a command in BASH as root.
	elif [[ "\${1//-}" = [Cc]* ]] ; then
		printf '\033]2; $STARTBIN command ARGS 📲  \007'
		touch $INSTALLDIR/root/.chushlogin
		set +Eeuo pipefail
	EOM
		echo "$PROOTSTMNT /bin/bash -lc \"\$ar2ar\" ||:" >> "$STARTBIN"
	cat >> "$STARTBIN" <<- EOM
		set -Eeuo pipefail
		printf '\033]2; $STARTBIN command ARGS 📲  \007'
		rm -f $INSTALLDIR/root/.chushlogin
	# [login user|login user [options]] Login as user [plus options].  Use \`addauser user\` first to create this user and user's home directory.
	elif [[ "\${1//-}" = [Ll]* ]] || [[ "\${1//-}" = [Uu]* ]] ; then
		printf '\033]2; $STARTBIN login user [options] 📲  \007'
		set +Eeuo pipefail
	EOM
		echo "$PROOTSTMNTU /bin/su - \"\$ar2ar\" ||:" >> "$STARTBIN"
	cat >> "$STARTBIN" <<- EOM
		set -Eeuo pipefail
		printf '\033]2; $STARTBIN login user [options] 📲  \007'
	# [raw ARGS] Construct the \`startarch\` proot statement.  For example \`startarch r su\` will exec su in Arch Linux.  See PROOTSTMNT for more options; share your thoughts at https://github.com/sdrausty/TermuxArch/issues and https://github.com/sdrausty/TermuxArch/pulls.
	elif [[ "\${1//-}" = [Rr]* ]] ; then
		printf '\033]2; $STARTBIN raw ARGS 📲  \007'
		set +Eeuo pipefail
	EOM
		echo "$PROOTSTMNT /bin/\"\$ar2ar\" ||:" >> "$STARTBIN"
	cat >> "$STARTBIN" <<- EOM
		set -Eeuo pipefail
		printf '\033]2; $STARTBIN raw ARGS 📲  \007'
	# [su user command] Login as user and execute command.  Use \`addauser user\` first to create this user and user's home directory.
	elif [[ "\${1//-}" = [Ss]* ]] ; then
		printf '\033]2; $STARTBIN su user command 📲  \007'
		if [[ "\$2" = root ]];then
			touch $INSTALLDIR/root/.chushlogin
		else
			touch $INSTALLDIR/home/"\$2"/.chushlogin
		fi
		set +Eeuo pipefail
	EOM
		echo "$PROOTSTMNTU /bin/su - \"\$2\" -c \"\$ar3ar\" ||:" >> "$STARTBIN"
	cat >> "$STARTBIN" <<- EOM
		set -Eeuo pipefail
		printf '\033]2; $STARTBIN su user command 📲  \007'
		if [[ "\$2" = root ]];then
			rm -f $INSTALLDIR/root/.chushlogin
		else
			rm -f $INSTALLDIR/home/"\$2"/.chushlogin
		fi
	else
		_PRINTUSAGE_
	fi
	EOM
	chmod 700 "$STARTBIN"
}

_MAKESYSTEM_() {
	_WAKELOCK_
	_CALLSYSTEM_
	_PRINTMD5CHECK_
	_MD5CHECK_
	_PRINTCU_ 
	rm -f "$INSTALLDIR"/*.tar.gz "$INSTALLDIR"/*.tar.gz.md5
	_PRINTDONE_ 
	_PRINTCONFIGUP_ 
	_TOUCHUPSYS_ 
}

_MD5CHECK_() {
	if "$PREFIX"/bin/md5sum -c "$file".md5 1>/dev/null ; then
		_PRINTMD5SUCCESS_
		printf "\\e[0;32m"
		_PREPROOT_ ## & spinner "Unpacking" "$file…" 
	else
		rm -f "$INSTALLDIR"/*.tar.gz "$INSTALLDIR"/*.tar.gz.md5
		_PRINTMD5ERROR_
	fi
}

_PREPROOTDIR_() {
	cd "$INSTALLDIR"
	mkdir -p etc 
	mkdir -p var/binds 
	mkdir -p root/bin
	mkdir -p usr/bin
}

_PREPINSTALLDIR_() {
	_PREPROOTDIR_
	_SETLANGUAGE_
	_ADDADDS_
	_MAKEFINISHSETUP_
	_MAKESETUPBIN_ 
	_MAKESTARTBIN_ 
}

_PREPROOT_() {
	if [[ "$CPUABI" = "$CPUABIX86" ]] || [[ "$CPUABI" = "$CPUABIX86_64" ]];then
 		proot --link2symlink -0 bsdtar -xpf "$file" --strip-components 1  
	else
 		proot --link2symlink -0 "$PREFIX"/bin/tar -xpf "$file" 
	fi
}

_RUNFINISHSETUP_() {
	printf "\\e[0m"
	if [[ "$FSTND" ]]; then
		NMIR="$(echo "$NLCMIRROR" |awk -F'/' '{print $3}')"
		sed -e '/http\:\/\/mir/ s/^#*/# /' -i "$INSTALLDIR"/etc/pacman.d/mirrorlist
		sed -e "/$NMIR/ s/^# *//" -i "$INSTALLDIR"/etc/pacman.d/mirrorlist
	else
	if [[ "$ed" = "" ]];then
		_EDITORS_ 
	fi
	if [[ ! "$(sed 1q  "$INSTALLDIR"/etc/pacman.d/mirrorlist)" = "# # # # # # # # # # # # # # # # # # # # # # # # # # #" ]];then
		_EDITFILES_
	fi
		"$ed" "$INSTALLDIR"/etc/pacman.d/mirrorlist
	fi
	printf "\\n"
	"$INSTALLDIR"/root/bin/setupbin.sh ||:
}

_SETLANGUAGE_() { # This function uses device system settings to set locale.  To generate locales in a preferred language, you can use "Settings > Language & Keyboard > Language" in Android; Then run `setupTermuxArch.sh r for a quick system refresh.
	ULANGUAGE="unkown"
  	LANGIN=([0]="$(getprop user.language)")
	LANGIN+=([1]="$(getprop user.region)")
	LANGIN+=([2]="$(getprop persist.sys.country)")
	LANGIN+=([3]="$(getprop persist.sys.language)")
 	LANGIN+=([4]="$(getprop persist.sys.locale)")
  	LANGIN+=([5]="$(getprop ro.product.locale)")
	LANGIN+=([6]="$(getprop ro.product.locale.language)")
	LANGIN+=([7]="$(getprop ro.product.locale.region)")
	touch "$INSTALLDIR"/etc/locale.gen 
	ULANGUAGE="${LANGIN[0]:-unknown}_${LANGIN[1]:-unknown}"
       	if ! grep "$ULANGUAGE" "$INSTALLDIR"/etc/locale.gen 1>/dev/null ; then 
		ULANGUAGE="unknown"
       	fi 
 	if [[ "$ULANGUAGE" != *_* ]];then
 		ULANGUAGE="${LANGIN[3]:-unknown}_${LANGIN[2]:-unknown}"
 	       	if ! grep "$ULANGUAGE" "$INSTALLDIR"/etc/locale.gen 1>/dev/null ; then 
 			ULANGUAGE="unknown"
 	       	fi 
 	fi 
	for i in "${!LANGIN[@]}"; do
		if [[ "${LANGIN[i]}" = *-* ]];then
 	 		ULANGUAGE="${LANGIN[i]//-/_}"
			break
		fi
	done
 	if [[ "$ULANGUAGE" != *_* ]];then
 		ULANGUAGE="${LANGIN[6]:-unknown}_${LANGIN[7]:-unknown}"
 	       	if ! grep "$ULANGUAGE" "$INSTALLDIR"/etc/locale.gen 1>/dev/null ; then 
 			ULANGUAGE="unknown"
 	       	fi 
 	fi 
 	if [[ "$ULANGUAGE" != *_* ]];then
   		ULANGUAGE="en_US"
 	fi 
	printf "\\n\\e[1;32m%s\\e[0;32m%s\\e[1;32m%s\\e[0;32m%s\\n" "Setting locales to: " "Language " ">> $ULANGUAGE << " "Region"
}

_SETLOCALE_() { # This function uses device system settings to set locale.  To generate locales in a preferred language, you can use "Settings > Language & Keyboard > Language" in Android; Then run `setupTermuxArch.sh r for a quick system refresh.
	FTIME="$(date +%F%H%M%S)"
	echo "##  File locale.conf generated by setupTermuxArch.sh at" ${FTIME//-}. > etc/locale.conf 
	for i in "${!LC_TYPE[@]}"; do
	 	echo "${LC_TYPE[i]}"="$ULANGUAGE".UTF-8 >> etc/locale.conf 
	done
	sed -i "/\\#$ULANGUAGE.UTF-8 UTF-8/{s/#//g;s/@/-at-/g;}" etc/locale.gen 
}

_TOUCHUPSYS_() {
	addmotd
	_SETLOCALE_
	_RUNFINISHSETUP_
	rm -f root/bin/finishsetup.sh
	rm -f root/bin/setupbin.sh 
}

_WAKELOCK_() {
	_PRINTWLA_ 
	am startservice --user 0 -a com.termux.service_wake_lock com.termux/com.termux.app.TermuxService > /dev/null
	_PRINTDONE_ 
}

_WAKEUNLOCK_() {
	_PRINTWLD_ 
	am startservice --user 0 -a com.termux.service_wake_unlock com.termux/com.termux.app.TermuxService > /dev/null
	_PRINTDONE_ 
}

# EOF