ShowFor.setup do |config|
  config.show_for_tag            = :dl
  config.wrapper_tag             = nil
  config.label_tag               = :dt
  config.content_tag             = :dd
  config.separator               = ""
  config.association_methods     = [ :name, :title, :to_s ]
  config.collection_tag          = :ul
  config.default_collection_proc = lambda { |value| "<li>#{value}</li>" }
  config.i18n_format             = :default
  config.label_proc              = lambda { |l| l + ":" }
end
