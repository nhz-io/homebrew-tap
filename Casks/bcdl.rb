cask "bcdl" do
  arch arm: "aarch64", intel: "x86_64"

  version "2.0.0"
  sha256 arm:   "207ff8c2748a9367dff07dfb9b4df8307240fdb14d53bfda3600b64962801abe",
         intel: "85fedd23388a9cfdafa4d29785cc5a3671e8ffaf74744543e2f5528f15879319"

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
