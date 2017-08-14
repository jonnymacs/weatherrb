#\ -s puma
$: << "lib"

require 'rubygems'
require 'rack'
require 'sinatra'
require 'logger'
require 'httparty'
require 'multi_json'
require 'i18n'
require 'representable'
require 'representable/json'

# load service first
Dir.glob('./lib/service/*.rb').each do |req|
  require req
end

Dir.glob('./lib/**/*.rb').sort.each do |req|
  require req
end

require './weather'

I18n.load_path += Dir[File.join(settings.root, 'locales', '*.yml')]
I18n.default_locale = :'en-US'

run Weather
