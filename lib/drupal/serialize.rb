module Drupal
  # Implements a Ruby-compatible subset of the PHP serialisation mechanism. This is often used for storing structured
  # data in text database columns.
  module Serialize
    # Serialises a value. For example:
    #
    #   Drupal::Serialize.serialize("Hello, World!")  # => "s:13:\"Hello, World!\";"
  	def self.serialize(var, assoc = false)
  		s = ''
  		case var
  			when Array
  				s << "a:#{var.size}:{"
  				if assoc and var.first.is_a?(Array) and var.first.size == 2
  					var.each { |k,v|
  						s << self.serialize(k) << self.serialize(v)
  					}
  				else
  					var.each_with_index { |v,i|
  						s << "i:#{i};#{self.serialize(v)}"
  					}
  				end

  				s << '}'

  			when Hash
  				s << "a:#{var.size}:{"
  				var.each do |k,v|
  					s << "#{self.serialize(k)}#{self.serialize(v)}"
  				end
  				s << '}'

  			when Struct
  				# encode as Object with same name
  				s << "O:#{var.class.to_s.length}:\"#{var.class.to_s.downcase}\":#{var.members.length}:{"
  				var.members.each do |member|
  					s << "#{self.serialize(member)}#{self.serialize(var[member])}"
  				end
  				s << '}'

  			when String
  				s << "s:#{var.length}:\"#{var}\";"

  			when Fixnum # PHP doesn't have bignums
  				s << "i:#{var};"

  			when Float
  				s << "d:#{var};"

  			when NilClass
  				s << 'N;'

  			when FalseClass, TrueClass
  				s << "b:#{var ? 1 :0};"

  			else
  				if var.respond_to?(:to_assoc)
  					v = var.to_assoc
  					# encode as Object with same name
  					s << "O:#{var.class.to_s.length}:\"#{var.class.to_s.downcase}\":#{v.length}:{"
  					v.each do |k,v|
  						s << "#{self.serialize(k.to_s)}#{self.serialize(v)}"
  					end
  					s << '}'
  				else
  					raise TypeError, "Unable to serialize type #{var.class}"
  				end
  		end

  		s
  	end

    # Unserialises a value. For example:
    #
    #   Drupal::Serialize.unserialize("s:13:\"Hello, World!\";")  # "Hello, World!"
  	def self.unserialize(string, classmap = nil, assoc = false)
  		string = StringIO.new(string)
  		def string.read_until(char)
  			val = ''
  			while (c = self.read(1)) != char
  				val << c
  			end
  			val
  		end

  		classmap ||= Hash.new

  		_unserialize(string, classmap, assoc)
  	end

    private

    	def self._unserialize(string, classmap, assoc)
    		val = nil
    		# determine a type
    		type = string.read(2)[0,1]
    		case type
    			when 'a' # associative array, a:length:{[index][value]...}
    				count = string.read_until('{').to_i
    				val = vals = Array.new
    				count.times do |i|
    					vals << [_unserialize(string, classmap, assoc), _unserialize(string, classmap, assoc)]
    				end
    				string.read(1) # skip the ending }

    				unless assoc
    					# now, we have an associative array, let's clean it up a bit...
    					# arrays have all numeric indexes, in order; otherwise we assume a hash
    					array = true
    					i = 0
    					vals.each do |key,value|
    						if key != i # wrong index -> assume hash
    							array = false
    							break
    						end
    						i += 1
    					end

    					if array
    						vals.collect! do |key,value|
    							value
    						end
    					else
    						val = Hash.new
    						vals.each do |key,value|
    							val[key] = value
    						end
    					end
    				end

    			when 'O' # object, O:length:"class":length:{[attribute][value]...}
    				# class name (lowercase in PHP, grr)
    				len = string.read_until(':').to_i + 3 # quotes, seperator
    				klass = string.read(len)[1...-2].capitalize.intern # read it, kill useless quotes

    				# read the attributes
    				attrs = []
    				len = string.read_until('{').to_i

    				len.times do
    					attr = (_unserialize(string, classmap, assoc))
    					attrs << [attr.intern, (attr << '=').intern, _unserialize(string, classmap, assoc)]
    				end
    				string.read(1)

    				val = nil
    				# See if we need to map to a particular object
    				if classmap.has_key?(klass)
    					val = classmap[klass].new
    				elsif Struct.const_defined?(klass) # Nope; see if there's a Struct
    					classmap[klass] = val = Struct.const_get(klass)
    					val = val.new
    				else # Nope; see if there's a Constant
    					begin
    						classmap[klass] = val = Module.const_get(klass)

    						val = val.new
    					rescue NameError # Nope; make a new Struct
    						classmap[klass] = val = Struct.new(klass.to_s, *attrs.collect { |v| v[0].to_s })
    					end
    				end

    				attrs.each do |attr,attrassign,v|
    					val.__send__(attrassign, v)
    				end

    			when 's' # string, s:length:"data";
    				len = string.read_until(':').to_i + 3 # quotes, separator
    				val = string.read(len)[1...-2] # read it, kill useless quotes

    			when 'i' # integer, i:123
    				val = string.read_until(';').to_i

    			when 'd' # double (float), d:1.23
    				val = string.read_until(';').to_f

    			when 'N' # NULL, N;
    				val = nil

    			when 'b' # bool, b:0 or 1
    				val = (string.read(2)[0] == ?1 ? true : false)

    			else
    				raise TypeError, "Unable to unserialize type '#{type}'"
    		end

    		val
    	end
  end
end
