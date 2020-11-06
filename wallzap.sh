#!/usr/bin/env zsh
beginnytime="1099267200"
nowtime=$(date +%s)
count=0
basedir="/home/scott/.scripts/wallzap"
currun=0
numruns=1
imagename="image"

function getpic {
	randate=$(shuf -i $beginnytime-$nowtime -n 1)
	getDate=$(date -d @$randate +%Y-%m-%d)
	baseURL="https://en.wikipedia.org/wiki/Template:POTD/"$getDate
	#echo $baseURL;
	picURL=$(curl -s $baseURL | grep -o -E -m1 'href="([^"#]+).jpg|jpeg"' | cut -d'"' -f2)
	procpic;
}
function procpic {
	#echo https://en.wikipedia.org$picURL;
	pt=$(echo $picURL | sed  's/\/wiki\/File\://g' 2>/dev/null)
	echo $pt
	imgURL=$(curl -s https://en.wikipedia.org$picURL | sed  's/>/\n/g'i 2>/dev/null | grep -o -E -m1 'href="//upload([^"#]+)'$pt'"' | cut -d'"' -f2)
	if [ -z "$imgURL" ]
	then
		((count++))
		#echo $count;
		if [ "$count" -ge 10 ]
		then
			echo "failed 10 times"
			exit
		else
			getpic
		fi
	else
		((currun++))
		echo $currun
		name="$basedir/$imagename$currun.jpg";
			curl -o $name https:$imgURL && convert -resize 2590x1090^ -gravity Center -crop 2590x1090+0+0 -quality 80 -delete 1--1 $name $name &&
            echo "<script>window.location=\"$baseURL\"</script>" > "$basedir/wiki$currun.html" &&
				#	echo "<script>window.location=\"$baseURL\"</script>" > "$basedir/wiki.html" &&
			font=$(convert -list font | grep "Font: " | sed -e '/Noto-/d' -e '/D050000L/d' -e '/JoyPixels/d' | shuf | head -n1 | sed -e 's/Font: //' -e 's/ //g')
			echo $font
			word=$(aspell dump master | sed "/'s/d" | shuf | head -n1)
			echo $word
            convert $name -fill "#000000"  -font $font -pointsize 300 \
            -gravity Center -annotate +10-10 "$word" \
			$name

			ffmpeg -i "$name" -vf hue=h=310:s=3.8:b=3,eq=contrast=4 "$name" -y >> /dev/null 2>&1 &&

			convert "$name"  \
			-set option:distort:viewport '%wx%h+0+0' \
			-colorspace CMYK -separate null: \
			\( -size 3x3 xc: \( +clone -negate \) \
			+append \( +clone -negate \) -append \) \
			-virtual-pixel tile -filter gaussian \
			\( +clone -distort SRT 60 \) +swap \
			\( +clone -distort SRT 30 \) +swap \
			\( +clone -distort SRT 45 \) +swap \
			\( +clone -fill black -colorize 100 -distort SRT 0 \)  +swap +delete \
			-compose Overlay -layers composite \
			-set colorspace CMYK -combine -colorspace RGB \
			"$name" &&
			convert "$name"  \
			-virtual-pixel edge -channel M -fx "p[-10,10]" \
			"$name"
			convert "$name" -crop 2580x1080+10-10 "$name"

			if [ $currun -ge $numruns ];then
				feh --bg-fill "$basedir/$imagename"{1..$numruns}".jpg"
				exit;
			else
				getpic
			fi
	fi
}

getpic;

