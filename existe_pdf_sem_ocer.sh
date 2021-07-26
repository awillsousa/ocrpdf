find $1 -iname "*.pdf" -exec /home/administrador/scriptsutilitarios/ocr/pdf_tem_ocr.sh {} \; | sort | sed -n "/NAO_OCR/p" | sed 's/NAO_OCR: //g' > "./lista-pdfs-semocr.lst"
