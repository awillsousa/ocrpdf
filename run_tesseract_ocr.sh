#!/bin/bash
# Verificar se a entrada é fazia.
DIR_MONTAGEM="/opt/EVIDENCIAS/"
DIR_EVIDENCIAS="EVIDENCIAS/APREENSOES"
DIR_SCRIPTS="/opt/apps/bash/scriptsutilitarios/"
if [ -z "$1" ]
	then
		echo "Considere o direitório atual como $DIR_MONTAGEM$DIR_EVIDENCIAS. Assim insira somente o caminho a partir dos subdiretórios seguintes."
		echo ""
		echo "Uso: ./run_tesseract_ocr.sh <diretorio origim de dados>"
		echo ""
		echo "Exemplo: ./run_tesseract_ocr.sh FASE_52/PR_PR_00001111_2018/"
else
	echo "Executando..."
	#ls /dados/EXTRACAO/$1 /dados/OCR/
	sudo docker run -v $DIR_SCRIPTS:/root/scripts -v $DIR_MONTAGEM:/dados -v /mnt/RAMDISK/:/tmp ocrmachine:latest pdfdir2ocr_paralelo.sh /dados/$DIR_EVIDENCIAS/$1 /dados/OCR/
fi
