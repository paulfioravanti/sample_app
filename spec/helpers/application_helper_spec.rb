require 'spec_helper'

describe ApplicationHelper do
  describe "#full_title" do
    I18n.available_locales.each do |locale|
      context "with page name" do
        let(:page_name) { 'foo' }
        let(:base_name) { t('layouts.application.base_title') }

        subject { full_title(page_name) }

        before { I18n.locale = locale }

        it { should =~ %r(#{page_name}) }
        it { should =~ %r(^#{base_name}) }
      end
    end

    context "without page name" do
      let(:bar) { '\|' }
      subject { full_title("") }
      it { should_not =~ %r(#{bar}) }
    end
  end

  describe "#gravatar_link" do
    let(:link) { 'http://gravatar.com/emails' }
    subject { gravatar_link }
    it { should == link }
  end
end