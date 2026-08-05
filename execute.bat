@echo off

set VERSAO=%1

if "%VERSAO%"=="" set VERSAO=Atual

set NOME_JAR=MiniTriangle.%VERSAO%.jar
set PASTA_BACKUP=versoes_antigas

echo Limpando arquivos antigos e organizando backups...

if not exist "%PASTA_BACKUP%" mkdir "%PASTA_BACKUP%"

for /f %%a in ('powershell -Command "Get-Date -format yyyyMMdd_HHmmss"') do set TIMESTAMP=%%a

if exist %NOME_JAR% (
	move %NOME_JAR% "%PASTA_BACKUP%\MiniTriangle.%VERSAO%.%TIMESTAMP%.jar" >nul
	echo -^> JAR antigo movido para: "%PASTA_BACKUP%\MiniTriangle.%VERSAO%.%TIMESTAMP%.jar"
)

del /q *.class 2>nul

echo.
echo Gerando codigo com JavaCC...
call javacc.bat MiniTriangle.jj

if %errorlevel% neq 0 (
	echo.
	echo ERRO: Falha no JavaCC. Interrompendo.
	pause
	exit /b %errorlevel%
)

echo.
echo Compilando arquivos Java...
javac *.java
if %errorlevel% neq 0 (
	echo.
	echo ERRO: Falha no Javac. Interrompendo.
	pause
	exit /b %errorlevel%
)

echo.
echo Criando o pacote JAR...
jar --create --file=%NOME_JAR% --main-class=MiniTriangle *.class
if %errorlevel% neq 0 (
	echo.
	echo ERRO: Falha ao criar o JAR. Interrompendo.
	pause
	exit /b %errorlevel%
)

echo.
echo Executando o programa...
java -jar %NOME_JAR% programa.minitriangle

echo.
pause