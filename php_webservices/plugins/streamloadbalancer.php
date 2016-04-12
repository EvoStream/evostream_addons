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
 * Stream Load Balancer Plugin
 */

class StreamLoadBalancer implements BasePlugin {

	private $settings;

	/**
	 * Initialize the settings for StreamLoadBalancer
	 * @param array $settings
	 * @return boolean
	 */
	public function init($settings) {
		$this->settings = $settings;
	}

	/**
	 * Execute process for StreamLoadBalancer
	 * @param array $event
	 * @return boolean
	 */
	public function processEvent($event) {

		//1. Get the localStreamName and List of Ip Address
		$localStreamName = $event->payload->name;
		$ipLists = $this->settings['destination_uri'];

		//Get the localStreamName from previous pull
		$_localStreamName = $event->payload->pullSettings->_localStreamName;
		$remote_address = $_SERVER['REMOTE_ADDR'];

		//2. Check if stream was a previously processed by using property of the pull settings
		if (empty($_localStreamName) || ($_localStreamName != $localStreamName)) {
			try {

				//3. Execute pullstream on each ip address from the list
				foreach ($ipLists as $ip_address) {

					//Create object for the ems core api
					$ip_ems = "http://" . $ip_address . ":7777/";
					$api = new EvoCoreAPI($ip_ems);

					if ($ip_address === $remote_address) {
						continue;
					}

					$target_uri = 'rtmp://' . $remote_address . '/live/' . $localStreamName;
					
					//Execute pullstream command
                    			$api->pullStream($target_uri, 0, $localStreamName, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '');
				}
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

		if ($eventType == 'inStreamCreated') {
			return true;
		}
	}

}

?>
