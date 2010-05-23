require 'settingslogic'

module BluplateServer
   class Configuration < Settingslogic
     source File.join(File.dirname(__FILE__), 'application.yml')
     namespace ENV["RACK_ENV"]
    end
end


$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'bluplate_server/user'
require 'bluplate_server/inbox'
require 'bluplate_server/ticket'
require 'bluplate_server/work_item'
require 'bluplate_server/account'