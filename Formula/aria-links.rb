class AriaLinks < Formula
  desc "Aria Links from your terminal — one named short link per placement, verified real clicks only"
  homepage "https://justaskaria.com"
  url "https://github.com/techytonys/aria-links-cli/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "866ad9d1efbe4a968db0c944e9ce355578e76709a42bd51140a8185a76bdc18a"
  license "MIT"

  depends_on "node"

  def install
    libexec.install "aria-links.js"
    (bin/"aria-links").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/aria-links.js" "$@"
    EOS
    chmod 0755, bin/"aria-links"
  end

  test do
    assert_match "aria-links", shell_output("#{bin}/aria-links --help")
  end
end
