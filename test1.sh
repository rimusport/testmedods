#!/bin/bash
curl https://raw.githubusercontent.com/GreatMedivack/files/master/list.out > list.out
awk '/Error|CrashLoopBackOff/ {print $1;}' list.out | cut -f1,2,3 -d'-' > "`hostname`"_"`date +"%d_%m_%Y"`"_failed.out
awk '/Running/ {print $1;}' list.out | cut -f1,2,3 -d'-' > "`hostname`"_"`date +"%d_%m_%Y"`"_running.out
awk 'END{print "Количество работающих сервисов:"NR}' "`hostname`"_"`date +"%d_%m_%Y"`"_running.out > "`hostname`"_"`date +"%d_%m_%Y"`"_report.out
awk 'END{print "Количество сервисов с ошибками:"NR}' "`hostname`"_"`date +"%d_%m_%Y"`"_failed.out >> "`hostname`"_"`date +"%d_%m_%Y"`"_report.out
awk 'END{print}$4>0' list.out | awk 'FNR>1' | awk 'NR>1{print buf}{buf = $0}' | awk 'END{print "Количество перезапустившихся сервисов:"NR}'>> "`hostname`"_"`date +"%d_%m_%Y"`"_report.out
chmod 744 "`hostname`"_"`date +"%d_%m_%Y"`"_report.out
id |awk -F'[)(]' '{print "Имя системного пользователя:"$2}' >> "`hostname`"_"`date +"%d_%m_%Y"`"_report.out
date +"Дата:%d/%m/%Y" >> "`hostname`"_"`date +"%d_%m_%Y"`"_report.out
mkdir -p ~/archives
tar -cvf ~/archives/"`hostname`"_"`date +"%d_%m_%Y"`".tar .
cp -n "`hostname`"_"`date +"%d_%m_%Y"`".tar ./archives
ls | grep -v test1.sh | xargs rm -rfv  
if ! tar tvf ~/archives/"`hostname`"_"`date +"%d_%m_%Y"`".tar &> /dev/null | echo "Успешное завершение работы";
then
    echo "Ошибка";
fi
