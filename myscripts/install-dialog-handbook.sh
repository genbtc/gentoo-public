Dialog0='About the Gentoo Linux installation'
Info0='This chapter introduces the installation approach documented within this handbook.'
Outline0='
    1 Introduction
        1.1 Welcome
            1.1.1 Openness
            1.1.2 Choice
            1.1.3 Power
        1.2 How the installation is structured
            1.2.1 Deciding which steps to take
            1.2.2 Suggested steps
            1.2.3 Optional steps
            1.2.4 Deprecated steps
            1.2.5 Defaults and alternatives
        1.3 Installation options for Gentoo
        1.4 Troubles
'
Dialog1='Choosing the right installation medium'
Info1='It is possible to install Gentoo in many ways.
        This chapter explains how to install Gentoo using the minimal live image.'
Outline1='
    1 Hardware requirements
    2 Gentoo Linux installation media
        2.1 Minimal installation CD
        2.2 The Gentoo LiveGUI
        2.3 What are stage files?
    3 Downloading
        3.1 Obtain the media
            3.1.1 Navigating Gentoo mirrors
        3.2 Verifying the downloaded files
            3.2.1 Microsoft Windows-based verification
            3.2.2 Linux based verification
    4 Writing the boot media
        4.1 Writing a bootable USB
            4.1.1 Writing with Linux
                4.1.1.1 Determining the USB device path
                4.1.1.2 Writing with dd
        4.2 Burning a disk
            4.2.1 Burning with Microsoft Windows 7 and above
            4.2.2 Burning with Linux
    5 Booting
        5.1 Booting the installation media
            5.1.1 Kernel choices
            5.1.2 Hardware options
            5.1.3 Logical volume/device management
            5.1.4 Other options
        5.2 Extra hardware configuration
        5.3 Optional: User accounts
        5.4 Optional: Viewing documentation while installing
            5.4.1 TTYs
            5.4.2 GNU Screen
        5.5 Optional: Starting the SSH daemon
'
Dialog2='Configuring the network'
Info2='An operational network connection is necessary to access the internet, download the latest repository updates, source code, and software packages.'
Outline2='
    1 Automatic network configuration
        1.1 Using DHCP
        1.2 Testing the network
    2 Obtaining interface info
    3 Optional: Application specific configuration
        3.1 Configure web proxies
        3.2 Using pppoe-setup for ADSL
        3.3 Using PPTP
        3.4 Configuring WEP
    4 Using net-setup
    5 Internet and IP basics
        5.1 Interfaces and addresses
        5.2 Networks and CIDR
        5.3 The Internet
        5.4 The Domain Name System
    6 Manual network configuration
        6.1 Interface address configuration
        6.2 Default route configuration
        6.3 DNS configuration
'
Dialog3='Preparing the disks'
Info3='Before Gentoo can be installed, a root file system layout and - optionally - other partitions need to be created.
        This chapter provides an overview of possible storage configuration for the installation.'
Outline3='
    1 Introduction to block devices
        1.1 Block devices
        1.2 Partition tables
            1.2.1 GUID Partition Table (GPT)
            1.2.2 Master boot record (MBR) or DOS boot sector
        1.3 Advanced storage
        1.4 Default partitioning scheme
    2 Designing a partition scheme
        2.1 How many partitions and how big?
        2.2 What about swap space?
        2.3 What is the EFI System Partition (ESP)?
        2.4 What is the BIOS boot partition?
    3 Partitioning the disk with GPT for UEFI
        3.1 Viewing the current partition layout
        3.2 Creating a new disklabel / removing all partitions
        3.3 Creating the EFI System Partition (ESP)
        3.4 Creating the swap partition
        3.5 Creating the root partition
        3.6 Saving the partition layout
    4 Partitioning the disk with MBR for BIOS / legacy boot
        4.1 Viewing the current partition layout
        4.2 Creating a new disklabel / removing all partitions
        4.3 Creating the boot partition
        4.4 Creating the swap partition
        4.5 Creating the root partition
        4.6 Saving the partition layout
    5 Creating file systems
        5.1 Introduction
        5.2 Filesystems
        5.3 Applying a filesystem to a partition
            5.3.1 EFI system partition filesystem
            5.3.2 Legacy BIOS boot partition filesystem
            5.3.3 Small ext4 partitions
        5.4 Activating the swap partition
    6 Mounting the root partition
'
Dialog4='Installing the Gentoo installation files'
Info4='The basic Gentoo operating system environment is downloaded as a stage 3 archive.
        This chapter explains how to download and extract the archive, and how to configure Portage - the package manager.'
Outline4='
    1 Choosing a stage file
        1.1 OpenRC
        1.2 systemd
        1.3 Multilib (32 and 64-bit)
        1.4 No-multilib (pure 64-bit)
    2 Downloading the stage file
        2.1 Setting the date and time
            2.1.1 Automatic
            2.1.2 Manual
        2.2 Graphical browsers
        2.3 Command-line browsers
        2.4 Verifying and validating
    3 Installing a stage file
    4 Configuring compile options
        4.1 Introduction
        4.2 CFLAGS and CXXFLAGS
        4.3 MAKEOPTS
        4.4 Ready, set, go!
    5 References
'
Dialog5='Installing the Gentoo base system'
Info5='After installing and configuring the stage 3, the base system is set up so that a minimal environment is available.'
Outline5='
    1 Chrooting
        1.1 Copy DNS info
        1.2 Mounting the necessary filesystems
        1.3 Entering the new environment
        1.4 Preparing for a bootloader
            1.4.1 UEFI systems
            1.4.2 DOS/Legacy BIOS systems
    2 Configuring Portage
        2.1 Installing a Gentoo ebuild repository snapshot from the web
        2.2 Optional: Selecting mirrors
        2.3 Optional: Updating the Gentoo ebuild repository
        2.4 Reading news items
        2.5 Choosing the right profile
            2.5.1 No-multilib
        2.6 Optional: Adding a binary package host
            2.6.1 Repository configuration
            2.6.2 Installing binary packages
        2.7 Optional: Configuring the USE variable
            2.7.1 CPU_FLAGS_*
            2.7.2 VIDEO_CARDS
        2.8 Optional: Configure the ACCEPT_LICENSE variable
        2.9 Optional: Updating the @world set
            2.9.1 Removing obsolete packages
    3 Optional: Using systemd as the system and service manager
    4 Timezone
    5 Configure locales
        5.1 Locale generation
        5.2 Locale selection
    6 References
'
Dialog6='Configuring the Linux kernel'
Info6='The Linux kernel is the core of every distribution.
        This chapter explains how to configure and compile the kernel.'
Outline6='
    1 Optional: Installing firmware and/or microcode
        1.1 Firmware
            1.1.1 Suggested: Linux Firmware
                1.1.1.1 Firmware Loading
            1.1.2 SOF Firmware
        1.2 Microcode
    2 sys-kernel/installkernel
        2.1 Bootloader
            2.1.1 GRUB
            2.1.2 systemd-boot
            2.1.3 EFI stub
            2.1.4 Traditional layout, other bootloaders (e.g. (e)lilo, syslinux, etc.)
        2.2 Initramfs
        2.3 Optional: Unified Kernel Image
            2.3.1 Generic Unified Kernel Image
            2.3.2 Secure Boot
    3 Kernel configuration and compilation
        3.1 Distribution kernels
            3.1.1 Optional: Signed kernel modules
            3.1.2 Optional: Signing the kernel image (Secure Boot)
            3.1.3 Installing a distribution kernel
            3.1.4 Upgrading and cleaning up
            3.1.5 Post-install/upgrade tasks
                3.1.5.1 Manually rebuilding the initramfs or Unified Kernel Image
        3.2 Installing the kernel sources
        3.3 Alternative: Manual configuration
            3.3.1 Modprobed-db process
            3.3.2 Manual process
                3.3.2.1 Enabling required options
                3.3.2.2 Enabling support for typical system components
            3.3.3 Optional: Signed kernel modules
            3.3.4 Optional: Signing the kernel image (Secure Boot)
            3.3.5 Architecture specific kernel configuration
            3.3.6 Compiling and installing
        3.4 Deprecated: Genkernel
    4 Kernel modules
        4.1 Listing available kernel modules
        4.2 Force loading particular kernel modules
'
Dialog7='Configuring the system'
Info7='Some important configuration files must be created.
        This chapter provides an overview of these files and explains how to tailor the configuration.'
Outline7='
    1 Filesystem information
        1.1 Filesystem labels and UUIDs
        1.2 Partition labels and UUIDs
        1.3 About fstab
        1.4 Creating the fstab file
            1.4.1 DOS/Legacy BIOS systems
            1.4.2 UEFI systems
            1.4.3 DPS UEFI PARTUUID
    2 Networking information
        2.1 Hostname
            2.1.1 Set the hostname (OpenRC or systemd)
            2.1.2 systemd
        2.2 Network
            2.2.1 DHCP via dhcpcd (any init system)
            2.2.2 netifrc (OpenRC)
                2.2.2.1 Configuring the network
                2.2.2.2 Automatically start networking at boot
        2.3 The hosts file
    3 System information
        3.1 Root password
        3.2 Init and boot configuration
            3.2.1 OpenRC
            3.2.2 systemd
'
Dialog8='Installing system tools'
Info8='In this chapter important system management tools are selected and installed.'
Outline8='
    1 System logger
        1.1 OpenRC
        1.2 systemd
    2 Optional: Cron daemon
        2.1 OpenRC
            2.1.1 Default: cronie
            2.1.2 Alternative: dcron
            2.1.3 Alternative: fcron
            2.1.4 Alternative: bcron
        2.2 systemd
    3 Optional: File indexing
    4 Optional: Remote shell access
        4.1 OpenRC
        4.2 systemd
    5 Optional: Shell completion
        5.1 Bash
    6 Suggested: Time synchronization
        6.1 OpenRC
        6.2 systemd
    7 Filesystem tools
    8 Networking tools
        8.1 Installing a DHCP client
        8.2 Optional: Installing a PPPoE client
        8.3 Optional: Install wireless networking tools
'
Dialog9='Configuring the bootloader'
Info9='In this chapter a secondary bootloader is installed and configured.'
Outline9='
    1 Selecting a boot loader
    2 Default: GRUB
        2.1 Emerge
        2.2 Install
            2.2.1 DOS/Legacy BIOS systems
            2.2.2 UEFI systems
                2.2.2.1 Optional: Secure Boot
                2.2.2.2 Debugging GRUB
        2.3 Configure
    3 Alternative 1: LILO
        3.1 Emerge
        3.2 Configure
        3.3 Install
    4 Alternative 2: EFI Stub
        4.1 Unified Kernel Image
    5 Alternative 3: Syslinux
    6 Alternative 4: systemd-boot
        6.1 Optional: Secure Boot
    7 Rebooting the system
'
Dialog10='Finalizing the installation'
Info10='The installation is almost complete! Finishing touches are documented in this chapter.'
Outline10='
    1 User administration
        1.1 Adding a user for daily use
        1.2 Temporarily elevating privileges
        1.3 Disabling root login
    2 Disk cleanup
        2.1 Removing installation artifacts
    3 Where to go from here
        3.1 Additional documentation
        3.2 Gentoo online
            3.2.1 Forums and IRC
            3.2.2 Mailing lists
            3.2.3 Bugs
            3.2.4 Development guide
    4 Closing thoughts
'

