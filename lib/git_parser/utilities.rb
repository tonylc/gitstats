def debug(line)
  return if true
  p "********* #{line}"
end

def list_of_supported_file_types_regex
  Gitstats::Application.config.languages.values.flatten.map {|a| a.sub(".", "\\.")}.join("|")
end
