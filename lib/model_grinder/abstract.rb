module ModelGrinder
  module Abstract

    def _mg_templates
      @_mg_templates ||= {}
    end

    def template(*args, &blk)
      klass, name = parse_args(args)
      _mg_templates[klass] ||= {}
      _mg_templates[klass][name] = blk
    end

    alias :fix :template
    alias :fixture :template

    def gen_hash(*args)
      klass, name, override_attrs = parse_args(args)
      raise ArgumentError.new("The template `#{name}` for `#{klass}` does not exist.") unless _mg_templates[klass] && _mg_templates[klass][name]
      attrs = _mg_templates[klass][name].call
      attrs.merge!(override_attrs) if override_attrs
      attrs
    end

    def generate(*args)
      klass = parse_args(args)
      unless klass.respond_to?(:new)
        raise ArgumentError.new('Class not supplied for fixture or class supplied does not respond to new call.')
      end
      klass.new(gen_hash(*args))
    end

    alias :gen :generate
    alias :make :generate

    def build(*args)
      model = generate(*args)
      model.save
      model
    end

    private

    # Returns class, fixture_name, and arguments in a hash
    def parse_args(args)
      error = false
      case args.size
        when 3 # do nothing
        when 2
          args.unshift(nil) if args[1].is_a?(Hash)
        when 1
          args.unshift(nil).push(nil)
        else
          error = true
      end
      args[0] ||= self
      error = true unless args[0].is_a?(Class) || args[0].is_a?(Module)
      error = true unless args[1].is_a?(Symbol)
      error = true unless args[2].nil? || args[2].is_a?(Hash)
      raise ArgumentError.new(
                'Invalid arguments passed. Valid syntax: class(opt), fixture_name (symbol, required), hash (opt)'
            ) if error == true
      return *args
    end

  end
end