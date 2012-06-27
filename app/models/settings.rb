class Settings < Settingslogic
  if File.exists? Rails.root.join "config", "application.yml"
    source Rails.root.join "config", "application.yml"
  else
    source Rails.root.join "config", "application.example.yml"
  end
  namespace Rails.env
end
