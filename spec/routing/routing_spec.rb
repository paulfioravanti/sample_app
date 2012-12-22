require 'spec_helper'

describe "Routing" do

  describe "locale scoped paths" do
    I18n.available_locales.each do |locale|

      describe "locale root routing" do
        subject { get("/#{locale.to_s}") }
        it { should route_to("static_pages#home", locale: locale.to_s) }
      end

      describe "/signup routing" do
        subject { get("/#{locale.to_s}/signup") }
        it { should route_to("users#new", locale: locale.to_s) }
      end

      describe "/signin routing" do
        subject { get("/#{locale.to_s}/signin") }
        it { should route_to("sessions#new", locale: locale.to_s) }
      end

      describe "/signout routing" do
        subject { delete("/#{locale.to_s}/signout") }
        it { should route_to("sessions#destroy", locale: locale.to_s) }
      end

      describe "/help routing" do
        subject { get("/#{locale.to_s}/help") }
        it { should route_to("static_pages#help", locale: locale.to_s) }
      end

      describe "/about routing" do
        subject { get("/#{locale.to_s}/about") }
        it { should route_to("static_pages#about", locale: locale.to_s) }
      end

      describe "/contact routing" do
        subject { get("/#{locale.to_s}/contact") }
        it { should route_to("static_pages#contact", locale: locale.to_s) }
      end
    end
  end
end