Copacetic::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,

  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true
  config.cache_store = :dalli_store
  config.action_dispatch.rack_cache = {
                        :metastore    => Dalli::Client.new,
                        :entitystore  => 'file:tmp/cache/rack/body',
                        :allow_reload => false }
  config.static_cache_control = "public, max-age=2592000"
  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  # Compress JavaScripts and CSS


  config.assets.precompile += %w(admin/active_admin.css jquery admin/active_admin.js  tabs.js  layout.css jquery-ui.min.js nested_form.js jquery.cycle.all.latest.js copacetic.css autocomplete-rails.js base.css skelton.css custom_admin.css application.css application.js frontpage.css jquery_ujs.js ) 
  config.assets.precompile += Ckeditor.assets
  # Generate digests for assets URLs

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end
