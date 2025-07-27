#!/bin/bash

# Pra caso não tenha os parametros
if [ $# -eq 0 ]; then
	echo "Erro: Nenhum arquivo fornecido." >&2
	echo "Uso: $0 <nome_do_arquivo> <precisao_do_corte> <inicio_do_corte> <fim_do_corte>" >&2
	echo "Precisão de corte: 0 = desabilitado, 1 = habilitado"
	echo "Formato de tempo <00:00:00.000> ou <00:00:00>"
	exit 1
elif [ $# -ne 4  ]; then
	echo "Erro: Passe exatos 4 argumentos." >&2
	echo "Uso: $0 <nome_do_arquivo> <precisao_do_corte> <inicio_do_corte> <fim_do_corte>" >&2
	echo "Precisão de corte: 0 = desabilitado, 1 = habilitado"
	echo "Formato de tempo <00:00:00.000> ou <00:00:00>"
	exit 1
fi

# ENTRADAS:
original_filename="$1"
cut_precision="$2"
start_point="$3"
end_point="$4"

# O % Pega a primeira ocorrência de algo e elimina. O .* é a ocorrência. 
filename="${original_filename%.*}"

new_filename="${filename}_cut.mkv"

# Mostra o nome dos arquivos
echo "$original_filename"
echo "$new_filename"

# Seleciona o corte preciso ou mais rápido
if [ "$cut_precision" -eq 0 ]; then
	ffmpeg -ss "$start_point" -to "$end_point" \
		-i "$original_filename" \
		-c:v libaom-av1 -crf 18 -cpu-used 2 \
		-row-mt 1 -tile-columns 2 -tile-rows 2 \
		-enable-cdef 1 -c:a libopus -b:a 192k \
		"$new_filename"
else
	ffmpeg -i "$original_filename" \
		-ss "$start_point" -to "$end_point" \
		-c:v libaom-av1 -crf 18 -cpu-used 2 \
		-row-mt 1 -tile-columns 2 -tile-rows 2 \
		-enable-cdef 1 -c:a libopus -b:a 192k \
		"$new_filename"
fi
