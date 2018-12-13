require 'webrick/https'

module Sinatra
  class Application
    def self.run!
      certificate_content = File.open('cert.crt').read
      key_content = File.open('pkey.pem').read

      server_options = {
        :Host => bind,
        :Port => port,
        :SSLEnable => true,
        :SSLCertificate => OpenSSL::X509::Certificate.new(certificate_content),
        :SSLPrivateKey => OpenSSL::PKey::RSA.new(key_content, '123456') # private key passphrase
      }

      Rack::Handler::WEBrick.run self, server_options do |server|
        [:INT, :TERM].each { |sig| trap(sig) { server.stop } }
        server.threaded = settings.threaded if server.respond_to? :threaded=
        set :running, true
      end
    end
  end
end
