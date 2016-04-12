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
 * Load Base Plugin
 * --------------------------------------------------------------------------
 * 
 * Include the Base Plugin for the application
 * 
 */
require_once 'baseplugin.php';


/*
 * Stream Auto Router Plugin
 */

class StreamAutoRouter implements BasePlugin {

	private $settings;

	/**
	 * Initialize the settings for Auto Router
	 * @param array $settings
	 * @return boolean
	 */
	public function init($settings) {
		$this->settings = $settings;
	}

	/**
	 * Execute process for Auto Router 
	 * @param array $event
	 * @return boolean
	 */
	public function processEvent($event) {

		//1. Get LocalStreamName and ip address of sender and receiver
		$localStreamName = $event->payload->name;
		$remote_address = $_SERVER['REMOTE_ADDR'];

		//2. Check the token on LocalStreamName
		$tokenExists = strpos($localStreamName, $this->settings['token']);

		//3. Execute AutoRouter Stream
		if ($tokenExists !== false || empty($this->settings['token'])) {

			try {
				//Create object for the ems core api
				$api = new EvoCoreAPI();

				//Exit plugin if ip address of receiver and sender is the same
				if ($this->settings['destination_uri'] === $remote_address) {
					return true;
				}

				$target_uri = 'rtmp://' . $this->settings['destination_uri'] . '/live';

				//Execute command for pushStream using destination address
                $api->pushStream($target_uri, $localStreamName, '', 0, '', '', '', '', '', '', '');
			} catch (Exception $e) {
				//Log any error message 
				error_log("Evowebservices Error: " . $e->getMessage());
			}
		}

		//Return True if process execution is done
		return true;
	}

	/**
	 * Check if Plugin supports the Event
	 * @param string $eventType
	 * @return boolean
	 */
	public function supportsEvent($eventType) {

		//Validate that Plugin supports the Event
		if ($eventType == 'inStreamCreated') {
			return true;
		}
	}

}

?>
