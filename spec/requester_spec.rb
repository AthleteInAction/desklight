require 'yaml'


describe DeskLight do


  before(:each) do
    desk_yml = YAML.load(File.read("spec/config/desk.yml"))
    DeskLight.configure do |config|
      config.subdomain = desk_yml['subdomain']
      config.email = desk_yml['email']
      config.password = desk_yml['password']
      config.key = desk_yml['key']
      config.secret = desk_yml['secret']
      config.api_token = desk_yml['api_token']
      config.api_secret = desk_yml['api_secret']
    end
  end


  context "Users" do
    it "Respond with 200 and users" do
      request = DeskLight.get(:users)
      expect(request.code).to eq(200)
      expect(request.limit).to be_a(Integer)
      expect(request.remaining).to be_a(Integer)
      expect(request.reset).to be_a(Integer)
      expect(request.json).to have_key('_embedded')
      expect(request.json['_embedded']).to have_key('entries')
      expect(request.json['_embedded']['entries'].first['_links']['self']['class']).to eq('user')
    end
  end


end
