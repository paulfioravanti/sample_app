require 'spec_helper'

describe "Authentication Requests" do

  subject { response }

  I18n.available_locales.each do |locale|

    describe "authorization" do

      context "for non-signed-in users" do
        let(:user) { create(:user) }

        context "in the UsersController" do

          context "PUT Users#update" do
            before { put user_path(locale, user) }
            it { should redirect_to(signin_url(locale)) }
          end
        end

        context "in the MicropostsController" do

          context "POST Microposts#create" do
            before { post microposts_path(locale) }
            it { should redirect_to(signin_url(locale)) }
          end

          context "DELETE Microposts#destroy" do
            let(:micropost) { create(:micropost) }
            before { delete micropost_path(locale, micropost) }
            it { should redirect_to(signin_url(locale)) }
          end
        end

        context "in the RelationshipsController" do

          describe "POST Relationships#create" do
            before { post relationships_path(locale) }
            it { should redirect_to(signin_url(locale)) }
          end

          describe "DELETE Relationships#destroy" do
            before { delete relationship_path(locale, 1) }
            it { should redirect_to(signin_url(locale)) }
          end
        end
      end

      context "for signed-in users" do
        let(:user) { create(:user) }

        before { sign_in_request(locale, user) }

        context "GET Users#new" do
          before { get signup_path(locale) }
          it { should redirect_to(locale_root_url(locale)) }
        end

        context "POST Users#create" do
          before { post users_path(locale) }
          it { should redirect_to(locale_root_url(locale)) }
        end

        context "when session is hijacked" do
          before { controller.handle_unverified_request }
          subject { controller.send(:signed_in?) }
          it { should be_false }
        end
      end

      context "as a wrong user" do
        let(:user)       { create(:user) }
        let(:wrong_user) { create(:user, email: "wrong@eg.com") }

        before { sign_in_request(locale, user) }

        context "PUT Users#update" do
          before { put user_path(locale, wrong_user) }
          it { should redirect_to(locale_root_url(locale)) }
        end
      end

      context "as a non-admin user" do
        let(:user)      { create(:user) }
        let(:non_admin) { create(:user) }

        before { sign_in_request(locale, user) }

        context "DELETE Users#destroy" do
          before { delete user_path(locale, user) }
          it { should redirect_to(locale_root_url(locale)) }
        end
      end

      context "as an admin user" do
        let(:admin) { create(:admin) }

        before { sign_in_request(locale, admin) }

        context "prevents admin users from destroying themselves" do
          let(:delete_admin) { delete user_path(locale, admin) }

          before { delete_admin }

          describe "behaviour" do
            it { should redirect_to(users_url(locale)) }
          end

          describe "appearance" do
            let(:no_suicide) { t('flash.no_admin_suicide', name: admin.name) }
            subject { flash[:error] }
            it { should == no_suicide }
          end

          describe "result" do
            subject { -> { delete_admin } }
            it { should_not change(User, :count) }
          end
        end
      end
    end
  end
end
