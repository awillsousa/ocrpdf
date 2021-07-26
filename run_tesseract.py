#!/usr/bin/python3
# -*- Coding: UTF-8 -*-
# coding: utf-8
# Copia arquivos a partir da lista de arquivos do IPED em diretorios de suas
# respectivas categorias

import csv
import argparse
import os
import subprocess
import shutil
from pathlib import Path

FLAGS = None

'''
Sample SH
BASE_EVIDENCIAS=/opt/VOL_EVIDENCIAS/EVIDENCIAS/

#INPUT_DIR=/APREENSOES/FASE_52/PR_PR_00088888_2019/LAUDO_487_2019/Item_1
#OUTPUT_DIR=/APREENSOES/FASE_52/PR_PR_00088888_2019/LAUDO_487_2019/Item_1

INPUT_DIR=$1
OUTPUT_DIR=$2

echo sudo docker run -v /opt/apps/bash/scriptsutilitarios/:/root/scripts -v $BASE_EVIDENCIAS:/EVIDENCIAS -v $BASE_EVIDENCIAS:/EVIDENCIAS -v /mnt/RAMDISK/:/tmp ocrmachine:latest pdfdir2ocr_paralelo.sh /EVIDENCIAS/$INPUT_DIR /EVIDENCIAS/.$

'''

CMD_RUN_TESSERACT = 'run_tesseract.sh'
BASE_EVIDENCIAS = '/opt/VOL_EVIDENCIAS/EVIDENCIAS/'


class EvidenciaCall(object):

    def call_cmd(self, args):
        process = subprocess.Popen(
            args,
            # shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT)

        # Previne o buffer overflow
        result_list = []
        while True:
            line = process.stdout.readline()
            if not line: break
            line_str = line.decode("utf-8")[:len(line) - 1]
            result_list.append(line_str)

        return result_list

    def run_tesseract(self,
                      cmd=CMD_RUN_TESSERACT,
                      dir_origem=None,
                      dir_destino=None,
                      debug=False):

        cmd = ['%s' % cmd,
               '%s' % dir_origem,
               '%s' % dir_destino]

        print("Comando: %s " % " ".join(cmd))

        if not debug:
            return self.call_cmd(cmd)


def main():
    print("Aplicacao principal")

    call = EvidenciaCall()
    print(vars(FLAGS))

    if None in [FLAGS.dir_origem, FLAGS.dir_destino] and None in [FLAGS.absolute_dir]:
        print("Parâmetro ausente!")

        print("Use: run_tesseract.py --dir-origem <Diretorios origem> --dir-destino <Diretorio destino>")
        print("Ou Use: run_tesseract.py --absolute-dir <Diretorio destino>")

        print("Argumentos <--origem e --destino> ou  < --absolute-dir > são obrigatórios!")

        os.sys.exit(1)

    else:
        dir_origem = None
        dir_destino = None

        if None in [FLAGS.absolute_dir]:
            print("Origem --dir-origem: %s | Destino --dir-destino:%s" % (FLAGS.dir_origem, FLAGS.dir_destino))
            dir_origem = FLAGS.dir_origem
            dir_destino = FLAGS.dir_destino
        else:
            obj_base_evidencias = Path(BASE_EVIDENCIAS)

            relative_dir = Path(FLAGS.absolute_dir).relative_to(str(obj_base_evidencias))
            dir_origem = str(relative_dir)
            dir_destino = str(relative_dir)

            print("Origem --absolute-dir: %s " % (FLAGS.absolute_dir))

        result = call.run_tesseract(dir_origem=dir_origem,
                           dir_destino=dir_destino,
                           debug=FLAGS.debug)
        print(result)

        # result_list.append(line.decode("utf-8"))

        print("Encerrado.")
        os.sys.exit(1)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()

    parser.add_argument(
        '--absolute-dir',
        type=str,
        default=None,
        help='Diretório absoluto, será utilizado quando o diretório de origem será o mesmo diretório de destino.'
    )

    parser.add_argument(
        '--dir-origem',
        type=str,
        default=None,
        help='Diretório de origem base'
    )

    parser.add_argument(
        '--dir-destino',
        type=str,
        default=None,
        help="Diretório de destino onde serão armazenados os OCRs"
    )

    parser.add_argument(
        '--debug',
        type=bool,
        default=False,
        help="Se vazio tentará executar o programa, se não, printa a string do comando"
    )

    FLAGS, unparsed = parser.parse_known_args()
    main()
