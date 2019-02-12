require_relative 'log/log_parser'
require_relative 'log/log_scanner'


begin
  path = File.join(File.dirname(__FILE__), 'test_files\test.log')
  file = File.open(path, 'r')
  scanner = Scanner.new(file)
  parser = LogParser.new(scanner)
  parser.parse_log
rescue EOFError
  puts 'End of File'
ensure
  file.close
end
