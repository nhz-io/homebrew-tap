cask "bcdl" do
  arch arm: "aarch64", intel: "x86_64"

  version "2.0.0"
  sha256 arm:   "5354b2f2359efc22248c9a1a8906f2efd4972114632ccdaab8b8faed780a7f4d",
         intel: "8e8c1b4085bc9a495690a188cfb1ddff5baeac1c1fea8ffaf9be6b2b1cddc888"

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
