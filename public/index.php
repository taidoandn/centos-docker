<?php
error_reporting(E_ALL);
ini_set('display_errors', 'On');
$meminstance = new Memcache();
$meminstance->connect('localhost', 11211) or die ("Could not connect");

$result = $meminstance->get("test");

if ($result) {
    echo $result;
} else {
    echo "No matching key found.  Refresh the browser to add it!";
    $meminstance->set("test", "Successfully retrieved the data!") or die("Couldn't save anything to memcached...");
}