<?

$KVM_NAME = $argv[1];
$KVM_UUID = $argv[2];
$KVM_RAM = $argv[3];
$KVM_CPU = $argv[4];
$KVM_VOLUME = $argv[5];
$KVM_MAC1 = $argv[6];
$KVM_NIC1 = $argv[7];
$KVM_MAC2 = $argv[8];
$KVM_NIC2 = $argv[9];

$config = "
<domain type='kvm'>
	<name>$KVM_NAME</name>
	<uuid>$KVM_UUID</uuid>
	<memory>$KVM_RAM</memory>
	<currentMemory>$KVM_RAM</currentMemory>
	<vcpu>$KVM_CPU</vcpu>
	<os>
		<type arch='x86_64' machine='pc'>hvm</type>
		<boot dev='hd'/>
	</os>
	<features>
		<acpi/>
		<apic/>
		<pae/>
	</features>
	<clock offset='utc'/>
	<on_poweroff>destroy</on_poweroff>
	<on_reboot>restart</on_reboot>
	<on_crash>restart</on_crash>
	<devices>
		<emulator>/usr/bin/kvm</emulator>
		<disk type='file' device='disk'>
			<source file='/dev/vps/$KVM_VOLUME'/>
			<target dev='vda' bus='virtio'/>
		</disk>
		<interface type='bridge'>
			<source bridge='br0'/>
			<mac address='$KVM_MAC1'/>
			<target dev='$KVM_NIC1'/>
		</interface>
		<interface type='bridge'>
			<source bridge='br1'/>
			<mac address='$KVM_MAC2'/>
			<target dev='$KVM_NIC2'/>
		</interface>
		<input type='mouse' bus='ps2'/>
		<serial type='pty'>
			<target port='0'/>
		</serial>
		<console type='pty'>
			<target type='serial' port='0'/>
		</console>
	</devices>
</domain>
";
echo $config;

?>
