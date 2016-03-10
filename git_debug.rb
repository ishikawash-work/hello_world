require "git"

line = "#{Time.now}: Updated"
`echo #{line} >> README.md`

g = Git.open(ENV["PWD"])

g.add("README.md")
g.commit("[DEBUG] modified")

tag_name = "1.0.0"
if tag = g.tags.find { |t| t.name == tag_name }
  g.delete_tag(tag.name)
end
g.add_tag(tag_name)

tags = Git.ls_remote().fetch("tags")
if tags.has_key?(tag_name)
  g.push("origin", ":" + tag_name)
end
g.push("origin", tag_name)
