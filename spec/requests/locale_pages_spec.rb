require 'spec_helper'

describe "Locale switching" do

  subject { page }

  let(:locale_selector) { 'set_locale' }
  let(:locale_submit)   { 'submit' }

  I18n.available_locales.each do |locale|

    LANGUAGES.each do |target_language, target_locale|
      next if locale == target_locale

      context "to another language" do
        let(:page_title) { t('layouts.application.base_title') }

        before do
          visit locale_root_path(locale)
          select target_language, from: locale_selector
          click_button locale_submit
        end

        it { should have_selector('select', text: target_language) }
        it { should have_selector('title', text: page_title) }
        specify { I18n.locale.should == target_locale.to_sym }
      end

      context "during pagination" do
        let(:user)      { FactoryGirl.create(:user) }
        let(:next_page) { t('will_paginate.next_label') }

        before(:all) { FactoryGirl.create_list(:user, 30) }
        after(:all)  { User.delete_all }

        before do
          visit signin_path(locale)
          valid_sign_in(user)
          visit users_path(locale)
          click_link next_page
          select target_language, from: locale_selector
          click_button locale_submit
        end

        it { should have_link('2', class: 'active') }
        its(:current_url) { should =~ /\?page/ }

      end

      context "after a validation error" do
        context "when failing to create a micropost" do
          let(:user)   { FactoryGirl.create(:user) }
          let(:page_title) { t('layouts.application.base_title') }
          let(:post) { t('shared.micropost_form.post') }

          before do
            visit signin_path(locale)
            valid_sign_in(user)
            visit locale_root_path(locale)
            click_button post
            select target_language, from: locale_selector
            click_button locale_submit
          end

          it "should render the home page in the target language" do
            expect { response.should redirect_to(locale_root_path(target_locale)) }
          end
          it { should have_selector('title', text: page_title)}
        end

        context "when failing to create a user" do
          let(:page_title) { t('users.new.sign_up') }
          let(:submit) { t('users.new.create_account') }

          before do
            visit signup_path(locale)
            click_button submit
            select target_language, from: locale_selector
            click_button locale_submit
          end

          it "should render the new user page in the target language" do
            expect { response.should redirect_to(signup_path(target_locale)) }
          end
          it { should have_selector('title', text: page_title) }

        end

        context "when failing to update a user" do
          let(:user)   { FactoryGirl.create(:user) }
          let(:page_title) { t('users.edit.edit_user') }
          let(:submit) { t('users.edit.save_changes') }

          before do
            visit signin_path(locale)
            valid_sign_in(user)
            visit edit_user_path(locale, user)
            click_button submit
            select target_language, from: locale_selector
            click_button locale_submit
          end

          it "should render the edit user page in the target language" do
            expect { response.should redirect_to(edit_user_path(target_locale, user)) }
          end
          it { should have_selector('title', text: page_title)}
        end
      end
    end
  end
end
