#!/bin/bash

SYSTEM="UEFI"
dev="/dev/sda"

lenhos=` expr length $dev `
        if [ "$lenhos" -gt 8 -a "$SYSTEM" = "BIOS" ]	
			then echo ${dev}p1

		elif [ "$lenhos" -gt 8 -a "$SYSTEM" != "BIOS" ]
			then echo ${dev}p1
			echo ${dev}p2

		elif [ "$lenhos" -lt 9 -a "$SYSTEM" = "BIOS" ]
			then echo ${dev}1

    	else 
    		echo ${dev}1
    		echo ${dev}2
    	fi


kswpnofile() {

        IFS='|'

        function ellenor {

                rootszamlal=0
                bootszamlal=0
                homeszamlal=0
                #mntszamlal=0
                optszamlal=0
                swapszamlal=0
                srvszamlal=0
                tmpszamlal=0
                usrszamlal=0
                varszamlal=0
                nincsszamlal=0
                
                root_part=$1
                boot_part=$2
                home_part=$3
                #mnt_part=$4
                opt_part=$4
                swap_part=$5
                srv_part=$6
                tmp_part=$7
                usr_part=$8
                var_part=$9


                alap=1
                alap0=0

                
                nincstolt=0

                echo "$root_part $boot_part $home_part $opt_part $swap_part $srv_part $tmp_part $usr_part $var_part"
                
                #echo "be for1"
                for k in { $root_part $boot_part $home_part $mnt_part $opt_part $swap_part $srv_part $usr_part $var_part }
                do
                        if [ "$k" == " " ]
                                then  ((nincstolt++))
                                #echo $nincstolt
                        fi
                done


                # Ha üres valamelyik partició...
                if [ "$nincstolt" -gt "$alap0" ]
                        then zenity --error --title="$title" --text "Minden mező kitöltése kötelező!!!\nHa nem akarsz az adott helyre csatolni, válaszd a Nincs lehetőséget" --height=100  --width=300 
                        kswpnofile
                        return 1
                        fi 

                # Root csatolás nem lehet üres...
                if [ "$root_part" = "Nincs" ]
                        then zenity --error --title="$title" --text "Nem választottal root partíciót" --height=100  --width=300
                        kswpnofile
                        return 1
                
                # Ha swap partició ez se lehet üres...
                elif   [ "$swap_part" = "Nincs" ]
                        then zenity --error --title="$title" --text "Nem választottal swap partíciót" --height=100  --width=300
                        kswp
                        return 1

                elif [ "$SYSTEM" = "UEFI" -a "$boot_part" = "Nincs" ]
                        then zenity --error --title="$title" --text "Nem választottal boot partíciót.\nUEFI-ben bootolt a rendszer." --height=100  --width=300
                        kswpnofile
                        return 1
                fi

                # Hanyszor szerepel a partició
                for i in { $root_part $boot_part $home_part $opt_part $swap_part $srv_part $tmp_part $usr_part $var_part }
                do
                        if [ "$i" == "$root_part" ]
                                then ((rootszamlal++))
                        
                        elif [ "$i" == "$boot_part" -a "$i" != "Nincs" ]
                                then ((bootszamlal++))
                        
                        elif [ "$i" == "$home_part" -a "$i" != "Nincs" ]
                                then ((homeszamlal++))
                        
                        
                       
                        elif [ "$i" == "$opt_part" -a "$i" != "Nincs" ]
                                then ((optszamlal++))
                        
                        elif [ "$i" == "$swap_part" ]
                                then ((swapszamlal++))
                        
                        elif [ "$i" == "$srv_part" -a "$i" != "Nincs" ]
                                then ((srvszamlal++))

                        elif [ "$i" == "$tmp_part" -a "$i" != "Nincs" ]
                                then ((tmpszamlal++))
                        
                        elif [ "$i" == "$usr_part" -a "$i" != "Nincs" ]
                                then ((usrszamlal++))
                        
                        elif [ "$i" == "$var_part" -a "$i" != "Nincs" ]
                                then ((varszamlal++))
                        
                        elif [ "$i" == "Nincs" ]
                                then ((nincsszamlal++))
                        fi
                        
               done
                # Dupla van-e...
                if [ "$rootszamlal" -gt "1" -o "$bootszamlal" -gt "$alap" -o "$homeszamlal" -gt "$alap" -o "$optszamlal" -gt "$alap" -o "$swapszamlal" -gt "$alap" -o "$srvszamlal" -gt "$alap" -o "$tmpszamlal" -gt "$alap" -o "$usrszamlal" -gt "$alap" -o "$varszamlal" -gt "$alap" ]
                        then 
                                zenity --error --title="$title" --text "Többször választottad ugyanazt a particiót" --height=100  --width=300
                                kswpnofile
                                return 1
                        fi

                # Csatolások
                # /
                if [ "$root_part" != "Nincs" ]
                 	then mount $root_part /mnt
         		fi

                

                
                
                egyeb_csatolas

                }

        echo "Nincs" > be.txt
        sudo fdisk -l | grep dev | grep -v Disk | awk '{print $1}' >> be.txt
        tr -s '\n' '|' < be.txt > ki.txt
        mylist=` cat ki.txt `
        ellenor $(zenity --forms --text "Ad meg a csatolási pontokat" --add-combo="Csatolási pont (/)" --combo-values="${mylist::-1}" \
                --add-combo="Csatolási pont (/boot/efi)" --combo-values=$"${mylist::-1}" --add-combo="Csatolási pont (/home)" --combo-values="${mylist::-1}" \
                --add-combo="Csatolási pont (/opt)" --combo-values="${mylist::-1}" \
                --add-combo="Csatolási pont (/swap)" --combo-values="${mylist::-1}" --add-combo="Csatolási pont (/srv)" --combo-values="${mylist::-1}" \
                --add-combo="Csatolási pont (/tmp)" --combo-values="${mylist::-1}" --add-combo="Csatolási pont (/usr)" --combo-values="${mylist::-1}" \
                --add-combo="Csatolási pont (/var)" --combo-values="${mylist::-1}")
}
kswpnofile