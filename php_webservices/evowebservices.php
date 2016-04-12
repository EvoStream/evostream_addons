<?php

/**
 *
 * EvoStream Web Services
 * EvoStream, Inc.
 * (c) 2016 by EvoStream, Inc. (support@evostream.com)
 * Released under the MIT License
 *
 **/

//1. Load the configuration
require_once 'config/config.php';

//	1.a Validate that php curl is enabled before going to next process
validateCurl();

//2. get the event from the pipe
$event = getEvent();

//3. Get the stack of plugins
$plugins = getPluginsStack();

//4. Call each plugin
foreach ($plugins as $plugin) {
	
	//Is this plugin supporting this event type?
	if ($plugin->supportsEvent($event->type) !== true)
		continue;

	//execute the plugin
	$continue = $plugin->processEvent($event);
	
	//should we continue?
	if ($continue !== true)
		break;
}


// ------------------------------------------------------------------------

/**
 * Get Event from the $_POST input
 * @return array
 */	
function getEvent() {	

	//Get the event from pipe and json_decode it
	return json_decode(file_get_contents('php://input'));
}

/**
 * Validate that php curl is enabled
 */	
function validateCurl(){
	// Before anything else, check if we have php-curl is installed
	if (!function_exists('curl_init')) {
		error_log("Kindly install/enable php-curl module and try again. This standard module allows the webserver to communicate with the EMS.");
		exit();
	}
}

?>
