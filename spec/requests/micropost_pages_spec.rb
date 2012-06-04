require 'spec_helper'

describe "Micropost pages" do
  
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  LANGUAGES.transpose.last.each do |locale|

    before do
      visit signin_path(locale)
      valid_sign_in user
    end

    describe "micropost creation" do
      let(:post) { t('static_pages.home.post') }

      before { visit root_path(locale) }

      context "with invalid information" do

        it "should not create a micropost" do
          expect { click_button post }.should_not change(Micropost, :count)
        end
        
        describe "error messages" do
          before { click_button post }
          it { should have_alert_message('error') }
        end
      end

      context "with valid information" do
        let(:micropost_content) { 'micropost_content' }

        before { fill_in micropost_content, with: "Lorem Ipsum" }

        it "should create a micropost" do
          expect { click_button post }.should change(Micropost, :count).by(1)
        end
      end
    end

    describe "micropost destruction" do
      before { FactoryGirl.create(:micropost, user: user) }

      context "as correct user" do
        let(:delete) { t('microposts.micropost.delete') }

        before { visit root_path(locale) }

        it "should delete a micropost" do
          expect { click_link delete }.should change(Micropost, :count).by(-1)
        end
      end
    end

    describe "pagination" do
      before do
        31.times { FactoryGirl.create(:micropost, user: user) }
        visit root_path(locale)
      end
      after { Micropost.delete_all }

      let(:next_page) { t('will_paginate.next_label') }

      it { should have_link(next_page) }
      its(:html) { should match('>2</a>') }

      it "should list each micropost" do
        Micropost.all[0..2].each do |micropost|
          # Each name should be a link (span>a)
          page.should have_selector('span>a', text: micropost.user.name)
        end
      end
    end

    describe "sidebar" do
      before { visit root_path(locale) }

      describe "micropost counts" do
        let(:one) { t('shared.user_info.microposts.one') }
        let(:other) { t('shared.user_info.microposts.other', count: user.microposts.count) }

        context "when user has zero microposts" do
          it { should have_selector('span', text: other) }
          it { should_not have_selector('span', text: one) }
        end
      
        context "when user has one micropost" do
          before do 
            FactoryGirl.create(:micropost, user: user)
            visit root_path(locale)
          end

          it { should have_selector('span', text: one) }
        end

        context "when user has multiple microposts" do
          before do 
            2.times { FactoryGirl.create(:micropost, user: user) }
            visit root_path(locale)
          end

          it { should have_selector('span', text: other) }
          it { should_not have_selector('span', text: one) }
        end

      end

    end
  end
end
