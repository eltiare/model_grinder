describe ModelGrinder do

  describe "integration" do

    after :each do
      ModelGrinder::ORMS.each { |k,v|
        next if v.nil?
        klass = eval(v[:class])
        ModelGrinder::Abstract.instance_methods.each { |m|
          klass.send(:remove_method, m) if klass.methods.include?(m)
        }
      }
    end

    it "integrates with DataMapper" do
      ModelGrinder.integrate(:datamapper)
      name = /\w+/.gen
      DataMapperModel.template(:testing) {{
        name: name
      }}
      t = DataMapperModel.generate(:testing)
      t.name.should == name
      t = DataMapperModel.build(:testing)
      t.name.should == name
      t.new_record?.should == false
    end

    it "integrates with Mongoid" do

    end

    it "integrates with ActiveRecord" do

    end

    it "integrates with all supported and present ORMs at once" do

    end
  end


end