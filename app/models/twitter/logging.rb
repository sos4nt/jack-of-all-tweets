module Twitter

  # Including this module adds logging capabilities to a class.
  # @example
  #   class Twitter::SomeClass
  #     include Logging
  #     def some_method
  #        info "some method called"
  #     end
  #   end
  module Logging

    include Term::ANSIColor

    def logger
      @logger ||= Twitter::API.logger
    end

    protected

    # Taken from ActiveSupport::LogSubscriber
    %w(info debug warn error fatal unknown).each do |level|
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{level}(progname = nil, &block)
          logger.#{level}(progname, &block) if logger
        end
      METHOD
    end

  end

end
