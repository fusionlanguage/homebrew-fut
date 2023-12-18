class Fut < Formula
  desc "Fusion Transpiler"
  homepage "https://github.com/fusionlanguage/fut"
  url "https://github.com/fusionlanguage/fut/archive/refs/tags/fut-3.1.1.tar.gz"
  sha256 "2faa564936a9b1b53dacc3f2f9bcf88a4c4f3a0470258570875c3d24589ef4f2"
  license "GPL-3.0-or-later"
  head "https://github.com/fusionlanguage/fut.git", branch: "master"

  depends_on "gcc" => :build

  fails_with :clang do
    cause "Missing std::format"
  end

  def install
    system "make CXXFLAGS='-Wall -O2 -ld_classic'"
    bin.install "fut"
  end

  test do
    (testpath/"hello.fu").write <<~EOS
      public class HelloFu
      {
          public static string GetMessage()
          {
              return "Hello, world!";
          }
      }
    EOS
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "hello.h"

      int main()
      {
          puts(HelloFu_GetMessage());
      }
    EOS

    system "#{bin}/fut", "-o", "hello.c", "hello.fu"
    system ENV.cc, "-o", "test", "test.c", "hello.c"
    assert_equal "Hello, world!\n", shell_output("./test")
  end
end
