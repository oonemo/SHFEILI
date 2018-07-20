from flask import Flask

app = Flask(__name__)

app.config.from_object('backend.config')

app.config.from_envvar('BACKEND_SETTINGS', silent=True)

import backend.api
import backend.util
