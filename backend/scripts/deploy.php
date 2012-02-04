<?
$plans = array(
		'tera' => array('12G', 256000, 2, '11750M'),
		'peta' => array('25G', 512000, 4, '24500M'),
		'exa' => array('50G', 1024000, 8, '49G'),
		'zetta' => array('100G', 2048000, 8, '99G'),
		'yotta' => array('200G', 4096000, 8, '199G')
	 );

$images = array(
		'ubuntu-11.10-64' => 'ubuntu-11.10-x86_64.img'
	  );

$publicIP = array(
		'address' => $argv[4],
		'gateway' => $argv[5],
		'netmask' => $argv[6]
	    );

$privateIP = array(
		'address' => $argv[7],
		'netmask' => $argv[8]
	    );

$kvmID = $argv[1];
$rootPassword = trim(substr(md5(rand().rand()), 0, 8));
//$rootPassword = 'blahblahblah';
$plan = $argv[2];
$image = $argv[3];

$disk = $plans[$plan][0];
$RAM = $plans[$plan][1];
$cpu = $plans[$plan][2];

$UUID = trim(`uuid`);
$mac1 = trim(`./generateMAC`);
$mac2 = trim(`./generateMAC`);

`virsh destroy $kvmID`;
`virsh undefine $kvmID`;
`lvremove -f vps/$kvmID`;
`lvcreate -L $disk vps -n $kvmID`;
`php -f generateKVMconfig.php $kvmID $UUID $RAM $cpu $kvmID $mac1 $kvmID.public $mac2 $kvmID.private > /kvmxml/$kvmID.xml`;
`virsh define /kvmxml/$kvmID.xml`;

$imageFile = $images[$image];

`qemu-img convert /kvmimg/$imageFile /dev/vps/$kvmID`;

$rootSize = trim($plans[$plan][3]);

//`echo "d\\nn\\np\\n\\n\\n+$rootSize\\nn\\np\\n\\n\\n\\nt\\n2\\n82\\np\\nw\\n" | fdisk /dev/vps/$kvmID`;

`cat ./partitionmaps/$plan | sfdisk /dev/vps/$kvmID --force`;

`rm /kvmdev/$kvmID`;
`mknod -m660 /kvmdev/$kvmID b 7 0`;

$kvmIDtmp = $kvmID;
if(is_numeric($kvmID[strlen($kvmID)-1]))
	$kvmIDtmp .= 'p';

`losetup /kvmdev/$kvmID /dev/vps/$kvmID`;
`kpartx -av /kvmdev/$kvmID`;
shell_exec("e4fsck -f /dev/mapper/".$kvmIDtmp."1");
shell_exec("resize4fs -f /dev/mapper/".$kvmIDtmp."1");
shell_exec("mkswap -f /dev/mapper/".$kvmIDtmp."2");
`rm -rf /kvmmnt/$kvmID/`;
`mkdir /kvmmnt/$kvmID/`;
shell_exec("mount /dev/mapper/".$kvmIDtmp."1 /kvmmnt/$kvmID/");
`chmod +w /kvmmnt/$kvmID/etc/shadow`;
`chmod +w /kvmmnt/$kvmID/etc/fstab`;

$fstab = file_get_contents("/kvmmnt/$kvmID/etc/fstab");
$fstab .= "
/dev/vda2       swap    swap    defaults        0       0
";
file_put_contents("/kvmmnt/$kvmID/etc/fstab", $fstab);

//
// UBUNTU CONFIGURATION
//
if(strpos($image, "ubuntu") !== false) {
	$publicIPaddress = $publicIP['address'];
	$publicIPnetmask = $publicIP['netmask'];
	$publicIPgateway = $publicIP['gateway'];
	$privateIPaddress = $privateIP['address'];
	$privateIPnetmask = $privateIP['netmask'];

	file_put_contents("/kvmmnt/$kvmID/etc/network/interfaces", "
# Automatically generated by Bitcable Dash.

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet static
	address $publicIPaddress
	netmask $publicIPnetmask
	gateway $publicIPgateway

# The private network interface
auto eth1
iface eth1 inet static
	address $privateIPaddress
	netmask $privateIPnetmask
");

	file_put_contents("/kvmmnt/$kvmID/etc/init/ttyS0.conf", "
start on stopped rc RUNLEVEL=[2345]
stop on runlevel [!2345]

respawn
exec /sbin/getty -L 115200 ttyS0 xterm");
}

//
// END UBUNTU CONFIGURATION
//

//$newpassword = trim(`openssl passwd -1 "$rootPassword"`);
$newpassword = trim(crypt($rootPassword));

$shadow = file("/kvmmnt/$kvmID/etc/shadow");
$shadow[0] = "root:$newpassword:15199:0:99999:7:::\n";
file_put_contents("/kvmmnt/$kvmID/etc/shadow", implode($shadow));

`umount /kvmmnt/$kvmID/`;
`kpartx -dv /kvmdev/$kvmID`;
`losetup -d /kvmdev/$kvmID`;
`virsh start $kvmID`;

`userdel $kvmID`;
`rm -rf /home/$kvmID`;

`useradd $kvmID -m`;
`usermod -G libvirtd -s /bin/DaSH $kvmID`;
`touch /home/$kvmID/.hushlogin`;
`chown $kvmID:$kvmID /home/$kvmID/.hushlogin`;

`chmod +w /etc/shadow`;
$shadow = file("/etc/shadow");

foreach($shadow as &$val) {
        if(strpos($val, "$kvmID:") === 0)
                $val = "$kvmID:$newpassword:15199:0:99999:7:::\n";
}

file_put_contents("/etc/shadow", implode($shadow));
`chmod -w /etc/shadow`;

`chmod 777 /dev/pts/*`;

$finalOutput =  "
{
	uuid:\"$UUID\",
	mac1:\"$mac1\",
	mac2:\"$mac2\",
	rootpassword:\"$rootPassword\"
}
";

echo $finalOutput;

mail('pj@isomero.us', 'VPS Deployed', $finalOutput);
?>
