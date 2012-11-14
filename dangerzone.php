<?php

// Prevent caching.
// header('Cache-Control: no-cache, must-revalidate');
// header('Expires: Mon, 01 Jan 2013 00:00:00 GMT');

// The JSON standard MIME header.
header('Content-type: application/json');

// This ID parameter is sent by our javascript client.
$id = $_GET['id'];

// Here's some data that we want to send via JSON.
// We'll include the $id parameter so that we
// can show that it has been passed in correctly.
// You can send whatever data you like.
$data = array(
                array(
                        'uid' => '123',
                        'category' => '0',
                        'latitude' => '1.222',
                        'longitude' => '1.3324',
                        'radius' => '30',
                        'severity' => '5',
                        'locale' => 'burlington'),
                array(  
                        'uid' => '123',
                        'category' => '1',
                        'latitude' => '1.222',
                        'longitude' => '1.3324',
                        'radius' => '30',
                        'severity' => '5',
                        'locale' => 'burlington'),
                 array(
                        'uid' => '123',
                        'category' => '2',
                        'latitude' => '1.222',
                        'longitude' => '1.3324',
                        'radius' => '30',
                        'severity' => '5',
                        'locale' => 'burlington'),
                array(
                        'uid' => '123',
                        'category' => '3',
                        'latitude' => '1.222',
                        'longitude' => '1.3324',
                        'radius' => '30',
                        'severity' => '5',
                        'locale' => 'burlington'),
                array(
                        'uid' => '123',
                        'category' => '4',
                        'latitude' => '1.222',
                        'longitude' => '1.3324',
                        'radius' => '30',
                        'severity' => '5',
                        'locale' => 'burlington'),
                array(
                        'uid' => '123',
                        'category' => '0',
                        'latitude' => '1.222',
                        'longitude' => '1.3324',
                        'radius' => '30',
                        'severity' => '5',
                        'locale' => 'burlington'),
                array(  
                        'uid' => '123',
                        'category' => '1',
                        'latitude' => '1.222',
                        'longitude' => '1.3324',
                        'radius' => '30',
                        'severity' => '5',
                        'locale' => 'burlington'),
                 array(
                        'uid' => '123',
                        'category' => '2',
                        'latitude' => '1.222',
                        'longitude' => '1.3324',
                        'radius' => '30',
                        'severity' => '5',
                        'locale' => 'burlington'),
                array(
                        'uid' => '123',
                        'category' => '3',
                        'latitude' => '1.222',
                        'longitude' => '1.3324',
                        'radius' => '30',
                        'severity' => '5',
                        'locale' => 'burlington'),
                array(
                        'uid' => '123',
                        'category' => '4',
                        'latitude' => '1.222',
                        'longitude' => '1.3324',
                        'radius' => '30',
                        'severity' => '5',
                        'locale' => 'burlington')
                );


// Send the data.
echo json_encode($data);

?>
