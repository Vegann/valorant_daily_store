# frozen_string_literal: true

RSpec.describe ValorantDailyStore do
  describe "#get_data" do
    it "should call ValorantDailyStore::Data" do
      instance = double
      expect(ValorantDailyStore::Data).to receive(:new).with(username: "xxxxx", password: "xxxxx", region: "xxxxx", language: "en-US").and_return(instance)
      expect(instance).to receive(:get)
      ValorantDailyStore.get_data(username: "xxxxx", password: "xxxxx", region: "xxxxx")
    end
  end
end
