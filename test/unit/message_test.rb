require '../test_helper'

class MessageTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def test_truth
   parsed = Date.parse(['2007', '07', '19'].join('/'))
   assert_nil parsed
  end
end
