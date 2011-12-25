<?
$UUID = trim(`uuid`);
echo `virsh destroy kvm1`;
echo `virsh undefine kvm1`;
echo `lvremove -f vps/kvm1`;
echo `lvcreate -L 1G vps -n kvm1`;
`php -f generateKVMconfig.php kvm1 $UUID 25600 1 kvm1 00:11:22:33:44:55 kvm1 9001 kvm1 > /kvmxml/kvm1.xml`;
echo `virsh define /kvmxml/kvm1.xml`;
echo `virsh start kvm1`;
?>
