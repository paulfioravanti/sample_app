require 'spec_helper'

describe "Routing" do

  describe "locale scoped paths" do
    I18n.available_locales.each do |locale|

      describe "locale root routing" do
        subject { get("/#{locale.to_s}") }
        it { should route_to("static_pages#home", locale: locale.to_s) }
      end
    end
  end
end