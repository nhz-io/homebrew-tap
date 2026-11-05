cask "se-agent" do
  version "0.2.0"
  sha256 "6981c79d1ad6e0792248853257d34ec503548a05e7be63c8e47b852ba2ba723b"

  url "https://github.com/nhz-io/se-agent/releases/download/v#{version}/se-agent-v#{version}-aarch64-apple-darwin.tar.gz"
  name "se-agent"
  desc "SSH agent with Secure Enclave keys, Touch ID or login password"
  homepage "https://github.com/nhz-io/se-agent"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :sonoma

  binary "se-agent"

  # NOTE: intentionally the legacy `postflight` block, not `postflight_steps`:
  # the steps sandbox redirects HOME, so `se-agent install` cannot deploy the
  # launch agent from inside it (launchctl bootstrap fails with EIO).
  # The binary has no signature, thus Gatekeeper stops it after a download.
  # Then (re)start the LaunchAgent through the stable /opt/homebrew/bin symlink,
  # so upgrades don't leave the old binary running.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{staged_path}/se-agent"]
    system_command "#{HOMEBREW_PREFIX}/bin/se-agent", args: ["install"]
  end

  uninstall launchctl: "io.nhz.se-agent"

  # ~/.se-agent is deliberately not zapped: it holds the Secure Enclave key blobs,
  # and a deleted key can never be recovered. Remove it by hand with `se-agent delete`.
  zap trash: [
    "~/Library/Caches/se-agent",
    "~/Library/LaunchAgents/io.nhz.se-agent.plist",
    "~/Library/Logs/se-agent.err.log",
    "~/Library/Logs/se-agent.log",
  ]
end
