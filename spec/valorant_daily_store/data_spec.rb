RSpec.describe ValorantDailyStore::Data do
  let(:subject) { described_class.new(username: "xxxxx", password: "xxxxx", region: "xxxxx").get }

  describe "#get" do
    context "when unsupported language was specified" do
      it "should raise ValorantDailyStore::UnsupportedLanguage" do
        expect { described_class.new(username: "xxxxx", password: "xxxxx", region: "xxxxx", language: "xx-XX").get }.to raise_error(ValorantDailyStore::UnsupportedLanguage)
      end
    end

    context "when everything went fine" do
      it "should not raise error" do
        VCR.use_cassette("everything_went_fine") do
          expect { subject }.not_to raise_error
        end
      end

      it "should return skins" do
        VCR.use_cassette("everything_went_fine") do
          skins = subject

          expect(skins.length).to eq 4
        end
      end
    end

    context "when initial cookies couldn't be acquired" do
      it "should raise ValorantDailyStore::AuthorizationCookiesError" do
        stub_request(:post, "https://auth.riotgames.com/api/v1/authorization")
          .to_return(status: 404, headers: {"Content-Type" => "application/json"})

        expect { subject }.to raise_error ValorantDailyStore::AuthorizationCookiesError
      end
    end

    context "when username or password is incorrect" do
      it "should raise ValorantDailyStore::AuthorizaionTokenError" do
        VCR.use_cassette("username_or_password_is_invalid") do
          expect { subject }.to raise_error ValorantDailyStore::AuthorizaionTokenError
        end
      end
    end

    context "when entitlements token couldn't be acquired" do
      it "should raise ValorantDailyStore::EntitlementsTokenError" do
        stub_request(:post, "https://entitlements.auth.riotgames.com/api/token/v1")
          .to_return(status: 404, body: {}.to_json, headers: {"Content-Type" => "application/json"})

        VCR.use_cassette("entitlements_token_could_not_be_acquired") do
          expect { subject }.to raise_error ValorantDailyStore::EntitlementsTokenError
        end
      end
    end

    context "when player id couldn't be acquired" do
      it "should raise ValorantDailyStore::PlayerIdError" do
        stub_request(:get, "https://auth.riotgames.com/userinfo")
          .to_return(status: 404, body: {}.to_json, headers: {"Content-Type" => "application/json"})

        VCR.use_cassette("player_id_could_not_be_acquired") do
          expect { subject }.to raise_error ValorantDailyStore::PlayerIdError
        end
      end
    end

    context "when skin ids couldn't be acquired" do
      it "should raise ValorantDailyStore::SkinIdsError" do
        stub_request(:get, "https://pd.xxxxx.a.pvp.net/store/v2/storefront/xxxxx")
          .to_return(status: 404, body: {}.to_json, headers: {"Content-Type" => "application/json"})

        VCR.use_cassette("skin_ids_could_not_be_acquired") do
          expect { subject }.to raise_error ValorantDailyStore::SkinIdsError
        end
      end
    end

    context "when offers couldn't be acquired" do
      it "should raise ValorantDailyStore::OffersError" do
        stub_request(:get, "https://pd.xxxxx.a.pvp.net/store/v1/offers/")
          .to_return(status: 404, body: {}.to_json, headers: {"Content-Type" => "application/json"})

        VCR.use_cassette("offers_could_not_be_acquired") do
          expect { subject }.to raise_error ValorantDailyStore::OffersError
        end
      end
    end

    context "when call to valorant api failed" do
      it "should raise ValorantDailyStore::OffersError" do
        stub_request(:get, "https://valorant-api.com/v1/weapons/skinlevels/31da3ec9-4eb0-ce9f-fcbb-e09ec626e748/?language=en-US")
          .to_return(status: 404, body: {status: 404}.to_json, headers: {"Content-Type" => "application/json"})

        VCR.use_cassette("valorant_api_fail") do
          expect { subject }.to raise_error ValorantDailyStore::ValorantApiError
        end
      end
    end
  end
end
