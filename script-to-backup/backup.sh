#!/bin/bash
source ./var.cfg

mysqldump --user=${USER} --password=${PASSWD} ${DB_NAME} > ${BACK_DIR}/${DB_FILE_NAME}
if [[ $? -gt 0 ]]; then echo "Something is wrong."
exit 1
fi

tar --listed-incremental=${BACK_DIR}/snapshot.snar -czvpf ${BACK_DIR}/${ARH_NAME}-${DATA}.tar.gz ${DATA_DIR}
if [[ $? -gt 0 ]]; then echo "Something is wrong."
exit 1
fi

scp -r ${BACK_DIR} anastasiya@192.168.1.5:/home/anastasiya/
if [[ $? -gt 0 ]]; then echo "Something is wrong."
exit 1
fi

echo "All operations completed successfully!"
