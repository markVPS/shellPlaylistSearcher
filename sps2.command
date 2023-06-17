#!/bin/sh
clear
echo 'Playlist Searcher'
read -p 'Spotify or Apple Music ' link
if [[ ${link} == "apple" ]];
then
	link='music.apple.com/*/playlist'
else
	link='open.spotify.com/playlist'
fi
echo $link
oylt='ould you like to'
while [[ ! $number =~ ^[0-9]+$ ]]
do
    read -p "How many songs w$oylt enter? " number
if [[ $number =~ ^[0-9]+$ ]] ; then
    break
fi
    echo 'Please enter a number'
done
current=1
while [ $number -ne 0 ]
do
    read -p "Enter the name of song $current: " song
    arr[$current]='"'${song}'"'
    let "number--"
    let "current++"
done
read -p "W$oylt exclude playlists over 24 hours? " long
search="${arr[*]}"+'-"Spotify%20Playlist"'
tempor=$(printf '%s' ${arr[*]} | tr ' ' '+')
echo $tempor
search="${search//'" "'/"+"}"
search="${search//' '/%20}"
if [[ $long == *Y* ]] || [[ $long == *y* ]] || [[ $long == *Yes* ]] || [[ $long == *YES* ]] || [[ $long == *yes* ]];
then
	search+='+-"over%2024%20hr"'
fi
#clear
agent='Mozilla/5.0 (X11; Linux x86_64; rv:105.0) Gecko/20100101 Firefox/105'
curl -s 'https://www.google.com/search?hl=en&q=site%3A'${link}'+'${search}'' -A "${agent}" > tmp
if grep -q "did not match any documents" "$tmp"; then
	echo "Sorry, no results..."
	break
	exit
fi
read -a arr <<< $(cat tmp | grep -Eoi '"https:\/\/'${link}'\/.{0,22}')
for each in "${arr[@]/?/}"
do
    let "number++"
    echo $number
    curl -s "$each" -A "${agent}" > tmp
    cat tmp | grep -Eoi 'og:ti.{0,60}' #| sed '/:ti/,/meta/p'| cut -c 20- #-d"meta
    #cat tmp | grep -Eoi '0Md">.{0,60}' #| sed '/:ti/,/meta/p'| cut -c 20- #-d"meta
done
#rm tmp
while [[ ! $pnumber =~ ^[0-9]+$ ]]
do
    read -p "Which playlist w$oylt open? " pnumber
if [[ $pnumber -gt $number ]] ; then
	echo "The number you entered is higher than the amount of playlists available, which is $number" 
fi
	break
done
open -a spotify ${arr[pnumber-1]/?/}
open -a music https://music.apple.com/us/playlist/indie-hits-1997/pl.bc1fdfea51a84d9b9c6a9487ab1df185
exit
