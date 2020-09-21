#!/usr/bin/env ruby
# Script basico para enviar informacoes via chamada telefonica

require 'net/http'
require 'uri'

# usuario e senha:
user = 'SUA_SENHA_AQUI'
pass = 'SEU_USER_AQUI'
# velip URL API:
velip_url = 'vox.velip.com.br'

# lista de destinos (ideal que extaido de uma ferramenta externa, como ITSM)
destinations = [
  '11964656894'
]

# Mensagem utilizada
mensagem = '\pause=300 Oi, esse é um teste simples de ligação. Até mais!'
message_encoded = URI::encode(mensagem)

# Esses ids podem ser enviados para Velip para utilização futura,
#    como validacao do tempo de ligacao, relatorios, etc...
ctid = 1
cpid = 2

# passando por toda a lista de destinos
destinations.each do |destination|
  puts "Enviando mensagem \"#{mensagem}\" para destino \"#{destination}\""

  # Contruindo URL
  uri = URI.parse(
    "http://#{velip_url}/pop/torpedo/MakeTTSCall.php?"\
    "type=0"\
    "&encoding=UTF-8"\
    "&setbrasil=1"\
    "&user=#{user}"\
    "&password=#{pass}"\
    "&ringtime=26"\
    "&text=#{message_encoded}"\
    "&ctid=#{ctid}"\
    "&cpid=#{cpid}"\
    "&dest=#{destination}"
  )
  request = Net::HTTP::Post.new(uri)
  req_options = {
    use_ssl: uri.scheme == "https",
  }
  # Realizando POST
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  puts "  Return code: \"#{response.code}\""
  puts "  Return body: \"#{response.body}\""
end
