#!/bin/bash

set -e

VERSAO=${1:-Atual}

NOME_JAR="MiniTriangle.${VERSAO}.jar"
PASTA_BACKUP="versoes_antigas"

echo "Limpando arquivos antigos e organizando backups..."

mkdir -p "$PASTA_BACKUP"

if [ -f "$NOME_JAR" ]; then
	TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
	mv "$NOME_JAR" "$PASTA_BACKUP/MiniTriangle.${VERSAO}.${TIMESTAMP}.jar"
	echo " -> JAR antigo movido para: $PASTA_BACKUP/MiniTriangle.${VERSAO}.${TIMESTAMP}.jar"
fi

rm -f *.class

echo -e "\nGerando código com JavaCC..."
javacc.bat MiniTriangle.jj

echo -e "\nCompilando arquivos Java..."
javac *.java

echo -e "\nCriando o pacote JAR..."
jar --create --file="$NOME_JAR" --main-class=MiniTriangle *.class

echo -e "\nExecutando o programa..."
java -jar "$NOME_JAR" programa.minitriangle

echo ""
read -p "Pressione ENTER para continuar..."