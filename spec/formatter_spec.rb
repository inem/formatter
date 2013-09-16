require 'spec_helper'

describe "formatter" do
  it "should restore oneliner" do
    `ruby formatter.rb < ./code_samples/oneliner.code`.should eql `cat ./code_samples/formatted.code`
  end

  it "should not break correct formatting" do
    `ruby formatter.rb < ./code_samples/formatted.code`.should eql `cat ./code_samples/formatted.code`
  end

  it "should restore broken formatting" do
    `ruby formatter.rb < ./code_samples/broken.code`.should eql `cat ./code_samples/formatted.code`
  end
end