class Gush < Formula
  desc "Push code to GitHub in one command — no SSH keys, no tokens"
  homepage "https://gushpush.com"
  url "https://github.com/techytonys/Gush/archive/refs/tags/v1.4.tar.gz"
  sha256 "4adb733b86240a13ad7c56cf3db8ed491c4f64bdd76ef1d35f569a85b6e5fd1e"
  version "1.4"
  license "MIT"

  depends_on "gh"

  def install
    bin.install "gush.sh" => "gush"
  end

  test do
    assert_match "push code to GitHub", shell_output("#{bin}/gush --help")
  end
end
