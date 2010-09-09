weblog_uri = "http://dogbiscuit.org/mdub/weblog"

entries = published_pages[0..19]
updated_at = entries.map { |e| e.updated_at }.compact.max

xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.feed :xmlns=>'http://www.w3.org/2005/Atom' do
  xml.id "#{weblog_uri}"
  xml.title "DogBiscuit"
  xml.updated(updated_at.xmlschema)
  xml.author do
    xml.name "Mike Williams"
    xml.email "mdub@dogbiscuit.org"
  end
  entries.each do |entry|
    xml.entry do
      entry_uri = "#{weblog_uri}/#{href(entry)}"
      xml.id entry_uri
      xml.title entry.title
      xml.link :rel=>"alternate", :type=>"text/html", :href=>entry_uri
      xml.published entry.published_at.xmlschema
      xml.updated entry.updated_at.xmlschema
      xml.content entry.render(self), :type=>"html"
    end
  end
end
