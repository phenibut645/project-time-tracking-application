<?php
$xmlFile = __DIR__ . '/../data/sample_reports.xml';

$aruandeId = $_POST['aruandeId'] ?? '';
$nimi = $_POST['nimi'] ?? '';
$perekonnanimi = $_POST['perekonnanimi'] ?? '';
$roll = $_POST['roll'] ?? '';
$hours = $_POST['hours'] ?? 0;
$kinnitusstaatus = $_POST['kinnitusstaatus'] ?? 'pending';
$sisselogimisaeg = date('Y-m-d H:i:s');

$dom = new DOMDocument();
$dom->preserveWhiteSpace = false;
$dom->formatOutput = true;
$dom->load($xmlFile);

$report = $dom->createElement('report');
$report->setAttribute('aruandeId', $aruandeId);
$report->setAttribute('kinnitusstaatus', $kinnitusstaatus);
$report->setAttribute('sisselogimisaeg', $sisselogimisaeg);

$kasutaja = $dom->createElement('kasutaja');
$kasutaja->setAttribute('roll', $roll);

$nimiElem = $dom->createElement('nimi', $nimi);
$perekonnanimiElem = $dom->createElement('perekonnanimi', $perekonnanimi);

$kasutaja->appendChild($nimiElem);
$kasutaja->appendChild($perekonnanimiElem);
$report->appendChild($kasutaja);

$hoursElem = $dom->createElement('hours', $hours);
$report->appendChild($hoursElem);

$dom->documentElement->appendChild($report);

$dom->save($xmlFile);
?>
