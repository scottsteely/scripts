#!/bin/python

import csv
import json

csvFilePath = '/home/scott/python/quote_gen/new_people.csv'
jsonFilePath = '/home/scott/python/quote_gen/famous_people.json'

data = {}
with open(csvFilePath) as csvFile:
    csvReader = csv.DictReader(csvFile)
    for rows in csvReader:
        id = rows['Famous Person']
        data[id] = rows

with open(jsonFilePath, 'w') as jsonFile:
    jsonFile.write(json.dumps(data, indent=4))


