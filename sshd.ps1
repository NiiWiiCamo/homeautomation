# Install OpenSSH Server Windows Feature

# Install OpenSSH Server Windows Feature
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start sshd and configure automatic start
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# Firewall should be configured already, if not uncomment this:
#New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
