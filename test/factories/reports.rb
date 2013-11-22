# This will guess the User class
FactoryGirl.define do
  factory :report do
    screenshot "ScreenshotBinaryData"
    logs  "Some logs"
    crash_logs "Some Crash Logs"
    dumped_view "My dumped view"
    title "full report"
    message "message for full report"
    os_version "7.0"
    device_model 'iPad'
    status 0
  end
end