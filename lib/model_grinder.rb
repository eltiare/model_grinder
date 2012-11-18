module ModelGrinder; end

require 'model_grinder/class_methods'

module ModelGrinder

  extend ActiveSupport::Concern if const_defined?(:ActiveSupport)

  ORMS = {
      datamapper: {
          class: 'DataMapper::Model',
          method: lambda { |obj| DataMapper::Model.append_extensions obj }
      },
      activerecord: {
          class: 'ActiveRecord::Base',
          method: lambda { |obj| ActiveRecord::Base.extend obj }
      },
      mongoid: {
          class: 'Mongoid::Finders',
          method: lambda { |obj| Mongoid::Document.send(:include, obj) }
      },
      all: nil
  }

  extend ClassMethods

  def self.extended(klass)
    klass.send(:extend,  ModelGrinder::ClassMethods)
  end

  def self.included(klass)
    klass.send(:extend,  ModelGrinder::ClassMethods)
  end

  def self.integrate(orm)
    if orm == :all
      ORMS.each { |k,v|
        next if v.nil?
        begin
          v[:method].call(self)
        rescue
          puts "Unable to extend #{k}"
        end
      }
    else
      if ORMS[orm]
        ORMS[orm][:method].call(self)
      else
        raise ArgumentError.new(
          "Unsupported argument: #{orm.inspect}. Valid options: #{ORMS.keys.map { |v| v.inspect }.join(', ')}"
        )
      end
    end
  end

  def self.clear_templates!
    @_mg_templates = {}
  end

  def self.templates
    @_mg_templates ||= {}
  end

end