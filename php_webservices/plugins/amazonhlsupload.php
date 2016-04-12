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
 * Include the Base HLS Plugin for the application
 * 
 */
require_once 'basehlsplugin.php';

/*
 * Amazon S3 Upload HLS Chunk Plugin
 */

class AmazonHLSUpload implements BaseHLSPlugin {

	private $settings;

	/**
	 * Initialize the settings for AmazonHDSUpload
	 * @param array $settings
	 * @return boolean
	 */
	public function init($settings) {
		$this->settings = $settings;
	}	
	
	/**
	 * Execute process for AmazonHLSUpload
	 * @param array $event
	 * @return boolean
	 */
	public function processEvent($event) {

		//1. Get file from the event
		$file = $event->payload->file;

		//2. Setup the file directory the the directory where the file would be uploaded
		$uploadDirectory = $this->getUploadDirectory($event->type, $file);

		//3. Create s3 object
		$s3 = new S3($this->settings['aws_access_key'], $this->settings['aws_secret_key']);

		//4. Execute the file upload using s3
	        try {
	            if (!$s3->putObjectFile($file, $this->settings['default_bucket'], $uploadDirectory['main'], S3::ACL_PUBLIC_READ)) {
	                error_log("Evowebservices Error: Something went wrong while uploading your file - " . $uploadDirectory['main']);
	            }
	        } catch(Exception $e) {
	            error_log('HLS Errors: '.$e->getMessage());
	        }


		//Return True if process execution is done
		return true;
	}

	/**
	 * Get the upload directory based on the file location
	 * @param string $eventType
	 * @param string $file
	 * @return array $uploadDirectory
	 */
	public function getUploadDirectory($eventType, $file) {
		
		//1. Get the folder and file names from the file location
		$fileDirectory = explode(DIRECTORY_SEPARATOR, $file);

		//2. Set the uploading directory where the files would be uploaded
		if ($eventType == 'hlsMasterPlaylistUpdated') {
			$uploadDirectory['mplaylist'] = array_pop($fileDirectory);
			$uploadDirectory['groupName'] = array_pop($fileDirectory);
			$uploadDirectory['main'] = $uploadDirectory['groupName'] . '/' . $uploadDirectory['mplaylist'];
			
		} else {
			$uploadDirectory['chunk'] = array_pop($fileDirectory);
			$uploadDirectory['localStreamName'] = array_pop($fileDirectory);
			$uploadDirectory['groupName'] = array_pop($fileDirectory);
			$uploadDirectory['main'] = $uploadDirectory['groupName'] . '/' . $uploadDirectory['localStreamName'] . '/' . $uploadDirectory['chunk'];
		}
						
		return $uploadDirectory;
	}

	/**
	 * Check if Plugin supports the Event
	 * @param string $eventType
	 * @return boolean
	 */
	public function supportsEvent($eventType) {
		
		//Validate that Plugin supports the Event for Master Playlist
		if ($eventType == 'hlsMasterPlaylistUpdated') {
			return true;
		}

		//Validate that Plugin supports the Event for Child Playlist
		if ($eventType == 'hlsChildPlaylistUpdated') {
			return true;
		}

		//Validate that Plugin supports the Event for Chunk
		if ($eventType == 'hlsChunkClosed') {
			return true;
		}
	}

}

?>
