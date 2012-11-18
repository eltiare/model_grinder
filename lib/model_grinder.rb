module ModelGrinder; end

require 'model_grinder/abstract'

module ModelGrinder

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
          method: lambda { |obj| Mongoid::Finders.extend obj }
      },
      all: nil
  }


  extend Abstract

  def self.extended(klass)
    klass.send(:extend,  ModelGrinder::Abstract)
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


end