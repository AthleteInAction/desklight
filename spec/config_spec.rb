require 'yaml'


describe DeskLight do


  let(:desk_yml){ YAML.load(File.read("spec/config/desk.yml")) }


  context "Config" do
    it "Should set config variables" do
      DeskLight.configure do |config|
        config.subdomain = desk_yml['subdomain']
        config.email = desk_yml['email']
        config.password = desk_yml['password']
        config.key = desk_yml['key']
        config.secret = desk_yml['secret']
        config.api_token = desk_yml['api_token']
        config.api_secret = desk_yml['api_secret']
      end
      expect(DeskLight.config.subdomain).to eq(desk_yml['subdomain'])
      expect(DeskLight.config.email).to eq(desk_yml['email'])
      expect(DeskLight.config.password).to eq(desk_yml['password'])
      expect(DeskLight.config.key).to eq(desk_yml['key'])
      expect(DeskLight.config.secret).to eq(desk_yml['secret'])
      expect(DeskLight.config.api_token).to eq(desk_yml['api_token'])
      expect(DeskLight.config.api_secret).to eq(desk_yml['api_secret'])
    end
  end


end
