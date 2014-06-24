module GitHooks
  module PreCommit
    class PreventMaster
      def validate
        return unless `git rev-parse --abbrev-ref HEAD`.strip == 'master'

        abort 'Prevented to commit on master'
      end
    end
  end
end
