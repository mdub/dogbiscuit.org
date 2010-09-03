# Handle legacy blog-entries in "WikiWah" format
require 'wikiwah/tilt_integration'

require "time"

class Pith::Input::Template 
  
  def publication_date
    published = meta["published"]
    Time.parse(published) if published
  end
  
end

class ::String
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
end

class ::Pathname
  def within?(ancestor_path)
    self.to_str.starts_with?(ancestor_path.to_str + "/")
  end
end

project.helpers do

  def published_pages
    project.inputs.select do |input|
      input.path.within?(current_input.path.parent)
    end.select do |input|
      input.respond_to?(:publication_date) && !input.publication_date.nil?
    end.compact.sort_by do |input|
      input.publication_date
    end.reverse
  end
  
end