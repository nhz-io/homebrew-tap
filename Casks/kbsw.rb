cask "kbsw" do
  version "0.1.1"
  sha256 "4b06700eff71fb5026432c9140af1f25df77efb2a014a957a27cc9508c11c3f4"

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
