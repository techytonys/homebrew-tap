class Gush < Formula
  desc "Push code to GitHub in one command"
  homepage "https://gushpush.com"
  url "https://raw.githubusercontent.com/techytonys/Gush/main/gush.sh"
  version "2.4"
  sha256 "92c8128136cb3be929b94095fcc4f642ea578e0accd0edfa8d1641b1e0ea7740"

  depends_on "gh"

  def install
    bin.install "gush.sh" => "gush"
  end

  test do
    system "#{bin}/gush", "--version"
  end
end