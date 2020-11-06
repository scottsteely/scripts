#!/bin/python3

import requests
import json
import random
import re

r = requests.get('https://api.urbandictionary.com/v0/random')
y = json.loads(r.text)

rand_select = random.choice((y["list"]))
rand_word = (rand_select["word"]).title()
rand_def = re.sub(r"\[|\]|\\|\/", "", rand_select["definition"], flags=0)

print ('Word: ',  rand_word)
print ('Definition: ', rand_def)
