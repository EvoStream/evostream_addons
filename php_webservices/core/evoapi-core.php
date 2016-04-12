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
 * @package evostream
 * @subpackage api
 * @version 0.708
 */

/**
 * EMS API
 */
class EvoCoreAPI
{
    /*
     * evostream server url
     * @var string
     * @access private
     */

    private $ServerUrl = "http://localhost:7777/";

    /*
     * json data
     * @var string
     * @access private
     */
    private $data = "";

    function __construct($svrURL)
    {

        if ($svrURL != "")
            $this->ServerUrl = $svrURL;
    }

    /*
     * process ems api function with curl
     *
     * @param    string      $fn         api function
     * @param    string      $params     function parameters
     * @return   string                  json data
     */

    private function _procFunc($fn, $params = '')
    {
        $url = $this->ServerUrl . $fn;

        if ($params != '') {
            $url .= '?params=' . base64_encode($params);
        }

        $curl = curl_init();

        // Set the URL including the parameters
        curl_setopt($curl, CURLOPT_URL, $url);

        // We don't need any HTTP header, so set as empty
        curl_setopt($curl, CURLOPT_HTTPHEADER, array());

        // Return the data instead of printing it out
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);

        // Set the time out to 10sec, should be long enough in case no response from server
        curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, 10);

        // Actual curl exec
        $this->data = curl_exec($curl);

        curl_close($curl);

        // Return as string, this however is in JSON format
        return $this->data;
    }

    /*
     * prints this help
     */

    public function help()
    {
        return $this->_procFunc("help");
    }


    /*
     * Returns the versions for framework and this application
     */

    public function Version()
    {
        return $this->_procFunc("Version");
    }

    /*
     * pull in a stream from an external source
     */

    public function pullStream($uri, $keepAlive, $localStreamName, $forceTcp, $tcUrl, $pageUrl, $swfUrl,
                               $rangeStart, $rangeEnd, $ttl, $tos, $rtcpDetectionInterval, $emulateUserAgent, $isAudio, $audioCodecBytes, $spsBytes, $ppsBytes, $ssmIp, $httpProxy, $internalArguments = NULL)
    {
        $params = "";

        if (!isset($uri) || empty($uri)) {
            Throw new Exception('parameter uri required');
        }else{
            $params .= 'uri=' . str_replace(' ', '', $uri);
        }

        // If keepAlive is set, add that param to the command
        if (isset($keepAlive) && $keepAlive !== '') {
            if (!preg_match('/^[0,1]{1}$/', $keepAlive)) {
                Throw new Exception('parameter keepAlive invalid');
            }
            $params .= ' keepAlive=' . $keepAlive;
        }


        if (isset($localStreamName) && $localStreamName !== '') {
            $params .= ' localStreamName=' . $localStreamName;
        }

        if (isset($forceTcp) && $forceTcp !== '') {
            if (!preg_match('/^[0,1]{1}$/', $forceTcp)) {
                Throw new Exception('parameter forceTcp invalid');
            }
            $params .= ' forceTcp=' . $forceTcp;
        }

        if (isset($tcUrl) && $tcUrl !== '') {
            $params .= ' tcUrl=' . $tcUrl;
        }

        if (isset($pageUrl) && $pageUrl !== '') {
            $params .= ' pageUrl=' . $pageUrl;
        }

        if (isset($swfUrl) && $swfUrl !== '') {
            $params .= ' swfUrl=' . $swfUrl;
        }

        if (isset($rangeStart) && $rangeStart !== '') {
            if (!preg_match('/^-[1,2]{1}$/', $rangeStart)) {
                Throw new Exception('parameter rangeStart invalid');
            }
            $params .= ' rangeStart=' . $rangeStart;
        }

        if (isset($rangeEnd) && $rangeEnd !== '') {
            if (!preg_match('/^-[1,2]{1}$/', $rangeEnd)) {
                Throw new Exception('parameter rangeEnd invalid');
            }
            $params .= ' rangeEnd=' . $rangeEnd;
        }

        if (isset($ttl) && $ttl !== '') {
            $params .= ' ttl=' . $ttl;
        }

        if (isset($tos) && $tos !== '') {
            $params .= ' tos=' . $tos;
        }

        if (isset($rtcpDetectionInterval) && $rtcpDetectionInterval !== '') {
            if ($rtcpDetectionInterval > 10) {
                Throw new Exception('parameter rtcpDetectionInterval invalid');
            }
            $params .= ' rtcpDetectionInterval=' . $rtcpDetectionInterval;
        }

        if (isset($emulateUserAgent) && $emulateUserAgent !== '') {
            $params .= ' emulateUserAgent=' . $emulateUserAgent;
        }

        //Set Protocol used
        $protocol = '';
        $pieces = explode(":", $uri);
        $protocol = $pieces[0];

        if ($protocol == 'rtsp') {
            if (isset($isAudio) && $isAudio !== '') {
                if (!preg_match('/^[0,1]{1}$/', $isAudio)) {
                    Throw new Exception('parameter isAudio invalid');
                }
                $params .= ' isAudio=' . $isAudio;
            }



            if ($isAudio == true) {
                if (isset($audioCodecBytes) && $audioCodecBytes !== '') {
                    $params .= ' audioCodecBytes=' . $audioCodecBytes;
                }
            } else {
                if (isset($spsBytes) && $spsBytes !== '') {
                    $params .= ' spsBytes=' . $spsBytes;
                }
                if (isset($ppsBytes) && $ppsBytes !== '') {
                    $params .= ' ppsBytes=' . $ppsBytes;
                }
            }
        }

        if (isset($ssmIp) && $ssmIp !== '') {
            $params .= ' ssmIp=' . $ssmIp;
        }

        if (isset($httpProxy) && $httpProxy !== '') {
            $params .= ' httpProxy=' . $httpProxy;
        }

        $params .= $internalArguments;
        return $this->_procFunc("pullStream", $params);
    }

    /*
     * push a local stream to an external destination
     */

    public function pushStream($uri, $localStreamName, $tos, $keepAlive, $targetStreamName, $targetStreamType, $emulateUserAgent,
                               $rtmpAbsoluteTimestamps, $swfUrl, $pageUrl, $ttl, $internalArguments = NULL)
    {
        $params = "";

        if (!isset($uri) || empty($uri)) {
            Throw new Exception('parameter uri required');
        }else{
            $params .= 'uri=' . str_replace(' ', '', $uri);
        }

        if (!isset($localStreamName) || empty($localStreamName)) {
            Throw new Exception('parameter localStreamName required');
        }else{
            $params .= ' localStreamName=' . str_replace(' ', '', $localStreamName);
        }

        if (isset($keepAlive) && $keepAlive !== '') {
            if (!preg_match('/^[0,1]{1}$/', $keepAlive)) {
                Throw new Exception('parameter keepAlive invalid');
            }
            $params .= ' keepAlive=' . $keepAlive;
        }

        if (!isset($targetStreamName) || empty($targetStreamName)) {
            $targetStreamName = $localStreamName;
        }
        $params .= ' targetStreamName=' . str_replace(' ', '', $targetStreamName);

        if (isset($targetStreamType) && $targetStreamType !== '') {
            if (!preg_match('/^live|record|append$/i', $targetStreamType)) {
                Throw new Exception('parameter targetStreamType invalid');
            }
            $params .= ' targetStreamType=' . $targetStreamType;
        }

        if (isset($emulateUserAgent) && $emulateUserAgent !== '') {
            $params .= ' emulateUserAgent=' . str_replace(' ', '', $emulateUserAgent);
        }

        if (isset($swfUrl) && $swfUrl !== '') {
            $params .= ' swfUrl=' . $swfUrl;
        }

        if (isset($pageUrl) && $pageUrl !== '') {
            $params .= ' pageUrl=' . $pageUrl;
        }

        if (isset($rtmpAbsoluteTimestamps) && $rtmpAbsoluteTimestamps !== '') {
            $params .= ' rtmpAbsoluteTimestamps=' . $rtmpAbsoluteTimestamps;
        }

        if (isset($ttl) && $ttl !== '') {
            $params .= ' ttl=' . $ttl;
        }

        if (isset($tos) && $tos !== '') {
            $params .= ' tos=' . $tos;
        }

        $params .= $internalArguments;
        return $this->_procFunc("pushStream", $params);
    }

    /*
     * create HTTP live stream out of an existing H.264/AAC stream
     */
    public function createHLSStream($localStreamNames, $targetFolder, $keepAlive, $overwriteDestination, $staleRetentionCount,
                                    $createMasterPlaylist, $cleanupDestination, $bandwidths, $groupName, $playlistType, $playlistLength, $playlistName, $chunkLength,
                                    $chunkBaseName, $chunkOnIDR, $drmType, $AESKeyCount)
    {
        $params = "";


        if (!isset($localStreamNames) || empty($localStreamNames)) {
            Throw new Exception('parameter localStreamNames required');
        }else{
            $params .= 'localStreamNames=' . str_replace(' ', '', $localStreamNames);
        }

        if (!isset($targetFolder) || empty($targetFolder)) {
            Throw new Exception('parameter targetFolder required');
        }else{
            $params .= ' targetFolder=' . str_replace(' ', '', $targetFolder);
        }

        if (isset($bandwidths) && $bandwidths !== '') {
            $params .= ' bandwidths=' . str_replace(' ', '', $bandwidths);
        }

        if (isset($keepAlive) && $keepAlive !== '') {
            if (!preg_match('/^[0,1]{1}$/', $keepAlive)) {
                Throw new Exception('parameter keepAlive invalid');
            }
            $params .= ' keepAlive=' . $keepAlive;
        }

        if (isset($overwriteDestination) && $overwriteDestination !== '') {
            if (!preg_match('/^[0,1]{1}$/', $overwriteDestination)) {
                Throw new Exception('parameter overwriteDestination invalid');
            }
            $params .= ' overwriteDestination=' . $overwriteDestination;
        }

        if (isset($createMasterPlaylist) && $createMasterPlaylist !== '') {
            if (!preg_match('/^[0,1]{1}$/', $createMasterPlaylist)) {
                Throw new Exception('parameter createMasterPlaylist invalid');
            }
            $params .= ' createMasterPlaylist=' . $createMasterPlaylist;
        }

        if (isset($groupName) && $groupName !== '') {
            $params .= ' groupName=' . str_replace(' ', '', $groupName);
        }


        if (isset($playlistType) && $playlistType !== '') {
            if (!preg_match('/^appending|rolling$/i', $playlistType)) {
                Throw new Exception('parameter playlistType invalid');
            }
            $params .= ' playlistType=' . $playlistType;
        }



        if (isset($playlistName) && $playlistName !== '') {
            $params .= ' playlistName=' . str_replace(' ', '', $playlistName);
        }


        if (isset($playlistLength) && $playlistLength !== '') {
            if (!preg_match('/^\d+$/', $playlistLength)) {
                Throw new Exception('parameter playlistLength invalid');
            }
            $params .= ' playlistLength=' . $playlistLength;
        }


        if (isset($staleRetentionCount) && $staleRetentionCount !== '') {
            if (!preg_match('/^\d+$/', $staleRetentionCount)) {
                Throw new Exception('parameter staleRetentionCount invalid');
            }
            $params .= ' staleRetentionCount=' . $staleRetentionCount;
        }



        if (isset($chunkLength) && $chunkLength !== '') {
            if (!preg_match('/^\d+$/', $chunkLength)) {
                Throw new Exception('parameter chunkLength invalid');
            }
            $params .= ' chunkLength=' . $chunkLength;
        }



        if (isset($chunkBaseName) && $chunkBaseName !== '') {
            $params .= ' chunkBaseName=' . str_replace(' ', '', $chunkBaseName);
        }


        if (isset($chunkOnIDR) && $chunkOnIDR !== '') {
            if (!preg_match('/^[0,1]{1}$/', $chunkOnIDR)) {
                Throw new Exception('parameter chunkOnIDR invalid');
            }
            $params .= ' chunkOnIDR=' . $chunkOnIDR;
        }


        if (isset($cleanupDestination) && $cleanupDestination !== '') {
            if (!preg_match('/^[0,1]{1}$/', $cleanupDestination)) {
                Throw new Exception('parameter cleanupDestination invalid');
            }
            $params .= ' cleanupDestination=' . $cleanupDestination;
        }


        if (isset($drmType) && $drmType !== '') {
            $params .= ' drmType=' . $drmType;
        }


        if (isset($AESKeyCount) && $AESKeyCount !== '') {
            $params .= ' AESKeyCount=' . $AESKeyCount;
        }

        return $this->_procFunc("createHLSStream", $params);
    }

    /*
      * Create an HTTP Dynamic Stream (HDS) out of an existing H.264/AAC stream.
      */

    public function createHDSStream($localStreamNames, $targetFolder, $bandwidths, $chunkBaseName, $chunkLength, $chunkOnIDR, $groupName, $keepAlive, $manifestName,
                                    $overwriteDestination, $playlistType, $playlistLength, $staleRetentionCount, $createMasterPlaylist, $cleanupDestination)
    {
        $params = "";

        if (!isset($localStreamNames) || empty($localStreamNames)) {
            Throw new Exception('parameter localStreamNames required');
        }else{
            $params .= 'localStreamNames=' . str_replace(' ', '', $localStreamNames);
        }

        if (!isset($targetFolder) || empty($targetFolder)) {
            Throw new Exception('parameter targetFolder required');
        }else{
            $params .= ' targetFolder=' . str_replace(' ', '', $targetFolder);
        }


        if (isset($bandwidths) && $bandwidths !== '') {
            $params .= ' bandwidths=' . str_replace(' ', '', $bandwidths);
        }


        if (isset($keepAlive) && $keepAlive !== '') {
            if (!preg_match('/^[0,1]{1}$/', $keepAlive)) {
                Throw new Exception('parameter keepAlive invalid');
            }
            $params .= ' keepAlive=' . $keepAlive;
        }


        if (isset($overwriteDestination) && $overwriteDestination !== '') {
            if (!preg_match('/^[0,1]{1}$/', $overwriteDestination)) {
                Throw new Exception('parameter overwriteDestination invalid');
            }
            $params .= ' overwriteDestination=' . $overwriteDestination;
        }



        if (isset($playlistLength) && $playlistLength !== '') {
            if (!preg_match('/^\d+$/', $playlistLength)) {
                Throw new Exception('parameter playlistLength invalid');
            }
            $params .= ' playlistLength=' . $playlistLength;
        }


        if (isset($staleRetentionCount) && $staleRetentionCount !== '') {
            if (!preg_match('/^\d+$/', $staleRetentionCount)) {
                Throw new Exception('parameter staleRetentionCount invalid');
            }
            $params .= ' staleRetentionCount=' . $staleRetentionCount;
        }


        if (isset($manifestName) && $manifestName !== '') {
            $params .= ' manifestName=' . str_replace(' ', '', $manifestName);
        }


        if (isset($groupName) && $groupName !== '') {
            $params .= ' groupName=' . str_replace(' ', '', $groupName);
        }


        if (isset($playlistType) && $playlistType !== '') {
            if (!preg_match('/^appending|rolling$/i', $playlistType)) {
                Throw new Exception('parameter playlistType invalid');
            }
            $params .= ' playlistType=' . $playlistType;
        }


        if (isset($chunkLength) && $chunkLength !== '') {
            if (!preg_match('/^\d+$/', $chunkLength)) {
                Throw new Exception('parameter chunkLength invalid');
            }
            $params .= ' chunkLength=' . $chunkLength;
        }



        if (isset($chunkBaseName) && $chunkBaseName !== '') {
            $params .= ' chunkBaseName=' . str_replace(' ', '', $chunkBaseName);
        }


        if (isset($chunkOnIDR) && $chunkOnIDR !== '') {
            if (!preg_match('/^[0,1]{1}$/', $chunkOnIDR)) {
                Throw new Exception('parameter chunkOnIDR invalid');
            }
            $params .= ' chunkOnIDR=' . $chunkOnIDR;
        }


        if (isset($createMasterPlaylist) && $createMasterPlaylist !== '') {
            $params .= ' createMasterPlaylist=' . $createMasterPlaylist;
        }


        if (isset($cleanupDestination) && $cleanupDestination !== '') {
            if (!preg_match('/^[0,1]{1}$/', $cleanupDestination)) {
                Throw new Exception('parameter cleanupDestination invalid');
            }
            $params .= ' cleanupDestination=' . $cleanupDestination;
        }

        return $this->_procFunc("createHDSStream", $params);
    }


    /*
      * Create a Microsoft Smooth Stream (MSS) out of an existing H.264/AAC stream.
      */

    public function createMSSStream($localStreamNames, $targetFolder, $bandwidths, $groupName, $playlistType, $playlistLength, $manifestName,
                                    $chunkLength, $chunkOnIDR, $keepAlive, $overwriteDestination, $staleRetentionCount, $cleanupDestination)
    {
        $params = "";

        if (!isset($localStreamNames) || empty($localStreamNames)) {
            Throw new Exception('parameter localStreamNames required');
        }else{
            $params .= 'localStreamNames=' . str_replace(' ', '', $localStreamNames);
        }

        if (!isset($targetFolder) || empty($targetFolder)) {
            Throw new Exception('parameter targetFolder required');
        }else{
            $params .= ' targetFolder=' . str_replace(' ', '', $targetFolder);
        }


        if (isset($bandwidths) && $bandwidths !== '') {
            $params .= ' bandwidths=' . str_replace(' ', '', $bandwidths);
        }


        if (isset($groupName) && $groupName !== '') {
            $params .= ' groupName=' . str_replace(' ', '', $groupName);
        }


        if (isset($playlistType) && $playlistType !== '') {
            if (!preg_match('/^appending|rolling$/i', $playlistType)) {
                Throw new Exception('parameter playlistType invalid');
            }
            $params .= ' playlistType=' . $playlistType;
        }



        if (isset($playlistLength) && $playlistLength !== '') {
            if (!preg_match('/^\d+$/', $playlistLength)) {
                Throw new Exception('parameter playlistLength invalid');
            }
            $params .= ' playlistLength=' . $playlistLength;
        }


        if (isset($staleRetentionCount) && $staleRetentionCount !== '') {
            $params .= ' staleRetentionCount=' . $staleRetentionCount;
        }


        if (isset($manifestName) && $manifestName !== '') {
            $params .= ' manifestName=' . str_replace(' ', '', $manifestName);
        }


        if (isset($chunkLength) && $chunkLength !== '') {
            if (!preg_match('/^\d+$/', $chunkLength)) {
                Throw new Exception('parameter chunkLength invalid');
            }
            $params .= ' chunkLength=' . $chunkLength;
        }


        if (isset($chunkOnIDR) && $chunkOnIDR !== '') {
            if (!preg_match('/^[0,1]{1}$/', $chunkOnIDR)) {
                Throw new Exception('parameter chunkOnIDR invalid');
            }
            $params .= ' chunkOnIDR=' . $chunkOnIDR;
        }



        if (isset($keepAlive) && $keepAlive !== '') {
            if (!preg_match('/^[0,1]{1}$/', $keepAlive)) {
                Throw new Exception('parameter keepAlive invalid');
            }
            $params .= ' keepAlive=' . $keepAlive;
        }



        if (isset($overwriteDestination) && $overwriteDestination !== '') {
            if (!preg_match('/^[0,1]{1}$/', $overwriteDestination)) {
                Throw new Exception('parameter overwriteDestination invalid');
            }
            $params .= ' overwriteDestination=' . $overwriteDestination;
        }

        if (isset($cleanupDestination) && $cleanupDestination !== '') {
            if (!preg_match('/^[0,1]{1}$/', $cleanupDestination)) {
                Throw new Exception('parameter cleanupDestination invalid');
            }
            $params .= ' cleanupDestination=' . $cleanupDestination;
        }


        return $this->_procFunc("createMSSStream", $params);
    }


    /*
      * Create a Dynamic Adaptive Streaming over HTTP (DASH) out of an existing H.264/AAC stream.
      */

    public function createDASHStream($localStreamNames, $targetFolder, $bandwidths, $groupName, $playlistType, $playlistLength, $manifestName,
                                     $chunkLength, $chunkOnIDR, $keepAlive, $overwriteDestination, $staleRetentionCount, $cleanupDestination)
    {
        $params = "";

        if (!isset($localStreamNames) || empty($localStreamNames)) {
            Throw new Exception('parameter localStreamNames required');
        }else{
            $params .= 'localStreamNames=' . str_replace(' ', '', $localStreamNames);
        }

        if (!isset($targetFolder) || empty($targetFolder)) {
            Throw new Exception('parameter targetFolder required');
        }else{
            $params .= ' targetFolder=' . str_replace(' ', '', $targetFolder);
        }

        if (isset($bandwidths) && $bandwidths !== '') {
            $params .= ' bandwidths=' . str_replace(' ', '', $bandwidths);
        }


        if (isset($groupName) && $groupName !== '') {
            $params .= ' groupName=' . str_replace(' ', '', $groupName);
        }


        if (isset($playlistType) && $playlistType !== '') {
            if (!preg_match('/^appending|rolling$/i', $playlistType)) {
                Throw new Exception('parameter playlistType invalid');
            }
            $params .= ' playlistType=' . $playlistType;
        }


        if (isset($playlistLength) && $playlistLength !== '') {
            if (!preg_match('/^\d+$/', $playlistLength)) {
                Throw new Exception('parameter playlistLength invalid');
            }
            $params .= ' playlistLength=' . $playlistLength;
        }


        if (isset($staleRetentionCount) && $staleRetentionCount !== '') {
            $params .= ' staleRetentionCount=' . $staleRetentionCount;
        }

        if (isset($manifestName) && $manifestName !== '') {
            $params .= ' manifestName=' . str_replace(' ', '', $manifestName);
        }


        if (isset($chunkLength) && $chunkLength !== '') {
            if (!preg_match('/^\d+$/', $chunkLength)) {
                Throw new Exception('parameter chunkLength invalid');
            }
            $params .= ' chunkLength=' . $chunkLength;
        }


        if (isset($chunkOnIDR) && $chunkOnIDR !== '') {
            if (!preg_match('/^[0,1]{1}$/', $chunkOnIDR)) {
                Throw new Exception('parameter chunkOnIDR invalid');
            }
            $params .= ' chunkOnIDR=' . $chunkOnIDR;
        }



        if (isset($keepAlive) && $keepAlive !== '') {
            if (!preg_match('/^[0,1]{1}$/', $keepAlive)) {
                Throw new Exception('parameter keepAlive invalid');
            }
            $params .= ' keepAlive=' . $keepAlive;
        }


        if (isset($overwriteDestination) && $overwriteDestination !== '') {
            if (!preg_match('/^[0,1]{1}$/', $overwriteDestination)) {
                Throw new Exception('parameter overwriteDestination invalid');
            }
            $params .= ' overwriteDestination=' . $overwriteDestination;
        }

        if (isset($cleanupDestination) && $cleanupDestination !== '') {
            if (!preg_match('/^[0,1]{1}$/', $cleanupDestination)) {
                Throw new Exception('parameter cleanupDestination invalid');
            }
            $params .= ' cleanupDestination=' . $cleanupDestination;
        }


        return $this->_procFunc("createDASHStream", $params);
    }

    /*
     * allow users to record a stream that does or does not yet exist
     */

    public function record($localStreamName, $fileLocation, $type, $overwrite, $keepAlive, $chunkLength, $waitForIDR, $winQtCompat, $internalArguments = NULL)
    {
        $params = "";

        if (!isset($localStreamName) || empty($localStreamName)) {
            Throw new Exception('parameter localStreamName required');
        }else{
            $params .= ' localStreamName=' . str_replace(' ', '', $localStreamName);
        }

        if (realpath($fileLocation) == FALSE) {
            Throw new Exception('parameter file location is invalid');
        }


        if (isset($type) && $type !== '') {
            $params .= ' type=' . $type;
        }


        if (isset($overwrite) && $overwrite !== '') {
            $params .= ' overwrite=' . $overwrite;
        }


        if (isset($keepAlive) && $keepAlive !== '') {
            if (!preg_match('/^[0,1]{1}$/', $keepAlive)) {
                Throw new Exception('parameter keepAlive invalid');
            }
            $params .= ' keepAlive=' . $keepAlive;
        }



        if (isset($chunkLength) && $chunkLength !== '') {
            if (!preg_match('/^\d+$/', $chunkLength)) {
                Throw new Exception('parameter chunkLength invalid');
            }
            $params .= ' chunkLength=' . $chunkLength;
        }



        if (isset($waitForIDR) && $waitForIDR !== '') {
            $params .= ' waitForIDR=' . $waitForIDR;
        }


        if (isset($winQtCompat) && $winQtCompat !== '') {
            $params .= ' winQtCompat=' . $winQtCompat;
        }

        //Add filename to file location
        $pathToFile = $fileLocation . $localStreamName . "." . $type;
        $params .= ' pathtofile=' . $pathToFile;

        return $this->_procFunc("record", $params);
    }


    /*
     * transcode a stream, add an overlay, or crop a stream
     */

    public function transcode($source, $destinations, $targetStreamNames, $groupName, $videoBitrates, $videoSizes, $videoAdvancedParamsProfiles, $audioBitrates, $audioChannelsCount, $audioFrequencies, $audioAdvancedParamsProfiles, $overlays, $croppings, $keepAlive, $internalArguments = NULL)
    {
        // initialize params
        $params = '';

        if (!isset($source) || empty($source)) {
            Throw new Exception('parameter source required');
        } else {
            $params .= 'source=' . $source;
        }

        if (!isset($destinations) || empty($destinations)) {
            Throw new Exception('parameter destinations required');
        } else {
            $params .= ' destinations=' . $destinations;
        }

        if (isset($targetStreamNames) && $targetStreamNames !== '') {
            $params .= ' targetStreamNames=' . $targetStreamNames;
        }

        if (isset($groupName) && $groupName !== '') {
            $params .= ' groupName=' . $groupName;
        }

        if (isset($videoBitrates) && $videoBitrates !== '') {
            $params .= ' videoBitrates=' . $videoBitrates;
        }

        if (isset($videoSizes) && $videoSizes !== '') {
            $params .= ' videoSizes=' . $videoSizes;
        }

        if (isset($videoAdvancedParamsProfiles) && $videoAdvancedParamsProfiles !== '') {
            $params .= ' videoAdvancedParamsProfiles=' . $videoAdvancedParamsProfiles;
        }

        if (isset($audioBitrates) && $audioBitrates !== '') {
            $params .= ' audioBitrates=' . $audioBitrates;
        }

        if (isset($audioChannelsCount) && $audioChannelsCount !== '') {
            $params .= ' audioChannelsCount=' . $audioChannelsCount;
        }

        if (isset($audioFrequencies) && $audioFrequencies !== '') {
            $params .= ' audioFrequencies=' . $audioFrequencies;
        }

        if (isset($audioAdvancedParamsProfiles) && $audioAdvancedParamsProfiles !== '') {
            $params .= ' audioAdvancedParamsProfiles=' . $audioAdvancedParamsProfiles;
        }

        if (isset($overlays) && $overlays !== '') {
            $params .= ' overlays=' . $overlays;
        }

        if (isset($croppings) && $croppings !== '') {
            $params .= ' croppings=' . $croppings;
        }

        if (isset($keepAlive) && $keepAlive !== '') {
            $params .= ' keepAlive=' . $keepAlive;
        }

        $params .= ' ' . $internalArguments;

        return $this->_procFunc("transcode", $params);
    }

    /*
     * Get a list of IDs from every active stream
     */
    public function listStreamsIds()
    {
        return $this->_procFunc("listStreamsIds");
    }

    /*
     * Returns the number of active streams
     */

    public function getStreamsCount()
    {
        return $this->_procFunc("getStreamsCount");
    }

    /*
     * Returns a detailed set of information about a stream
     */

    public function getStreamInfo($id)
    {

        if (!isset($id) || empty($id)) {
            Throw new Exception('parameter id required');
        } else if (!preg_match('/^\d+$/', $id)) {
            Throw new Exception('parameter id invalid');
        }
        $params = 'id=' . $id;
        return $this->_procFunc("getStreamInfo", $params);
    }

    /*
     * Provides a detailed description of every active stream
     */
    public function listStreams()
    {
        return $this->_procFunc("listStreams");
    }

    /*
     * Terminate a specific stream
     */

    public function shutdownStream($id, $localStreamName, $permanently)
    {
        $params = '';

        if ((!isset($id) || empty($id)) && (empty($localStreamName))) {
            Throw new Exception('either parameter id or localStreamName required');
        }

        if ($id !== '') {
            if (!preg_match('/^\d+$/', $id)) {
                Throw new Exception('parameter id invalid');
            } else {
                $params .= 'id=' . $id;
            }
        }

        if ($localStreamName !== '') {
            $params .= ' localStreamName=' . str_replace(' ', '', $localStreamName);
        }

        if (isset($permanently) || $permanently !== '') {
            $params .= ' permanently=' . str_replace(' ', '', $permanently);
        }

        if (!preg_match('/^[0,1]{1}$/', $permanently)) {
            Throw new Exception('parameter permanently invalid');
        }

        return $this->_procFunc("shutdownStream", $params);
    }

    /*
     * Returns a list with all push/pull configurations
     */

    public function listConfig()
    {
        return $this->_procFunc("listConfig");
    }

    /*
     * Removes a pull/push configuration. It does NOT stop the corresponding stream
     */

    public function removeConfig($id, $HlsHdsGroup, $removeHLSFiles)
    {

        // initialize params
        $params = '';

        if (!isset($id) || empty($id)) {
            Throw new Exception('parameter id required');
        } else if (!preg_match('/^\d+$/', $id)) {
            Throw new Exception('parameter id invalid');
        }else{
            $params = 'id=' . $id;
        }
        if (isset($HlsHdsGroup) || $HlsHdsGroup !== '') {
            $params = ' HlsHdsGroup=' . str_replace(' ', '', $HlsHdsGroup);
        }
        if (isset($removeHLSFiles) || $removeHLSFiles !== '') {
            $params = ' removeHLSFiles=' . $removeHLSFiles;
        }
        if (!preg_match('/^[0,1]{1}$/', $removeHLSFiles)) {
            Throw new Exception('parameter removeHLSFiles invalid');
        }
        $params = 'id=' . $id . ' HlsHdsGroup=' . str_replace(' ', '', $HlsHdsGroup) . ' removeHLSFiles=' . $removeHLSFiles;
        return $this->_procFunc("removeConfig", $params);
    }


    /*
     * Allows you to create secondary name(s) for internal streams
     */

    public function addStreamAlias($localStreamName, $aliasName)
    {
        // initialize params
        $params = '';

        if (!isset($localStreamName) || empty($localStreamName)) {
            Throw new Exception('parameter localStreamName required');
        }
        if (!isset($aliasName) || empty($aliasName)) {
            Throw new Exception('parameter aliasName required');
        }
        $params = 'localStreamName=' . str_replace(' ', '', $localStreamName) . ' aliasName=' . str_replace(' ', '', $aliasName);
        return $this->_procFunc("addStreamAlias", $params);
    }

    /*
     * Removes an alias of a stream
     */

    public function removeStreamAlias($aliasName)
    {
        if (!isset($aliasName) || empty($aliasName)) {
            Throw new Exception('parameter aliasName required');
        }
        $params = 'aliasName=' . str_replace(' ', '', $aliasName);
        return $this->_procFunc("removeStreamAlias", $params);
    }

    /*
     * Returns a complete list of aliases
     */

    public function listStreamAliases()
    {
        return $this->_procFunc("listStreamAliases");
    }

    /*
     * Invalidates all streams aliases
     */

    public function flushStreamAliases()
    {
        return $this->_procFunc("flushStreamAliases");
    }

    /*
     * Creates an RTMP ingest point
     */
    public function createIngestPoint($privateStreamName, $publicStreamName)
    {
        if (!isset($privateStreamName) || empty($privateStreamName)) {
            Throw new Exception('parameter privateStreamName required');
        }
        if (!isset($publicStreamName) || empty($publicStreamName)) {
            Throw new Exception('parameter publicStreamName required');
        }
        $params = 'privateStreamName=' . str_replace(' ', '', $privateStreamName) . ' publicStreamName=' . str_replace(' ', '', $publicStreamName);
        return $this->_procFunc("createIngestPoint", $params);
    }

    /*
     * Removes an RTMP ingest point
     */
    public function removeIngestPoint($privateStreamName)
    {
        if (!isset($privateStreamName) || empty($privateStreamName)) {
            Throw new Exception('parameter privateStreamName required');
        }

        $params = 'privateStreamName=' . str_replace(' ', '', $privateStreamName);
        return $this->_procFunc("removeIngestPoint", $params);
    }

    /*
     * Lists the currently available Ingest Points
     */

    public function listIngestPoints()
    {
        return $this->_procFunc("listIngestPoints");
    }


    /*
     * Allows the user to launch an external process on the local machine.
     */
    public function launchProcess($fullBinaryPath, $keepAlive, $arguments, $environmentVariables)
    {
        $params = '';
        $argumentsParams = null;
        $environmentVariablesParams = null;

        if (!file_exists($fullBinaryPath)) {
            Throw new Exception('parameter fullBinaryPath required');
        }
        if (!is_executable($fullBinaryPath)) {
            Throw new Exception('parameter fullBinaryPath is an invalid executable');
        }
        if (!isset($keepAlive) || $keepAlive === '') {
            $params .= ' keepAlive=1';
        }else{
            $params .= ' keepAlive=' . $keepAlive;
        }

        if ($arguments != '') {
            if (!preg_match("/([^\s]+)([\\][ ])/", $arguments)) {
                Throw new Exception('parameter arguments invalid. it should be delimited by ESCAPED SPACES (“\ “).');
            }
            $argumentsParams = ' arguments=' . $arguments;
        }
        if ($environmentVariables !== '') {
            if (!preg_match('/([$][^\s]+)=([^\s]+)/', $environmentVariables)) {
                Throw new Exception('parameter environment Variables invalid');
            }
            $environmentVariablesParams = ' environmentVariables=' . $environmentVariables;
        }
        $params .= 'fullBinaryPath=' . $fullBinaryPath . $argumentsParams . $environmentVariablesParams;
        return $this->_procFunc("launchProcess", $params);
    }

    /*
     * Adds a timer. When triggered, it will send an event to the event logger
     */

    public function setTimer($timePeriod, $internalArguments = NULL)
    {
        if (!isset($timePeriod) || empty($timePeriod)) {
            Throw new Exception('parameter timePeriod required');
        }
        if (!is_int($timePeriod)) {
            Throw new Exception('parameter time period value invalid');
        }

        $params = 'value=' . str_replace(' ', '', $timePeriod) . ' ' . $internalArguments;

        return $this->_procFunc("setTimer", $params);
    }

    /*
     * Returns a list of currently active timers
     */

    public function listTimers()
    {
        return $this->_procFunc("listTimers");
    }

    /*
     * Removes a previously armed timer
     */
    public function removeTimer($id)
    {
        if (!isset($id) || empty($id)) {
            Throw new Exception('parameter id required');
        }
        $params = 'id=' . str_replace(' ', '', $id);
        return $this->_procFunc("removeTimer", $params);
    }

    /*
     * Inserts a new item into an RTMP playlist.
     */
    public function insertPlaylistItem($playlistName, $localStreamName, $insertPoint, $sourceOffset, $duration)
    {

        // initialize params
        $params = '';

        if (isset($type) && $type !== '') {
            $params .= 'playlistName=' . str_replace(' ', '', $playlistName);
        }

        if (isset($localStreamName) && $localStreamName !== '') {
            $params .= ' localStreamName=' . str_replace(' ', '', $localStreamName);
        }

        if (isset($insertPoint) && $insertPoint !== '') {
            $params .= ' insertPoint=' . $insertPoint;
        }

        if (isset($sourceOffset) && $sourceOffset !== '') {
            $params .= ' sourceOffset=' . $sourceOffset;
        }

        if (isset($duration) && $duration !== '') {
            $params .= ' duration=' . $duration;
        }

        return $this->_procFunc("insertPlaylistItem", $params);
    }


    /*
     * Lists currently available media storage locations
     */
    public function listStorage()
    {
        return $this->_procFunc("listStorage");
    }

    /*
     * Adds a new storage location
     */
    public function addStorage($mediaFolder)
    {
        if (realpath($mediaFolder) == FALSE) {
            Throw new Exception('parameter mediaFolder is invalid');
        }
        $params = 'mediaFolder=' . $mediaFolder;
        return $this->_procFunc("addStorage", $params);
    }

    /*
     * Removes a storage location
     */
    public function removeStorage($mediaFolder)
    {
        if (realpath($mediaFolder) == FALSE) {
            Throw new Exception('parameter file location is invalid');
        }
        $params = 'mediaFolder=' . $mediaFolder;
        return $this->_procFunc("removeStorage", $params);
    }

    /*
     * Will enable/disable RTMP authentication
     */
    public function setAuthentication($enabled)
    {
        if (!isset($enabled) || $enabled === '') {
            Throw new Exception('parameter enabled required');
        }
        if (!preg_match('/^[0,1]{1}$/', $enabled)) {
            Throw new Exception('parameter enabled invalid');
        }
        $params = 'enabled=' . $enabled;
        return $this->_procFunc("setAuthentication", $params);
    }

    /*
     * Change the log level for all log appenders
     */

    public function setLogLevel($level)
    {
        if (!isset($level) || $level === '') {
            Throw new Exception('parameter level required');
        }
        if (!preg_match('/^[0-7]{1}$/', $level)) {
            Throw new Exception('parameter level invalid');
        }
        $params = 'level=' . $level;
        return $this->_procFunc("setLogLevel", $params);
    }

    /*
     * Shuts down the server
     */
    public function shutdownServer()
    {
        $shutdownServerList = json_decode($this->_procFunc("shutdownServer"));
        $key = $shutdownServerList->data->key;

        if (!isset($key) || empty($key)) {
            Throw new Exception('parameter key required');
        }

        $params = 'key=' . str_replace(' ', '', $key);
        return $this->_procFunc("shutdownServer", $params);
    }

    /*
     * Returns a list containing the IDs of every active connection
     */
    public function listConnectionsIds()
    {
        return $this->_procFunc("listConnectionsIds");
    }

    /*
     * Returns a detailed set of information about a connection
     */
    public function getConnectionInfo($id)
    {
        if (!isset($id) || empty($id)) {
            Throw new Exception('parameter id required');
        } else if (!preg_match('/^\d+$/', $id)) {
            Throw new Exception('parameter id invalid');
        }
        $params = 'id=' . $id;
        return $this->_procFunc("getConnectionInfo", $params);
    }

    /*
     * Returns the list of active connections
     */
    public function listConnections()
    {
        return $this->_procFunc("listConnections");
    }

    /*
     * Returns a detailed description of the network descriptors counters
     */
    public function getExtendedConnectionCounters()
    {
        return $this->_procFunc("getExtendedConnectionCounters");
    }

    /*
     * Reset the maximum, or high-water-mark, from the Connection Counters
     */
    public function resetMaxFdCounters()
    {
        return $this->_procFunc("resetMaxFdCounters");
    }

    /*
     * Reset the cumulative totals from the Connection Counters
     */
    public function resetTotalFdCounters()
    {
        return $this->_procFunc("resetTotalFdCounters");
    }

    /*
     * Returns the number of active connections
     */
    public function getConnectionsCount()
    {
        return $this->_procFunc("getConnectionsCount");
    }

    /*
     * Returns the limit of concurrent connections. This is the maximum number of connections this EMS instance will allow at one time
     */
    public function getConnectionsCountLimit()
    {
        return $this->_procFunc("getConnectionsCountLimit");
    }

    /*
     * This interface sets a limit on the number of concurrent connections the EMS will allow
     */
    public function setConnectionsCountLimit($count)
    {
        if (!isset($count) || empty($count)) {
            Throw new Exception('parameter count required');
        } else if (!preg_match('/^\d+$/', $count)) {
            Throw new Exception('parameter count invalid');
        }
        $params = 'count=' . $count;
        return $this->_procFunc("setConnectionsCountLimit", $params);
    }

    /*
     * Returns bandwidth information: limits and current values.
     */
    public function getBandwidth()
    {
        return $this->_procFunc("getBandwidth");
    }

    /*
     * This interface enforces a limit on the input and output bandwidth.
     */

    public function setBandwidthLimit($in, $out)
    {
        if (!isset($in) || empty($in)) {
            Throw new Exception('parameter in required');
        } else if (!preg_match('/^\d+$/', $in)) {
            Throw new Exception('parameter in invalid');
        }
        if (!isset($out) || empty($out)) {
            Throw new Exception('parameter out required');
        } else if (!preg_match('/^\d+$/', $out)) {
            Throw new Exception('parameter out invalid');
        }
        $params = 'in=' . $in . ' out=' . $out;
        return $this->_procFunc("setBandwidthLimit", $params);
    }

    /*
     * Services: Returns the list of available service
     */
    public function listServices()
    {
        return $this->_procFunc("listServices");
    }

    /*
     * Services: Enable or disable a service
     */
    public function enableService($id, $enable)
    {
        if (!isset($id) || empty($id)) {
            Throw new Exception('parameter id required');
        } else if (!preg_match('/^\d+$/', $id)) {
            Throw new Exception('parameter id invalid');
        }
        if (!isset($enable) || $enable === '') {
            Throw new Exception('parameter enable required');
        }
        if (!preg_match('/^[0,1]{1}$/', $enable)) {
            Throw new Exception('parameter enable invalid');
        }
        $params = 'id=' . $id . ' enable=' . $enable;
        return $this->_procFunc("enableService", $params);
    }

    /*
     * Services: Terminates a service
     */

    public function shutdownService($id)
    {
        if (!isset($id) || empty($id)) {
            Throw new Exception('parameter id required');
        } else if (!preg_match('/^\d+$/', $id)) {
            Throw new Exception('parameter id invalid');
        }
        $params = 'id=' . $id;
        return $this->_procFunc("shutdownService", $params);
    }

    /*
     * Services: Creates a new service
     */

    public function createService($ip, $port, $protocol, $sslCert, $sslKey)
    {
        if (!isset($ip) || empty($ip)) {
            Throw new Exception('parameter ip required');
        } else if (!preg_match('/^[0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}[.][0-9]{1,3}$/i', $ip)) {
            Throw new Exception('parameter ip invalid');
        }
        if (!isset($port) || empty($port)) {
            Throw new Exception('parameter port required');
        } else if (!preg_match('/^\d+$/', $port)) {
            Throw new Exception('parameter port invalid');
        }
        if (!isset($protocol) || empty($protocol)) {
            Throw new Exception('parameter protocol required');
        }
        if (!isset($sslCert) || empty($sslCert)) {
            $sslCert = '';
        }
        if (!isset($sslKey) || empty($sslKey)) {
            $sslKey = '';
        }
        $params = 'ip=' . $ip . ' port=' . $port . ' protocol=' . $protocol . ' sslCert=' . $sslCert . ' sslKey=' . $sslKey;
        return $this->_procFunc("createService", $params);
    }

    /*
     * Webserver: This command creates secondary name(s) for group names.
     */
    public function addGroupNameAlias($aliasName, $groupName)
    {
        if (!isset($aliasName) || empty($aliasName)) {
            Throw new Exception('parameter aliasName required');
        }
        if (!isset($groupName) || empty($groupName)) {
            Throw new Exception('parameter groupName required');
        }
        $params = 'groupName=' . str_replace(' ', '', $groupName) . ' aliasName=' . str_replace(' ', '', $aliasName);

        return $this->_procFunc("addGroupNameAlias", $params);
    }

    /*
     * Webserver: This command invalidates all group name aliases.
     */
    public function flushGroupNameAliases()
    {
        return $this->_procFunc("flushGroupNameAliases");
    }

    /*
     * Webserver: This command returns the group name given the alias name.
     */
    public function getGroupNameByAlias($aliasName)
    {

        if (!isset($aliasName) || empty($aliasName)) {
            Throw new Exception('parameter aliasName required');
        }

        $params = 'aliasName=' . str_replace(' ', '', $aliasName);

        return $this->_procFunc("getGroupNameByAlias", $params);
    }

    /*
     * Webserver: This command returns a complete list of group name aliases
     */
    public function listGroupNameAliases()
    {
        return $this->_procFunc("listGroupNameAliases");
    }

    /*
     * Webserver: This command creates secondary name(s) for group names.
     */
    public function removeGroupNameAlias($aliasName)
    {
        if (!isset($aliasName) || empty($aliasName)) {
            Throw new Exception('parameter aliasName required');
        }
        $params = 'aliasName=' . str_replace(' ', '', $aliasName);

        return $this->_procFunc("removeGroupNameAlias", $params);
    }

    /*
     * Webserver: This command lists all currently active HTTP streaming sessions.
     */
    public function listHttpStreamingSessions()
    {
        return $this->_procFunc("listHttpStreamingSessions");
    }


}

?>
