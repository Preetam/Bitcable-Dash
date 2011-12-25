<?
$UUID = trim(`uuid`);
$mac = `printf 'DE:AD:BE:EF:%02X:%02X' $((RANDOM%256)) $((RANDOM%256))`;
//echo $mac;
$mesg = '';
$mesg .= `virsh destroy kvm1`;
$mesg .= `virsh undefine kvm1`;
$mesg .= `lvremove -f vps/kvm1`;
$mesg .= `lvcreate -L 12500M vps -n kvm1`;
`php -f generateKVMconfig.php kvm1 $UUID 256000 1 kvm1 $mac kvm1 9001 kvm1 > /kvmxml/kvm1.xml`;
$mesg .= `virsh define /kvmxml/kvm1.xml`;
$mesg .= `qemu-img convert /kvmimg/ubuntu-11.10-x86_64.img /dev/vps/kvm1`;
//$mesg .= `echo -e "d\nn\np\n1\n\n\n+12000M\np\nn\np\n2\n\n\nt\n2\n82\np\nw\n" | fdisk /dev/vps/kvm1`;
$mesg .= `echo "d\\nn\\np\\n\\n\\n+12G\\nn\\np\\n\\n\\n\\nt\\n2\\n82\\np\\nw\\n" | fdisk /dev/vps/kvm1`;
$mesg .= `sync`;
$mesg .= `echo "p\nq" | fdisk /dev/vps/kvm1`;
$mesg .= `rm /kvmdev/kvm1`;
$mesg .= `mknod -m660 /kvmdev/kvm1 b 7 0`;
$mesg .= `losetup /kvmdev/kvm1 /dev/vps/kvm1`;
$mesg .= `kpartx -av /kvmdev/kvm1`;
$mesg .= `e2fsck -f /dev/mapper/kvm1p1`;
$mesg .= `resize2fs -f /dev/mapper/kvm1p1`;
$mesg .= `mkswap -f /dev/mapper/kvm1p2`;
$mesg .= `rm -rf /kvmmnt/kvm1/`;
$mesg .= `mkdir /kvmmnt/kvm1/`;
$mesg .= `mount /dev/mapper/kvm1p1 /kvmmnt/kvm1/`;
$mesg .= `chmod +w /kvmmnt/kvm1/etc/shadow`;
$mesg .= `chmod +w /kvmmnt/kvm1/etc/fstab`;

$fstab = file_get_contents('/kvmmnt/kvm1/etc/fstab');
$fstab .= "
/dev/vda2       swap    swap    defaults        0       0
";
file_put_contents('/kvmmnt/kvm1/etc/fstab', $fstab);

file_put_contents('/kvmmnt/kvm1/etc/network/interfaces', "
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet static
        address 199.58.161.252
        netmask 255.255.255.128
        network 199.58.161.128
        broadcast 199.58.161.255
        gateway 199.58.161.129
");

$newpassword = trim(`openssl passwd -1 "coldmagma"`);
$shadow = file('/kvmmnt/kvm1/etc/shadow');
$shadow[0] = "root:$newpassword:15199:0:99999:7:::\n";
file_put_contents('/kvmmnt/kvm1/etc/shadow', implode($shadow));

$mesg .= `umount /kvmmnt/kvm1/`;
$mesg .= `kpartx -dv /kvmdev/kvm1`;
$mesg .= `losetup -d /kvmdev/kvm1`;

$mesg .= `virsh start kvm1`;
//$mesg = str_replace("\n", "\\n", $mesg);

echo "{
	messages: \"$mesg\",
	uuid: \"$UUID\",
	mac: \"$mac\"
}";
?>
