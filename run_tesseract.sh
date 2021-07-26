#!/bin/bash

BASE_EVIDENCIAS=/opt/VOL_EVIDENCIAS/EVIDENCIAS/
#BASE_EVIDENCIAS=/opt/VOL_EVIDENCIAS/TESTE_COPIA_EVIDENCIAS/

#INPUT_DIR=/APREENSOES/FASE_52/PR_PR_00088888_2019/LAUDO_487_2019/Item_1
#OUTPUT_DIR=/APREENSOES/FASE_52/PR_PR_00088888_2019/LAUDO_487_2019/Item_1

INPUT_DIR=$1
OUTPUT_DIR=$2

#sudo docker run -v /opt/apps/bash/scriptsutilitarios/:/root/scripts -v $BASE_EVIDENCIAS:/EVIDENCIAS -v /mnt/RAMDISK/:/tmp ocrmachine:latest pdfdir2ocr_paralelo.sh /EVIDENCIAS/$INPUT_DIR /EVIDENCIAS/TMP/$OUTPUT_DIR
sudo docker run -v /opt/apps/bash/scriptsutilitarios/:/root/scripts -v $BASE_EVIDENCIAS:/EVIDENCIAS -v /mnt/RAMDISK/:/tmp ocrmachine:latest pdfdir2ocr_paralelo.sh /EVIDENCIAS/$INPUT_DIR /EVIDENCIAS/$OUTPUT_DIR/TMP

rsync -avz $BASE_EVIDENCIAS/$OUTPUT_DIR/TMP/ $BASE_EVIDENCIAS/$OUTPUT_DIR

SIZE_TMP=$(du -sh $BASE_EVIDENCIAS/$OUTPUT_DIR/TMP/ | awk '{print $1}')
SIZE_COPY=$(du -sh $BASE_EVIDENCIAS/$OUTPUT_DIR | awk '{print $1}')

echo "Tamanho do TMP(OCRizado): $SIZE_TMP"
echo "Tamanho base original: $SIZE_COPY"

#if [ "$SIZE_TMP" == "$SIZE_COPY" ]
#then
echo "Apagando o TMP:"
rm -R $BASE_EVIDENCIAS/$OUTPUT_DIR/TMP
#fi
