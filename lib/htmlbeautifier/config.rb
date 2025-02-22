module HtmlBeautifier
  class Config
    require "yaml"

    def self.app_config
      return {} unless app_config_file

      YAML.load_file(app_config_file).transform_keys { |key| key.to_sym }
    end

    def self.app_config_file
      return @app_config_file if defined?(@app_config_file)

      supported_locations = [
        File.join(app_path, "config", "htmlbeautifier.yml"),
        File.join(app_path, ".htmlbeautifier.yml"),
        File.join(app_path, "tmp", "config", "htmlbeautifier.yml") # for testing, any idea how to avoid it?
      ]
      @app_config_file = supported_locations.detect { |f| File.file?(f) }
    end

    def self.app_path
      @app_path ||= ::Dir.pwd
    end
  end
end
