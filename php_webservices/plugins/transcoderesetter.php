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

class TranscodeResetter implements BasePlugin {

	private $settings;

	/**
	 * Initialize the settings for Auto Router
	 * @param array $settings
	 * @return boolean
	 */
	/*public function init($settings) {
		$this->settings = $settings;
	}*/

	/**
	 * Execute process for Auto Router 
	 * @param array $event
	 * @return boolean
	 */
	public function processEvent($event) {

		//1. Get LocalStreamName and ip address of sender and receiver
		$localStreamName = $event->payload->localStreamName;
		$streamId = $event->payload->id;
		$remote_address = $_SERVER['REMOTE_ADDR'];

		//3. Execute AutoRouter Stream
		if (!empty($streamId) && !empty($localStreamName)) {

			try {
				//Create object for the ems core api
				$api = new EvoCoreAPI();
				$api->shutdownStream($streamId, $localStreamName, 1);
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
		if ($eventType == 'audioFeedStopped') {
			return true;
		}
	}

}

?>
