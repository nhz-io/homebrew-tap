cask "bcdl" do
  arch arm: "aarch64", intel: "x86_64"

  version "2.0.2"
  sha256 arm:   "15a6ee25bc68b0da039924156bb15413e229666d4043bd72fb4f339ead754c2d",
         intel: "6adb30a0512347100c2d522623b6a4f8dd53e9be17a56a20f58fbe541bd927b5"

  url "https://github.com/nhz-io/bandcamp-downloader/releases/download/v#{version}/bcdl-v#{version}-#{arch}-apple-darwin.tar.gz"
  name "bcdl"
  desc "Download and keep a Bandcamp collection"
  homepage "https://github.com/nhz-io/bandcamp-downloader"

  livecheck do
    url :url
    strategy :github_latest
  end

  binary "bcdl"

  # The binary has no signature, thus Gatekeeper stops it after a download
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{staged_path}/bcdl"]
  end

  # There is no zap stanza. bcdl keeps its record in the directory with your
  # music, and that directory is your library. A zap must never delete it.
end
