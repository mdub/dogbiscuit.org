#!/usr/bin/env ruby

# A handy script for exploring the output of 
#
#   java -Xrunhprof:heap=dump
#
# Synopsis: hprofexplore java.hprof.txt

COMMANDS = <<EOF
S <pattern> ... list objects with type matching (glob-style) <pattern>
<id>        ... goto object with specified <id>
O           ... display output references FROM current object
I           ... display input references TO current object
D [<file>]  ... dump a DOT graph of visited objects to <file> 
                (default: last DOT output file)
U           ... un-visit the current object, for graphing purposes
C           ... clear the visited-set; ie. un-visit all objects
Q           ... quit
EOF

# One of the handiest features is generation of object-reference graphs in
# DOT format; these can be rendered in various output-formats using
# Graphviz "dot", from http://www.research.att.com/sw/tools/graphviz.

#---( Init )---

require 'set'
require 'optparse'

#---( Heap model )---

# A Node in the heap model
class Node

  def initialize(id)
    @id = id
    @links = []
    @reverse_links = []
    @is_root = false
  end

  attr_accessor :info, :is_root

  attr_reader :id, :links, :reverse_links

  def link(dest, label)
    link = Link.new(self, dest, label)
    @links.push(link)
    dest.add_reverse_link(link)
  end

  attr_accessor :dot_attributes
  
  def to_dot
    top_line = info.dot_label
    bottom_line = "{#{id}|#{links.size} out|#{reverse_links.size} in}"
    s = "\"#{id}\" [label=\"{#{top_line}|#{bottom_line}}\""
    if (info.is_a? ClassInfo)
      s << ", shape=Mrecord"
    end
    if (dot_attributes)
      s << ", " + dot_attributes
    end
    s << "];"
    return s
  end

  protected 

  def add_reverse_link(link)
    @reverse_links.push(link)
  end

end

# A link between Nodes
class Link

  def initialize(src, dest, label)
    @src = src
    @dest = dest
    @label = label
  end

  attr_reader :src, :dest, :label

  def to_dot
    return "\"#{src.id}\" -> \"#{dest.id}\" [label=\"#{label}\"];"
  end

end

# Info about an Object node
class ObjectInfo

  def initialize(type, size)
    @type = type
    @size = size
  end

  attr_reader :type, :size

  def summary
    "OBJECT #{type}"
  end
  
  def details
    summary + " size=#{size}"
  end

  def dot_label
    type
  end
  
end

# Info about an Array node
class ArrayInfo

  def initialize(element_type, size, n_elements)
    @element_type = element_type
    @size = size
    @n_elements = n_elements
  end

  attr_reader :element_type, :size, :n_elements

  def summary
    "ARRAY #{element_type}"
  end
  
  def details
    summary + " size=#{size} n_elements=#{n_elements}"
  end

  def dot_label
    element_type + '[]'
  end
  
end

# Info about an Class node
class ClassInfo

  def initialize(name)
    @name = name
  end

  attr_reader :name

  def summary
    "CLASS #{name}"
  end
  
  def details
    summary
  end

  def dot_label
    "{CLASS|#{name}}"
  end

end

#---( DOT output )---

class DotWriter

  HEADER = <<EOF
digraph X {
  node [
    fontsize = "9"
    shape = "record"
  ];
  edge [
    fontsize = "9"
  ];
EOF

  def DotWriter.write(nodes, out = STDOUT)
    dot_writer = DotWriter.new(out)
    dot_writer.draw_nodes(nodes)
    dot_writer.close
  end

  def initialize(out)
    @already_drawn = Set.new
    @out = out
    @out.puts HEADER
  end

  def close
    @out.puts "}"
    @out = nil
  end

  def drawn(node_or_link)
    @already_drawn.include?(node_or_link)
  end
  
  def draw(node_or_link)
    return if drawn(node_or_link)
    @already_drawn << node_or_link
    @out.puts(node_or_link.to_dot)
  end
  
  def draw_nodes(nodes)
    nodes.each do |node|
      draw(node)
      node.links.each do |link|
        if (drawn(link.dest))
          draw(link) 
        end
      end
      node.reverse_links.each do |link| 
        if (drawn(link.src))
          draw(link) 
        end
      end
    end
  end

end

#---( Check args )---

def bad_usage
  STDERR.puts <<EOF
usage: hprofexplore [<options>] <hprof_file>

  options:
    -d|--dot FILE    generate Dot output to FILE

EOF
  exit(1)
end

ARGV.options { |opts|
  opts.on('-d FILE', '--dot FILE', 'DOT output file') { |@dot_file_name| }
  opts.parse!
} or bad_usage

bad_usage unless (ARGV.size == 1)

@hprof_file_name = ARGV.shift

unless (@dot_file_name) 
  @dot_file_name = File.basename(@hprof_file_name, ".hprof") + ".dot"
end

#---( Parse input; build heap model )---

STDERR.sync = 1

STDERR.puts("loading HPROF data from #{@hprof_file_name} ...");

@node_map = Hash.new do |h,k| 
  h[k] = Node.new(k)
end

def add_node(id, info)
  node = @node_map[id]
  node.info = info
  if (@node_map.size % 100 == 0)
    STDERR.print("\r#{@node_map.size} objects ...")
  end
  return node
end

File.open(@hprof_file_name) do |hprof|

  # Skip header
  hprof.each_line do |line|
    break if (line =~ /^HEAP DUMP BEGIN/);
  end
  
  # Parse nodes 'n' links
  current_node = nil
  hprof.each_line do |line|
    case line
    when /^ROOT (\w+) /
      next if ($1 == "0")       # skip object "0"
      @node_map[$1].is_root = true
    when /^OBJ (\w+) \(sz=(\d+),.*, class=([^@\)]+)/
      current_node = add_node($1, ObjectInfo.new($3, $2))
    when /^ARR (\w+) \(sz=(\d+),.*, nelems=(\d+), elem type=([^@\)]+)/
      current_node = add_node($1, ArrayInfo.new($4, $2, $3))
    when /^CLS (\w+) \(name=(\S+),/
      current_node = add_node($1, ClassInfo.new($2))
    when /^\s+(.*\S)\s+(\w+)$/
      dest = $2
      label = $1.sub(/^static /, '$')
      current_node.link(@node_map[dest], label)
    end
  end

end

STDERR.puts("\r#{@node_map.size} objects loaded");

#---( Get interactive )---

STDOUT.sync = 1

@visited_nodes = Set.new
@current_node = nil

def show_commands
  puts COMMANDS
end

def check_node_selected(node = @current_node)
  if (@current_node == nil) 
    raise "no node selected"
  end
end

def display_node(node = @current_node)
  root_flag = (node.is_root ? "!" : "")
  printf("%-9s %1s %s\n", node.id, root_flag, node.info.details)
end

def display_out_links(node = @current_node)
  node.links.each do |link|
    printf("  %-17s -> %-9s (%s)\n", link.label, link.dest.id, link.dest.info.summary)
  end
end

def display_in_links(node = @current_node)
  node.reverse_links.each do |link|
    printf("  <- %-17s %-9s (%s)\n", link.label, link.src.id, link.src.info.summary)
  end
end

def visit_node(id)
  return false if (id == nil) 
  unless (@node_map.include?(id)) 
    puts("no such node: #{id}")
    return false
  end
  node = @node_map[id]
  @visited_nodes << node
  @current_node = node
  return true
end

def unvisit_node
  puts("removing: #{@current_node.id} from graph")
  @visited_nodes.delete(@current_node)
end

def unvisit_all
  puts("clearing the graph")
  @visited_nodes.clear
end

def write_dot_file(file_name = nil)
  @dot_file_name = file_name if (file_name)
  File.open(@dot_file_name, "w") do |dot_file|
    DotWriter.write(@visited_nodes, dot_file)
  end
  puts("wrote " + @dot_file_name)
end

def search_nodes(pattern)
  unless (pattern =~ %r(^/))
    # convert from glob to regexp
    pattern.gsub!(/\*/,'.*')
  end
  begin 
    regexp = Regexp.new(pattern)
    n_matches = 0
    @node_map.each do |id,node|
      if (node.info != nil && regexp === node.info.summary)
        display_node(node)
        n_matches += 1
      end
    end
    puts("#{n_matches} objects matched")
  rescue RegexpError
    puts "bad pattern"
  end
end

def eval_command(command)
  case (command)
  when /^q/i
    throw :quit
  when /^i$/i
    check_node_selected
    display_node
    display_in_links
  when /^o$/i
    check_node_selected
    display_node
    display_out_links
  when /^(io|oi)$/i
    check_node_selected
    display_node
    display_out_links
    display_in_links
  when /^u$/i
    check_node_selected
    unvisit_node
  when /^c$/i
    unvisit_all
  when /^d(\s+(\S+))?/i
    write_dot_file($2)
  when /^s\s+(\S+)/i
    search_nodes($1)
  when /^([0-9a-f]+)\s*(.+)?/i
    visit_node($1) || return
    if ($2)
      eval_command($2)
    else
      display_node
    end
  else 
    show_commands
  end
end

# Command loop
catch(:quit) do
  while(true) do
    print "\n>> "
    begin
      eval_command(STDIN.readline.chomp)
    rescue => e
      puts e
    end
  end
end

puts "Thanks for playing."
