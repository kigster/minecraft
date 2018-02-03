require "spec_helper"

RSpec.describe MineCraft do
  it "has a version number" do
    expect(MineCraft::VERSION).not_to be nil
  end
end
