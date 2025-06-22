#INSTALL 
apt install mdadm -y      # Instala o mdadm, que é a ferramenta para gerenciar RAIDs.

#RAID CREATE
mdadm --create /dev/md0 --level=5 --raid-devices=6 /dev/vda /dev/vdb /dev/vdc /dev/vdd /dev/vde /dev/vdf --spare-device=1 /dev/vdg
# Cria um array RAID 5 chamado /dev/md0,
#utilizando 6 discos (/dev/vda a /dev/vdf) 
# e um spare (/dev/vdg) que permanecerá como backup.

#DETAILS
cat /proc/mdstat          # Verifica o estado atualizado do array depois da criação.
mdadm --detail /dev/md0   # Exibe novamente os detalhes do array criado.


#FORMAT & MOUNT
mkdir /mnt/dados          # Cria o diretório onde o array será montado.
mkfs -t ext4 /dev/md0     # Formata o array com o sistema de arquivos EXT4.
mount /dev/md0 /mnt/dados # Monta o array no diretório criado (/mnt/dados).


#FAIL FLAG
mdadm /dev/md0 --fail /dev/sdd
# Marca o disco /dev/sdd como "defeituoso".

#REMOVE COMMAND
mdadm /dev/md0 --remove /dev/vdd
# Remove o disco que caiu (/dev/vdd) do array.

#ADD COMMAND
mdadm /dev/md0 --add /dev/vdd
# Adiciona o disco de spare (/dev/vdd) para que ele comece a reconstruir o array.
