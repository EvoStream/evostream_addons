<?php

/**
 *
 * EvoStream Web Services
 * EvoStream, Inc.
 * (c) 2016 by EvoStream, Inc. (support@evostream.com)
 * Released under the MIT License
 *
 **/

/*
 * --------------------------------------------------------------------------
 * Load Plugins
 * --------------------------------------------------------------------------
 * 
 * Include the plugins for the application
 * 
 */

require_once (dirname(__FILE__) . '/../plugins/plugins.php');


/*
 * --------------------------------------------------------------------------
 * Error Logging Configuration
 * --------------------------------------------------------------------------
 *
 * Enable error reporting and tell php where your custom php error log is
 *
 */

//Enable error logging
ini_set('display_errors', 1);
error_reporting(E_ALL & ~E_NOTICE);

// Specify where the error log is located
ini_set('error_log', 'evowebservices.log');
?>
