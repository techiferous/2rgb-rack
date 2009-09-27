require 'app'

use Rack::ShowExceptions
use Rack::Static, :urls => ["/stylesheets", "/images"], :root => "public"

run App.new
