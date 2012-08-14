require "spec_helper"

describe Kbb::Client do
  describe "with_retries" do

    it "should call the block as many times as the attempts parameter" do
      @attempts = 0
      Kbb::Client.with_retries(5) do
        @attempts += 1
        nil
      end
      @attempts.should == 5
    end

    it "should return the object returned by the block" do
      Kbb::Client.with_retries(5) do
        {a: :b}
      end.should == {a: :b}
    end

    it "should break when the object returned by the block is present" do
      @attempts = 0
      Kbb::Client.with_retries(5) do
        @attempts += 1
        @attempts > 3 ? "present" : nil
      end.should == "present"
      @attempts.should == 4
    end

  end
end
