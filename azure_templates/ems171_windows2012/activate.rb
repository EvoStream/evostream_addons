require 'digest/md5'
require 'fileutils'

VERBOSE = true
PROXY_DOMAIN = "apiproxy"
WEB_CONFIG_FILE = "C:\\EvoStream\\config\\webconfig.lua"
WEB_CONFIG_AUTH_FILE = WEB_CONFIG_FILE + ".auth"
WEBUI_HTDIGEST_FILE = "C:\\EvoStream\\evo-webroot\\EMS_Web_UI\\settings\\passwords\\.htdigest"
WEBUI_HTDIGEST_AUTH_FILE = WEBUI_HTDIGEST_FILE + ".auth"
DOWNLOAD_FOLDER = "C:\\Users\\evostream\\Downloads"

def get_instance_id
  result = `wmic csproduct get uuid`.split[1]
end

def replace_proxy_password
  if File.exists?(WEB_CONFIG_AUTH_FILE)
    instance_id = get_instance_id
    `type #{WEB_CONFIG_AUTH_FILE} | ruby -pe "gsub '__STANDARD_PROXY_DOMAIN__', '#{PROXY_DOMAIN}'" | \
        ruby -pe "gsub '__STANDARD_PROXY_PASSWORD__', '#{instance_id}'" > #{WEB_CONFIG_FILE}`
    FileUtils.cp WEB_CONFIG_AUTH_FILE, DOWNLOAD_FOLDER
    FileUtils.rm WEB_CONFIG_AUTH_FILE
  else
    puts "Missing file '#{WEB_CONFIG_AUTH_FILE}'!" if VERBOSE
  end
end

def replace_webui_password
  if File.exists?(WEBUI_HTDIGEST_AUTH_FILE)
    instance_id = get_instance_id
    out_file = File.open(WEBUI_HTDIGEST_FILE, "w")
    password = Digest::MD5.hexdigest(instance_id)
    out_file.puts "evostream:#{password}"
    out_file.puts "user1000:#{password}"
    out_file.close
    FileUtils.cp WEBUI_HTDIGEST_AUTH_FILE, DOWNLOAD_FOLDER
    FileUtils.rm WEBUI_HTDIGEST_AUTH_FILE
  else
    puts "Missing file '#{WEBUI_HTDIGEST_AUTH_FILE}'!" if VERBOSE
  end
end

begin
  replace_proxy_password
  replace_webui_password
end
