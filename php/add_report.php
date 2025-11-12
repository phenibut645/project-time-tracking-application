<?php
$xmlFile = "../data/sample_reports.xml";

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $xml = simplexml_load_file($xmlFile);

    $report = $xml->addChild('report');
    $report->addAttribute('aruandeId', $_POST['aruandeId']);
    $report->addAttribute('sisselogimisaeg', date('Y-m-d\TH:i:s'));
    $report->addAttribute('kinnitusstaatus', $_POST['kinnitusstaatus']);

    $user = $report->addChild('kasutaja');
    $user->addAttribute('id', uniqid());
    $user->addAttribute('roll', $_POST['roll']);
    $user->addChild('nimi', $_POST['nimi']);
    $user->addChild('perekonnanimi', $_POST['perekonnanimi']);

    $dimensions = $report->addChild('dimensions');
    $dim1 = $dimensions->addChild('dim1');
    $dim1->addAttribute('name', $_POST['project']);
    $dim2 = $dim1->addChild('dim2');
    $dim2->addAttribute('name', $_POST['feature']);
    $dim3 = $dim2->addChild('dim3');
    $dim3->addAttribute('name', $_POST['task']);
    $dim3->addChild('hours', $_POST['hours']);
    $dim3->addChild('date', date('Y-m-d'));
    $dim3->addChild('comment', 'Added via form');

    $xml->asXML($xmlFile);

    header("Location: ../php/transform.php");
    exit;
}
?>
