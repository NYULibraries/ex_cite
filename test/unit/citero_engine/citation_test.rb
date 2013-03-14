require 'test_helper'

module CiteroEngine
  class RecordTest < ActiveSupport::TestCase

    test "typeones fields should be records fields" do
      assert_equal "formatting", TypeOne.format_field
    end

    test "test a typetwos fields should be records fields" do
      assert_equal "from_format", TypeTwo.format_field
    end

    test "test typeones formatting should populate records fields" do
      typeone = TypeOne.new(:formatting => "csf", :raw => "itemType: book")
      # typeone.formatting("CSF")
      assert_equal "csf", typeone.formatting
    end

    test "test typetwos formatting should populate records fields" do
      # CiteroEngine::ActsAsCitableClass = TypeOne
            # 
            # t = CiteroEngine::ActsAsCitableClass.new(:formatting => "csf", :raw => "itemType: book")
            # p t.tryfff
    end
  end
end