require_relative 'log/log_parser'
require_relative 'log/log_scanner'
require_relative 'object/object_parser'
require_relative 'object/object_scanner'
require_relative 'checker'

def parse_object path
  begin
    object_path = File.join(File.dirname(__FILE__ ), 'test_files\\' + path)
    object_file = File.open(object_path, 'r')
    object_scanner = ObjectScanner.new(object_file)
    object_parser = ObjectParser.new(object_scanner)
    ast = object_parser.parse_object
  rescue EOFError
    puts 'End of File'
  ensure
    object_file.close
  end
  return ast
end


def parse_log path
  begin
    log_path = File.join(File.dirname(__FILE__), 'test_files\\' + path)
    log_file = File.open(log_path, 'r')
    log_scanner = LogScanner.new(log_file)
    log_parser = LogParser.new(log_scanner)
    ast = log_parser.parse_log
  rescue EOFError
    puts 'Error while parsing file. EOF caught'
  ensure
    log_file.close
  end
  return ast
end



ast_object = parse_object('test.object')
ast_log = parse_log('test.log')
ast = AbstractSyntaxTree::Program.new(ast_object, ast_log)
Checker.new.check(ast)