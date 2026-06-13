class Gush < Formula
  desc "Push code to GitHub in one command — no SSH keys, no tokens"
  homepage "https://gushpush.com"
  url "https://github.com/techytonys/Gush/archive/refs/tags/v1.5.tar.gz"
  sha256 "6fb091b05a0feba540cd81ef4946d6114f680879ac1779f46dee4406724b2e3f"
  version "1.5"
  license "MIT"

  depends_on "gh"

  def install
    bin.install "gush.sh" => "gush"
  end

  test do
    assert_match "push code to GitHub", shell_output("#{bin}/gush --help")
  end
end
