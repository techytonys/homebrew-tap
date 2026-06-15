class Gush < Formula
  desc "Push code to GitHub in one command"
  homepage "https://gushpush.com"
  url "https://raw.githubusercontent.com/techytonys/Gush/main/gush.sh"
  version "2.5"
  sha256 "6a836bf6b299f5ceb6f525927f5d1e30117202fdf73df85966cabb3a6afdc166"

  depends_on "gh"

  def install
    bin.install "gush.sh" => "gush"
  end

  test do
    system "#{bin}/gush", "--version"
  end
end