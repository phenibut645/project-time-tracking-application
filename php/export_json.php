<?php
$xmlFile = "../data/sample_reports.xml";
$jsonFile = "../data/reports.json";

$xml = simplexml_load_file($xmlFile);
$json = json_encode($xml, JSON_PRETTY_PRINT);

header('Content-Type: application/json');
header('Content-Disposition: attachment; filename="reports.json"');
echo $json;
exit;
?>
