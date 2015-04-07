require "spec_helper"

describe AppUpdatesController do
  describe "routing" do

    it "routes to #index" do
      get("/app_updates").should route_to("app_updates#index")
    end

    it "routes to #new" do
      get("/app_updates/new").should route_to("app_updates#new")
    end

    it "routes to #show" do
      get("/app_updates/1").should route_to("app_updates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/app_updates/1/edit").should route_to("app_updates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/app_updates").should route_to("app_updates#create")
    end

    it "routes to #update" do
      put("/app_updates/1").should route_to("app_updates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/app_updates/1").should route_to("app_updates#destroy", :id => "1")
    end

  end
end
