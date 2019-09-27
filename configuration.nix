# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
			./udev.nix
		];

# https://bugzilla.kernel.org/show_bug.cgi?id=110941
#boot.kernelParams = [ "intel_pstate=no_hwp" ];
#boot.initrd.kernelModules = ["acpi" "thinkpad-acpi" "acpi-call" ];
#boot = {
	boot.kernelPackages = pkgs.linuxPackages_latest;
#  kernelModules = [ "tp_smapi" "thinkpad_acpi" "fbcon" "i915" "acpi_call" ];
#  extraModulePackages = with config.boot.kernelPackages; [ tp_smapi acpi_call ];
#};
	fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

# Use the GRUB 2 boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.initrd.luks.devices = [
	{
		name = "root";
		device = "/dev/disk/by-uuid/9f4c6116-be72-402b-b522-1b82b062437f";
		preLVM = true;
		allowDiscards = true;
	}
	];
# Enables wireless support via wpa_supplicant.  

	networking.hostName = "tpX240"; # Define your hostname.

# Select internationalisation properties.
		i18n = {
			consoleFont = "Lat2-Terminus16";
			consoleKeyMap = "us";
			defaultLocale = "en_DK.UTF-8";
		};

# Set your time zone.
	time.timeZone = "Europe/Berlin";

# List packages installed in system profile. To search by name, run:
# $ nix-env -qaP | grep wget
# environment.systemPackages = with pkgs; [
#   wget
# ];

# List services that you want to enable:

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# services.openssh.permitRootLogin = "yes";





	nixpkgs.config = {

		allowUnfree = true;

		firefox = {
			enableAdobeFlash = false;
		};

	};


	hardware.trackpoint.emulateWheel = true;
	services.thinkfan.enable = true;
	services.thinkfan.sensors = ''
		hwmon /sys/class/hwmon/hwmon2/temp1_input (0, 0, 10)
		'';

# ThinkPad ACPI
	services.acpid = {
		enable = true;
		powerEventCommands = ''
			echo 2 > /proc/acpi/ibm/beep
			'';
		lidEventCommands = ''
			echo 3 > /proc/acpi/ibm/beep
			'';
		acEventCommands = ''
			echo 4 > /proc/acpi/ibm/beep
			'';
	};

#System Packages
	environment.systemPackages = with pkgs; [

# Desktop Env
			sway
			dmenu
			termite
# Tools
			vim
			htop
			usbutils
			transmission-gtk
			blueman
			libusb
			acpi
			mate.caja
			mplayer
			wget
			unzip
			imv
# Dev			
			git
			python3
			platformio
			vscode
			android-studio
			jetbrains.idea-community

# Ops			
			ansible

# Security/Hacking		
			nmap
			masscan
			arp-scan
			kicad
			openscad
			wireshark
			radare2-cutter			
		        radare2	
			

# Network
			connman
			wpa_supplicant
			

# GPG/Yubikey/Passwords
			keepassx2
			gnupg
			opensc
			libu2f-host
			yubikey-personalization

# Web
			udisks
			firefox
			midori

# Creativity		
			gimp
			lmms
			inkscape

# Elecronics
			kicad

#Communication		
                        irssi
			thunderbird-bin	#tbr
			signal-desktop
];

	users.defaultUserShell = "/run/current-system/sw/bin/bash";
	powerManagement.enable = true;
	powerManagement.powertop.enable = true;
	powerManagement.cpuFreqGovernor = "powersave";
	services.logind.lidSwitch = "hibernate";

#Syncthing
	services.syncthing = {
		enable = true;
		user = "hochi";
		dataDir = "/home/hochi/.syncthing";
	};

#Audio
sound.enable = true;
hardware.pulseaudio.enable = true;
hardware.pulseaudio.package = pkgs.pulseaudioFull;
hardware.bluetooth.enable = true;
hardware.bluetooth.powerOnBoot = false;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
networking.firewall.enable = true;
networking.connman.enable = true;
#networking.connman.extraFlags = [ "--nodnsproxy" ];
networking.wireless = {
    enable = true; # Actually automatically enabled by connman.
    networks = {
      # Fake ssid so NixOS creates wpa_supplicant.conf
      # otherwise the service fails and WiFi is not available.
      # https://github.com/NixOS/nixpkgs/issues/23196
      S4AKR00UNUN21W1NV2Y5MDDW8 = {};
    };
  };
networking.networkmanager.enable = false;


# Enable CUPS to print documents.
services.printing.enable = true;
services.printing.drivers = [pkgs.hplip pkgs.gutenprint pkgs.splix];

# services.xserver.displayManager.sddm.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
users.extraUsers.hochi = {
	isNormalUser = true;
	uid = 1000;
	extraGroups = [ "wheel" "networkmanager" "audio" "adbusers" "video" "sway"];
	shell = "/run/current-system/sw/bin/bash";
};


# The NixOS release to be compatible with for stateful data such as databases.
system.stateVersion = "17.03";
fonts.fonts = with pkgs; [
	noto-fonts
	noto-fonts-cjk
	noto-fonts-emoji
	liberation_ttf
	fira-code
	fira-code-symbols
	mplus-outline-fonts
	dina-font
	proggyfonts
	fantasque-sans-mono
	font-awesome_4
	roboto
	orbitron
];

# Enable grsecurity
#security.grsecurity.enable = true;
programs.light.enable = true;
programs.sway.enable = true;    

#Aliases can go here
environment.interactiveShellInit = ''
'';

}
