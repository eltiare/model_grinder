module ModelGrinder; end

require 'model_grinder/abstract'

module ModelGrinder

  extend Abstract

  def extended(klass)
    klass.send(Abstract)
  end

  def self.integrate(orm)
    valid_orms = {
        datamapper: lambda { |obj| DataMapper::Model.append_extensions obj },
        activerecord: lambda { |obj| ActiveRecord::Base.extend obj },
        mongoid: lambda { |obj| Mongoid::Finders.extend obj },
        all: nil
    }
    if orm == :all
      valid_orms.each { |k,v|
        begin
          v.call(self)
        rescue
          puts "Unable to extend #{k}"
        end
      }
    else
      if valid_orms[orm]
        valid_orms[orm].call(orm)
      else
        raise ArgumentError.new(
          "Unsupported argument: #{orm.inspect}. Valid options: #{valid_orms.keys.map { |v| v.inspect }.join(', ')}"
        )
      end
    end
  end

  def self.clear_templates!
    @_mg_templates = {}
  end


end