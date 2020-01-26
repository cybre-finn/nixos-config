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
		device = "/dev/disk/by-uuid/8b0f6c1f-b105-4ad4-a664-5af66432763b";
		preLVM = true;
		allowDiscards = true;
	}
	];
# Enables wireless support via wpa_supplicant.  

	networking.hostName = "tpT470"; # Define your hostname.

# Select internationalisation properties.
		i18n = {
			consoleFont = "Lat2-Terminus16";
			consoleKeyMap = "us-acentos";
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
            termite
            rofi

# Tools
                        home-manager
			vim
			htop
	    texlive.combined.scheme-full
            tikzit
            qtikz
			usbutils
			transmission-gtk
			blueman
			libusb
			mate.caja
			mplayer
			wget
			unzip
			imv
                        bluez
                        gummi
            fzf
            vagrant
            tree
            vlc
            connman-gtk
# Dev	
            pipenv 
			git
			python3
			platformio
			vscode
			android-studio
            jetbrains.idea-community
	    jetbrains.clion
            jetbrains.pycharm-community
            gcc
            gradle
            cmake
            clang
            netbeans 
	    gnumake
	    gdb
# Ops			
	    ansible
	    
            mysql-workbench
gnome3.gnome-keyring
dbeaver
            
# Security/Hacking		
			nmap
			masscan
			arp-scan
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
            tdesktop
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

services.gnome3.gnome-keyring.enable = true;

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
	extraGroups = [ "wheel" "networkmanager" "audio" "adbusers" "video" "sway" "uucp"];
	shell = "/run/current-system/sw/bin/bash";
};


virtualisation.virtualbox.host.enable = true;
users.extraGroups.vboxusers.members = [ "hochi" ];
virtualisation.virtualbox.host.package = pkgs.virtualbox;

# The NixOS release to be compatible with for stateful data such as databases.
system.stateVersion = "19.03";
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

security.pki.certificates = [ ''
    Eduroam HAW
    =========
-----BEGIN CERTIFICATE-----
MIIDwzCCAqugAwIBAgIBATANBgkqhkiG9w0BAQsFADCBgjELMAkGA1UEBhMCREUx
KzApBgNVBAoMIlQtU3lzdGVtcyBFbnRlcnByaXNlIFNlcnZpY2VzIEdtYkgxHzAd
BgNVBAsMFlQtU3lzdGVtcyBUcnVzdCBDZW50ZXIxJTAjBgNVBAMMHFQtVGVsZVNl
YyBHbG9iYWxSb290IENsYXNzIDIwHhcNMDgxMDAxMTA0MDE0WhcNMzMxMDAxMjM1
OTU5WjCBgjELMAkGA1UEBhMCREUxKzApBgNVBAoMIlQtU3lzdGVtcyBFbnRlcnBy
aXNlIFNlcnZpY2VzIEdtYkgxHzAdBgNVBAsMFlQtU3lzdGVtcyBUcnVzdCBDZW50
ZXIxJTAjBgNVBAMMHFQtVGVsZVNlYyBHbG9iYWxSb290IENsYXNzIDIwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCqX9obX+hzkeXaXPSi5kfl82hVYAUd
AqSzm1nzHoqvNK38DcLZSBnuaY/JIPwhqgcZ7bBcrGXHX+0CfHt8LRvWurmAwhiC
FoT6ZrAIxlQjgeTNuUk/9k9uN0goOA/FvudocP05l03Sx5iRUKrERLMjfTlH6VJi
1hKTXrcxlkIF+3anHqP1wvzpesVsqXFP6st4vGCvx9702cu+fjOlbpSD8DT6Iavq
jnKgP6TeMFvvhk1qlVtDRKgQFRzlAVfFmPHmBiiRqiDFt1MmUUOyCxGVWOHAD3bZ
wI18gfNycJ5v/hqO2V81xrJvNHy+SE/iWjnX2J14np+GPgNeGYtEotXHAgMBAAGj
QjBAMA8GA1UdEwEB/wQFMAMBAf8wDgYDVR0PAQH/BAQDAgEGMB0GA1UdDgQWBBS/
WSA2AHmgoCJrjNXyYdK4LMuCSjANBgkqhkiG9w0BAQsFAAOCAQEAMQOiYQsfdOhy
NsZt+U2e+iKo4YFWz827n+qrkRk4r6p8FU3ztqONpfSO9kSpp+ghla0+AGIWiPAC
uvxhI+YzmzB6azZie60EI4RYZeLbK4rnJVM3YlNfvNoBYimipidx5joifsFvHZVw
IEoHNN/q/xWA5brXethbdXwFeilHfkCoMRN3zUA7tFFHei4R40cR3p1m0IvVVGb6
g1XqfMIpiRvpb7PO4gWEyS8+eIVibslfwXhjdFjASBgMmTnrpMwatXlajRWc2BQN
9noHV8cigwUtPJslJj0Ys6lDfMjIq2SPDqO/nBudMNva0Bkuqjzx+zOAduTNrRlP
BSeOE6Fuwg==
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIIFEjCCA/qgAwIBAgIJAOML1fivJdmBMA0GCSqGSIb3DQEBCwUAMIGCMQswCQYD
VQQGEwJERTErMCkGA1UECgwiVC1TeXN0ZW1zIEVudGVycHJpc2UgU2VydmljZXMg
R21iSDEfMB0GA1UECwwWVC1TeXN0ZW1zIFRydXN0IENlbnRlcjElMCMGA1UEAwwc
VC1UZWxlU2VjIEdsb2JhbFJvb3QgQ2xhc3MgMjAeFw0xNjAyMjIxMzM4MjJaFw0z
MTAyMjIyMzU5NTlaMIGVMQswCQYDVQQGEwJERTFFMEMGA1UEChM8VmVyZWluIHp1
ciBGb2VyZGVydW5nIGVpbmVzIERldXRzY2hlbiBGb3JzY2h1bmdzbmV0emVzIGUu
IFYuMRAwDgYDVQQLEwdERk4tUEtJMS0wKwYDVQQDEyRERk4tVmVyZWluIENlcnRp
ZmljYXRpb24gQXV0aG9yaXR5IDIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
AoIBAQDLYNf/ZqFBzdL6h5eKc6uZTepnOVqhYIBHFU6MlbLlz87TV0uNzvhWbBVV
dgfqRv3IA0VjPnDUq1SAsSOcvjcoqQn/BV0YD8SYmTezIPZmeBeHwp0OzEoy5xad
rg6NKXkHACBU3BVfSpbXeLY008F0tZ3pv8B3Teq9WQfgWi9sPKUA3DW9ZQ2PfzJt
8lpqS2IB7qw4NFlFNkkF2njKam1bwIFrEczSPKiL+HEayjvigN0WtGd6izbqTpEp
PbNRXK2oDL6dNOPRDReDdcQ5HrCUCxLx1WmOJfS4PSu/wI7DHjulv1UQqyquF5de
M87I8/QJB+MChjFGawHFEAwRx1npAgMBAAGjggF0MIIBcDAOBgNVHQ8BAf8EBAMC
AQYwHQYDVR0OBBYEFJPj2DIm2tXxSqWRSuDqS+KiDM/hMB8GA1UdIwQYMBaAFL9Z
IDYAeaCgImuM1fJh0rgsy4JKMBIGA1UdEwEB/wQIMAYBAf8CAQIwMwYDVR0gBCww
KjAPBg0rBgEEAYGtIYIsAQEEMA0GCysGAQQBga0hgiweMAgGBmeBDAECAjBMBgNV
HR8ERTBDMEGgP6A9hjtodHRwOi8vcGtpMDMzNi50ZWxlc2VjLmRlL3JsL1RlbGVT
ZWNfR2xvYmFsUm9vdF9DbGFzc18yLmNybDCBhgYIKwYBBQUHAQEEejB4MCwGCCsG
AQUFBzABhiBodHRwOi8vb2NzcDAzMzYudGVsZXNlYy5kZS9vY3NwcjBIBggrBgEF
BQcwAoY8aHR0cDovL3BraTAzMzYudGVsZXNlYy5kZS9jcnQvVGVsZVNlY19HbG9i
YWxSb290X0NsYXNzXzIuY2VyMA0GCSqGSIb3DQEBCwUAA4IBAQCHC/8+AptlyFYt
1juamItxT9q6Kaoh+UYu9bKkD64ROHk4sw50unZdnugYgpZi20wz6N35at8yvSxM
R2BVf+d0a7Qsg9h5a7a3TVALZge17bOXrerufzDmmf0i4nJNPoRb7vnPmep/11I5
LqyYAER+aTu/de7QCzsazeX3DyJsR4T2pUeg/dAaNH2t0j13s+70103/w+jlkk9Z
PpBHEEqwhVjAb3/4ru0IQp4e1N8ULk2PvJ6Uw+ft9hj4PEnnJqinNtgs3iLNi4LY
2XjiVRKjO4dEthEL1QxSr2mMDwbf0KJTi1eYe8/9ByT0/L3D/UqSApcb8re2z2WK
GqK1chk5
-----END CERTIFICATE-----

-----BEGIN CERTIFICATE-----
MIIFrDCCBJSgAwIBAgIHG2O60B4sPTANBgkqhkiG9w0BAQsFADCBlTELMAkGA1UE
BhMCREUxRTBDBgNVBAoTPFZlcmVpbiB6dXIgRm9lcmRlcnVuZyBlaW5lcyBEZXV0
c2NoZW4gRm9yc2NodW5nc25ldHplcyBlLiBWLjEQMA4GA1UECxMHREZOLVBLSTEt
MCsGA1UEAxMkREZOLVZlcmVpbiBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSAyMB4X
DTE2MDUyNDExMzg0MFoXDTMxMDIyMjIzNTk1OVowgY0xCzAJBgNVBAYTAkRFMUUw
QwYDVQQKDDxWZXJlaW4genVyIEZvZXJkZXJ1bmcgZWluZXMgRGV1dHNjaGVuIEZv
cnNjaHVuZ3NuZXR6ZXMgZS4gVi4xEDAOBgNVBAsMB0RGTi1QS0kxJTAjBgNVBAMM
HERGTi1WZXJlaW4gR2xvYmFsIElzc3VpbmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUA
A4IBDwAwggEKAoIBAQCdO3kcR94fhsvGadcQnjnX2aIw23IcBX8pX0to8a0Z1kzh
axuxC3+hq+B7i4vYLc5uiDoQ7lflHn8EUTbrunBtY6C+li5A4dGDTGY9HGRp5Zuk
rXKuaDlRh3nMF9OuL11jcUs5eutCp5eQaQW/kP+kQHC9A+e/nhiIH5+ZiE0OR41I
X2WZENLZKkntwbktHZ8SyxXTP38eVC86rpNXp354ytVK4hrl7UF9U1/Isyr1ijCs
7RcFJD+2oAsH/U0amgNSoDac3iSHZeTn+seWcyQUzdDoG2ieGFmudn730Qp4PIdL
sDfPU8o6OBDzy0dtjGQ9PFpFSrrKgHy48+enTEzNAgMBAAGjggIFMIICATASBgNV
HRMBAf8ECDAGAQH/AgEBMA4GA1UdDwEB/wQEAwIBBjApBgNVHSAEIjAgMA0GCysG
AQQBga0hgiweMA8GDSsGAQQBga0hgiwBAQQwHQYDVR0OBBYEFGs6mIv58lOJ2uCt
sjIeCR/oqjt0MB8GA1UdIwQYMBaAFJPj2DIm2tXxSqWRSuDqS+KiDM/hMIGPBgNV
HR8EgYcwgYQwQKA+oDyGOmh0dHA6Ly9jZHAxLnBjYS5kZm4uZGUvZ2xvYmFsLXJv
b3QtZzItY2EvcHViL2NybC9jYWNybC5jcmwwQKA+oDyGOmh0dHA6Ly9jZHAyLnBj
YS5kZm4uZGUvZ2xvYmFsLXJvb3QtZzItY2EvcHViL2NybC9jYWNybC5jcmwwgd0G
CCsGAQUFBwEBBIHQMIHNMDMGCCsGAQUFBzABhidodHRwOi8vb2NzcC5wY2EuZGZu
LmRlL09DU1AtU2VydmVyL09DU1AwSgYIKwYBBQUHMAKGPmh0dHA6Ly9jZHAxLnBj
YS5kZm4uZGUvZ2xvYmFsLXJvb3QtZzItY2EvcHViL2NhY2VydC9jYWNlcnQuY3J0
MEoGCCsGAQUFBzAChj5odHRwOi8vY2RwMi5wY2EuZGZuLmRlL2dsb2JhbC1yb290
LWcyLWNhL3B1Yi9jYWNlcnQvY2FjZXJ0LmNydDANBgkqhkiG9w0BAQsFAAOCAQEA
gXhFpE6kfw5V8Amxaj54zGg1qRzzlZ4/8/jfazh3iSyNta0+x/KUzaAGrrrMqLGt
Mwi2JIZiNkx4blDw1W5gjU9SMUOXRnXwYuRuZlHBQjFnUOVJ5zkey5/KhkjeCBT/
FUsrZpugOJ8Azv2n69F/Vy3ITF/cEBGXPpYEAlyEqCk5bJT8EJIGe57u2Ea0G7UD
DDjZ3LCpP3EGC7IDBzPCjUhjJSU8entXbveKBTjvuKCuL/TbB9VbhBjBqbhLzmyQ
GoLkuT36d/HSHzMCv1PndvncJiVBby+mG/qkE5D6fH7ZC2Bd7L/KQaBh+xFJKdio
LXUV2EoY6hbvVTQiGhONBg==
-----END CERTIFICATE-----
''
];

# Enable grsecurity
#security.grsecurity.enable = true;
programs.light.enable = true;
programs.sway.enable = true;    
programs.sway.extraSessionCommands = ''
'';

#Aliases can go here
environment.interactiveShellInit = ''
  export _JAVA_AWT_WM_NONREPARENTING=1
'';

}
