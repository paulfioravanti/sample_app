require 'spec_helper'

describe "Static Pages" do

  subject { page }

  # full_title method referenced in spec/support/utilties.rb
  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  shared_examples_for "all layout links" do
    it { should have_selector('title', text: full_title(page_title)) }
  end
  
  LANGUAGES.transpose.last.each do |locale|
    
    describe "Layout" do
      before { visit root_path(locale) }
      
      describe "About link" do
        let(:page_title) { t('static_pages.about.about_us') }
        let(:about)      { t('layouts.footer.about') }
        
        before { click_link about }      
        
        it_should_behave_like "all layout links"
      end

      describe "Help link" do
        let(:page_title) { t('static_pages.help.help') }
        let(:help)       { t('layouts.header.help') }
        
        before { click_link help }

        it_should_behave_like "all layout links"
      end

      describe "Contact link" do
        let(:page_title) { t('static_pages.contact.contact') }
        let(:contact)    { t('layouts.footer.contact') }
        
        before { click_link contact }

        it_should_behave_like "all layout links"
      end

      describe "Home link" do
        let(:page_title) { '' }
        let(:home)       { t('layouts.header.home') }
        
        before { click_link home }

        it_should_behave_like "all layout links"
      end

      describe "Sign up link" do
        let(:page_title) { t('users.new.sign_up') }
        let(:sign_up)    { t('static_pages.home.sign_up') }
        
        before { click_link sign_up }

        it_should_behave_like "all layout links"
      end
    end
    
    describe "Home page" do
      let(:heading)    { t('layouts.header.sample_app') }
      let(:page_title) { '' }
      let(:home)       { t('layouts.header.home') }

      before { visit root_path(locale) }

      it_should_behave_like "all static pages"
      it { should_not have_selector('title', text: "| #{home}") }

      context "for signed-in users" do
        let(:user) { FactoryGirl.create(:user) }

        before do
          FactoryGirl.create(:micropost, user: user, content: "Lorem Ipsum")
          FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
          visit signin_path(locale)
          valid_sign_in(user)
          visit root_path(locale)
        end

        it "should render the user's feed" do
          user.feed.each do |item|
            subject.should have_selector("li##{item.id}", text: item.content)
          end
        end
      end
    end

    describe "Help Page" do
      let(:heading)    { t('static_pages.help.help') }
      let(:page_title) { t('static_pages.help.help') }
      
      before { visit help_path(locale) }

      it_should_behave_like "all static pages"
    end

    describe "About Page" do
      let(:heading)    { t('static_pages.about.about_us') }
      let(:page_title) { t('static_pages.about.about_us') }

      before { visit about_path(locale) }

      it_should_behave_like "all static pages"
    end

    describe "Contact Page" do
      let(:heading)    { t('static_pages.contact.contact') }
      let(:page_title) { t('static_pages.contact.contact') }

      before { visit contact_path(locale) }

      it_should_behave_like "all static pages"
    end
  end
end