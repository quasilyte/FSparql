require_relative './Roadmap'
class Formatter
  require 'json'

  def initialize
    @out = []
  end

  def collect_hash json_hash
    proto = {}
    json_hash.each { |json_prop|
      json_recur_walk (Keyval.new json_prop), proto
    }

    @out << proto
  end

  def run json_s
    @in = (JSON.parse json_s)['results']['bindings']

    @in.each { |json_hash|
      collect_hash json_hash
    }

    puts @out.to_json
  end

  def json_recur_walk keyval, proto
    return if keyval.k_empty?

    key = keyval.k_shift
    proto[key] = (keyval.k_empty? ? keyval.val : {}) unless proto.has_key? key

    json_recur_walk keyval, proto[key]
  end
end

# json_s = '{"lang":{"name":"C","year":"1953","author":{"name":"Dennis", "depictiot":"URL"}}}'

fmt = Formatter.new
fmt.run IO.read './resp.json'