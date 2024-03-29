I18n.available_locales = [:es, :en]
I18n.default_locale = :es
I18n.load_path += Dir[Rails.root.join('config', 'locales', 'models', '*.yml')]
I18n.load_path += Dir[Rails.root.join('config', 'locales', 'views', '*.yml')]
I18n.load_path += Dir[Rails.root.join('config', 'locales', 'emails', '*.yml')]
I18n.load_path += Dir[Rails.root.join('config', 'locales', 'layouts', '*.yml')]
I18n.load_path += Dir[Rails.root.join('config', 'locales', 'controllers', '*.yml')]
I18n.load_path += Dir[Rails.root.join('config', 'locales', 'frontend', '*.yml')]
I18n.load_path += Dir[Rails.root.join('config', 'locales', 'pages', '*.yml')]
