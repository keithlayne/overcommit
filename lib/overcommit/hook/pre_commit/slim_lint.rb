module Overcommit::Hook::PreCommit
  # Runs `slim-lint` against any modified Slim templates.
  #
  # @see https://github.com/sds/slim-lint
  class SlimLint < Base
    MESSAGE_TYPE_CATEGORIZER = lambda do |type|
      type.include?('W') ? :warning : :error
    end

    def run
      result = execute(command, args: applicable_files)
      return :pass if result.success?

      output = result.stdout.split("\n").reject { |line| line =~ /^\(.*\)$/ }

      extract_messages(
        output,
        /^(?<file>(?:\w:)?[^:]+):(?<line>\d+)[^ ]* (?<type>[^ ]+)/,
        MESSAGE_TYPE_CATEGORIZER,
      )
    end
  end
end
