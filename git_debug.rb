require "git"
require "logger"

def log(message)
  $stderr.puts("** #{message}")
end

def create_tag(version)
  if version.empty?
    log("VERSION is empty")
    return
  end

  g = Git.open(ENV["PWD"])
  g.fetch("origin")

  tag_name = "v#{version}"
  tag = g.tags.find { |t| t.name == tag_name }
  if tag
    log("#{tag.name}@local already exists")
  else
    tag = g.add_tag(tag_name)
    log("#{tag_name}@local was created")
  end

  tags = Git.ls_remote("origin").fetch("tags", {})
  if tags.has_key?(tag.name)
    log("#{tag.name}@remote already exists")
    return
  end

  print "Do you push #{tag.name} ? [y/n]> "
  answer = $stdin.readline.strip.downcase
  unless answer == "y"
    return
  end
  g.push("origin", tag.name)

  tag
end

def main
  version = `cat VERSION`.strip
  if tag = create_tag(version)
    log("CREATED: #{tag.name}")
  else
    log("ABORT")
    exit(1)
  end
end

main
