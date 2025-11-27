import sys
import logging

logging.basicConfig(stream=sys.stderr)
sys.path.insert(0, '/web-app/sakila-demo/')

from sakila_demo import application  # assuming your Flask app object is called 'application'
