require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  test "signup" do
    @expected.subject = "Signup"
    @expected.to      = "to@example.org"
    @expected.from    = "from@example.com"
    @expected.body    = read_fixture("signup")
    @expected.date    = Time.now

    assert_equal @expected, Notifications.signup
  end

  test "joined_mission" do
    @expected.subject = "Joined mission"
    @expected.to      = "to@example.org"
    @expected.from    = "from@example.com"
    @expected.body    = read_fixture("joined_mission")
    @expected.date    = Time.now

    assert_equal @expected, Notifications.joined_mission
  end

  test "profile_incomplete" do
    @expected.subject = "Profile incomplete"
    @expected.to      = "to@example.org"
    @expected.from    = "from@example.com"
    @expected.body    = read_fixture("profile_incomplete")
    @expected.date    = Time.now

    assert_equal @expected, Notifications.profile_incomplete
  end

  test "notice" do
    @expected.subject = "Notice"
    @expected.to      = "to@example.org"
    @expected.from    = "from@example.com"
    @expected.body    = read_fixture("notice")
    @expected.date    = Time.now

    assert_equal @expected, Notifications.notice
  end

  test "password_reset" do
    @expected.subject = "Password reset"
    @expected.to      = "to@example.org"
    @expected.from    = "from@example.com"
    @expected.body    = read_fixture("password_reset")
    @expected.date    = Time.now

    assert_equal @expected, Notifications.password_reset
  end

end
