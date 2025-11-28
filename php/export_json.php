<?php
$xmlFile = __DIR__ . '/../data/sample_reports.xml';

$xml = simplexml_load_file($xmlFile);
$json = json_encode($xml, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);

header('Content-Type: application/json; charset=utf-8');
header('Content-Disposition: attachment; filename="reports.json"');
echo $json;
exit;
