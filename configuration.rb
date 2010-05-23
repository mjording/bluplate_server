require 'settingslogic'

class Configuration < Settingslogic
  source File.join(File.dirname(__FILE__), 'application.yml')
  namespace ENV["RACK_ENV"]
end