<?
function run($str) {
	shell_exec("nohup $str > /dev/null 2>&1");
}

echo "\nDestroying KVM...";
run('virsh destroy kvm191');
echo "destroyed.";

echo "\nCopying disk image...";
run('qemu-img convert /home/kvm/kvm191/centos-5.7-x86-64.img /dev/vps/kvm191_img');
echo "done.";

echo "\nRepartitioning...";
run('echo -e "d\nn\np\n1\n1\n+12000M\np\nn\np\n2\n\n\nt\n2\n82\np\nw\n" | fdisk /dev/vps/kvm191_img');
echo "done.";

echo "\nMapping partitions...";
run('losetup /dev/loop0 /dev/vps/kvm191_img');
run('kpartx -av /dev/loop0');
echo "done.";

echo "\nResizing root partition...";
run('resize2fs -f /dev/mapper/loop0p1');
echo "done.";

run('mkswap /dev/mapper/loop0p2');
run('mount /dev/mapper/loop0p1 /home/kvm/kvm191/mnt/');
// run('echo "/dev/vda2	swap	swap	defaults	0	0" >> /home/kvm/kvm191/mnt/etc/fstab');
run('chmod +w /home/kvm/kvm191/mnt/etc/shadow');
run('chmod +w /home/kvm/kvm191/mnt/etc/fstab');

$fstab = file_get_contents('/home/kvm/kvm191/mnt/etc/fstab');
$fstab .= "
/dev/vda2	swap	swap	defaults	0	0
";
file_put_contents('/home/kvm/kvm191/mnt/etc/fstab', $fstab);

$newpassword = trim(`openssl passwd -1 "coldmagma"`);
$shadow = file('/home/kvm/kvm191/mnt/etc/shadow');
$shadow[0] = "root:$newpassword:15199:0:99999:7:::\n";
file_put_contents('/home/kvm/kvm191/mnt/etc/shadow', implode($shadow));
run('umount /home/kvm/kvm191/mnt/');

echo "\nFinishing up...";
run('kpartx -dv /dev/loop0');
run('losetup -d /dev/loop0');
echo "complete.\n\n";

run('virsh start kvm191');
?>
