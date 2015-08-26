require 'rails_helper'

RSpec.describe "Goods", type: :request do
  describe "GET /goods" do
    it "display goods" do
      get goods_path
      expect(response).to have_http_status(200)
    end
  end
end
