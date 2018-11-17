from bs4 import BeautifulSoup
from requests_html import HTMLSession
import requests
import json
import time

companiesFile = open('companies_test.json')
companies = json.load(companiesFile)

companiesWithoutUrl = ['Cofense (PhishMe)', 'Facebook', 'Spotify']

for company, values in companies.items():
	print(companiesWithoutUrl)
	urlExists = values.get('url') != None

	if urlExists:
		continue
	if company in companiesWithoutUrl:
		continue

	session = HTMLSession()
	companyName = company.lower().replace(' ', '-')

	searchPage = 'https://www.glassdoor.com/Reviews/' + companyName + '-reviews-SRCH_KE0,'+ str(len(company)) +'.htm'
	print(searchPage)
	r = session.get(searchPage)

	htmlString = str(r.html)
	print('html:' + htmlString)
	isRedirectedLink = 'https://www.glassdoor.ca/Overview/Working-at-' in htmlString
	if isRedirectedLink:
		link = htmlString[htmlString.find('\'')+1 : htmlString.rfind('\'')]
		print("did redirect to: " + link)
		companies[company]['url'] = link
		print("set company url: " + companies[company]['url'])
	else:
		r.html.render()
		searchResultList = r.html.find('.tightAll.h2')

		# check if result list is not empty & result contains company name
		if len(searchResultList) > 0: # and company in searchResultList[0].attrs['href']:
			companies[company]['url'] = 'http://www.glassdoor.com' + searchResultList[0].attrs['href']
			print("set company url: " + companies[company]['url'])

	r.close()
	session.close()

	noUrl = companies[company].get('url') == None
	if noUrl:
		print("no url found for:" + company)
		companiesWithoutUrl.append(company)

	with open('companies_test.json', 'w') as outfile:
		print("writing to file...")
		json.dump(companies, outfile)
	time.sleep(5)
