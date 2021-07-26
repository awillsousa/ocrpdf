#!/bin/bash
# Verificar se a entrada é fazia.
BASE_PADRAO="/opt/EVIDENCIAS/"
INPUT_PADRAO="$BASE_PADRAO/EVIDENCIAS/APREENSOES"
OUTPUT_PADRAO="$BASE_PADRAO/OCR"
DIR_SCRIPTS="/opt/apps/bash/scriptsutilitarios/"
LOGS="$DIR_SCRIPTS/logs"
ARQ_LOG="ocr_`date +%Y%m%d%H%M%S`.log"
ARQ_LOG_ERROS="ocr_`date +%Y%m%d%H%M%S`.err"
DIR_INPUT=${1:-$INPUT_PADRAO}
DIR_OUTPUT=${2:-$OUTPUT_PADRAO}
ARQ_LST_PDFS="$3"

display_help() {
		# Utilizacao default
		echo ""
		echo "Para realização de OCR em arquivos de evidencias: "
		echo "Considere o direitório atual como $INPUT_PADRAO."
		echo "Assim insira somente o caminho a partir dos subdiretórios seguintes."
		echo ""
		echo "Uso: ./run_tesseract_ocr.sh <diretorio origem de dados>"
		echo "Exemplo: ./run_tesseract_ocr.sh FASE_52/PR_PR_00001111_2018/"
		echo "Os arquivos convertidos estarão em : $OUTPUT_PADRAO "
		echo ""
		# Utilizacao customizada
		echo "Para realização de OCR em qualquer arquivo com diretorios de entrada e saida customizados: "
		echo ""
		echo "Uso: ./run_tesseract_ocr.sh <diretorio origem de dados> <diretorio de saida> <lista de arquivos a converter>(opcional)"
		echo "Exemplo: ./run_tesseract_ocr.sh /dados/FASE_52/PR_PR_00001111_2018/ /output/" 
		echo "Os arquivos convertidos estarão em : /output"

		exit 1
}

display_dirs() {
		echo "Diretório de entrada: $DIR_INPUT"	
		echo "Diretório de saida: $DIR_OUTPUT"	
		echo "Arquivo de arquivos a ocrizar: $ARQ_LST_PDFS"	
}


if [ "$1" == "-h" ] || [ -z "$1" ]; then
   display_help
fi

if [ ! -z "$1" ]; then
	
	# Se foi passado um arquivo com os arquivos a ocrizar
	# use-le-ei-o	
	if [ ! -z "$2" ] && [ -f "$2" ]; then   # segundo argumento e o arquivo com a lista de pdfs
           ARQ_LST_PDFS="$2"
	   DIR_INPUT="$BASE_PADRAO/EVIDENCIAS"   
           DIR_OUTPUT="$BASE_PADRAO/OCR"   
	elif [ -z "$2" ]; then   # passado apenas o primeiro argumento
           ARQ_LST_PDFS=""
	   DIR_INPUT="$BASE_PADRAO/EVIDENCIAS"   
           DIR_OUTPUT="$BASE_PADRAO/OCR"   
	elif [ ! -z "$3" ] && [ -f "$3" ]; then # terceiro argumento e um arquivo com a lista de pdfs
	   ARQ_LST_PDFS="$3"
	   DIR_INPUT="$1"
           DIR_OUTPUT="$2"
	else			# passados primeiro e segundo argumento, mas nao o terceiro
           ARQ_LST_PDFS=""	
	   DIR_INPUT="$1"
           DIR_OUTPUT="$2"
	
	fi

	echo $DIR_SCRIPTS:/root/scripts -v $DIR_INPUT:/dados -v /mnt/RAMDISK/:/tmp ocrmachine:latest pdfdir2ocr_paralelo.sh "/dados/$DIR_INPUT" "/dados/$DIR_OUTPUT/" "$ARQ_LST_PDFS" > "$LOGS/$ARQ_LOG" 2>"$LOGS/$ARQ_LOG_ERROS"
	# Chamada do comando dentro do docker para realizar ocrizacao
	if [ -d "$DIR_INPUT/$1" ]; then      
	   display_dirs   # Exibe os diretorios de entrada e saida
	   sudo docker run -v $DIR_SCRIPTS:/root/scripts -v $DIR_INPUT:/dados -v /mnt/RAMDISK/:/tmp ocrmachine:latest pdfdir2ocr_paralelo.sh "/dados/$DIR_INPUT" "/dados/$DIR_OUTPUT/" "$ARQ_LST_PDFS" > "$LOGS/$ARQ_LOG" 2>"$LOGS/$ARQ_LOG_ERROS"
        else
	   echo "Diretorio de dados NÃO EXISTE!"
           exit 0
        fi
fi

#exit 0
