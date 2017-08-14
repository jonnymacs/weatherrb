# WeatherRB

This is a simple sinatra web app to demo the open weather api

You can demo this application on [aws](http://54.172.47.112/)

# Implementation

The app is implemented with sinatra, a simple ruby framework for
building web applications.

HTTParty is used to call the open weather api.

Results are parsed with the representable library.

Nginx is used to serve static files, puma is used to serve the application.

Rendering is done on the server side with erb.

Bootstrap is included but not really used.

jQuery is used for making an ajax request to the backend.

Google Maps is used to show a map of the location requested.

# Caching

Requests to the /search endpoint are cached for 4 hours from the
first request with a [rack-cache reverse proxy](http://rtomayko.github.io/rack-cache/). rack-cache uses the cache-control and age headers from the http spec to enforce the cache policy.

If a browser does not have a page cached it will query the server. The
page will be fetched from the rack-cache if the key exists (key is the url).

If there the key is not present in the File cache, the route action will be executed - a call goes out to open weather, the page is rendered, cached on disk,
and returned to the browser with the cache set to 14400 seconds (4 hours).

Browsers will render the cached page without making an http request for 4 hours from the time the first request was made by any client for that url.

# Build / Run

If you check out this source code you can run it on your local
machine.

~~~
Install ruby-2.4.1 (via apt, brew, or rvm)
gem install bundler
bundle install
bundle exec puma
~~~

# Docker

There is no Dockerfile for this web app (yet).
