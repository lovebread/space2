require 'socket'
require 'rubygems'
require 'curb'
require 'cgi'

class Contacts

  class Msn < Base
    
    SERVER = 'messenger.hotmail.com'
    PORT = 1863
    NEXUS  = 'https://nexus.passport.com/rdr/pprdr.asp'
    SSH_LOGIN  = 'login.live.com/login2.srf'

    def real_connect
      @sock = TCPSocket::new(SERVER, PORT)
      @trID = 1
  
      output "VER 1 MSNP11 CVR0"          
      input
    end

    def contacts
    end

    def output data
      @sock.write data + '\r\n'
      @trID = @trID + 1
      puts ">>> #{data}"
    end

    def input
      str = @sock.recv(1000)
      puts "<<< #{str}"
      str
    end

  private
  
    TYPES[:msn] = Msn

  end

end
