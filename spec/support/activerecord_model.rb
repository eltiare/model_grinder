ActiveRecord::Schema.define do
  self.verbose = false

  create_table :active_record_models, :force => true do |t|
    t.string :name
    t.timestamps
  end

end

class ActiveRecordModel <  ActiveRecord::Base; end

