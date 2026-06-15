class Gush < Formula
  desc "Push code to GitHub in one command"
  homepage "https://gushpush.com"
  url "https://raw.githubusercontent.com/techytonys/Gush/main/gush.sh"
  version "2.1"
  sha256 "1fa10d367a8f2e91ac359aef699978a8bfcca66ddc8bae4c86efb35ffa2538aa"

  depends_on "gh"

  def install
    bin.install "gush.sh" => "gush"
  end

  test do
    system "#{bin}/gush", "--version"
  end
end