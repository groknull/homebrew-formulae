class Skhd < Formula
  desc "Simple hotkey-daemon for macOS."
  homepage "https://github.com/koekeishiya/skhd"
  url "https://github.com/koekeishiya/skhd/archive/v0.0.6.zip"
  sha256 "aaafcaa35b7343f6aacd37ee83ca8a042916f35bc2630924cc9e8bdb9706b9b9"
  head "https://github.com/koekeishiya/skhd.git"

  option "with-logging", "Redirect stdout and stderr to log files"
  def install
    (var/"log/skhd").mkpath
    system "make", "install"
    bin.install "#{buildpath}/bin/skhd"
    (pkgshare/"examples").install "#{buildpath}/examples/skhdrc"
  end

  def caveats; <<-EOS.undent
    Copy the example configuration into your home directory:
        cp #{opt_pkgshare}/examples/khdrcrc ~/.khdrc

    If the formula has been built with --with-logging, logs will be found in
      #{var}/log/skhd/skhd.[out|err].log
    EOS
  end

  plist_options :manual => "skhd"

  if build.with? "logging"
      def plist; <<-EOS.undent
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/skhd</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
            <key>PATH</key>
            <string>#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
          </dict>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>StandardOutPath</key>
          <string>#{var}/log/skhd/skhd.out.log</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/skhd/skhd.err.log</string>
        </dict>
        </plist>
        EOS
      end
  else
      def plist; <<-EOS.undent
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/skhd</string>
          </array>
          <key>EnvironmentVariables</key>
          <dict>
            <key>PATH</key>
            <string>#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
          </dict>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
        </dict>
        </plist>
        EOS
      end
  end

  test do
    assert_match "skhd #{version}", shell_output("#{bin}/skhd --version")
  end
end