te2cil() {
 te=$1
 ff=$(echo $te | sed 's/.te//g')
 if [[ $(make -f /usr/share/selinux/strict/include/Makefile $ff) ]]; then
	/usr/libexec/selinux/hll/pp $ff
 fi
}

te2mod() {
 ints="tmp/all_interfaces.conf"
 if [[ ! -f $ints ]]; then
   echo "We need a ${ints} file to exist first. Exiting."
   exit
 fi
 te=$1
 ff=$(echo $te | sed 's/.te//g')
 pp="${ff}.pp"
#got these vars from the makefile
opt="-D distro_gentoo -D enable_ubac -D mls_num_sens=16 -D mls_num_cats=1024 -D mcs_num_cats=1024"
spt="-s \
/usr/share/selinux/strict/include/support/all_perms.spt \
/usr/share/selinux/strict/include/support/file_patterns.spt \
/usr/share/selinux/strict/include/support/ipc_patterns.spt \
/usr/share/selinux/strict/include/support/loadable_module.spt \
/usr/share/selinux/strict/include/support/misc_macros.spt \
/usr/share/selinux/strict/include/support/misc_patterns.spt \
/usr/share/selinux/strict/include/support/mls_mcs_macros.spt \
/usr/share/selinux/strict/include/support/obj_perm_sets.spt"

#echo "Running M4 on .te and output a .tmp file:"
m4 ${opt} ${spt} ${ints} $te > tmp/$ff.tmp

fc="${ff}.fc"
modfc="${ff}.mod.fc"
#echo "Running M4 on .fc and output a .mod.fc file:"
m4 ${opt} ${spt} $fc > $modfc

#This is how things are normally done:
#echo "Running checkmodule on .tmp to make a .mod in \$pwd"
#/usr/bin/checkmodule -m tmp/$ff.tmp -o $ff.mod
#echo "Running semodule_package on" .mod${,.fc} "to compile .pp"
#/usr/bin/semodule_package -o $pp -m $ff.mod -f $modfc

#echo "Running checkmodule on .tmp to make a .cil in pwd"
/usr/bin/checkmodule -C -m tmp/$ff.tmp -o $ff.cil

}

ciljit()
{
 while read -r line;
 do
  if [[ ${line:0:1} == "#" ]]; then
     continue
  else
        echo "----------------------$line----------------------";
  fi
  tmp="xxxx.te" ; cil="xxxx.cil"
  echo "policy_module(xxxx)" > $tmp
#  echo "type line_t; type user_t; type xxxx_t;" >> $tmp
  echo "gen_require(\` type user_t; role user_r; type line_t; attribute user_application_exec_domain; ')" >> $tmp
  echo "$line" >> $tmp
  te2mod $tmp
  if [[ -f $cil ]]; then tail -n+5 $cil ; rm $cil ; fi
  echo -e "\n"
 done < $1
}
