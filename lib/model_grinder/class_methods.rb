module ModelGrinder
  ##
  # Please see the documentation for the module ModelGrinder for full documentation.
  #
  module ClassMethods

    # Sets up a template that's a block which contains a hash (for pseudo-random generation later). A bit of magic is
    # used to make the first argument optional on all methods.
    #
    # @param [Class] klass The class that's attached to the template (optional)
    # @param [Symbol] name The name of the template (optional, defaults to :default)
    # @raise [ArgumentError] on no block passed
    # @return [Proc] The passed block
    #
    def template(*args, &blk)
      #TODO: check to make sure block returns hash
      raise ArgumentError.new('A block that contains a hash must be passed to template.') unless block_given?
      klass, name = parse_args(args)
      _mg_templates[klass] ||= {}
      _mg_templates[klass][name] = blk
    end

    alias :fix :template
    alias :fixture :template
    alias :t :template


    # Generates a new hash from a template found by the Class and name passed. A bit of magic is used to make the first
    # argument optional on all methods.
    #
    # @param [Class] klass The class that's attached to the template (optional)
    # @param [Symbol] name The name of the template (optional, defaults to :default)
    # @param [Hash] override_attrs Values to assign to the hash irrespective of the template
    # @raise [ArgumentError] if template does not exist.
    #
    def gen_hash(*args)
      klass, name, override_attrs = parse_args(args)
      raise ArgumentError.new("The template `#{name}` for `#{klass}` does not exist.") unless _mg_templates[klass] && _mg_templates[klass][name]
      attrs = _mg_templates[klass][name].call
      attrs.merge!(override_attrs) if override_attrs
      attrs
    end

    alias :genh :gen_hash

    # Generates a new hash from a template on a class and creates a new object. Class must respond to new and accept
    # a hash as the first and only argument.
    #
    # @param (see #gen_hash)
    # @return [Class]
    #
    def generate(*args)
      klass, name, attrs = parse_args(args)
      # This returns the model instance
      _mg_store_generated(
          klass,
          name,
          klass.new(gen_hash(*args) || {})
      )
    end

    alias :gen :generate
    alias :make :generate


    # Picks a specified number of already generated models
    #
    # @param [Class] klass The class that's attached to the template (optional)
    # @param [Symbol] name The name of the template (optional, defaults to :default)
    # @param [Hash] options Currently the only option is number of models returned (e.g. number: 3)
    # @return [Array] An array of the number of generated models, up to the number actually generated.
    def pick(*args)
      klass, name, hash = parse_args(args)
      hash[:number] ||= 1
      return [] unless _mg_generated[klass].is_a?(Hash) && _mg_generated[klass][name].is_a?(Array)
      _mg_generated[klass][name].sample hash[:number]
    end

    # Generates a new hash from a template on a class, creates a new object, and persists it to the datastore. Class must
    # respond to new, accept a hash as the first and only argument, and respond to save.
    #
    # @param (see #gen_hash)
    # @return [Class]
    #
    def build(*args)
      model = generate(*args)
      model.save
      model
    end

    private

    # Parses out the class, fixture name, and override attributes from the arguments
    #
    # @param [Array] args The array of arguments passed to the calling method.
    # @raise  [ArgumentError] if invalid/out of order arguments are passed
    # @return [Class/Module, Symbol, Hash]
    #
    def parse_args(args)
      error = false
      new_args = []
      args.each { |arg|
        case arg
          when Class, Module
            new_args[0] = arg
          when Symbol, String
            new_args[1] = arg.to_sym
          when Hash
            new_args[2] = arg
        end
      }
      args = new_args
      case args.size
        when 3,2,1 # do nothing
        else error = true
      end
      args[0] ||= self
      args[1] ||= :default
      args[2] ||= {}
      error = true unless args[0].is_a?(Class) || args[0].is_a?(Module)
      error = true unless args[1].is_a?(Symbol)
      error = true unless args[2].is_a?(Hash)
      raise ArgumentError.new(
                'Invalid arguments passed. Valid syntax: class(opt), fixture_name (symbol, required), hash (opt)'
            ) if error == true
      return *args
    end

  private

    # References the global template hash
    def _mg_templates
      @_mg_templates ||= ModelGrinder.templates
    end

    def _mg_generated
      @_mg_generated ||= ModelGrinder._generated
    end

    def _mg_store_generated(klass, name, instance)
      _mg_generated[klass] ||= {}
      _mg_generated[klass][name] ||= []
      _mg_generated[klass][name] << instance
      instance
    end

  end
end