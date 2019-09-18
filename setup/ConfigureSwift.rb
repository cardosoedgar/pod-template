module Pod

  class ConfigureSwift
    attr_reader :configurator

    def self.perform(options)
      new(options).perform
    end

    def initialize(options)
      @configurator = options.fetch(:configurator)
    end

    def perform
      keep_demo = "Yes".to_sym

      configurator.add_pod_to_podfile "Quick', '~> 2.1.0"
      configurator.add_pod_to_podfile "Nimble', '~> 8.0.2"
      configurator.add_pod_to_podfile "Nimble-Snapshots', '~> 7.1.0"

      Pod::ProjectManipulator.new({
        :configurator => @configurator,
        :xcodeproj_path => "templates/swift/Example/PROJECT.xcodeproj",
        :platform => :ios,
        :remove_demo_project => (keep_demo == :no),
        :prefix => "C6"
      }).run

      `mv ./templates/swift/* ./`

      # There has to be a single file in the Classes dir
      # or a framework won't be created
      `touch Pod/Classes/ReplaceMe.swift`

      # remove podspec for osx
      `rm ./NAME-osx.podspec`
    end
  end

end
