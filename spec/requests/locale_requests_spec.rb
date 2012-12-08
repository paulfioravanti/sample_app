require 'spec_helper'

describe "Locale Switching Requests" do

  subject { response }

  I18n.available_locales.each do |locale|

    I18n.available_locales.each do |target_locale|
      next if locale == target_locale

      context "after a validation error" do

        context "when failing to create a micropost" do
          let(:user)            { create(:user) }

          context "behaviour" do
            before do
              sign_in_request(locale, user)
              post microposts_path(locale)
              get locale_root_url(set_locale: target_locale)
            end

            it { should redirect_to(locale_root_url(target_locale)) }
          end
        end

        context "when failing to create a user" do

          context "behaviour" do
            before do
              post users_path(locale)
              get signup_path(set_locale: target_locale)
            end

            it { should redirect_to(signup_url(target_locale)) }
          end
        end

        context "when failing to update a user" do
          let(:user)            { create(:user) }

          context "behaviour" do
            before do
              sign_in_request(locale, user)
              put user_path(locale, user)
              get edit_user_path(user, set_locale: target_locale)
            end

            it { should redirect_to(edit_user_url(target_locale, user)) }
          end
        end
      end
    end
  end
end
