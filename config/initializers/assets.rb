Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( ckeditor/* autocomplete-rails.js custom_admin.css admin/active_admin.css active_admin.js admin/active_admin.js )
Rails.application.config.assets.precompile += %w(ckeditor/config.js)