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
  end
end
