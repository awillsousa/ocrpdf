# Script para buscar todos os arquivos PDF que não estão OCRizados, extrai o texto e gera
# um novo arquivo com OCR. 
DIRINPUT=$1
DIROUTPUT=$2
PDF_TEM_OCR="/sbin/pdf_tem_ocr.sh"
PDFOCR="/sbin/pdfocr.rb"
#DIRBASEINPUT=""

if [ ! -d "$DIRINPUT" ] 
then
    echo "Diretorio $DIRINPUT nao existe!" 
    exit 9999 
fi

if [ ! -d "$DIROUTPUT" ] 
then
    echo "Diretorio $DIROUTPUT nao existe!" 
    exit 9999 
fi

# Itera um diretorio, verifica os arquivos que não estao ocrizados e gera uma versão ocrizada
for PDFFILE in $(find $DIRINPUT -iname "*.pdf" -exec $PDF_TEM_OCR {} \; | sort | sed -n "/NAO_OCR/p" | sed 's/NAO_OCR: //g'); do 
#for PDFFILE in $(cat lista-pdfs-semocr.lst); do
   DIRBASEINPUT=`dirname $PDFFILE`
   # Se o diretorio de saida nao existe, crei-lo-ei-o
   [ ! -d "$DIROUTPUT/$DIRBASEINPUT" ] && mkdir -p "$DIROUTPUT/$DIRBASEINPUT"
   # Chama o script ruby que faz a conversao
   # TODO: Converter este script para shell ou python
   if [ ! -f "$DIROUTPUT/$PDFFILE" ]
   then
        $PDFOCR -l "por" -u -t -i "$PDFFILE" -o "$DIROUTPUT/$PDFFILE"  
   fi
   ###echo "$PDFOCR -l por -u -t -i $PDFFILE -o $DIROUTPUT/$PDFFILE"  #para testar exibicao do comando 
done

