cask "credproxy" do
  version "0.5.0"
  sha256 "ae9863fe5161b11f6371275c9541aec45fc5bd2df7ead92c144dd36d3adf44b1"

  url "https://github.com/nhz-io/credproxy/releases/download/v#{version}/credproxy-v#{version}-aarch64-apple-darwin.tar.gz"
  name "credproxy"
  desc "Local proxy that adds age-sealed API keys to allowlisted requests"
  homepage "https://github.com/nhz-io/credproxy"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on formula: "age"
  depends_on macos: :sonoma

  binary "credproxy"

  # NOTE: intentionally the legacy `postflight` block (as se-agent): the steps sandbox redirects HOME, so
  # `credproxy install` couldn't write the LaunchAgent from inside it.
  # The binary has no signature, thus Gatekeeper stops it after a download.
  # Then (re)install the LaunchAgent through the stable /opt/homebrew/bin link, so upgrades don't leave launchd
  # pointing at a removed Caskroom version. Needs ~/.config/credproxy/config.toml; without it, run
  # `credproxy install` after writing the config.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{staged_path}/credproxy"]
    system_command "#{HOMEBREW_PREFIX}/bin/credproxy", args: ["install"], must_succeed: false
  end

  uninstall launchctl: "io.nhz.credproxy"

  # ~/.config/credproxy is left alone (your config; e.g. managed by chezmoi).
  zap trash: [
    "~/Library/Caches/credproxy",
    "~/Library/LaunchAgents/io.nhz.credproxy.plist",
    "~/Library/Logs/credproxy.err.log",
    "~/Library/Logs/credproxy.log",
    "~/Library/Logs/credproxy.log.1",
  ]
end
