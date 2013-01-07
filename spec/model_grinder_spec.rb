describe ModelGrinder do

  describe "integration" do

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
      t.new?.should == false
    end

    it "integrates with Mongoid" do
      ModelGrinder.integrate(:mongoid)
      name = /\w+/.gen
      MongoidModel.template(:testing) {{
          name: name
      }}
      t = MongoidModel.generate(:testing)
      t.name.should == name
      t = MongoidModel.build(:testing)
      t.name.should == name
      t.new_record?.should == false
    end

    it "integrates with ActiveRecord" do
      ModelGrinder.integrate(:activerecord)
      name = /\w+/.gen
      ActiveRecordModel.template(:testing) {{
          name: name
      }}
      t = ActiveRecordModel.generate(:testing)
      t.name.should == name
      t = ActiveRecordModel.build(:testing)
      t.name.should == name
      t.new_record?.should == false
    end

    it "integrates with all supported and present ORMs at once"

  end


end