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
 * Stream Recorder Plugin
 */

class StreamRecorder implements BasePlugin {

	private $settings;

	/**
	 * Initialize the settings for Recorder
	 * @param array $settings
	 * @return boolean
	 */
	public function init($settings) {
		$this->settings = $settings;
	}

	/**
	 * Execute process for Recorder
	 * @param array $event
	 * @return boolean
	 */
	public function processEvent($event) {

		//Process for New Stream created
		if ($event->type == 'inStreamCreated') {
			//1. Get LocalStreamName
			$localStreamName = $event->payload->name;

			//2. Execute Record Stream
			try {

				//Create object for the ems core api
				$api = new EvoCoreAPI();

				if (!is_dir($this->settings['file_location'])) {
					error_log("Evowebservices Error: The file location for recorded files is invalid");
				}

				//Execute command for record stream
                $api->record($localStreamName, $this->settings['file_location'], '', '', '1', '', '', '', '_localStreamName=' . str_replace(' ', '', $localStreamName));
			} catch (Exception $e) {
				//Log any error message 
				error_log("Evowebservices Error: " . $e->getMessage());
			}
		}

		//Process for OutStreamCreated for the recorded stream
		if ($event->type == 'outStreamCreated') {
			
			//1. Get the Recorded stream
			$recordedStream = $event->payload->recordSettings->_localStreamName;
			$localStreamName = $event->payload->name;
			$uniqueId = $event->payload->uniqueId;

			//Check if the localStreamName is the recorded stream, 
			//if not exit the plugin
			if ($localStreamName !== $recordedStream) {
				return true;
			}
			
			//2. Execute creation of timer
			try {

				//Create object for the ems core api
				$api = new EvoCoreAPI();

				$timerList = json_decode($api->listTimers());

				if (!empty($timerList->data)) {
					$timerListData = $timerList->data;

					//Check that the stream is not yet set with a timer
					foreach ($timerListData as $timerData) {
						if ($timerData->_uniqueId == $uniqueId) {

							//if a timer is already set to the stream, exit plugin 
							//by returning true
							return true;
						}
					}
				}

				$api->setTimer(intval($this->settings['period_time']), '_uniqueId=' . $uniqueId);
			} catch (Exception $e) {
				//Log any error message 
				error_log("Evowebservices Error: " . $e->getMessage());
			}
		}

		//Process when timer is triggered
		if ($event->type == "timerTriggered") {
			
			//1. Get uniqueId from a parameter set by the Set Timer	
			$_uniqueId = $event->payload->_uniqueId;

			//2. Execute ShutdownStream using the uniqueId
			try {
				
				//Create object for the ems core api
				$api = new EvoCoreAPI();

				//Execute command for shutdown stream
				$api->shutdownStream($_uniqueId, '', 0);

				//Remove the timer after the shutdown
				$timerList = json_decode($api->listTimers());

				if (!empty($timerList->data)) {
					$timerListData = $timerList->data;

					//Get the timer id using the _localStreamName and remove it
					foreach ($timerListData as $timerData) {
						if ($timerData->_uniqueId == $_uniqueId) {

							//Execute api for removing a timer
							$api->removeTimer($timerData->timerId);
						}
					}
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

		//Validate that Plugin supports the Event
		if ($eventType == 'inStreamCreated') {
			return true;
		}

		if ($eventType == 'outStreamCreated') {
			return true;
		}

		if ($eventType == 'timerTriggered') {
			return true;
		}
	}

}

?>
