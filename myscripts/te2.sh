#!/bin/bash
#script v0.3 by @genr8eofl copyright 2023 - AGPL3 License
SELINCLUDE="/usr/share/selinux/strict/include"
SEMAKEFILE="${SELINCLUDE}/Makefile"
#te to cil statement
te2cil() {
 te=$1
#ff=$(echo $te | sed 's/.te//g')
 ff="${te//.te/}"
 if [[ $(make -f $SEMAKEFILE $ff) ]]; then
    echo "Compiling te to pp"
	/usr/libexec/selinux/hll/pp $ff
 fi
}
#libsepol.module_package_read_offsets: wrong magic number for module package:  expected 0xf97cff8f, got 0x74726261
#Failed to read policy package


#te to module compiler, full version
te2mod() {
 ints="tmp/all_interfaces.conf"
 if [[ ! -f $ints ]]; then
   echo "We need a ${ints} file to exist first. Exiting."
   exit
 fi
 te=$1
#ff=$(echo $te | sed 's/.te//g')
 ff="${te//.te/}"
 pp="${ff}.pp"
#got these vars from the makefile
opt="-D distro_gentoo -D enable_ubac -D mls_num_sens=16 -D mls_num_cats=1024 -D mcs_num_cats=1024"
spt="-s \
${SELINCLUDE}/support/all_perms.spt \
${SELINCLUDE}/support/file_patterns.spt \
${SELINCLUDE}/support/ipc_patterns.spt \
${SELINCLUDE}/support/loadable_module.spt \
${SELINCLUDE}/support/misc_macros.spt \
${SELINCLUDE}/support/misc_patterns.spt \
${SELINCLUDE}/support/mls_mcs_macros.spt \
${SELINCLUDE}/support/obj_perm_sets.spt \
"
#echo debug "Running M4 on .te and output a .tmp file:"
m4 ${opt} ${spt} ${ints} $te > tmp/$ff.tmp

fc="${ff}.fc"
modfc="${ff}.mod.fc"
#echo debug "Running M4 on .fc and output a .mod.fc file:"
m4 ${opt} ${spt} $fc > $modfc

#NOTE: This is how things are normally done:
#echo "Running checkmodule on .tmp to make a .mod in \$pwd"
#/usr/bin/checkmodule -m tmp/$ff.tmp -o $ff.mod
#echo "Running semodule_package on" .mod${,.fc} "to compile .pp"
#/usr/bin/semodule_package -o $pp -m $ff.mod -f $modfc

#echo "Running checkmodule on .tmp to make a .cil in pwd"
/usr/bin/checkmodule -C -m tmp/$ff.tmp -o $ff.cil

}

#Read a list of selinux interface statements with user_t or xxxx_t, line by line from a file.
#Make a dummy TE file compile it with te2mod (reverse it to CIL) and output the CIL to stdout
ciljit()
{
 tmp="xxxx.te"
 cil="xxxx.cil"
 fc="xxxx.fc"
 touch $fc
 while read -r line;
 do
  if [[ ${line:0:1} == "#" ]]; then
    continue
  else
    echo "----------------------$line----------------------";
  fi
  echo "policy_module(xxxx)" > $tmp
  echo "gen_require(\` type user_t; ')" >> $tmp
  echo "$line(user_t)" >> $tmp
  te2mod $tmp
  if [[ -f $cil ]]; then tail $cil ; rm $cil $tmp ; fi
  echo -e "\n"
 done < $1
}
#TODO: Describe how to make the interface file.
#1) get the list of interfaces. How?
#   a) /var/lib/sepolgen/interface_info
#   b) /etc/selinux/strict/policy/tmp/all_interfaces.conf
#2) Take the list and reformat it into a list of interface names only
#WARNING CAVEAT: ONLY Ones with (domain) as the only parameter will work for now
