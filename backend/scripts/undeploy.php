<?
$kvmID = $argv[1];
`pkill -9 -u $kvmID`;
`virsh destroy $kvmID`;
`virsh undefine $kvmID`;
`lvremove -f vps/$kvmID`;

`rm /kvmdev/$kvmID`;

`userdel $kvmID`;
`rm -rf /home/$kvmID`;
?>
