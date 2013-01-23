require 'spec_helper'

describe Platform45GamesController do
  describe "POST /create" do
    let(:name) { "Name" }
    let(:email) { "Email" }
    let(:game) { Platform45Game.new }

    before :each do
      game.stub(:id).and_return(12)
      CreateGameService.any_instance.stub(:process).and_return(game)
    end

    it "uses the CreateGameService to create a new game" do
      CreateGameService.any_instance.should_receive(:process).with(name,email)
      post :create, {platform45_game: {name: name, email: email }}
    end

    context "on success" do
      it "redirects to the returned game's page" do
        post :create, {platform45_game: {name: name, email: email }}
        response.should redirect_to("/platform45_games/12") 
      end
    end

    context "on failure" do
      let(:failure) { ServiceResponse.new("an error message") }
      before :each do
        CreateGameService.any_instance.stub(:process).and_return(failure)
      end

      it "redirects to the /platform45_games/new URL" do
        post :create, {platform45_game: {name: name, email: email }}
        response.should redirect_to("/platform45_games/new") 
      end

      it "sets the flash error to the error message" do
        post :create, {platform45_game: {name: name, email: email }}
        flash[:error].should == "an error message"
      end
    end
  end
end
