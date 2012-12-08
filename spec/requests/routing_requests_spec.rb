require 'spec_helper'

describe "Routing Requests" do

  subject { response }

  describe "locale scoped paths" do
    I18n.available_locales.each do |locale|

      describe "redirecting" do

        context "fake paths" do
          let(:fake_path) { "fake_path" }
          before { get "/#{locale.to_s}/#{fake_path}" }
          it { should redirect_to(locale_root_url(locale)) }
        end
      end
    end
  end

  describe "non-locale scoped paths" do
    describe "redirecting" do

      context "no path given" do
        before { get "/" }
        it { should redirect_to(locale_root_url(I18n.default_locale)) }
      end

      context "a valid action" do
        let(:action) { "about" }
        let!(:default_locale_action_url) { about_url(I18n.default_locale) }

        context "with a valid but unsupported locale" do
          let(:unsupported_locale) { "fr" }

          before { get "/#{unsupported_locale}/#{action}" }
          it { should redirect_to(default_locale_action_url) }
        end

        context "with invalid information for the locale" do
          let(:invalid_locale) { "invalid" }

          before { get "/#{invalid_locale}/#{action}" }
          it { should redirect_to(default_locale_action_url) }
        end

        context "with no locale information" do
          before { get "/#{action}" }
          it { should redirect_to(default_locale_action_url) }
        end
      end

      context "invalid information" do
        let(:invalid_info) { "invalid" }

        before { get "/#{invalid_info}" }
        it { should redirect_to("/#{I18n.default_locale}/#{invalid_info}") }
        # This will then get caught by the "redirecting fake paths" condition
        # and hence be redirected to locale_root_url with I18n.default_locale
      end
    end
  end
end