require 'spec_helper'

describe "Microposts on UI" do

  subject { page }

  let(:user) { create(:user) }

  I18n.available_locales.each do |locale|

    describe "micropost creation" do
      let(:post_button) { t('static_pages.home.post') }
      let(:click_post) { click_button post_button }

      before do
        visit signin_path(locale)
        valid_sign_in(user)
        visit locale_root_path(locale)
      end

      context "with invalid information" do

        describe "appearance" do
          before { click_post }
          it { should have_alert_message('error') }
        end

        describe "result" do
          subject { -> { click_post } }
          it { should_not change(Micropost, :count) }
        end
      end

      context "with valid information" do
        let(:micropost_content) { 'micropost_content' }

        before { fill_in micropost_content, with: "Lorem Ipsum" }

        describe "result" do
          subject { -> { click_post } }
          it { should change(Micropost, :count).by(1) }
        end
      end
    end

    describe "micropost destruction" do
      before { create(:micropost, user: user) }

      context "as correct user" do
        let(:delete_link) { t('shared.delete_micropost.delete') }
        let(:click_delete) { click_link delete_link }

        before do
          visit signin_path(locale)
          valid_sign_in(user)
          visit locale_root_path(locale)
        end

        describe "result" do
          subject { -> { click_delete } }
          it { should change(Micropost, :count).by(-1) }
        end
      end
    end

    describe "pagination" do
      let(:next_page) { t('will_paginate.next_label') }

      before do
        visit signin_path(locale)
        valid_sign_in(user)
        create_list(:micropost, 31, user: user)
        visit locale_root_path(locale)
      end
      after { Micropost.delete_all }

      it { should have_link(next_page) }
      its(:html) { should match('>2</a>') }

      it "lists each micropost" do
        Micropost.all[0..2].each do |micropost|
          # Each name should be a link (span>a)
          page.should have_selector('span>a', text: micropost.user.name)
        end
      end
    end

    describe "sidebar" do
      before do
        visit signin_path(locale)
        valid_sign_in(user)
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
        valid_sign_in(user)
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
