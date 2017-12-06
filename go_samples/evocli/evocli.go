//
// EvoStream Media Server Extensions
// EvoStream, Inc.
// (c) 2017 by EvoStream, Inc. (support@evostream.com)
// Released under the MIT License
//

package main

import (
	"encoding/base64"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"strings"

	"github.com/joshbetz/config"
)

var conf struct {
	ip   string
	port int
	user string
	pass string
}
var client *http.Client

func main() {
	settings := config.New("settings-evocli.json")
	settings.Get("ip", &conf.ip)
	settings.Get("port", &conf.port)
	settings.Get("user", &conf.user)
	settings.Get("pass", &conf.pass)
	//fmt.Printf("conf: %#v\n", conf)
	client = &http.Client{}

	cmd := "version"
	if len(os.Args) > 1 {
		cmd = os.Args[1]
	}
	url := fmt.Sprintf("http://%s:%s@%s:%d/apiproxy/%s", conf.user, conf.pass, conf.ip, conf.port, cmd)
	if len(os.Args) >= 2 {
		params := strings.Join(os.Args[2:], " ")
		data := base64.StdEncoding.EncodeToString([]byte(params))
		url += "?params=" + data
	}
	req, _ := http.NewRequest("GET", url, nil)

	resp, err := client.Do(req)
	if err != nil {
		fmt.Println("Error on send request to server")
		fmt.Println(err)
		return
	}

	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	fmt.Println(string(body))
}
