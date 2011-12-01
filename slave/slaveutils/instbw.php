<?
`vnstat -u`;
$rxStart = explode(";", `vnstat --dumpdb -i $argv[1] | grep "currx"`);
$txStart = explode(";", `vnstat --dumpdb -i $argv[1] | grep "curtx"`);

$rxStart = intval($rxStart[1]);
$txStart = intval($txStart[1]);

sleep(5);
`vnstat -u`;

$rxEnd = explode(";", `vnstat --dumpdb -i $argv[1] | grep "currx"`);
$txEnd = explode(";", `vnstat --dumpdb -i $argv[1] | grep "curtx"`);

$rxEnd = intval($rxEnd[1]);
$txEnd = intval($txEnd[1]);

$output = ($rxEnd-$rxStart)+($txEnd-$txStart);

echo ($output / 5 / 1024 / 1024);//." MB/s\n";
?>
