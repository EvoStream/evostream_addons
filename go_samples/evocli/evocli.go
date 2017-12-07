//
// EvoStream Media Server Extensions
// EvoStream, Inc.
// (c) 2017 by EvoStream, Inc. (support@evostream.com)
// Released under the MIT License
//

package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"

	"github.com/joshbetz/config"
)

type setupData struct {
	ip     string
	port   int
	user   string
	pass   string
	pretty int
	debug  int
}

const settingsFile = "./settings-evocli.json"

var client *http.Client

func main() {
	setup := setupData{ip: "127.0.0.1", port: 8888, user: "username", pass: "password", pretty: 1, debug: 1}
	_, err := os.Stat(settingsFile)
	if err == nil {
		settings := config.New(settingsFile)
		settings.Get("ip", &setup.ip)
		settings.Get("port", &setup.port)
		settings.Get("user", &setup.user)
		settings.Get("pass", &setup.pass)
		settings.Get("pretty", &setup.pretty)
		settings.Get("debug", &setup.debug)
	}
	if setup.debug > 1 {
		log.Printf("-- Init: %#v\n", setup)
	}
	client = &http.Client{}

	cmd := "version"
	if len(os.Args) > 1 {
		cmd = os.Args[1]
	}
	url := fmt.Sprintf("http://%s:%s@%s:%d/apiproxy/%s", setup.user, setup.pass, setup.ip, setup.port, cmd)
	if len(os.Args) >= 2 {
		params := strings.Join(os.Args[2:], " ")
		data := base64.StdEncoding.EncodeToString([]byte(params))
		url += "?params=" + data
	}
	req, _ := http.NewRequest("GET", url, nil)

	resp, err := client.Do(req)
	if err != nil {
		if setup.debug > 0 {
			log.Println("-- Error on send request to server:")
			log.Println(err)
		}
		return
	}

	defer resp.Body.Close()
	jsonPlain, _ := ioutil.ReadAll(resp.Body)
	switch setup.pretty {
	case 1:
		var jsonPretty bytes.Buffer
		err = json.Indent(&jsonPretty, jsonPlain, "", "    ")
		if err != nil {
			if setup.debug > 0 {
				log.Println("-- Error on parse JSON:", err)
				log.Println(string(jsonPlain))
			}
			return
		}
		fmt.Println(string(jsonPretty.Bytes()))
	default:
		fmt.Println(string(jsonPlain))
	}
}
