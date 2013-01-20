require 'spec_helper'

describe Platform45GamesController do
  describe "POST /create" do
    it "uses the CreateGameService to create a new game"
    context "on success" do
      it "redirects to the returned game's page"
    end
    context "on failure" do
      it "redirects to the /platform45_games/new URL and sets the error flash"
    end
  end
end
