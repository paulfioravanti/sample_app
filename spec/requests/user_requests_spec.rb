require 'spec_helper'

describe "User pages" do

  subject { response }

  I18n.available_locales.each do |locale|

    describe "index" do
      before(:all) { create_list(:user, 1) }
      after(:all)  { User.delete_all }

      describe "delete links" do

        context "as an admin user" do
          let(:admin) { create(:admin) }

          describe "result" do
            let(:delete_user) { delete user_path(locale, User.first) }

            before { sign_in_request(locale, admin) }

            subject { -> { delete_user } }

            it { should change(User, :count).by(-1) }
          end
        end
      end
    end
  end
end