<?php
error_reporting(E_ALL);
ini_set('display_errors', 'On');
$memIntance = new Memcache();
$memIntance->connect('memcached', 11211) or die ("Could not connect");

$result = $memIntance->get("test");

if ($result) {
    echo $result;
} else {
    echo "No matching key found.  Refresh the browser to add it!";
    $memIntance->set("test", "Successfully retrieved the data!") or die("Couldn't save anything to memcached...");
}