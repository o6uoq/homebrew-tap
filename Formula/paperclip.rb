require "language/node"

class Paperclip < Formula
  desc "Open-source orchestration for zero-human companies"
  homepage "https://github.com/paperclipai/paperclip"
  url "https://registry.npmjs.org/paperclipai/-/paperclipai-2026.609.0.tgz"
  sha256 "66078b6d1970e1fc5a1cf24c213a2c70940a145f04f92f30a0d12bb7614c31b2"
  license "MIT"

  # Tap-only until upstream provides a Homebrew formula.

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    (libexec/"lib/node_modules/paperclipai/node_modules/@embedded-postgres").children.each do |package|
      next unless (package/"native/pg-symlinks.json").exist?

      cd package do
        system "node", "scripts/hydrate-symlinks.js"
      end
    end
    cd libexec/"lib/node_modules/paperclipai" do
      system "npm", "rebuild", "sqlite3", "--devdir=#{buildpath/".node-gyp"}"
    end
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/paperclipai --version")
    system "node", "-e", "require('#{libexec}/lib/node_modules/paperclipai/node_modules/sqlite3')"
    initdb = (libexec/"lib/node_modules/paperclipai/node_modules/@embedded-postgres").glob("*/native/bin/initdb").first
    refute_nil initdb
    system initdb, "--version"
  end
end
