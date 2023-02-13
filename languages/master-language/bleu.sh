currentDir=${PWD##*/}
srcModelName=${currentDir:0:7}
regex='([a-z]{3})-([a-z]{3})'
[[ $srcModelName =~ $regex ]]
srcLanguage=${BASH_REMATCH[1]}
tgtLanguage=${BASH_REMATCH[2]}

if [ ! -f model-to-txt.py ]
then
    echo "Downloading model-to-txt"
    wget -q https://raw.githubusercontent.com/Softcatala/nmt-softcatala/master/use-models-tools/requirements.txt
    wget -q https://raw.githubusercontent.com/Softcatala/nmt-softcatala/master/use-models-tools/model-to-txt.py
    wget -q https://raw.githubusercontent.com/Softcatala/nmt-softcatala/master/use-models-tools/segment.srx
    wget -q https://raw.githubusercontent.com/Softcatala/nmt-softcatala/master/use-models-tools/srx_segmenter.py
    wget -q https://raw.githubusercontent.com/Softcatala/nmt-softcatala/master/use-models-tools/texttokenizer.py
    wget -q https://raw.githubusercontent.com/Softcatala/nmt-softcatala/master/use-models-tools/ctranslate.py
    wget -q https://raw.githubusercontent.com/Softcatala/nmt-softcatala/master/use-models-tools/preservemarkup.py
    pip3 install -r requirements.txt
fi


if [ $tgtLanguage = "jpn" ]; then
    tokenizer="--tokenize ja-mecab"
fi


modelRootDir=exported/
echo "Test data set" > bleu.txt
python3 model-to-txt.py -m $srcModelName -f src-test.txt -t predictions-test.txt -x $modelRootDir
sacrebleu tgt-test.txt $tokenizer -i predictions-test.txt -m bleu chrf --format text >> bleu.txt

echo "Flores data set" >> bleu.txt
python3 model-to-txt.py -m $srcModelName -f flores200.$srcLanguage -t predictions-flores.txt -x $modelRootDir
sacrebleu $tokenizer flores200.$tgtLanguage -i predictions-flores.txt -m bleu chrf --format text >> bleu.txt

cat bleu.txt


