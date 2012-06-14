# load the ennvironment specific YAML file
APP_CONFIG = YAML.load_file("#{::Rails.root}/config/config.yml")
SECRETS_CONFIG = YAML.load_file("#{::Rails.root}/config/secrets.yml")
