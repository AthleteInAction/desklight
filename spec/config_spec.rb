require 'yaml'


describe DeskLight do


  let(:desk_yml){ YAML.load(File.read("spec/config/desk.yml")) }


  context "Config" do
    it "Should set config variables" do
      DeskLight.configure do |config|
        config.subdomain = desk_yml['subdomain']
        config.email = desk_yml['email']
        config.password = desk_yml['password']
      end
      expect(DeskLight.config.subdomain).to eq(desk_yml['subdomain'])
      expect(DeskLight.config.email).to eq(desk_yml['email'])
      expect(DeskLight.config.password).to eq(desk_yml['password'])
    end
  end
  

end
