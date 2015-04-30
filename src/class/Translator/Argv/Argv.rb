module Argv
  @@flags = {}

  def parse_args
    debug_flag = Flag.new 'debug'
    limit_flag = Flag.new 'limit', /\d+/

    expected_flags = {
      '-d' => debug_flag, '--debug' => debug_flag,
      '-l' => limit_flag, '--limit' => limit_flag
    }

    match_against_args expected_flags
  end

  def match_against_args expected_flags
    ARGV.each { |arg|
      keyval = arg.split '='
      keyval[1] = true if keyval[1].nil?

      if expected_flags.has_key? keyval[0]
        @@flags[expected_flags[keyval[0]].hash_key keyval] = keyval[1]
      else
        abort "unresolved flag #{keyval[0]}"
      end
    }
  end
end