cask "kbsw" do
  version "0.1.0"
  sha256 "26b79b4a95016cbdc60d967b4839afefc960337a53055375ae5419bfd751fb61"

  url "https://github.com/nhz-io/kbsw/releases/download/v#{version}/kbsw-#{version}-macos-aarch64.zip"
  name "kbsw"
  desc "Launch and switch macOS apps with global keyboard shortcuts"
  homepage "https://github.com/nhz-io/kbsw"

  app "kbsw.app"

  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/kbsw.app"]
  end

  zap trash: [
    "~/Library/LaunchAgents/io.nhz.kbsw.agent.plist",
    "~/Library/Logs/kbsw.log",
    "~/.config/kbsw",
  ]
end
