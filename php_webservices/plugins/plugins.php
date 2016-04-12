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
 * Load Available Plugins
 * --------------------------------------------------------------------------
 * 
 * Include and load the core and apis to be used by the plugins 
 * 
 */

require_once (dirname(__FILE__).'/../core/ini-parser.php');
require_once (dirname(__FILE__).'/../core/evoapi-core.php');
require_once (dirname(__FILE__).'/../core/s3-core.php');

/*
 * Return the array of plugins used by the service
 * in the correct executionorder
 */
function getPluginsStack() {
	
	//1. Parse the ini file and get the array of plugins
	$iniParse = new iniParser();
	$plugins = $iniParse->getPlugins();

	foreach ($plugins as $key => $value) {
		
		//2. Check which plugin is enabled
		if ($value !== 'enabled')
			continue;
		
		//3. Load the plugin
		try {
			require_once strtolower($key) . '.php';
			$instance = new $key;
		} catch (Exception $e) {
			error_log("Evowebservices Error: " . $e->getMessage());
			continue;
		}
		
		//4. Get the setting of the plugin loaded
		$settings = $iniParse->getSettings($key);
		$instance->init($settings);
		$plugin[] = $instance;
	}
	
	return $plugin;

}

?>
