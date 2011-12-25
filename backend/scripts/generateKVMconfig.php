<?

$KVM_NAME = $argv[1];
$KVM_UUID = $argv[2];
$KVM_RAM = $argv[3];
$KVM_CPU = $argv[4];
$KVM_VOLUME = $argv[5];
$KVM_MAC = $argv[6];
$KVM_NIC = $argv[7];
$KVM_VNC_PORT = $argv[8];
$KVM_VNC_PASS = $argv[9];

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
	<on_reboot>destroy</on_reboot>
	<on_crash>destroy</on_crash>
	<devices>
		<emulator>/usr/bin/kvm</emulator>
		<disk type='file' device='disk'>
			<source file='/dev/vps/$KVM_VOLUME'/>
			<target dev='vda' bus='virtio'/>
		</disk>
		<interface type='bridge'>
			<source bridge='br0'/>
			<mac address='$KVM_MAC'/>
			<target dev='$KVM_NIC'/>
		</interface>
		<input type='mouse' bus='ps2'/>
		<graphics type='vnc' port='$KVM_VNC_PORT' autoport='no' listen='0.0.0.0' keymap='en-us'/>
	</devices>
</domain>
";


$config1 = "<domain type='kvm'>
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
  </features>
  <clock offset='utc'>
    <timer name='pit' tickpolicy='delay'/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>destroy</on_crash>
  <devices>
    <emulator>/usr/bin/kvm</emulator>
    <disk type='file' device='disk'>
      <driver name='qemu' type='raw'/>
      <source file='/dev/vps/$KVM_VOLUME'/>
      <target dev='vda' bus='virtio'/>
      <address type='drive' controller='0' bus='0' unit='0'/>
    </disk>
    <controller type='ide' index='0'>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x1'/>
    </controller>
    <interface type='bridge'>
      <mac address='$KVM_MAC'/>
      <source bridge='br0'/>
      <target dev='$KVM_NIC'/>
      <model type='virtio'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
    </interface>
    <input type='tablet' bus='usb'/>
    <input type='mouse' bus='ps2'/>
    <graphics type='vnc' port='$KVM_VNC_PORT' autoport='no' listen='0.0.0.0' passwd='$KVM_VNC_PASS'/>
    <video>
      <model type='cirrus' vram='9216' heads='1'/>
      <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0'/>
    </video>
  </devices>
</domain>
";

echo $config;

?>
