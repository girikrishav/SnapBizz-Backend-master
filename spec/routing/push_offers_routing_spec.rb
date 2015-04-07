require "spec_helper"

describe PushOffersController do
  describe "routing" do

    it "routes to #index" do
      get("/push_offers").should route_to("push_offers#index")
    end

    it "routes to #new" do
      get("/push_offers/new").should route_to("push_offers#new")
    end

    it "routes to #show" do
      get("/push_offers/1").should route_to("push_offers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/push_offers/1/edit").should route_to("push_offers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/push_offers").should route_to("push_offers#create")
    end

    it "routes to #update" do
      put("/push_offers/1").should route_to("push_offers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/push_offers/1").should route_to("push_offers#destroy", :id => "1")
    end

  end
end
