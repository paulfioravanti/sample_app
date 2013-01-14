require 'spec_helper'

describe "Micropost Requests" do

  subject { response }

  let(:user) { create(:user) }

  I18n.available_locales.each do |locale|

    describe "micropost destruction" do
      before { create(:micropost_with_translations, user: user) }

      context "as an incorrect user" do
        let(:other_micropost) { create(:micropost, user: create(:user)) }
        let(:translations) { Micropost.translation_class }
        let(:delete_other_micropost)  do
          delete micropost_path(locale, other_micropost)
        end

        before do
          sign_in_request(locale, user)
          delete_other_micropost
        end

        describe "behaviour" do
          it { should redirect_to(locale_root_url(locale)) }
        end

        describe "result" do
          subject { -> { delete_other_micropost } }
          it { should_not change(Micropost, :count) }
          it { should_not change(translations, :count) }
        end
      end
    end
  end
end