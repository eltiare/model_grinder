class CreateTestTable < ActiveRecord::Migration
  def self.up
    create_table :active_record_models do |t|
      t.integer :id
      t.string  :name
    end
  end
end
class ActiveRecordModel <  ActiveRecord::Base; end