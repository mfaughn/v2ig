page "V2+ Home" do
  file  "index.html"
  link_to "Introduction.adoc",
  link_to "Foundation.adoc",
  includes "include1.adoc"
  includes "include2.adoc"  
end

page "Domains" do

end

page "Message Structures" do
  list :message_structures
end

page "Segments" do
  list :segments
end

page "Data Types" do
  list :data_types
end

page "Data Type Flavors" do
end

page "Vocabulary" do
  list :code_systems
end

page "Control" do
end

page "Conformance" do
end

page "Encoding" do
end

page "Transport" do
end

page "v2.x" do
end

page "Introduction" do
  file "Introduction.adoc"
end

page "Foundation" do
  file "foundation.adoc"
  includes "Introduction.adoc"
  includes "Control.adoc"
  includes "Etc.adoc"
end

page "Domain Messaging" do
  file "DomainMessaging.adoc"
  xref "DomainMessaging/Administration.adoc"
  xref "DomainMessaging/Clinical.adoc"
  xref "DomainMessaging/Financial.adoc"
  xref "DomainMessaging/ERP.adoc"
  xref "DomainMessaging/Technical.adoc"
end

page "Administration" do
  file "DomainMessaging/Administration.adoc"
  xref "Administration.adoc"
  xref "Clinical.adoc"
  xref "Financial.adoc"
  xref "ERP.adoc"
  xref "Technical.adoc"
end
  
  



