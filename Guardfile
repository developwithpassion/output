
notification :tmux,
  :display_message => true,
  :timeout => 5, # in seconds
  # :default_message_format => '%s >> %s',
  # :success_message_format => "Success",
  # the first %s will show the title, the second the message
  # Alternately you can also configure *success_message_format*,
  # *pending_message_format*, *failed_message_format*
  :line_separator => '\n', # since we are single line we need a separator
  :color_location => 'status-left-bg' # to customize which tmux

guard 'shell' do
  watch(/(.*).rb/) do |file|
    result = system("pushd proofs;suite")
    status = result ? "Passed" : "Failed"
    n "#{status}", "Proof Run", (result ? :success : :failed)
  end
end
