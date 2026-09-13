cask "kbsw" do
  version "0.1.1"
  sha256 "4b06700eff71fb5026432c9140af1f25df77efb2a014a957a27cc9508c11c3f4"

  url "https://github.com/nhz-io/kbsw/releases/download/v#{version}/kbsw-#{version}-macos-aarch64.zip"
  name "kbsw"
  desc "Launch and switch macOS apps with global keyboard shortcuts"
  homepage "https://github.com/nhz-io/kbsw"

  depends_on :macos

  app "kbsw.app"
  binary "kbsw.app/Contents/MacOS/kbsw"

  # NOTE: intentionally the legacy `postflight` block, not `postflight_steps`:
  # the steps sandbox redirects HOME, so `kbsw install` cannot deploy the
  # launch agent from inside it (launchctl bootstrap fails with EIO).
  postflight do
    system_command "xattr", args: ["-cr", "#{appdir}/kbsw.app"]
    # Deploy the runtime copy to ~/Applications and (re)start the launch
    # agent, so upgrades don't leave a stale agent running the old binary.
    system_command "#{appdir}/kbsw.app/Contents/MacOS/kbsw",
                   args: ["install", "--force"]
  end

  uninstall launchctl: "io.nhz.kbsw.agent",
            trash:     "~/Applications/kbsw.app"

  zap trash: [
    "~/.config/kbsw",
    "~/Library/LaunchAgents/io.nhz.kbsw.agent.plist",
    "~/Library/Logs/kbsw.log",
  ]
end
