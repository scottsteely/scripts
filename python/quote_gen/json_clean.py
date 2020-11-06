#!/home/scott/python/fake_quotes/bin/python
import json
import requests
import wikipedia

def get_portrait(search_term):
    WIKI_REQUEST = 'http://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=original&titles='
    try:
        result = wikipedia.search(search_term, results = 1)
        wikipedia.set_lang('en')
        wkpage = wikipedia.WikipediaPage(title = result[0])
        title = wkpage.title
        response  = requests.get(WIKI_REQUEST+title)
        json_data = json.loads(response.text)
        img_link = list(json_data['query']['pages'].values())[0]['original']['source']
        return img_link
        #r = requests.get(img_link)
    except:
        return 0


with open('famous_people.json', 'r+') as f:
    json_data = json.load(f)
    for k,v in json_data.items():
        print (k)
        link = get_portrait(k)
        if link != 0 or link == 'https://upload.wikimedia.org/wikipedia/commons/6/6c/DE_Band_mit_RK_%281%29.jpg':
            y = {'link': link}
            json_data[k].update(y)
        else:
            json_data[k] = "delete"
    
    keys = [k for k, v in json_data.items() if v == 'delete']
    for x in keys:
        del json_data[x]
            
    f.seek(0)
    f.write(json.dumps(json_data, indent=4))
    f.truncate()

