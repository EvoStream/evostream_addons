<?php

/**
 *
 * EvoStream Web Services
 * EvoStream, Inc.
 * (c) 2016 by EvoStream, Inc. (support@evostream.com)
 * Released under the MIT License
 *
 **/

/**
 * ini Parser for Evostream Webservices config.ini
 */
class iniParser {

	private $config = "";

	/**
	 * Instantiate iniParser using the config.ini file
	 */
	public function __construct() {
		$this->config = parse_ini_file(dirname(__FILE__) . '/../config/config.ini', true);
	}

	/**
	 * Get the plugins
	 */
	public function getPlugins() {
		return $this->config["Plugins"];
	}

	/**
	 * Get the settings of a plugin
	 */
	public function getSettings($PluginName) {
		return $this->config[$PluginName];
	}

}

?>
