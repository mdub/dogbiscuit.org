weblog_uri = "http://dogbiscuit.org/mdub/weblog"

entries = published_pages[0..19]
updated_at = entries.map { |e| e.updated_at }.compact.max

xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.feed :xmlns=>'http://www.w3.org/2005/Atom' do
  xml.id "#{weblog_uri}"
  xml.link :rel=>"self", :type=>"application/atom+xml", :href=>"#{weblog_uri}/feed.atom"
  xml.title "DogBiscuit"
  xml.updated(updated_at.xmlschema)
  xml.author do
    xml.name "Mike Williams"
    xml.email "mdub@dogbiscuit.org"
  end
  entries.each do |entry|
    entry_uri = "#{weblog_uri}/#{href(entry)}"
    xml.entry do
      xml.id entry_uri
      xml.title entry.title
      xml.link :rel=>"alternate", :type=>"text/html", :href=>entry_uri
      xml.published entry.published_at.xmlschema
      xml.updated entry.updated_at.xmlschema
      xml.content entry.render(self), :type=>"html", "xml:base" => entry_uri
    end
  end
end
