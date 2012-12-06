require 'spec_helper'

describe ApplicationHelper do
  describe "#full_title" do
    context "with page name" do
      I18n.available_locales.each do |locale|
        let(:page_name) { 'foo' }
        let(:base_name) { t('layouts.application.base_title') }

        before { I18n.locale = locale }

        subject { full_title(page_name) }

        it { should =~ /#{page_name}/ }
        it { should =~ /^#{base_name}/ }
      end
    end

    context "without page name" do
      let(:bar) { '|' }
      subject { full_title("") }
      it { should_not =~ /\#{bar}/ }
    end
  end

  describe "#gravatar_link" do
    let(:link) { 'http://gravatar.com/emails' }
    subject { gravatar_link }
    it { should == link }
  end

  describe "#locale_languages" do
    let(:language_labels) do
      [
        { label: t('locale_selector.en'), locale: 'en' },
        { label: t('locale_selector.it'), locale: 'it' },
        { label: t('locale_selector.ja'), locale: 'ja' }
      ]
    end
    subject { locale_languages }
    it { should ==  language_labels }
  end
end