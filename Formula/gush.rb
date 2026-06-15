class Gush < Formula
  desc "Push code to GitHub in one command"
  homepage "https://gushpush.com"
  url "https://raw.githubusercontent.com/techytonys/Gush/main/gush.sh"
  version "2.4"
  sha256 "4cdc9caa74d55be162d1e45dfff13a96d34e9121bd665156d6759d55e470ecb0"

  depends_on "gh"

  def install
    bin.install "gush.sh" => "gush"
  end

  test do
    system "#{bin}/gush", "--version"
  end
end