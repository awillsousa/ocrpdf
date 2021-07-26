APP_SH=run_tesseract.sh
APP_PY=run_tesseract.py

echo "Apagando o comando $APP_SH $APP_PY "
echo sudo rm /sbin/$APP_SH
sudo rm /sbin/$APP_SH

echo sudo rm /sbin/$APP_PY
sudo rm /sbin/$APP_PY

echo "Criando links simbólicos: "
echo ln -s /opt/apps/bash/scriptsutilitarios/ocr/$APP_SH /sbin/
sudo ln -s /opt/apps/bash/scriptsutilitarios/ocr/$APP_SH /sbin/

echo ln -s /opt/apps/bash/scriptsutilitarios/ocr/$APP_PY /sbin/
sudo ln -s /opt/apps/bash/scriptsutilitarios/ocr/$APP_PY /sbin/

