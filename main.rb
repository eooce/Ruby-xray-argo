File.chmod(0o777, './start.sh')

system('./start.sh')

require 'webrick'

root = File.expand_path('.')
server = WEBrick::HTTPServer.new BindAddress: '0.0.0.0', Port: 3000, DocumentRoot: root

server.mount_proc '/' do |_req, res|
  res.body = 'Hello world'
end

# sub route
server.mount_proc '/sub' do |_req, res|
  file_path = File.join(root, 'temp', 'sub.txt')
  if File.exist?(file_path)
    content = File.read(file_path, encoding: 'utf-8')
    res['Content-Type'] = 'text/plain; charset=utf-8'

    res.body = content
  else
    res.status = 404
    res.body = 'File not found'
  end
end

# Ctrl+C Stop the server on interruption
trap('INT') { server.shutdown }

server.start
