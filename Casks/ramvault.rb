cask "ramvault" do
  version "0.1.0"
  sha256 "d1eb11ad2083849630029a91cf6e09a43cd081f53af3f89115db64cfd903a867"

  url "https://github.com/nhz-io/ramvault/releases/download/v#{version}/ramvault-v#{version}-aarch64-apple-darwin.tar.gz"
  name "ramvault"
  desc "In-memory filesystem for short-lived credentials that ejects itself when idle"
  homepage "https://github.com/nhz-io/ramvault"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on cask: "macfuse"
  depends_on macos: :sonoma

  binary "ramvault"

  # The binary has no signature, thus Gatekeeper stops it after a download. Nothing else to set up:
  # `ramvault unlock` starts the vault on demand (launchd job outside ~/Library/LaunchAgents).
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{staged_path}/ramvault"]
  end

  uninstall launchctl: "io.nhz.ramvault"

  # ~/.config/ramvault (your config and profiles) is left alone.
  zap trash: [
    "~/Library/Application Support/ramvault",
    "~/Library/Logs/ramvault.err.log",
    "~/Library/Logs/ramvault.log",
    "~/Library/Logs/ramvault.log.1",
  ]
end
