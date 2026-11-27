class AriaLinks < Formula
  desc "One named short link per placement, verified real clicks only"
  homepage "https://justaskaria.com"
  url "https://github.com/techytonys/aria-links-cli/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "266cb53522cdf7e15cff7d7b3d4e55a27bc1daff80fc19f550c9365ece6f3f4f"
  license "MIT"

  depends_on "node"

  def install
    libexec.install "aria-links.js"
    (bin/"aria-links").write <<~EOS
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/aria-links.js" "$@"
    EOS
    chmod 0755, bin/"aria-links"
  end

  test do
    assert_match "aria-links", shell_output("#{bin}/aria-links --help")
  end
end
