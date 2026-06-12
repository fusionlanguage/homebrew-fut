class Fut < Formula
  desc "Fusion Transpiler"
  homepage "https://github.com/fusionlanguage/fut"
  url "https://github.com/fusionlanguage/fut/archive/refs/tags/fut-3.3.4.tar.gz"
  sha256 "ecfe8562dd653ca82eb39c531de47d34fe8624fac3f6d70573eb9ff1777fdb8d"
  license "GPL-3.0-or-later"
  head "https://github.com/fusionlanguage/fut.git", branch: "master"

  def install
    system "make CXXFLAGS='-std=c++20 -Wall -O2'"
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
