# frozen_string_literal: true

# It makes possible to print to HTML from a ruby process
class PrintChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'print_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
