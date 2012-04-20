require 'spec_helper'

describe "Static Pages" do

  # full_title method referenced in spec/support/utilties.rb
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  shared_examples_for "all layout link verifications" do
    it { should have_selector('title', text: full_title(page_title)) }
  end
  
  LANGUAGES.transpose.last.each do |locale|
    
    describe "Layout" do
      before { visit root_path(locale) }
      
      context "About link" do
        before { click_link I18n.t('layouts.footer.about') }
        let(:page_title) { I18n.t('static_pages.about.about_us') }
        
        it_should_behave_like "all layout link verifications"
      end

      context "Help link" do
        before { click_link I18n.t('layouts.header.help') }
        let(:page_title) { I18n.t('static_pages.help.help') }

        it_should_behave_like "all layout link verifications"
      end

      context "Contact link" do
        before { click_link I18n.t('layouts.footer.contact') }
        let(:page_title) { I18n.t('static_pages.contact.contact') }

        it_should_behave_like "all layout link verifications"
      end

      context "Home link" do
        before { click_link I18n.t('layouts.header.home') }
        let(:page_title) { '' }

        it_should_behave_like "all layout link verifications"
      end

      context "Sign up link" do
        before { click_link I18n.t('static_pages.home.sign_up') }
        let(:page_title) { I18n.t('users.new.sign_up') }

        it_should_behave_like "all layout link verifications"
      end
    end
    
    describe "Home page" do
      before { visit root_path(locale) }
      let(:heading) { I18n.t('layouts.header.sample_app') }
      let(:page_title) { '' }

      it_should_behave_like "all static pages"
      it { should_not have_selector('title', text: '| Home') }
    end

    describe "Help Page" do
      before { visit help_path(locale) }
      let(:heading) { I18n.t('static_pages.help.help') }
      let(:page_title) { I18n.t('static_pages.help.help') }

      it_should_behave_like "all static pages"
    end

    describe "About Page" do
      before { visit about_path(locale) }
      let(:heading) { I18n.t('static_pages.about.about_us') }
      let(:page_title) { I18n.t('static_pages.about.about_us') }

      it_should_behave_like "all static pages"
    end

    describe "Contact Page" do
      before { visit contact_path(locale) }
      let(:heading) { I18n.t('static_pages.contact.contact') }
      let(:page_title) { I18n.t('static_pages.contact.contact') }

      it_should_behave_like "all static pages"
    end
  end
end