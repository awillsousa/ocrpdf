# Script para buscar todos os arquivos PDF que nÃ£o estÃ£o OCRizado
# gerando uma listagem e passando para o parallel processar atraves do script
# pdfdir2ocr_worker.sh  

DIRINPUT="$1"
DIROUTPUT="$2"
NMARQ="toocr/lista-pdfs-semocr`date +%Y%m%d%H%M%S`.lst"
LSTPDFS=${3:-$NMARQ}
DIRSCRIPT="/root/scripts/ocr"
PDFTEMOCR="/sbin/pdf_tem_ocr.sh"
CORES=$(nproc --all)
NUM_JOBS=$((CORES-CORES%3))  


## Para debug
#echo "NUM_JOBS: $NUM_JOBS"
#echo "NMARQ: $NMARQ"
#echo "LSTPDFS: $LSTPDFS"
#exit 0

if [ ! -d "$DIRINPUT" ] 
then
    echo "Arquivo $DIRINPUT NAO existe!" 
    exit 9999 
fi

if [ ! -d "$DIROUTPUT" ] 
then
    echo "Diretorio $DIROUTPUT NAO existe!" 
    exit 9999 
fi

if [ ! -f "$LSTPDFS" ]
then  # se nÃo existe a lista de arquivos, cria-la-ei-a
     find $DIRINPUT -iname "*.pdf" -exec $PDFTEMOCR {} \; | sort | sed -n "/NAO_OCR/p" | sed 's/NAO_OCR: //g' > "$DIRSCRIPT/$NMARQ"
else # se foi passada uma lista dos arquivos a processar, usa-la-ei-a
     cp "$LSTPDFS" "$DIRSCRIPT/$NMARQ"
fi

# Copia o arquivo com a lista de PDFs para OCR no diretorio de saida
cp "$DIRSCRIPT/$NMARQ" "$DIROUTPUT/"

if [ $? -eq 0 ]; then
   #cat "$DIRSCRIPT/$NMARQ" | parallel --tag -j $NUM_JOBS /sbin/pdfdir2ocr_worker.sh "{}" "$DIROUTPUT/"
   parallel -a "$DIRSCRIPT/$NMARQ" --tag -j $NUM_JOBS /sbin/pdfdir2ocr_worker.sh "{}" "$DIROUTPUT"
fi
