# Everything in the ClassMethods module is expressed through ModelGrinder, so tests will deal with it instead.
describe ModelGrinder::ClassMethods do

  before :all do
    ModelGrinder.integrate :all
  end

  after :each do
    ModelGrinder.clear_templates!
  end

  it "defines a template" do
    name = /\w+/.gen
    ModelGrinder.template(:your_mom) {{ name: name }}
    attrs = ModelGrinder.gen_hash(:your_mom)
    attrs[:name].should == name
  end

  it "gives different content for templates." do
    ModelGrinder.template(:your_mom) {{ name: /\w+/.gen }}
    attrs = ModelGrinder.gen_hash(:your_mom)
    attrs2 = ModelGrinder.gen_hash(:your_mom)
    attrs.should_not == attrs2
  end

  it "picks models of templates" do
    MongoidModel.template(:your_mom) {{ name: /\w+/.gen }}
    5.times { MongoidModel.gen(:your_mom) }
    MongoidModel.pick(:your_mom, number: 3).size.should == 3
  end

end