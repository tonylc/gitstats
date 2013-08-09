if Gitstats::Application.config.languages.keys.find {|language_type| ["src", "test"].include?(language_type) } ||
    Gitstats::Application.config.languages.values.flatten.find {|language_type| ["src", "test"].include?(language_type) } ||
    Gitstats::Application.config.tests.find {|language_type| ["src", "test"].include?(language_type) }
  raise "Invalid language type: Cannot be named 'src' or 'test'"
end