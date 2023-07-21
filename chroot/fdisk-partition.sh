# Source = https://superuser.com/questions/332252/how-to-create-and-format-a-partition-using-a-bash-script/1132834#1132834
# invented 4/10/2016, copied 07/07/2023
# Script to create the partitions programatically (rather than manually)
# We're going to simulate the manual input to fdisk.
# The sed script strips off all the comments so that we can
#  document what we're doing in-line with the actual commands.
# Note that a blank line (commented as "default" will send a empty
#  line terminated with a newline to take the fdisk default.

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk ${TGTDEV}
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk
  +100M # 100 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
    # default, extend partition to end of disk
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF
