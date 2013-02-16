require 'spec_helper'

describe "Microposts on UI" do

  subject { page }

  let(:user) { create(:user) }

  I18n.available_locales.each do |locale|

    describe "micropost creation" do
      let(:translations) { Micropost.translation_class }
      let(:click_post_button) { click_button t('static_pages.home.post') }

      before do
        visit signin_path(locale)
        sign_in_through_ui(user)
        visit locale_root_path(locale)
      end

      context "with invalid information" do

        describe "appearance" do
          before { click_post_button }
          it { should have_alert_message('error') }
        end

        describe "result" do
          subject { -> { click_post_button } }
          it { should_not change(Micropost, :count) }
          it { should_not change(translations, :count) }
        end
      end

      context "with valid information" do
        let(:micropost_content) { 'micropost_content' }
        let(:content) { "Lorem Ipsum Test" }

        before { fill_in micropost_content, with: content }

        describe "appearance" do
          before { click_post_button }
          it { should have_selector('span', text: content) }

          I18n.available_locales.each do |target_locale|
            next if locale == target_locale

            context "in other locales" do
              let(:target_language) do
                t("layouts.locale_selector.#{target_locale}")
              end
              before { click_link target_language }
              it { should have_selector('span', text: content) }
            end
          end
        end

        describe "result" do
          let(:locale_count) { I18n.available_locales.count }

          subject { -> { click_post_button } }

          it { should change(Micropost, :count).by(1) }
          it { should change(translations, :count).by(locale_count) }
        end
      end
    end

    describe "micropost destruction" do
      let(:micropost_content) { 'micropost_content' }
      let(:content) { "Lorem Ipsum Test" }
      let(:click_post_button) { click_button t('static_pages.home.post') }

      before { create(:micropost_with_translations, user: user) }

      context "as correct user" do
        let(:click_delete_link) do
          click_link t('shared.delete_micropost.delete')
        end
        let(:translations) { Micropost.translation_class }
        let(:locale_count) { I18n.available_locales.count }

        before do
          visit signin_path(locale)
          sign_in_through_ui(user)
          visit locale_root_path(locale)
        end

        describe "result" do
          subject { -> { click_delete_link } }
          it { should change(Micropost, :count).by(-1) }
          it { should change(translations, :count).by(-locale_count) }
        end
      end
    end

    describe "pagination" do
      let(:first_page)  { user.microposts.paginate(page: 1) }
      let(:second_page) { user.microposts.paginate(page: 2) }
      let(:next_page) { t('will_paginate.next_label') }

      before do
        visit signin_path(locale)
        sign_in_through_ui(user)
        create_list(:micropost, 31, user: user)
        visit locale_root_path(locale)
      end
      after { Micropost.delete_all }

      it { should have_selector('div.pagination') }
      it { should have_link(next_page) }
      its(:html) { should match('>2</a>') }


      describe "first page" do
        it "lists the first page of microposts" do
          first_page[0..2].each do |micropost|
            page.should have_selector('span', text: micropost.content)
          end
        end

        it "does not list the second page of microposts" do
          second_page[0..2].each do |micropost|
            page.should_not have_selector('span', text: micropost.content)
          end
        end
      end

      describe "second page" do
        before { visit locale_root_path(locale, page: 2) }

        it "should list the second page of microposts" do
          second_page[0..2].each do |micropost|
            page.should have_selector('span', text: micropost.content)
          end
        end
      end
    end

    describe "sidebar" do
      before do
        visit signin_path(locale)
        sign_in_through_ui(user)
        visit locale_root_path(locale)
      end

      describe "micropost counts" do
        let(:one) { t('shared.user_info.microposts', count: 1) }
        let(:other) do
          t('shared.user_info.microposts', count: user.microposts.count)
        end

        context "when user has zero microposts" do
          it { should have_selector('span', text: other) }
          it { should_not have_selector('span', text: one) }
        end

        context "when user has one micropost" do
          before do
            create(:micropost, user: user)
            visit locale_root_path(locale)
          end

          it { should have_selector('span', text: one) }
        end

        context "when user has multiple microposts" do
          before do
            create_list(:micropost, 2, user: user)
            visit locale_root_path(locale)
          end

          it { should have_selector('span', text: other) }
          it { should_not have_selector('span', text: one) }
        end
      end
    end

    describe "feed" do
      let!(:current_user_micropost) do
        create(:micropost, user: user)
      end

      before do
        visit signin_path(locale)
        sign_in_through_ui(user)
        visit locale_root_path(locale)
      end

      describe "delete links" do
        let(:delete) { t('shared.delete_micropost.delete') }
        let(:other_micropost) do
          create(:micropost, user: create(:user))
        end

        specify "for user's microposts" do
          should have_link(delete, href: micropost_path(locale,
                                         current_user_micropost))
        end

        specify "for other user's microposts" do
          should_not have_link(delete, href: micropost_path(locale,
                                             other_micropost))
        end
      end
    end
  end
end
