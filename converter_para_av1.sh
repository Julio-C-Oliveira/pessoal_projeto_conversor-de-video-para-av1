#!/bin/bash

# Pra caso não tenha os parametros
if [ $# -eq 0 ]; then
    echo "Erro: Nenhum arquivo fornecido." >&2
    echo "Uso: $0 <nome_do_arquivo>" >&2
    exit 1
elif [ $# -gt 1 ]; then
    echo "Erro: Passe apenas 1 arquivo." >&2
    echo "Uso: $0 <nome_do_arquivo>" >&2
    exit 1
fi

# ENTRADAS:
original_filename="$1"

# O % Pega a primeira ocorrência de algo e elimina. O .* é a ocorrência. 
filename="${original_filename%.*}"

new_filename="${filename}.mkv"

# Mostra o nome dos arquivos
echo "$original_filename"
echo "$new_filename"

ffmpeg -i "$original_filename" \
       -c:v libaom-av1 -crf 18 -cpu-used 2 \
       -row-mt 1 -tile-columns 2 -tile-rows 2 \
       -enable-cdef 1 -c:a libopus -b:a 192k \
       "$new_filename"
