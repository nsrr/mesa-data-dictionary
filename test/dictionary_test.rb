require 'test_helper'
require 'colorize'

class DictionaryTest < Minitest::Test
  # This line includes all default Spout Dictionary tests
  include Spout::Tests

  # This line provides access to @variables, @forms, and @domains
  # iterators that can be used to write custom tests
  include Spout::Helpers::Iterators

  VALID_UNITS = [nil, '', 'naps', 'days', 'nights', 'events per hour', 'event count', 'minutes', 'hours',
   'beats per minute', 'seconds', 'percent', 'good days', 'weekdays', 'weekend days', 'valid nights', 'invalid nights' , 'wake bouts' , 'sleep bouts' , 'activity counts' , 'non-workdays' ,
    'naps per day' , 'minutes per day' , 'reliable days' , 'workdays']

   @variables.select{|v| ['numeric','integer'].include?(v.type)}.each do |variable|
     define_method("test_units: "+variable.path) do
       message = "\"#{variable.units}\"".colorize( :red ) + " invalid units.\n" +
                 "             Valid types: " +
                 VALID_UNITS.sort_by(&:to_s).collect{|u| u.inspect.colorize( :white )}.join(', ')
       assert VALID_UNITS.include?(variable.units), message
     end
   end

end
