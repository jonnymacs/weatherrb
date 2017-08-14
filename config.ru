#\ -s puma
$: << "lib"

require 'rubygems'
require 'rack'
require 'rack/cache'
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

I18n.load_path += Dir[File.join(settings.root, 'locales', '*.yml')]
I18n.default_locale = :'en-US'

# use a file cache for this excerise.
# memcached would be the choice if
# running multiple app instances
#
use Rack::Cache,
  metastore:    'file:./tmp/cache/rack/meta',
  entitystore:  'file:./tmp/cache/rack/body',
  verbose:      true

require './weather'
run Weather
