class Fut < Formula
  desc "Fusion is a programming language which can be translated automatically to C, C++, C#, D, Java, JavaScript, Python, Swift, TypeScript and OpenCL C. Instead of writing code in all these languages, you can write it once in Fusion."
  homepage "https://github.com/fusionlanguage/fut"
  url "https://github.com/fusionlanguage/fut/releases/tag/fut-3.0.0.tar.gz"
  sha256 ""
  license "GPL-3.0-or-later" 
  head "https://github.com/fusionlanguage/fut.git", branch: "master"

  fails_with :clang do
    cause "Missing std::format"
  end

  depends_on "gcc" => :build

  def install
    system "make"
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
