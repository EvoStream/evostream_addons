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
 * Include the Base HDS Plugin for the application
 * 
 */
require_once 'basehdsplugin.php';

/*
 * Amazon S3 Upload HDS Chunk Plugin
 */

class AmazonHDSUpload implements BaseHDSPlugin {

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
	 * Execute process for AmazonHDSUpload
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
	            error_log($e->getMessage());
	        }


		//5. Upload the bootstrap file
		if (file_exists(dirname($file) . DIRECTORY_SEPARATOR . $this->settings['bootstrap'])) {

			//6. Execute the boostrap file upload using s3
			if (!$s3->putObjectFile($uploadDirectory['bootstrap_file'], $this->settings['default_bucket'], $uploadDirectory['bootstrap_directory'], S3::ACL_PUBLIC_READ)) {
				error_log("Evowebservices Error: Something went wrong while uploading your bootstrap file - " . $uploadDirectory['bootstrap_directory']);
			}
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
		if ($eventType == 'hdsMasterPlaylistUpdated') {
			$uploadDirectory['mplaylist'] = array_pop($fileDirectory);
			$uploadDirectory['groupName'] = array_pop($fileDirectory);
			$uploadDirectory['main'] = $uploadDirectory['groupName'] . '/' . $uploadDirectory['mplaylist'];
		} else {
			$uploadDirectory['chunk'] = array_pop($fileDirectory);
			$uploadDirectory['localStreamName'] = array_pop($fileDirectory);
			$uploadDirectory['groupName'] = array_pop($fileDirectory);
			$uploadDirectory['main'] = $uploadDirectory['groupName'] . '/' . $uploadDirectory['localStreamName'] . '/' . $uploadDirectory['chunk'];
		}

		//Get the bootstrap
		if (file_exists(dirname($file) . DIRECTORY_SEPARATOR . $this->settings['bootstrap'])) {
			
			//1. Setup the bootstrap file directory the the directory where the bootstrap would be uploaded
			$uploadDirectory['bootstrap_file'] = dirname($file) . DIRECTORY_SEPARATOR . $this->settings['bootstrap'];
			$uploadDirectory['bootstrap_directory'] = $uploadDirectory['groupName'] . '/' . $uploadDirectory['localStreamName'] . '/' . $this->settings['bootstrap'];
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
		if ($eventType == 'hdsMasterPlaylistUpdated') {
			return true;
		}

		//Validate that Plugin supports the Event for Child Playlist
		if ($eventType == 'hdsChildPlaylistUpdated') {
			return true;
		}

		//Validate that Plugin supports the Event for Chunk
		if ($eventType == 'hdsChunkClosed') {
			return true;
		}
	}

}

?>
