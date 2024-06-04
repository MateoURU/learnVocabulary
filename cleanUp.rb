require 'json'


files = Dir.entries("./data")
files.slice!(0,2)

files.each do |file|
  # Lee el archivo JSON
  file_path = 'data/'+ file
  json_data = File.read(file_path)

  # Parsea el JSON a un objeto Ruby
  data = JSON.parse(json_data)

  # Elimina los elementos con MEANING igual a [] porque no todas las palabras en el diccionarios tenían MEANING.
  data.delete_if { |key,value| value['MEANINGS']["1"].nil? }

  # Guarda los cambios de nuevo en el archivo JSON
  File.open(file_path, 'w') do |file|
    file.write(JSON.pretty_generate(data))
  end
end

