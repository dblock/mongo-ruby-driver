# Copyright (C) 2015 MongoDB, Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module Mongo
  class Monitoring

    # Subscribes to command events and logs them.
    #
    # @since 2.1.0
    class CommandLogSubscriber

      # Constant for the max number of characters to print when inspecting
      # a query field.
      #
      # @since 2.1.0
      LOG_STRING_LIMIT = 250

      # Handle the command started event.
      #
      # @example Handle the event.
      #   subscriber.started(event)
      #
      # @param [ CommandStartedEvent ] event The event.
      #
      # @since 2.1.0
      def started(event)
        if Logger.logger.debug?
          log("#{prefix(event)} | STARTED | #{format(event.command)}")
        end
      end

      # Handle the command succeeded event.
      #
      # @example Handle the event.
      #   subscriber.succeeded(event)
      #
      # @param [ CommandSucceededEvent ] event The event.
      #
      # @since 2.1.0
      def succeeded(event)
        if Logger.logger.debug?
          log("#{prefix(event)} | SUCCEEDED | #{event.duration}s")
        end
      end

      # Handle the command failed event.
      #
      # @example Handle the event.
      #   subscriber.failed(event)
      #
      # @param [ CommandFailedEvent ] event The event.
      #
      # @since 2.1.0
      def failed(event)
        if Logger.logger.debug?
          log("#{prefix(event)} | FAILED | #{event.message} | #{event.duration}s")
        end
      end

      private

      def format(args)
        ((s = args.inspect).length > LOG_STRING_LIMIT) ? "#{s[0..LOG_STRING_LIMIT]}..." : s
      rescue ArgumentError
        '<Unable to inspect arguments>'
      end

      def log(message)
        Logger.logger.debug(message)
      end

      def prefix(event)
        "MONGODB | #{event.address.to_s} | #{event.database_name}.#{event.command_name}"
      end
    end
  end
end
