<?
$UUID = trim(`uuid`);
$mac = `printf 'DE:AD:BE:EF:%02X:%02X' $((RANDOM%256)) $((RANDOM%256))`;
//echo $mac;
$mesg = '';
$mesg .= `virsh destroy kvm1`;
$mesg .= `virsh undefine kvm1`;
$mesg .= `lvremove -f vps/kvm1`;
$mesg .= `lvcreate -L 12000M vps -n kvm1`;
`php -f generateKVMconfig.php kvm1 $UUID 256000 1 kvm1 $mac kvm1 9001 kvm1 > /kvmxml/kvm1.xml`;
$mesg .= `virsh define /kvmxml/kvm1.xml`;
$mesg .= `qemu-img convert /kvmimg/centos-5.7-x86_64.img /dev/vps/kvm1`;
$mesg .= `echo -e "d\nn\np\n1\n1\n+12000M\np\nn\np\n2\n\n\nt\n2\n82\np\nw\n" | fdisk /dev/vps/kvm1`;
$mesg .= `losetup /dev/loop0 /dev/vps/kvm1`;
$mesg .= `kpartx -av /dev/loop0`;
$mesg .= `resize2fs -f /dev/mapper/loop0p1`;
$mesg .= `mkswap /dev/mapper/loop0p2`;
$mesg .= `rm -rf /kvmmnt/kvm1/`;
$mesg .= `mkdir /kvmmnt/kvm1/`;
$mesg .= `mount /dev/mapper/loop0p1 /kvmmnt/kvm1/`;
$mesg .= `chmod +w /kvmmnt/kvm1/etc/shadow`;
$mesg .= `chmod +w /kvmmnt/kvm1/etc/fstab`;

$fstab = file_get_contents('/kvmmnt/kvm1/etc/fstab');
$fstab .= "
/dev/vda2       swap    swap    defaults        0       0
";
file_put_contents('/kvmmnt/kvm1/etc/fstab', $fstab);

$newpassword = trim(`openssl passwd -1 "coldmagma"`);
$shadow = file('/kvmmnt/kvm1/etc/shadow');
$shadow[0] = "root:$newpassword:15199:0:99999:7:::\n";
file_put_contents('/kvmmnt/kvm1/etc/shadow', implode($shadow));

$mesg .= `umount /kvmmnt/kvm1/`;
$mesg .= `kpartx -dv /dev/loop0`;
$mesg .= `losetup -d /dev/loop0`;

$mesg .= `virsh start kvm1`;
$mesg = str_replace("\n", "\\n", $mesg);
echo "{
	messages: \"$mesg\",
	uuid: \"$UUID\",
	mac: \"$mac\"
}";
?>
