# Handle legacy blog-entries in "WikiWah" format
require 'wikiwah/tilt_integration'

require "time"

class Pith::Input::Template 
  
  def publication_date
    published = meta["published"]
    Time.parse(published) if published
  end
  
end

project.helpers do
  
  def blog_entries
    project.inputs.select do |input|
      input.respond_to?(:publication_date) && !input.publication_date.nil?
    end.compact.sort_by do |input|
      input.publication_date
    end.reverse
  end
  
end