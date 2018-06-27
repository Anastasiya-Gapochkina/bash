#!/bin/bash
#текущая дата
data=$(date +%Y-%m-%d)
#имя БД
db_name=magento
#файл дампа
db_file_name=dump-$data.sql
#имя архива
arh_name=media_bak
#пользователь БД
user=user
#пароль БД ...все во имя безопасности :)
passwd=toor
#папка для бэкапов
back_dir=/var/backup_dir
#что бэкапим
data_dir=/var/www/magento/media/

#делаем дамп БД
mysqldump --user=$user --password=$passwd $db_name > $back_dir/$db_file_name
if [[ $? -gt 0 ]]; then echo "Something is wrong." #поверяем успешность выполнения команды
exit 1
fi

#упаковываем media (инкрементально)
tar --listed-incremental=$back_dir/snapshot.snar -czvpf $back_dir/$arh_name-$data.tar.gz $data_dir
if [[ $? -gt 0 ]]; then echo "Something is wrong." #поверяем успешность выполнения команды
exit 1
fi

#отправляем на удаленный хост
scp -r $back_dir anastasiya@192.168.1.5:/home/anastasiya/

#синхронизируем
rsync -a /var/www/magento/media anastasiya@192.168.1.5:/home/anastasiya/media

echo "All operations completed successfully!"
