# Script para buscar todos os arquivos PDF que não estão OCRizados, extrai o texto e gera
# um novo arquivo com OCR. 
PDFFILE="$1"
DIROUTPUT="$2"

PDFOCR="/sbin/pdfocr.rb"

echo "Verificando arquivo..."
if [ ! -f "$PDFFILE" ] 
then
    echo "Arquivo $PDFFILE NAO existe!" 
    exit 9999
else
    echo "Arquivo PDF OK!" 
fi

echo "Verificando diretorio de saida..."
if [ ! -d "$DIROUTPUT" ] 
then
    echo "Diretorio $DIROUTPUT NAO existe!" 
    exit 9999 
else
    echo "Diretorio de saida OK!"
fi

#DIRBASEINPUT=`dirname $PDFFILE`
DIRBASEINPUT=$(dirname "$PDFFILE")/
echo "verificação"
echo $DIRBASEINPUT
echo $DIROUTPUT
echo "verificação"
echo "Diretorio de saida do arquivo: $DIROUTPUT/${DIRBASEINPUT/#$DIROUTPUT}"
echo "Arquivo de saida do arquivo: $DIROUTPUT/${PDFFILE#$DIROUTPUT}"

# Se o diretorio de saida nao existe, crei-lo-ei-o
[ ! -d "$DIROUTPUT/${DIRBASEINPUT#$DIROUTPUT}" ] && mkdir -p "$DIROUTPUT/${DIRBASEINPUT#$DIROUTPUT}" 
# Chama o script ruby que faz a conversao
# TODO: Converter este script para shell
#exit 0
#if [ ! -f "$DIROUTPUT/${PDFFILE#$DIROUTPUT}" ]
#then
    $PDFOCR -l "por" -u -t -i "$PDFFILE" -o "$DIROUTPUT/${PDFFILE#$DIROUTPUT}"
#fi

