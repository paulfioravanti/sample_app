require 'spec_helper'

describe "Locale Switching on UI" do

  subject { page }

  I18n.available_locales.each do |locale|

    I18n.available_locales.each do |target_locale|
      next if locale == target_locale

      context "to another language" do
        let(:current_locale_page_title) do
          t('layouts.application.base_title', locale: locale)
        end
        let(:target_locale_page_title) do
          t('layouts.application.base_title', locale: target_locale)
        end
        let(:target_language) { t("layouts.locale_selector.#{target_locale}") }
        let(:new_language)    { t("layouts.locale_selector.#{I18n.locale}") }

        before { visit locale_root_path(locale) }

        it { should have_title(current_locale_page_title) }

        context "changes text to target language" do
          before { click_link target_language }
          it { should have_title(target_locale_page_title) }

          context "and changes locale to target locale" do
            subject { I18n.locale }
            it { should == target_locale.to_sym }
          end
        end
      end

      context "during pagination" do
        let(:user)            { create(:user) }
        let(:next_page)       { t('will_paginate.next_label') }
        let(:target_language) { t("layouts.locale_selector.#{target_locale}") }

        before(:all) { create_list(:user, 30) }
        after(:all)  { User.delete_all }

        before do
          visit signin_path(locale)
          valid_sign_in(user)
          visit users_path(locale)
          click_link next_page
          click_link target_language
        end

        it { should have_css("li.active a", text: '2') }
        its(:current_url) { should =~ /\?page/ }

      end

      context "after a validation error" do
        context "when failing to create a micropost" do
          let(:user)            { create(:user) }
          let(:page_title)      { t('layouts.application.base_title') }
          let(:post_button)     { t('shared.micropost_form.post') }
          let(:target_language) { t("layouts.locale_selector.#{target_locale}") }

          context "appearance" do
            before do
              visit signin_path(locale)
              valid_sign_in(user)
              visit locale_root_path(locale)
              click_button post_button
              click_link target_language
            end
            it { should have_title(page_title) }
          end
        end

        context "when failing to create a user" do
          let(:page_title)      { t('users.new.sign_up') }
          let(:submit)          { t('users.new.create_account') }
          let(:target_language) { t("layouts.locale_selector.#{target_locale}") }

          context "appearance" do
            before do
              visit signup_path(locale)
              click_button submit
              click_link target_language
            end
            it { should have_title(page_title) }
          end
        end

        context "when failing to update a user" do
          let(:user)            { create(:user) }
          let(:page_title)      { t('users.edit.edit_user') }
          let(:submit)          { t('users.edit.save_changes') }
          let(:target_language) { t("layouts.locale_selector.#{target_locale}") }

          context "appearance" do
            before do
              visit signin_path(locale)
              valid_sign_in(user)
              visit edit_user_path(locale, user)
              click_button submit
              click_link target_language
            end
            it { should have_title(page_title) }
          end
        end
      end
    end
  end
end
