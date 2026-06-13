class Gush < Formula
  desc "Push code to GitHub in one command — no SSH keys, no tokens"
  homepage "https://gushpush.com"
  url "https://github.com/techytonys/Gush/archive/refs/tags/v1.6.tar.gz"
  sha256 "d816926c0976fa81a300cae4923f9f35baae07f69828bb06fbb2d0aba48f83bb"
  version "1.6"
  license "MIT"

  depends_on "gh"

  def install
    bin.install "gush.sh" => "gush"
  end

  test do
    assert_match "push code to GitHub", shell_output("#{bin}/gush --help")
  end
end
