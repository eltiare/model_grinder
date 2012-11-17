# Everything in the abstract is expressed through ModelGrinder, so tests will deal with it instead.
describe ModelGrinder::Abstract do

  after :each do
    ModelGrinder.clear_templates!
  end

  it "defines a template" do
    name = /\w+/.gen
    ModelGrinder.template(:your_mom) {{ name: name, }}
    attrs = ModelGrinder.gen_hash(:your_mom)
    attrs[:name].should == name
  end

  it "gives different content for templates." do
    ModelGrinder.template(:your_mom) {{ name: /\w+/.gen, }}
    attrs = ModelGrinder.gen_hash(:your_mom)
    attrs2 = ModelGrinder.gen_hash(:your_mom)
    attrs.should_not == attrs2
  end

end