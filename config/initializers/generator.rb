Rails.application.config.generators do |generator|
  generator.fixture_replacement :factory_bot, dir: "spec/factories"
end
