require File.join(File.dirname(__FILE__),'..','test_helper')

class ThemeTest < ActiveSupport::TestCase
  test "theme finds all themes" do
    themes = Theme.all
    puts themes.inspect
  end
end
