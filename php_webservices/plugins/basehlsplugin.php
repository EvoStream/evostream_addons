<?php

/**
 *
 * EvoStream Web Services
 * EvoStream, Inc.
 * (c) 2016 by EvoStream, Inc. (support@evostream.com)
 * Released under the MIT License
 *
 **/

interface BaseHLSPlugin {
	
	public function init($settings);
	/* !
	 * @brief This function will initialize the setting for the plugin
	 *
	 * @param $settings - the array of setting fot the plugin
	 *
	 * @return It must return true if the plugins stack should continue
	 * processing, or false if not
	 */

	public function processEvent($event);

	/* !
	 * @brief This function will be called for each and every event. It is going
	 * to tell the framework if processEvent should be called or not
	 *
	 * @param $event - the event which will be passed to processEvent
	 *
	 * @return It must return true or false. If true, the next plugin would be executed
	 * if false, the process would stop executing the other plugins
	 *
	 */
	
	public function getUploadDirectory($eventType, $file);
	/*
	 * @brief This function will get the upload directory based on the file location
	 * 
	 * @param $eventType - the event type which will be passed to processEvent
	 * @param $file - the file to be uploaded
	 * 
	 * @return $uploadDirectory - It must return an array of values containing the 
	 * directory information for the uploading of the file
	 * 
	 */	
	
	public function supportsEvent($eventType);
	/*
	 * @brief This function will check if the plugin supports the ems event
	 * 
	 * @param $eventType - the event type which will be passed to processEvent
	 * 
	 * @return It must return true or false. If true, than processEvent will be called
	 * if false, processEvent will not be called, skipping this plugin execution
	 * 
	 */	
}

?>
