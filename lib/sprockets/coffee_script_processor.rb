require 'coffee_script'
require 'source_map'

module Sprockets
  # Processor engine class for the CoffeeScript compiler.
  # Depends on the `coffee-script` and `coffee-script-source` gems.
  #
  # For more infomation see:
  #
  #   https://github.com/josh/ruby-coffee-script
  #
  module CoffeeScriptProcessor
    VERSION = '2'
    SOURCE_VERSION = ::CoffeeScript::Source.version

    def self.call(input)
      data = input[:data]
      key  = [self.name, SOURCE_VERSION, VERSION, data]

      result = input[:cache].fetch(key) do
        ::CoffeeScript.compile(data, sourceMap: true, sourceFiles: [input[:name]])
      end

      if input[:map]
        map = input[:map] | SourceMap::Map.from_json(result['v3SourceMap'])
        { data: result['js'],
          map: map }
      else
        result['js']
      end
    end
  end
end
