module ModelGrinder; end

require 'model_grinder/class_methods'

##
# = Introduction
# Model Grinder is a library to make the generation of data for use in tests. It is inspired by dm-sweatshop and is
# intended for use in all ORMs, not just DataMapper.
#
# == Setup
# To use with one ORM, pass the name of the ORM to ModelGrinder.integrate via a symbol. Like so:
#    ModelGrinder.integrate(:datamapper)
# Currently the options are :datamapper, :activerecord, and :mongoid. I'm still trying to get Mongoid to work
# properly, so be patient. If you wish to simply have it load for all available ORMs, pass the argument of :all instead
# of the ORM name.
#
# Note that you do not have to integrate if you wish to use the ModelGrinder to make all the calls instead of calling
# directly on the models.
#
# == Usage
# === Templates
# An example is worth ten million words and two examples are worth twenty million, I suppose. Both are identical -
# the second sets up and calls the same methods the first one does.
#
#  ModelGrinder.template(YourModel, :valid ) {{
#    name: /\w+/.gen,
#    some_text: /[:sentence]/.gen
#    some_number: rand(5938571234)
#  }}
#
#  YourModel.template(:valid) {{
#    name: /\w+/.gen,
#    some_text: /[:sentence]/.gen
#    some_number: rand(5938571234) + 6
#  }}
#
# Your first question might be: "what the crap is up with the double curly braces??" Well, the first curly brace is
# the beginning of the block, the second curly brace is the beginning of the hash. You pass a hash inside a block so
# that the library can call this block multiple times and get different results. Anything you want to stay the same
# you pass in as a static value, anything you want to be different you pass in some sort of random generator.
#
# This library includes the randexp gem, which is used in these examples to generate random data. You can read more about
# it here at https://github.com/benburkert/randexp. However, you can use whatever libraries or methods you would like
# to generate the data.
#
# === Using The Templates
# If you'd like to get the hash by itself:
#  ModelGrinder.gen_hash(YourModel, :valid, name: "Your mom" )
# or
#  YourModel.gen_hash(:valid, name: "Your mom")
# Anything you pass in the last hash will override the values in the hash generated by the template.
#
# If you'd like to have them assigned to a model instance, use:
#  ModelGrinder.generate(YourModel, :valid, name: "Your mom")
# or
#  YourModel.generate(:valid, name: "Your mom")
#
# If you'd like to persist the model to the data store (by calling "save" on the instance), use the build method instead
# with the same arguments. It will return the instance for you to manipulate later.
#
module ModelGrinder

  extend ActiveSupport::Concern if const_defined?(:ActiveSupport)

  # List of supported ORMs
  ORMS = {
      datamapper: lambda { |obj| DataMapper::Model.append_extensions obj },
      activerecord: lambda { |obj| ActiveRecord::Base.extend obj },
      mongoid: lambda { |obj|
        if Mongoid.respond_to?(:models)
          Mongoid.models.each { |o| o.extend obj}
        else
          # Find all the mongoids, find them all!
          ObjectSpace.each_object(Class) { |o|
            next unless o.ancestors.include?(Mongoid::Components)
            o.extend obj
          }
        end
      },
      all: nil
  }

  extend ClassMethods

  def self.extended(klass) # :nodoc:
    klass.send(:extend,  ModelGrinder::ClassMethods)
  end

  # Integrate Model Grinder into an ORM, or to all available ORMs
  #
  # @param [Symbol] orm can either be :datamapper, :activerecord, :mongoid, or :all
  #
  def self.integrate(orm)
    if orm == :all
      ORMS.each { |k,v|
        next if v.nil?
        begin
          v.call(self)
        rescue
          puts "Unable to extend #{k}"
        end
      }
    else
      if ORMS[orm]
        ORMS[orm].call(self)
      else
        raise ArgumentError.new(
          "Unsupported argument: #{orm.inspect}. Valid options: #{ORMS.keys.map { |v| v.inspect }.join(', ')}"
        )
      end
    end
  end

  # Clears all currently defined templates
  #
  def self.clear_templates!
    @_mg_templates = {}
  end

  # The templates currently defined
  #
  # @return [Hash]
  #
  def self.templates
    @_mg_templates ||= {}
  end

  def self._generated
    @_mg_generated ||= {}
  end

end