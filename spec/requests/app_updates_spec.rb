require 'spec_helper'

describe "AppUpdates" do
  describe "GET /app_updates" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get app_updates_path
      response.status.should be(200)
    end
  end
end
