require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "confirm" do

    email = UserMailer.confirm_email("email@email.com")

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ['email@email.com'], email.to
  end
end
