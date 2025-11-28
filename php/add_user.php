<?php
$xmlFile = __DIR__ . '/../data/sample_reports.xml';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $firstName = $_POST['firstName'] ?? '';
    $lastName = $_POST['lastName'] ?? '';
    $login = $_POST['login'] ?? '';
    $email = $_POST['email'] ?? '';
    $phone = $_POST['phone'] ?? '';
    $workHours = $_POST['workHours'] ?? '';
    $roleRef = $_POST['roleRef'] ?? '';

    if (!$firstName || !$lastName || !$login) {
        die('Missing required fields');
    }

    $xml = simplexml_load_file($xmlFile);

    $id = uniqid('u');

    $user = $xml->users->addChild('user');
    $user->addAttribute('id', $id);
    if ($roleRef) $user->addAttribute('roleRef', $roleRef);
    $user->addChild('firstName', htmlspecialchars($firstName));
    $user->addChild('lastName', htmlspecialchars($lastName));
    $user->addChild('login', htmlspecialchars($login));
    $user->addChild('email', htmlspecialchars($email));
    $user->addChild('phone', htmlspecialchars($phone));
    $user->addChild('workHours', htmlspecialchars($workHours));

    $xml->asXML($xmlFile);

    header('Location: ../php/transform.php?page=users');
    exit;
}
