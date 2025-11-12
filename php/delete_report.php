<?php
$xmlFile = __DIR__ . '/../data/sample_reports.xml';
$aruandeId = $_GET['aruandeId'] ?? '';

if (!$aruandeId) {
    die("Kustutatava kirje ID pole märgitud");
}

$dom = new DOMDocument();
$dom->preserveWhiteSpace = false;
$dom->formatOutput = true;
$dom->load($xmlFile);

$xpath = new DOMXPath($dom);
$nodes = $xpath->query("/reports/report[@aruandeId='$aruandeId']");

if ($nodes->length > 0) {
    foreach ($nodes as $node) {
        $node->parentNode->removeChild($node);
    }
    $dom->save($xmlFile);
    echo "ID-ga $aruandeId kirje on kustutatud.";
} else {
    echo "ID-ga $aruandeId kirjet ei leitud.";
}
?>
