collection @songs, :object_root => false
attributes :id, :title, :description, :file
node :file_url do |u|
  u.file.url
end
node :rank do |u|
  u.id
end
