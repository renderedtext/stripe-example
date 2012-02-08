def fill_in_fields *args
  raise 'Too many arguments!' if args.size > 2
  prefix = args.first.is_a?(Hash) ? '' : "#{ args.shift }_" 
  args.last.each { |field, value| fill_in "#{ prefix }#{ field }", with: value }
end

def should_be_on path
  current_path.should == path.split('?').first #ignore query string
end
