<?php
$xmlFile = __DIR__ . '/../data/sample_reports.xml';
$xslFile = __DIR__ . '/../xsl/reports_to_html.xsl';

$xml = new DOMDocument;
$xml->load($xmlFile);
$xsl = new DOMDocument;
$xsl->load($xslFile);

$proc = new XSLTProcessor();
$proc->importStylesheet($xsl);

$page = $_GET['page'] ?? 'reports';
$statusFilter = $_GET['statusFilter'] ?? '';
$search = $_GET['search'] ?? '';
$groupBy = $_GET['groupBy'] ?? '';

$proc->setParameter('', 'currentDate', date('Y-m-d'));
$proc->setParameter('', 'page', $page);
$proc->setParameter('', 'statusFilter', $statusFilter);
$proc->setParameter('', 'search', $search);
$proc->setParameter('', 'groupBy', $groupBy);

header('Content-Type: text/html; charset=utf-8');
echo $proc->transformToXML($xml);
